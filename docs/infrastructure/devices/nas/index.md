# NAS

One box does storage: `nas2.int.leighhack.org` (`10.3.1.6`), an HP MicroServer Gen8
running TrueNAS. It keeps the camera recordings, the filestore share, every Proxmox VM
disk, the backups, and member home directories, so anything that matters to the space is
somewhere in here.

* Web UI: [truenas.int.leighhack.org](https://truenas.int.leighhack.org) (through the front
  door, Infra only)
* One ZFS pool, `sas-10k`, about 14.5 TiB
* Everything on it is out-of-flake: the appliance is configured in its own UI, and the
  infra repo only declares the mounts on the boxes that use it

## What's On It

| Dataset | NFS export | Used by |
| ------- | ---------- | ------- |
| `cameras` | yes | Frigate's recordings |
| `filestore` | yes, and over SMB | The [Filestore](../../internal_services.md#filestore) share |
| `backups` | yes | The borg repositories from the fleet |
| `proxmox-monster-ds1` | yes | **Every Proxmox VM disk**, over `nas2-nfs` |
| `ds-home`, `home` | yes | Member home directories |
| `ds-photos` | yes | Photo storage |
| `retrogames` | yes | The retro machine's ROMs |
| `ix-applications` | no | TrueNAS's own apps directory, nothing of ours |

The exports are locked to `10.3.1.0/24` except `filestore`, `ds-photos` and `ds-home`.

Member homes are the one thing here with per-person permissions on them: the ACL is your
Authentik account, and the uid it maps to is derived from your Authentik user id. Which
means the account isn't just how you log in, it's how your files know you.

## Availability

There is no second NAS and no replication, so treat the pool as the single copy. It is
also **slow to come up after a power cut**, and that is a fact about the whole fleet rather
than an inconvenience: every box that mounts it waits for it forever rather than failing
(`wait-for-nas.service`), and Proxmox refuses to start any VM until the export answers.
If the network is back and the services aren't, this is usually why.

## Backups

`services1` pushes its `/srv` - the databases and state behind most of what
[Internal Services](../../internal_services.md) lists - to a borg repository over SSH on a
schedule. The borg server is a container (`borg-server`, an Incus container on the NAS)
listening on port `3022`:

```bash
borg list ssh://backups@nas2.int.leighhack.org:3022/backups/services1.int.leighhack.org/borg/srv
```

A few honest caveats: the backups live on the same box as the data, nothing is copied off
site, and nobody has verified a restore recently. If you have something genuinely
irreplaceable, keep a second copy of it yourself.

## The Old QNAP (retired)

The QNAP TS-431+ at `10.3.1.5` (`nas1`) is off. Its address is still reserved and its name
still resolves, which is why it looks like it might be up; it does not answer ping, and the
`nas1-nfs` Proxmox datastore that used to point at it is disabled.

It went away because of storage, not because of failure: a single 4-bay box couldn't hold
the camera recordings and the VM disks both. Its Samba service was the thing that couldn't
talk to Authentik's LDAP, which is why SMB was disabled on it - on TrueNAS, SMB just works,
and the guest shares are served from there.

## Admin Tasks

### Check Disk Health

* Login to [truenas.int.leighhack.org](https://truenas.int.leighhack.org) as an Infra member.
* Pool status is on the dashboard; per-disk SMART results are under **Storage → Disks**.
* From a terminal, `ssh leigh-admin@10.3.1.6` then `sudo zpool status sas-10k` - a pool in
  `DEGRADED` here is the moment to ask infra, not the moment to keep working.

### Add a Share

* In the TrueNAS UI, create or pick the dataset, then add the NFS or SMB share you want.
* If a machine in the fleet needs it as a mount, that half is a commit: add an entry to
  that machine's `infra.nas.exports` list (`machines/<box>/hardware-configuration.nix`) and
  deploy. Mounts and their automounts are generated from that one list, so the two halves
  can't drift.

### Don't

* **Don't edit `/etc/sudoers` on the NAS.** Middleware regenerates it at boot and the
  generated file has no `#includedir`, so a hand edit or a drop-in is simply lost. The
  passwordless sudo for `leigh-admin` is set as the *middleware user record* - do it that
  way, through the API or the UI.
* **Don't move or rename a dataset that Proxmox or a mount is using** without taking the
  consumer off it first; the automounts retry forever, which reads as a hung machine
  rather than a missing path.
