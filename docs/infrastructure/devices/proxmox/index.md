# Proxmox

There is one Proxmox host, `monster1` (`10.3.1.11`), running Proxmox VE 9.x. The UI is at
[monster.int.leighhack.org](https://monster.int.leighhack.org) - sign in with your
Authentik account (the `leighhack.org` OpenID realm).

It is called "monster" after a machine that no longer exists: the HP SL2x170z blades and
`monster2`-`monster5` are gone, and what's running now is a single desktop box.

| | |
| --- | --- |
| Machine | HP 290 G1 SFF |
| CPU / RAM | Intel i5-8500 (6 cores) / 32 GB |
| Local disk | 500 GB SSD |
| Not in this flake | Nothing about this host or its VMs is declarative |

**There is no cluster, and no redundancy.** HA is enabled, but with one node that means
"restart a VM that dies", not "fail over".

## Storage

VM disks are qcow2 files on the NAS over NFS: `nas2-nfs` is
`10.3.1.6:/mnt/sas-10k/proxmox-monster-ds1`, mounted at `/mnt/pve/nas2-nfs`. The second
mount (`nas1-nfs`, the old QNAP) is disabled.

Two consequences that bite people:

* **After a power cut, every VM start fails** with `storage 'nas2-nfs' is not online` while
  the NAS is still booting. Check `pvesm status` and `mount | grep nas2-nfs` before
  blaming a VM; the fix is to wait and retry.
* Boots take **minutes** even when nothing is wrong, because every disk is a file on a
  network share with `cache=direct`.

**There are no backup jobs and no snapshots on this host.** `/etc/pve/jobs.cfg` is empty,
and the NAS holds the only copy of every disk image. Treat anything you put here as
dispensable unless you have copied it somewhere else.

## What's Running

| VMID | Name | Address | State |
| ---- | ---- | ------- | ----- |
| 109 | `apps1` | `10.3.1.30` | Running. Mostly superseded by services1, but a few things still live in it |
| 127 | `web1` | `10.3.1.39` | Running. The hackspace website: `webhooks.`, `web-test.` and `retro.leighhack.org` |
| 108 | `authentik` | `10.3.1.36` | **Stopped on purpose** since the 2026-10-28 cutover to containers on services1. It must stay stopped |
| 128 | `mercury` | `10.3.1.166` | Stopped. The intercom, replaced by Asterisk on services1 |
| 107 | `mx1` | - | Stopped since 2026-10. This was the outbound mail relay |
| 100/103/104 | `k8s-lab-*` | - | Stopped, see [Kubernetes Lab](../k8s-lab/index.md) |
| 110-118 | GOAD / Windows lab | - | Stopped since 2023-2025 |
| 132 | `Terraria` | - | Stopped |

Anything not in that list is dormant disk. Before starting a VM to "check whether anyone is
using it", ask in Slack - half of these have last written to disk years ago.

`10.3.1.36` is answered by services1 now, but its **DHCP reservation is still live and
still names the old VM's MAC** - booting VM 108 takes that address back, and two hosts
answering one address is silent for whoever is trying to log in. The intercom's address is
protected the other way: the router is told `dhcp-host=10.3.1.166,ignore` so nothing else
can be handed it.

## Admin Tasks

### Allowing users access to the Cluster

* Login to [https://monster.int.leighhack.org/](https://monster.int.leighhack.org/) as a Infra member.
* Click on 'Datacenter (monster)' in the left menu.
* Goto Users and find the user that requires access.
* Either add them to the 'Infra', or 'Members' group as needed.

### Login without using id.leighhack.org/Authentik

* Go to [https://monster.int.leighhack.org/](https://monster.int.leighhack.org/)
* On the login screen, select the dropdown and pick 'Linux PAM'
* Username is 'root', password is in the password manager.

### Starting a VM that HA manages

Use `ha-manager`, never `qm start`, or HA and the VM disagree about who owns it:

```bash
ha-manager set vm:109 --state started
```

If the service is sitting in `error`, clearing it is **disable, wait, then start** - doing
both in one loop races and the start is rejected:

```bash
ha-manager disable vm:109 ; sleep 15 ; ha-manager enable vm:109 ; ha-manager set vm:109 --state started
```

The VMs that are not HA-managed (`107 mx1`, `132 Terraria`) are `qm start`ed by hand.

### After an outage

`docs/monster-powercut-runbook.md` in the infra repo is the full procedure, including what
to start in which order and how long the NAS takes. The host is deliberately not on the
router's shutdown list, so it stays up until the mains actually go.
