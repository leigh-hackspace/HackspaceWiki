# pfSense / Gateway

We use pfSense as our router/gateway for the hackspace systems.

## ISP / Connectivity

### Mill Network

The mill provides internet access via a 100mbps internal network. It can be a bit unreliable but it works for our general usage. 

* ISP: [Awareness Software Ltd](https://aware-soft.com/) (AS34931)
* Mill Network Administrator: [Mark Nightingale](data@imagevillage.co.uk), Image Village.

Access to the mill network is provided by a singular CAT5 delivered to the rear of the main space, just above where Rack1 is.

* VLAN: 50 (untagged)
* Subnet: `192.168.20.0/24`
* Gateway: `192.168.20.1`
* DHCP Enabled

Currently this is cabled into the 'mini switch' in Rack1 (see [network layout](../../network_layout.md#network-layout)).

Usage is bound by the [LBPT Tenant Network Agreement](../../mill_network_tc.md).

### Hackspace Connectivity

Our internet connection uses the mill's shared network, but we have a [Business L2TP](https://www.aa.net.uk/broadband/l2tp-service/) 'VPN' to [Andrew Arnold](https://www.aa.net.uk/), who provide us with 600Mb/sec, 10TB/month, and a /29 block of IPv4 and a /48 IPv6.

* Line ID: lhc1@a
* Account ID: A8***0A

* Control Panel Login: [https://control.aa.net.uk/](https://control.aa.net.uk/)
* Billing Login: [https://accounts.aa.net.uk/](https://accounts.aa.net.uk/)

The L2TP connection is currently paid for and managed by [Andrew Williams](mailto:lhwiki@m.tensixtyone.com). If you have any queries regarding the connection please contact them.

## Admin Tasks

### Restart the L2TP Connection

Sometimes, the L2TP connection doesn't automatically restore due to bug in pfSense, and may need reconnecting until it works.

* Login to pfSense - [https://gw.int.leighhack.org](https://gw.int.leighhack.org).
* Goto `Status` -> `Interfaces`
* Find the `AAISP` interface, and click the `Disconnect` button
* Wait for the page to reload, click the `Connect` button.
* Check the status on the front page to make sure that the AAISP gateways are online and have no lag, if not repeat again.

### Add a DNS record

* Login to pfSense - [https://gw.int.leighhack.org](https://gw.int.leighhack.org).
* Goto `Services` -> `DNS Resolver`
* Scroll to the bottom of the page and click `+ Add`
* Fill in the hostname, the domain as `int.leighhack.org` and the IP address.
* Give a meaningful description
* Click `Save`, then restart the DNS resolver when prompted.

### Assign a static DHCP

* Login to pfSense - [https://gw.int.leighhack.org](https://gw.int.leighhack.org).
* Goto `Services` -> `DHCP Server`
* Select the VLAN at the top of the screen.
* Scroll to the bottom of the page, and click the `+ Add` button
* Fill in the form with the required details
* Click `Save`
* Restart the DHCP server when prompted.

If you want to modify a device that already has a IP address via DHCP, you can use `Status` -> `DHCP Leases` and click the `+` button next to the device to take you to the create new lease page and pre-filling the MAC.

### Add a firewall rule

We shouldn't have any reason to add firewall rules as most of the paths are open within the hackspace network. This is an expansive topic and has many pitfalls. 

Please have a good read of the [documentation](https://docs.netgate.com/pfsense/en/latest/firewall/fundamentals.html) before proceeding.