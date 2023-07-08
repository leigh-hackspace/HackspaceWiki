# Internal Services

The hackspace runs a collection of services on the hackspace network, either to assist with automation or just to be useful for members.

## NAS Storage

We have a 4TB NAS storage system running as RAID-10, while it should give a reasonable amount of reliability we provide absolutely no guarantees regarding data security and provide *no backups*.

The NAS storage is available via NFS, we can't offer CIFS/SMB due to it not working correctly on the QNAP device for guest access.

If you have a specific requirement for a private share, contact [infra](../membership/useful_contacts.md#tech-infrastructure).

## Filestore

Filestore is a generic, web accessible filestore system that is available on all segments of the network. Any files stored in this location are scanned with ClamAV, and anything identified as problematic will be automatically quarantined. If you have any issues then contact [infra](../membership/useful_contacts.md#tech-infrastructure).

* [http://filestore.int.leighhack.org](http://filestore.int.leighhack.org)

## MQTT

We have a MQTT server available, at `mqtt.int.leighhack.org`. At the moment this service is unauthenticated, but in the future it'll require a login and possibly TLS client certs.

Hostname: `mqtt.int.leighhack.org`
Port: `1883`

## Prometheus

A internal Prometheus instance is available at `http://apps1.int.leighhack.org:9090`. If you wish to have it scrape any internal services then drop a message to the Infra team.

## Grafana

Grafana dashboarding is available at [http://grafana.int.leighhack.org](http://grafana.int.leighhack.org).