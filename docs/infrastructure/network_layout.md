# Network Layout

## Hardware

| Name     | Manf    | Model          | Type      | Location    | Status                  | Notes                                  |
| -------- | ------- | -------------- | --------- | ----------- | ----------------------- | -------------------------------------- |
| GW       | HP      | Unknown        | Router    | Rack 1      | Live                    | HP desktop system running pfSense      |
| Switch 1 | Cisco   | Catalyst 3560G | L3 Switch | Rack 1      | Live                    | Serial console connected to USB on GW  |
| Switch 2 | Cisco   | Catalyst 3560G | L3 Switch | Rack 1      | Waiting to be installed | Sandbox/Learning switch                |
| Switch 3 | HP      | Procurve 2824  | L2 Switch | Fabrication | Live                    | Switch for the fabrication area        |
| AP 1     | TP-Link |                | AP        | Top of Rack | Live                    | Uses stock firmware                    |
| AP 2     | ???     | ???            | AP        | Pi Room     | Live                    | Connects to Pi Room VLAN, needs fixing |
| NAS 1    | QNAP    | TS-431+        | NAS       | Rack 1      | Waiting to be installed | Requires PSU                           |
| UPS      | APC     | ???            | UPS       | Rack 1      | Waiting to be used      | Ready to go when NAS has a PSU         |

## Physical Layout

Correct as of 2023-04-20

```mermaid
graph LR
    subgraph Rack1
    GW[GW - pfSense] 
    AP[AP 1] -->|en1| GW
    SWITCH1[Switch 1] -->|en0| GW
    SERVER1[Server 1] -->|Port46| SWITCH1
    NAS1[NAS 1] --> |Port45| SWITCH1
    end

    GW -->|re0| MILL
    MILL[Mill Network] --> MILLROUTER[Mill Router - Draytek] --> INTERNET((Internet))
    
    subgraph Pi Room
    PIROOMPC[Pi Room PCs] -->|Port3-24| SWITCH1
    PRINTERS[Printers] -->|Port47-48| SWITCH1
    PIROOMAP[AP 2] --> |Port15?| SWITCH1
    end

    subgraph Classroom
    CLASSROOMPC[Class Room PCs] -->|Port25-26| SWITCH1
    end
    
    subgraph Bar
    BAR[Bar Socket] -->|Port33| SWITCH1
    end
    
    subgraph Workshop
    SWITCH3[Switch 3] -->|Port34| SWITCH1
    end
```

### GW - pfSense

We've got a small HP desktop system running pfSense with a quad port NIC, giving us 5 physical NICs. At the moment the motherboard NIC is connected to the Mill network, and the 4 port NIC is used for internal traffic.

Some ports are having issues pulling 1gbps to the Switch, so the card/system needs replacing at the moment. If traffic across VLAN boundries becomes a problems it can be sorted.

| Port  | Connected to | Notes                          |
| ----- | ------------ | ------------------------------ |
| `re0` | Mill network |                                |
| `en0` | Switch 1     | Tagged only traffic, all VLANs |
| `en1` | AP 1         |                                |
| `en2` |              |                                |
| `en3` |              |                                |

## AP 1

Wifi is served by a router/AP on top of the rack. Its currently in 'dumb AP' mode, in that DHCP is disabled and we're not using any of the routing mode of the router itself. It has a 4 port switch and a 'Internet' port.

| Port       | Connected to | Notes |
| ---------- | ------------ | ----- |
| `Internet` |              |       |
| `Port1`    |              |       |
| `Port2`    |              |       |
| `Port3`    |              |       |
| `Port4`    | GW           |       |

## L3 Layout / VLANs

```mermaid
graph
    INTERNET((Internet))
    SHARED[Shared Services - VLAN 225]
    WIFI[WiFi - VLAN 226]
    PIROOM[Pi Room - VLAN 227]
    CLASSROOM[Classroom - VLAN 228]
    AUTOMATION[Automation VLAN 229]
    SHARED --> INTERNET
    PIROOM --> INTERNET
    CLASSROOM --> INTERNET
    WIFI --> INTERNET
    
    WIFI --> SHARED
    PIROOM --> SHARED
    CLASSROOM --> SHARED
    SHARED --> AUTOMATION
```

### Mill Network - VLAN '101'

Our outbound internet route, should be treated as untrusted due to relatively little control over devices in other businesses.

IP Range: `192.168.0.0/16`

### Shared Services - VLAN 225

Where the servers, routers, and other central bits are hosted.

IP Range: `10.3.1.0/24`

This subnet doesn't have DHCP enabled, we use static assignment. Here is the current list:

| Device Name   | IP Address  | Location               |
| ------------- | ----------- | ---------------------- |
| GW            | `10.3.1.1`  | Rack 1                 |
| Switch 1      | `10.3.1.2`  | Rack 1                 |
| Server 1      | `10.3.1.3`  | Rack 1                 |
| Switch 3      | `10.3.1.4`  | Workshop / Fabrication |
| HP Printer    | `10.3.1.50` | Pi Room 5/7            |
| Epson Printer | `10.3.1.51` | Pi Room 5/8            |

### Wifi - VLAN 226

Wifi users, General open access to the internet and internal services.

IP Range: `10.3.2.0/24`

DHCP enabled, `10.3.2.2 - 10.3.2.254`

### Pi Room - VLAN 227

Pi Room / Co-Working space. General open access to the internet and internal services.

IP Range: `10.3.14.0/24`

DHCP enabled, `10.3.14.2 - 10.3.14.254`

### Classroom - VLAN 228

Class room, General open access to the internet and internal services.

IP Range `10.3.15.0/24`

DHCP enabled, `10.3.15.2 - 10.3.15.254`

### Automation - VLAN 229

Used for any automation devices that do not require open internet access, or need to be secured away from the general network (e.g. Door system)

IP Range `10.3.16.0/24`

DHCP enabled, `10.3.16.2 - 10.3.16.128`

This subnet does have DHCP enabled, but we use some static assignment. Here is the current list:

| Device Name | IP Address | Location |
| ----------- | ---------- | -------- |