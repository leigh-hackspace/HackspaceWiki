# AliExpress 'P8' Laptop

The P8 laptop is a miniature OEM laptop that is available on AliExpress under many different names. The device itself has no identifying branding outside of the model 'P8'.

It seems to relate to FCC ID [2A8WM-P8](https://fcc.report/FCC-ID/2A8WM-P8) by [Shenzhen Anxin Taihe Technology Co., Ltd](https://sz-botu.en.alibaba.com), which is the parent of Koosmile.

It is also known as: 

* Koosmile P8
* Topton P8 - https://www.toptonpc.com
* Meenhong P8 2-in-1 Laptop
* Crelander P8 Pocket mini Laptop

## Hardware Specs

* Intel [N100 Alder Lake](https://ark.intel.com/content/www/us/en/ark/products/231803/intel-processor-n100-6m-cache-up-to-3-40-ghz.html) Processor (4 E-Cores, 6W TDP)
* 12GB LPDDR5 RAM
* [Realtek 8852BE](https://techinfodepot.shoutwiki.com/wiki/Realtek_RTL8852BE_Combo_Module) WiFi 6 
* Realtek 8111 Gigabit Ethernet ([Datasheet](specs/RTL8111.PDF))
* Realtek ACL269 Audio ([Datasheet](specs/ALC269_RealtekMicroelectronics.pdf))
* Intel UHD Graphics (Alder Lake-N GT1) with 24 execution units
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
* Ubuntu 23.01 - Requires Kernel 6.7 for the screen to work correctly with the [workaround](#in-built-screen-is-blank-after-booting-a-linux-kernel)

## Workarounds

### In-built screen is blank after booting a Linux kernel

[Issue tracker](https://gitlab.freedesktop.org/drm/intel/-/issues/9063)

This is due to the modeset being wrong for the display (the values provided by the VBIOS seem to be wrong). To disable modesetting at boot add the following to the kernel command line:

`i915.modeset=0`

This will disable the iGPU for use in X/Wayland, so useful for getting to the installer of some distributions.

### The screen is not rotated correctly in Linux on boot

As root:

````
echo 1 > /sys/class/graphics/fbcon/rotate_all
````

X/Wayland can be done with Xrandr

### The sensor keeps rotating the screen incorrectly.

This issue is due to the 'IIO' sensors not being mapped correctly within Linux. This sensor works perfectly fine in Windows with the correct driver, but Linux doesn't seem to be able to detect the screen rotated. The rotation will work if the screen is rotated outwards like a tablet, but normally it believes that the correct rotation in laptop mode is 'right_up'.

A couple of services are used in this system.

* udev
* systemd-hwdb
* iio-sensor-proxy

First you need to create a rule for the sensor device in the hwdb, `/etc/udev/hwdb.d/60-sensors.hwdb`:

```
# A wide matching rule, but the Koosmile P8 has no Manf/Prod strings
# This fixes the screen in 'laptop' mode to rotate correctly, but not tablet mode
sensor:modalias:acpi:BOSC0200*
  ACCEL_MOUNT_MATRIX=-1, 0, 0; 0, 1, 0; 0, 0, 1
```

This file will set a udev variable for the device of `ACCEL_MOUNT_MATRIX`, which `iio-sensor-proxy` uses. Then you need to reload the hardware DB, and get udev to 'trigger' for the sensor device, recreating the settings and variables for it.

```shell
# systemd-hwdb update
# udevadm trigger -v -p DEVNAME=/dev/iio:device0
```

Next, you need to restart `iio-sensor-proxy`

```shell
# systemd restart iio-sensor-proxy
```

Depending on your desktop environment, you may need to do some further configuration or install a library, in the case of GNOME you'll need the [Screen Rotate](https://extensions.gnome.org/extension/5389/screen-rotate/) extension.