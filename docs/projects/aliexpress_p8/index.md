# AliExpress 'P8' Laptop

The P8 laptop is a miniature OEM laptop that is available on AliExpress under many different names. The device itself has no identifying branding outside of the model 'P8'.

It seems to relate to FCC ID [2A8WM-P8](https://fcc.report/FCC-ID/2A8WM-P8) by [Shenzhen Anxin Taihe Technology Co., Ltd](https://sz-botu.en.alibaba.com), which is the parent of Koosmile.

It is also known as: 

* Koosmile P8
* Topton P8 - https://www.toptonpc.com
* Meenhong P8 2-in-1 Laptop
* Crelander P8 Pocket mini Laptop

## Hardware Specs

* Intel N100 Alder Lake Processor (4 E-Cores, 6W TDP)
* 12GB LPDDR5 RAM
* Realtek 8852BE WiFi 6 
* Realtek 8111 Gigabit Ethernet
* Realtek ACL269 Audio
* Intel UHD Graphics (Alder Lake-N GT1) with 32 execution units
* 1280x800 touchscreen 8 inch display ([Datasheet](specs/lcd_panel.pdf))
* 2242 M.2 slot with PCIe Gen 3x4
* 1 x USB 3.1 type A port
* 1 x USB 3.2 Gen 1 type C port

Thunderbolt is mentioned in the AMI BIOS, but the original listing for the device doesn't. Some Alder Lake processors support Thunderbolt on the CPU, but it looks like the N series doesn't.

* [HWInfo Report](hwinfo.html)

## OS Support

### Windows

The device has drivers for Windows 10 and 11, a fresh installation of Windows 11 will boot and operate correctly but the Intel UHD graphics will only operate at 800x600, non-rotated.

A driver package is available for the device: (link soon)

### Linux

Working distributions:

* PopOS
* Arch Linux 
* NixOS - Current release is missing the WiFi drivers
* Ubuntu 23.01

## Workarounds

### In-built screen is blank after booting a Linux kernel

[Issue tracker](https://gitlab.freedesktop.org/drm/intel/-/issues/9063)

This is due to the modeset being wrong for the display (the values provided by the VBIOS seem to be wrong). To disable modesetting at boot add the following to the kernel command line:

`i915.modeset=0`

This will disable the iGPU for use in X/Wayland, so useful for getting to the installer of some distributions.

### The screen is not rotated in Linux

As root:

````
echo 1 > /sys/class/graphics/fbcon/rotate_all
````

X/Wayland can be done with Xrandr