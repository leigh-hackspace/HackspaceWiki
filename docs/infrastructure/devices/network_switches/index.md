# Network Switches

## Logging In

For **switch1**, check the password manager.

For all managed switches you can login using your [id.leighhack.org](https://id.leighhack.org) account if you're in the 'Infra' group. This will give you write permissions to the switch. This uses RADIUS to Authentik behind the scenes.

## HP Switches

All managed switches in the space are HP Procurve switches. They're now supported under the 'Aruba' brand as 'HPE/Aruba' switches.

Switch 1 and 2 are **2510-48G**, and Switch 3 is a **2824**

While the 2824 is the older switch it offers L3-lite capabilities, that we don't use. The others are just standard L2 managed switches with the usual bells and whistles.

### Enabling a port untagged on a VLAN

* Login to the switch via telnet, using your  [id.leighhack.org](https://id.leighhack.org) account.
* Run `conf`
* Switch to the VLAN context needed with `vlan 225`
* Type `untagged 25` representing the port number, ranges can be specified e.g. `25-30`
* `exit`, `exit`, `wr mem`

### Enabling a trunk port on multiple VLANs

* Same as a untagged port, switch to each VLAN and use `tagged <portid>` rather than `untagged`