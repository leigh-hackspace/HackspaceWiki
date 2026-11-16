# Infrastructure

This section will cover any details of the hackspace's technical infrastructure, that being things that have blinking lights and beepity boops.

## The Shape Of It

Everything comes in through one box, [gw](devices/gateway/index.md), which is the
router, firewall, DHCP server, DNS server, VPN endpoint, and the TLS front door for
every service we publish. Behind it are four NixOS machines (`services1`, `services2`,
`services3`, `aibox`), a [TrueNAS box](devices/nas/index.md) for storage and backups, a
[Proxmox host](devices/proxmox/index.md) for the VMs that don't fit the NixOS fleet, and
three ProCurve switches.

Single sign-on across all of it is [Authentik](devices/authentik/index.md) at
[id.leighhack.org](https://id.leighhack.org). If you have an account there you can reach
the internal dashboards, the [tailnet VPN](vpn.md), the switches, and the member VMs.

## Configuration Is In Git

The servers and the network are defined in
[leigh-hackspace/infrastructure-nix-flake](https://github.com/leigh-hackspace/infrastructure-nix-flake)
and deployed with `nixos-rebuild switch`. That includes the bits that used to live in a
web UI: DNS records, DHCP reservations, firewall rules, the VLANs, every vhost, and each
service's config. So for most of the network there is nothing to log into and click - the
change is a commit, and `machines/` and `common/` in that repo are the real reference.

Each page here says which file owns what it describes. When a page and the repo disagree,
the repo is right.

## Pages

* [Internal Services](internal_services.md) - the services members actually use, and where they live
* [Network Layout](network_layout.md) - VLANs, addresses, and the hardware list
* [VPN](vpn.md) - getting into the network from outside
* [Devices & Services](devices/index.md) - the router, switches, NAS, Proxmox, Authentik, and the hackspace's own gadgets

## Contact

Anything in here broken, out of date, or missing? Ping [infra](../membership/useful_contacts.md#tech-infrastructure).
