# Gateway / Router

Our router is a NixOS box called `gw`, at `10.3.1.1` on VLAN 225. It took over from the
pfSense box on 2026-10-21, and the appliance is retired. **There is no web UI**: it is
configured from
[the infrastructure repo](https://github.com/leigh-hackspace/infrastructure-nix-flake)
(`machines/gw/`), deployed with a NixOS switch, and reached over ssh.

Hardware is a Supermicro X9SCM (Xeon E3-1220 v2, 8 GB), two Intel NICs - `router-lan`
carrying the VLAN trunk to Switch 1, `router-uplink` to the AAISP hub.

## What Lives On It

| Thing | What it does |
| ----- | ------------ |
| dnsmasq | DNS for `int.leighhack.org`, DHCP and router advertisements for every VLAN |
| nftables | The firewall and NAT, generated from `common/config.nix`'s `LOCAL_NETWORK` table |
| xl2tpd | The AAISP L2TP tunnel, which is `ppp0` and is the network's real uplink |
| wan-manager | Finds every other uplink (USB tether, any Wi-Fi adapter), ranks them, repairs routes |
| nginx | The [front door](#the-front-door): TLS, every vhost, `nginx-sso`, and `anubis` |
| headscale + headplane | The [tailnet](../../vpn.md) control server, and its admin UI |
| network-status | [network-info.int.leighhack.org](https://network-info.int.leighhack.org) - live uplink, interface, connection and lease tables |
| NUT + ups-watchdog | The UPS on its USB port, the outage countdown, and the ordered shutdown of the fleet |

`machines/gw/README.md` in the repo is the authority on all of it, including the four
commands that prove the router is doing its job.

## ISP / Connectivity

### Mill Network

The mill provides internet access via a gigabit internal network. It can be a bit unreliable but it works for our general usage.

* ISP: [Awareness Software Ltd](https://aware-soft.com/) (AS34931)
* Mill Network Administrator: [Mark Nightingale](mailto:data@imagevillage.co.uk), Image Village.

Access to the mill network is provided by a singular CAT5 delivered to the rear of the main space, just above where Rack1 is.

* VLAN: 1 (untagged)
* Subnet: `192.168.20.0/24`
* Gateway: `192.168.20.1`
* DHCP Enabled

Usage is bound by the [LBPT Tenant Network Agreement](../../mill_network_tc.md).

### Hackspace Connectivity

Our internet connection uses the mill's shared network, but we have a [Business L2TP](https://www.aa.net.uk/broadband/l2tp-service/) 'VPN' to [Andrew Arnold](https://www.aa.net.uk/), who provide us with 600Mb/sec, 10TB/month, and a `/29` block of IPv4 and a `/48` IPv6.

* Line ID: lhc1@a
* Account ID: A8***0A
* Control Panel Login: [https://control.aa.net.uk/](https://control.aa.net.uk/)
* Billing Login: [https://accounts.aa.net.uk/](https://accounts.aa.net.uk/)

The tunnel is `ppp0`; if it is down there is no IPv6 and VLAN 225 has no route out. The
L2TP connection is currently paid for and managed by [Andrew Williams](mailto:lhwiki@m.tensixtyone.com). If you have any queries regarding the connection please contact them.

Egress is split by VLAN: VLAN 225's IPv4 leaves through the tunnel, every other VLAN's
IPv4 goes straight out of the hub with a second NAT, and all IPv6 on every VLAN leaves
through the tunnel.

### Backup Uplink

`wan-manager` discovers any second uplink it can - a USB tethered phone, a USB Ethernet
adapter, or any Wi-Fi adapter - scans for `Leighhack WAN Backup`, and measures each
candidate's path before selecting it. A selected uplink whose gateway goes quiet is
dropped and the routes move. It is IPv4 only: a backup uplink cannot give us IPv6 or
inbound connections, because those come with the AAISP tunnel.

## The Front Door

GW is the only box with a certificate and the only box with a public listener, so it is
the only way in from outside. It terminates TLS for every name we run, proxies to the
service behind it, and applies the gate:

* one wildcard ACME certificate, covering `leighhack.org`, `*.leighhack.org`,
  `*.ai.leighhack.org`, and `*.int.leighhack.org`
* every name is one row in `common/front-door.nix`; the router's nginx is rendered from
  that table, and `common/int-dns.nix` is the DNS half of the same fact
* rows marked `sso = true` go through `nginx-sso`, so an app gets a trustworthy
  `X-WEBAUTH-USER` header for whoever is logged into Authentik
* public rows are protected from scrapers by `anubis`
* `*.int` names are answered only on the LAN and the tailnet

The services themselves are **origins**: plain HTTP, no certificate, no gate, and a
socket that only the front door is allowed to reach. Adding an `acme` or an `nginx-sso`
to another box creates a second front door, which is the one thing not to do here.

## Admin Tasks

### Add a DNS Record, or a Static DHCP Lease

There is no form for this any more, and no need for one - the answer is a commit:

* A device that keeps an address goes in `common/dns-records.nix`: its name, its VLAN,
  its IPv4, and its MAC (or DHCP client ID). That is one reservation *and* one DNS
  record, and the router is restarted for it in the same deploy.
* A `*.int.leighhack.org` name is a row in `common/int-dns.nix`, saying whether the front
  door answers it, whether the front door serves it, or whether it is dialled as a socket
  by one box.
* A new vhost needs a row in `common/front-door.nix` as well. Two evaluation-time checks
  refuse a half-move, so a name and its vhost cannot drift apart.

Deploy with `just deploy gw` from any flake machine (it ssh's in, fetches, switches, and
confirms), or `just switch` while ssh'd to the router.

### Restart the L2TP Connection

* `ssh leigh-admin@10.3.1.1`, then `sudo -i` (root's ssh is not enabled, the admin account has sudo).
* `systemctl status xl2tpd-aaisp.service` - it is a never-give-up service, so it should be active and restarting rather than failed.
* `sudo systemctl restart xl2tpd-aaisp.service` to redial.
* `ip addr show ppp0` should show an address in `81.187.0.0/16`, and
  [network-info](https://network-info.int.leighhack.org)'s Uplink tab should show the
  tunnel as the selected uplink with a measured internet path.

### Check the Network Is Being Routed

The same four checks the cutover was accepted with, on the box:

```bash
ip -4 addr show scope global                  # .1 on 225, 226, 227 and 222
getent hosts gw                               # 10.3.1.1
systemctl is-active dnsmasq xl2tpd-aaisp nginx wan-manager
ip route get 1.1.1.1                          # dev ppp0 unless a backup is selected
```

### Fix a Camera or Printer That Won't Come Back

Don't. A thingino camera's only path back to the network is the Wi-Fi association you'd
be changing, so never re-associate a camera over ssh. Ask [infra](../../../membership/useful_contacts.md#tech-infrastructure).

### Do Not

* **Do not edit `/etc/dnsmasq.d/network.conf`** (or `/etc/dnsmasq-int-vhosts.hosts`). Both
  are generated store paths, and the next deploy silently replaces whatever you wrote.
* **Do not build on the router.** It delegates every build to aibox and runs with
  `max-jobs = 0`; it is also the box every other box resolves names through.
* **Do not open a service's port to the LAN** because the front door is inconvenient. The
  door and its ACLs are the boundary; a service listening on a LAN address is one that
  anyone on the network can talk to directly.
* **Do not reboot it to fix something.** A reboot takes the network's DNS, DHCP and route
  away from everything, and the only way back in is the console.
