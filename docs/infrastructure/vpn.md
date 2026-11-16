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

The one rule on every device: **tell the app which server to use before you sign in**. If
you sign in first you'll join Tailscale's own network instead of ours, and you'll have to
log out and start again. The URL every time is:

```
https://tailscale.leighhack.org
```

### Android (no command line)

1. Install Tailscale from the [Play Store](https://play.google.com/store/apps/details?id=com.tailscale.ipn) or F-Droid.
2. Open the app and tap the **settings menu in the top-right corner**, then `Accounts`.
3. Tap the **three-dot menu** in the top-right and select `Use an alternate server`.
4. Enter `https://tailscale.leighhack.org` and confirm. If a login window pops up, let it.
5. Sign in with your id.leighhack.org account in the browser window that opens.
6. Android will ask to add a VPN configuration - tap `Allow`/`OK`.
7. Flip the switch at the top of the app to connect.

### iPhone and iPad (no command line)

1. Install Tailscale from the [App Store](https://apps.apple.com/app/tailscale/id1470499037).
2. Open the app, tap the **account icon in the top-right**, and select `Log in…`.
3. Tap the **options menu in the top-right** and select `Use custom coordination server`.
4. Enter `https://tailscale.leighhack.org`, then sign in with your id.leighhack.org account.
5. iOS will open Settings asking you to add a VPN configuration - tap `Allow`, and use
   Face ID/your passcode when it asks.
6. Flip the switch in the app to connect.

Two things specific to iOS: if the phone has ever been signed into Tailscale's own service,
log out of that first. And the same setting is reachable outside the app - **Settings →
Tailscale → Alternate Coordination Server URL** - which is the way to do it if you've
already got a login stuck in there. Our server also prints these steps with its own URL
filled in, if you open [tailscale.leighhack.org/apple](https://tailscale.leighhack.org/apple)
on the phone.

### Linux, macOS, and Windows (with a terminal)

```bash
sudo tailscale up --login-server=https://tailscale.leighhack.org
```

That prints a URL; open it, sign in, and the device is on the network.

The GNOME `Network` VPN panel can't do this - Tailscale is not a protocol NetworkManager
speaks, it's a program with its own daemon. Install the `tailscale` package for your distro
and run the command above (or the GNOME extension that wraps it). There's nothing to import
and no profile to configure.

### Check it worked

Open [gatus.int.leighhack.org](https://gatus.int.leighhack.org) - it needs no login, so it's
a clean yes/no. Your device also appears in the admin list at
[tailscale.leighhack.org/admin](https://tailscale.leighhack.org/admin), where you can rename
it or remove old ones yourself.

### Make sure you get the LAN

Subnet routes are offered by the router and approved by us, but a client has to say it will
use them. On a laptop:

```bash
sudo tailscale set --accept-routes
```

On a phone there's a switch for it in the app's settings rather than a command, and its
wording changes between versions (something like "Approve routes" / "Use subnet routers"),
sometimes appearing as a prompt on the main screen instead.

Without this you'll reach the things that live on tailnet addresses and nothing else, so
`10.3.1.20` or `10.3.14.61` will just time out - which looks exactly like the VPN being
broken, and isn't. It's the first thing to check, and the first thing to mention when
asking for help.

## Access

This VPN will give you access the same as being on the WiFi within the hackspace. All of
the space's subnets are reachable - the servers in `10.3.1.0/24`, the wireless block in
`10.3.2.0/24`, the wired block in `10.3.14.0/24`, the CS network at `192.168.2.0/24`, and
the space's IPv6.

Names are worth knowing about, because they catch people out. `*.int.leighhack.org` has
public DNS records pointing at the router's internal address, so a name *resolves* from
anywhere, but it's only reachable when the VPN is carrying you - opening an `.int` link
without the VPN on just hangs rather than giving an error. Short names like `services1`
don't work off-site at all; use the `.int` name or the IP.

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
