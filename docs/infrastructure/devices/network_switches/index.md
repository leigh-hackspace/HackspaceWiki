# Network Switches

Three managed switches, all HP ProCurve, all configured over **Telnet only** - there is no
API and no web UI on the devices themselves:

| Name | Model | Address | Firmware |
| ---- | ----- | ------- | -------- |
| `switch1` | HP ProCurve 2510G-48 (J9280A) | `10.3.1.2` | Y.11.44 |
| `switch2` | HP ProCurve 2510G-48 (J9280A) | `10.3.1.3` | Y.11.44 |
| `switch3` | HP ProCurve 2824 (J4903A) | `10.3.1.4` | I.10.107 |

`switch1` is the core: the router's trunk lands on it, and it carries every VLAN.
`switch2` feeds the Pi Room, Classroom and Social Space, and `switch3` the fabrication
area. While the 2824 is the older switch it offers L3-lite capabilities that we don't use;
the others are plain managed L2 switches. All three speak the standard HP CLI.

* [CLI Reference for the 2510 series](./2510-MgmtCfg-July2007-59914761.pdf)
* [CLI Reference for the 2800 series](./59906023-1004-Mgmt%20&%20Config.pdf)

## The Web UI

[switch.int.leighhack.org](https://switch.int.leighhack.org) is the supported way to change
a port. It signs in with your Authentik account (`Infra` group), polls all three switches
every minute into a shadow copy, shows you a diff, and applies a queued batch on the
switch box - then follows every batch it applied with `write memory`, because these
switches hold a change in RAM until something saves it.

Use it in preference to a telnet session. A hand-made change is invisible to it until the
next poll, and is undone by a reboot: a mains blip on 2026-10-31 reverted a day of hand
edits on all three switches.

## Logging In

`telnet 10.3.1.2`, username `agent`, password in the password manager. `agent` is a
Manager, so you get in read-only and have to `enable` before `conf` will do anything.

You will see **`Can't reach RADIUS server.`** printed on a perfectly successful login. That
is this firmware's generic "authentication failed" line: the switches are configured to try
RADIUS against Authentik first and fall back to their local account database, and RADIUS
never answers - there is no `agent` user in Authentik, so the outpost sends no reply at all.
So your id.leighhack.org account does **not** work on the switches today, and every login
costs a few seconds of RADIUS timeout. `switch3` is the slow one: 15-25 s to a prompt is
normal there.

Fixing it means giving Authentik an `agent` user whose password matches the switches'
local one, or dropping RADIUS from those accounts' auth order; until then a `login_failed`
for `agent` in Authentik is this, and not an incident.

## HP Switches

### Enabling a port untagged on a VLAN

* Login to the switch via telnet, and run `enable`.
* Run `conf`
* Switch to the VLAN context needed with `vlan 225`
* Type `untagged 25` representing the port number, ranges can be specified e.g. `25-30`
* `exit`, `exit`, `wr mem`

### Enabling a trunk port on multiple VLANs

* Same as a untagged port, switch to each VLAN and use `tagged <portid>` rather than `untagged`

### Reading what a port is in

`show vlan <id>` leaves the `Name` column blank for dynamically-learned members, and
`show port name` doesn't exist on this firmware, so port names come from
`show running-config`. `switch-gui` merges the six `show` commands needed to describe a
port; doing it by hand means running all six.

### Saving

**Nothing saves itself.** `running-config` is in RAM and `startup-config` is what loads at
boot, so a change made by hand is only real once you've typed `write memory`. A reboot is
the only undo for a bad change, and for a change made at a console it's also the only way
back - so check what you've written before you save, and don't save the thing you were only
testing.
