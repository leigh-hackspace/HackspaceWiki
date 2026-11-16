# VPN

Leigh Hackspace offers a VPN service to its members, this allows you connect to hackspace internal services while outside of the space itself.

We run our own [Tailscale](https://tailscale.com) network (the control server is
[Headscale](https://headscale.net), on the router), so you use the normal Tailscale client
on Windows, Linux, macOS, Android, and iOS. It is not Tailscale's hosted service: you tell
the client to use *our* coordination server, and you sign in with
[id.leighhack.org](https://id.leighhack.org).

> The old OpenVPN service is retired. It went away with the pfSense box it ran on; the
> configs at the bottom of this page are kept for the record and do not connect.

## Requirements

You'll need an account on [id.leighhack.org](https://id.leighhack.org). Ideally, sign up with the same email address that you used for your GoCardless membership and privileges will be automatically assigned - that puts you in the `Members` group, which is what the VPN checks. If not, then contact [Infra](../membership/useful_contacts.md#tech-infrastructure).

## Connecting

Install Tailscale, then point it at our server. On the command line:

```bash
sudo tailscale up --login-server=https://tailscale.leighhack.org
```

That prints a URL; open it, sign in with your Authentik account, and the device is on the
network. Every device you've ever joined is listed in the admin UI at
[tailscale.leighhack.org/admin](https://tailscale.leighhack.org/admin), so you can rename or
remove old ones yourself.

The apps have the same option in their settings rather than on the command line - it's
usually called "Use custom hosting provider" or "Self-hosted" (Android: the three-dot menu
on the sign-in screen; iOS: Settings → Advanced). Put `https://tailscale.leighhack.org` in
it, then sign in.

### Linux, GNOME, and Network Manager

The GNOME `Network` VPN panel has no Tailscale support - Tailscale is not a protocol
NetworkManager speaks, it's a program with its own daemon. So install the `tailscale`
package for your distro, and then either run the command above or install the GNOME
extension that wraps it. There's nothing to import and no profile to configure.

### Make sure you get the LAN

Subnet routes are offered by the router and approved by us, but a client has to say it will
use them:

```bash
sudo tailscale set --accept-routes
```

Without it you'll reach the services that run on tailnet addresses and nothing else - a
`10.3.1.20` or `10.3.14.61` connection will just time out, which looks like "the VPN is
broken" and isn't.

## Access

This VPN will give you access the same as being on the WiFi within the hackspace. All of
`10.3.0.0/16`, the `10.3.x.x` VLANs, the CS network at `192.168.2.0/24`, and the space's
IPv6 are reachable, and with the tailnet's DNS turned on `*.int.leighhack.org` resolves and
the short machine names work too.

The router also offers itself as an exit node, if you want everything on a device to come
out of the space rather than just the traffic destined for us. Ask
[Infra](../membership/useful_contacts.md#tech-infrastructure) to turn that on for your device.

If you have any specific requirements you need from the VPN then contact
[Infra](../membership/useful_contacts.md#tech-infrastructure).

## The Old OpenVPN Configs

These are the configs for the service we ran before the router was rebuilt. They will not
connect: there is no OpenVPN server listening, and we haven't rebuilt one because the old
one's keys and its Authentik bind account only existed on the retired appliance. If you
genuinely need OpenVPN rather than Tailscale, say why to
[Infra](../membership/useful_contacts.md#tech-infrastructure).

* [VPN Configuration](vpn/members-vpn.ovpn)
* [VPN Configuration for older OpenVPN versions](vpn/members-vpn-old.ovpn)
