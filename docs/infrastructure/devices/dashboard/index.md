# Dashboard

The dashboard is a AIO (all-in-one) PC that shows interesting stuff about the hackspace, either the current status, flyers for upcoming events or just fun bits of information.

## System

The system is a 

* Intel Atom J1900
* 8GB RAM
* 32GB eMMC
* RTL WiFi card 
 
# Software

Currently it has Ubuntu 22, and has a very bare bones configuration, making use of snaps for the display framework.

## Ubuntu Frame

Ubuntu Frame is a snap package that provide a Wayland environment for other snaps and applications.

```
# snap install ubuntu-frame
# snap install ubuntu-frame-vnc
```

### Display configuration

As we have the display rotated 90 degrees it requires a small tweak to the config of Ubuntu Frame.

## WPE Webkit Mir Kiosk

A snap that bundles together a simline Webkit browser with some very basic configuration options. All it needs is connection to a Wayland environment and the URL to load.

```
# snap install wpe-webkit-mir-kiosk
# snap connect wpe-webkit-mir-kiosk ubuntu-frame:wayland
# snap set wpe-webkit-mir-kiosk url=http://localhost:9400/receiver
```

## DashKiosk

[Management interface](http://dashboard.int.leighhack.org:9400/)

```
# snap install dashkiosk
```