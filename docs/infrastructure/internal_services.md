# Internal Services

The hackspace runs a collection of services on the hackspace network, either to assist with automation or just to be useful for members.

## Filestore

Filestore is a generic, web-accessible filestore system that is available on all segments of the network. 

[http://filestore.int.leighhack.org](http://filestore.int.leighhack.org)

## MQTT

We have a MQTT server available, at `mqtt.int.leighhack.org`. At the moment this service is unauthenticated, but in the future it'll require a login and possibly TLS client certs.

Hostname: `mqtt.int.leighhack.org`
Port: `1883`

## Prometheus

A internal Prometheus instance is available at `http://server1.int.leighhack.org:9090`. If you wish to have it scrape any internal services then drop a message to the Infra team.

## Grafana

Grafana dashboarding is available at [http://grafana.int.leighhack.org](http://grafana.int.leighhack.org).