# Internal Services

The hackspace runs a collection of services on the hackspace network, either to assist with automation or just to be useful for members.

## Printers

We have a couple of printers available for members to use, they should be visible to all systems (using Bonjour/mDNS) and work with any device that supports IPP.

* Big Laser Printer - A HP black and white laser printer
* Colour Inkjet Printer - A Epson colour inkjet multi-function printer.

Both are located in the corner of the [Pi Room](../facilities/pi_room.md). Replacement cartridges/toner are available, if they need replacing then contact [infra](../membership/useful_contacts.md#tech-infrastructure) or one of the [directors](../membership/useful_contacts.md#directors).

## NAS Storage

We have a 10TB NAS storage system running as RAIDZ1, while it should give a reasonable amount of reliability we provide absolutely no guarantees regarding data security and provide *no backups*.

The NAS storage is available via NFS, we can't offer private CIFS/SMB access, only guest access.

If you have a specific requirement for a private share, contact [infra](../membership/useful_contacts.md#tech-infrastructure).

## Filestore

Filestore is a generic, web accessible filestore system that is available on all segments of the network. Any files stored in this location are scanned with ClamAV, and anything identified as problematic will be automatically quarantined. If you have any issues then contact [infra](../membership/useful_contacts.md#tech-infrastructure).

* [http://filestore.int.leighhack.org](http://filestore.int.leighhack.org)
* [smb://guest:guest@nas2.int.leighhack.org/filestore](smb://guest:guest@nas2.int.leighhack.org/filestore)

## Outbound Mailserver

`mx1.int.leighhack.org` has been configured as an outbound email server relay for the internal hackspace systems, configured with all mod-cons such as SPF and DKIM so mail should arrive at their destination when the downstream systems are configured correctly.

* Port `25`
* Supports STARTTLS
* Use `leighhack.org` or `int.leighhack.org` for the mails

Outbound mails are monitored, and Infra will be unhappy if this is abused.

## MQTT

We have a MQTT server available, at `mqtt.int.leighhack.org`. At the moment this service is unauthenticated, but in the future it'll require a login and possibly TLS client certs.

Hostname: `mqtt.int.leighhack.org`
Port: `1883`

## Prometheus

A internal Prometheus instance is available at `http://apps1.int.leighhack.org:9090`. If you wish to have it scrape any internal services then drop a message to the [infra](../membership/useful_contacts.md#tech-infrastructure) team.

## Grafana

Grafana dashboarding is available at [http://grafana.int.leighhack.org](http://grafana.int.leighhack.org).

## Member VMs

Members can create VMs on our 'monster' Proxmox host. Permissions should be setup correctly for members to self service via the [Proxmox portal](https://monster.int.leighhack.org).

For further information contact [infra](../membership/useful_contacts.md#tech-infrastructure).
