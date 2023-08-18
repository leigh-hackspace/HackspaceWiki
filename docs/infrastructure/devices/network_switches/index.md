# Network Switches

## Logging In

For **switch1**, check the password manager.

For **switch2**, you can login using your [id.leighhack.org](https://id.leighhack.org) account if you're in the 'Infra' group. This will give you write permissions to the switch. This uses RADIUS to Authentik behind the scenes.

## Switch1

Switch1 is a Cisco Catalyst 3560G. A 52 port switch that is the core of our network. Its located in Rack1.

### Enabling a port untagged on a VLAN

Check the [network layout](../../network_layout.md) for the VLAN you need, most of the time for servers in the rack, then its `225`.

* Login to the switch
* Run `enable` to escalate to a privileged login
* Run `conf t` to switch to config mode.
* Configure the port as needed:

For a singluar port:
```
interface Gi0/35
switchport mode access
switchport access vlan 225
```


For multiple ports at once:
```
interface range GigabitEthernet0/35 - 37
switchport mode access
switchport access vlan 225
```

* Enter `exit`
* Test the port and connectivity
* Once happy, run `write mem` to commit the change to storage.

### Enabling a trunk port on multiple VLANs

Check the [network layout](../../network_layout.md) for the VLANs the device needs.

* Login to the switch
* Run `enable` to escalate to a privileged login
* Run `conf t` to switch to config mode.
* Configure the port to be a trunk:

```
interface Gi0/35
switchport mode trunk
```

* Optionally, define and limit the VLANs allowed: `switchport trunk allowed vlan 225,226,227`
* Optionally, define the VLAN that untagged packets will go to: `switchport trunk native vlan 225`
* Enter `exit`
* Test the port and connectivity
* Once happy, run `write mem` to commit the change to storage.



## Switch2

Switch2 is a HP Procurve 2824 Gigabit switch, it has full L2 and L3-lite managed features. We only make use of the L2 features. The device is located in the Fabrication area under the CAD desk, and is connected to Switch1 via a single CAT5 connection running at 100mbps (for some reason!). 

### Enabling a port untagged on a VLAN

* Login to the switch via telnet, using your  [id.leighhack.org](https://id.leighhack.org) account.
* Run `conf`
* Switch to the VLAN context needed with `vlan 225`
* Type `untagged 25` representing the port number, ranges can be specified e.g. `25-30`
* `exit`, `exit`, `wr mem`

### Enabling a trunk port on multiple VLANs

* Same as a untagged port, switch to each VLAN and use `tagged <portid>` rather than `untagged`