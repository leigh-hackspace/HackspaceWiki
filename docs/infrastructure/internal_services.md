# Internal Services

The hackspace runs a collection of services on the hackspace network, either to assist with automation or just to be useful for members.

Everything is HTTPS and everything is behind the [front door on the router](devices/gateway/index.md#the-front-door), so
a `*.int.leighhack.org` name resolves on the space's networks and on the [tailnet](vpn.md) only. Names
without `.int` are public. Most of them want you to be signed in with your
[id.leighhack.org](https://id.leighhack.org) account.

| Service | Address | Reachable from |
| ------- | ------- | -------------- |
| Monitoring overview | [status.leighhack.org](https://status.leighhack.org) | Anywhere, once signed in |
| Prometheus | [prometheus.int.leighhack.org](https://prometheus.int.leighhack.org) | LAN / VPN, Infra |
| Grafana | [grafana.int.leighhack.org](https://grafana.int.leighhack.org) | LAN / VPN, Infra |
| Gatus (uptime alerts) | [gatus.int.leighhack.org](https://gatus.int.leighhack.org) | LAN / VPN |
| Router/network dashboard | [network-info.int.leighhack.org](https://network-info.int.leighhack.org) | LAN / VPN |
| Switch management | [switch.int.leighhack.org](https://switch.int.leighhack.org) | LAN / VPN, Infra |
| Proxmox | [monster.int.leighhack.org](https://monster.int.leighhack.org) | Anywhere, Members read / Infra write |
| TrueNAS | [truenas.int.leighhack.org](https://truenas.int.leighhack.org) | LAN / VPN, Infra |
| Authentik | [id.leighhack.org](https://id.leighhack.org) | Anywhere |
| UniFi (access points) | [unifi-admin.int.leighhack.org](https://unifi-admin.int.leighhack.org) | LAN / VPN, Infra |
| Home Assistant | [ha.int.leighhack.org](https://ha.int.leighhack.org) | LAN / VPN |
| Frigate (cameras) | [frigate.int.leighhack.org](https://frigate.int.leighhack.org) | LAN / VPN |
| zigbee2mqtt | [zigbee2mqtt.int.leighhack.org](https://zigbee2mqtt.int.leighhack.org) | LAN / VPN |
| Filestore | [filestore.int.leighhack.org](https://filestore.int.leighhack.org) | LAN / VPN, Infra |
| Membership (GoCardless) dashboard | [gocardless.int.leighhack.org](https://gocardless.int.leighhack.org) | LAN / VPN, Directors + Infra |
| Speedtest | [speed.leighhack.org](https://speed.leighhack.org) | Anywhere |
| Photos (Immich) | [immich.leighhack.org](https://immich.leighhack.org) | Anywhere |
| Matrix / Element | [matrix.leighhack.org](https://matrix.leighhack.org), [element.leighhack.org](https://element.leighhack.org) | Anywhere |
| Mattermost | [mattermost.leighhack.org](https://mattermost.leighhack.org) | Anywhere |
| Outline (wiki) | [outline.leighhack.org](https://outline.leighhack.org) | Anywhere |
| Audiobooks (Alexandria) | [alexandria.int.leighhack.org](https://alexandria.int.leighhack.org) | LAN / VPN |
| Inference API | [strata.leighhack.org](https://strata.leighhack.org) | Anyone with the API key |
| Space status feed | [api.leighhack.org](https://api.leighhack.org) | Anywhere |

Each one is a row in `common/front-door.nix` in the infra repo, and that table is what
the router's nginx is generated from - which is why a name either has a row or doesn't
resolve. "LAN / VPN" means the row is answered only to the space's own address ranges and
the tailnet; "Anywhere" means it isn't. Some of those also want a sign-in at the door
before they'll answer - that's the `sso` flag on the row, and it's Authentik doing the
checking. "Infra"/"Members" means the application itself applies a group check on top.

## Printers

The member printer is a **Brother MFC-L3740CDW** colour laser MFP, at
`10.3.2.30` / `brother.int.leighhack.org`. It's on the wireless VLAN and advertises
itself over mDNS, so any device that supports IPP/AirPrint should find it; the raw IPP
queue is `ipp://10.3.2.30/ipp/print`.

The old HP Laserjet and the Epson inkjet in the Pi Room are gone - the Brother is the only
printer answering on the network. If you can't find it, or need something printed and
can't work out how, contact [infra](../membership/useful_contacts.md#tech-infrastructure).

## NAS Storage

Storage is a TrueNAS box - `nas2.int.leighhack.org`, `10.3.1.6`, in Rack 1 - holding the
member data, the camera recordings, and the Proxmox VM disks. It should give a reasonable
amount of reliability, and we still provide *no guarantees* about data on it.

* NFS is for the servers. Members don't need it.
* SMB guest access is available for share access; there are no private CIFS shares.
* Members who log in on the network (the Pi Room, aibox) get a home directory on it. Its
  ACL is your Authentik account, so the account *is* the backup of your identity here.

While it should be reliable, it is **slow to come up after a power cut**, and everything
that needs it waits for it rather than failing. Ask [infra](../membership/useful_contacts.md#tech-infrastructure) if
you have a specific requirement for a share.

## Backups

There are backups, of a sort: `services1`'s `/srv` (its databases, its configs, the state
of most of what's in the table above) is pushed to the NAS with borg on a schedule, and
the borg server is a container on the NAS itself.

That means the NAS holds the only copy of everything, including itself. Anything that
matters to you personally should exist somewhere else too. Nobody is checking restores on
a rota - if that changes you'll see it here.

## Filestore

Filestore is a web file browser over the NAS `filestore` share, at
[filestore.int.leighhack.org](https://filestore.int.leighhack.org). It's an Infra tool now -
signed in with Authentik, gated to the `Infra` group - and it does thumbnailing, search,
preview, and drag-and-drop upload.

**It is not scanned for viruses.** It used to be, and the scanner isn't wired in any more,
so treat the share as unfiltered storage.

## Single Sign-On

Everything above authenticates against [Authentik](devices/authentik/index.md) at
[id.leighhack.org](https://id.leighhack.org). Your membership subscription is what puts you
in the `Members` group, and that group is what the [tailnet](vpn.md) and the general
services check; `Infra` is what gets you into the administrative ones. Ask
[infra](../membership/useful_contacts.md#tech-infrastructure) if you think you should be in one and aren't.

## Monitoring

Prometheus scrapes every machine we control (and the print servers' APIs), Grafana
draws it, and Gatus checks the endpoints and shouts in Slack when one stops answering.
`status.leighhack.org` is the public view of that, and each box also runs its own little
status dashboard (`services1-status.int`, `services2-status.int`, `aibox-status.int`) for
when the monitoring itself is the thing that's broken.

If you want something scraped or checked, drop a message to
[infra](../membership/useful_contacts.md#tech-infrastructure).

## MQTT

An MQTT broker is available at `mqtt.int.leighhack.org`, port `1883`. It is still
unauthenticated and there is no TLS listener, so anything on the network or the tailnet can
read and publish whatever it likes - which is fine for the sensors and dashboards it's used
for, and is not a channel for anything secret. Home Assistant, Frigate and zigbee2mqtt all
dial it.

## Inference

We have three GPU/accelerated boxes offering OpenAI-compatible endpoints:

* [strata.leighhack.org](https://strata.leighhack.org) - public, API key required (ask infra)
* `strata.int.leighhack.org` and `strata2.int.leighhack.org` - the same engines on the LAN, where the door injects the key so local clients don't need one
* `llama.int.leighhack.org` - llama.cpp on services3 (a GTX 1080 Ti), LAN only
* `whisper.int.leighhack.org` - speech to text, over a WebSocket

The chat UI at `ai.leighhack.org` lives on aibox and shares that box with the build
machine; when the big engine is loaded there isn't enough RAM for both, so the UI being
down is usually "someone is running inference", not an outage.

## Cameras, Door, and Phones

Frigate is our NVR ([frigate.int.leighhack.org](https://frigate.int.leighhack.org)) for the eight feeds around the
space, plus a scene-change monitor that watches the main space. The door entry system has its own
UI at [doors.int.leighhack.org](https://doors.int.leighhack.org) and an API at `api-doors.int`. The intercom is
bare Asterisk on services1, answering `10.3.1.166`, and the [state switch](devices/state_switch/index.md) by the
front door is what sets whether we're open.

The [Space API](https://api.leighhack.org) (`/space.json`, `/events.ics`) is the public,
machine-readable version of that - whether we're open, and what's on.

## Member VMs

Members can request VMs on our Proxmox host, `monster1`. Log in with your Authentik
account at [monster.int.leighhack.org](https://monster.int.leighhack.org); permissions for self-service should already be set
up.

Read the [Proxmox page](devices/proxmox/index.md) before you build anything important: the disks live on the NAS,
there are **no backups of any VM**, and the host is a single machine.

## Outbound Mail (retired)

`mx1.int.leighhack.org` was an outbound relay for internal systems. The VM has been stopped
since 2026-10 and mail from the space does not send. If you need outbound mail for a
service, talk to [infra](../membership/useful_contacts.md#tech-infrastructure) - it's a decision, not a switch.
