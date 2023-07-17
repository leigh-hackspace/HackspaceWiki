# 3D Printers

We have 3 printers available for all members to use after training.

All printers are networked, and we ask that you use the linked OctoPi server when printing your files.

[PrusaSlicer](https://www.prusa3d.com/page/prusaslicer_424/) profiles are linked for each printer.

CAD-1 is available for you to design, slice and print your models.

> You are responsible for ensuring the safe operation of printers.  
> Do not leave the printers unattended for prolonged periods of 
> time.  
> If you are in doubt about the operation of the printers, please ask, and 
> someone will be happy to help.


Workflow:

There's a number of repeatable steps to printing on our printers.  
We're hoping that everyone can follow them and have a consistent experience.

* You'll need a STL model file to print.  [Find one online](https://www.printables.com/), or design your own using the CAD tools available.
* If using CAD-1, [PrusaSlicer](https://www.prusa3d.com/page/prusaslicer_424/) is configured for the printers.
* If not using CAD-1, download PrusaSlicer and the PrusaSlicer profile for the printer you want to use.
* Copy the profile files to your local Prusa folder (c:\users\USERNAME\AppData\Roaming\PrusaSlicer on Windows).
* Start PrusaSlicer, import your STL.
* [Slice your model and export a GCode file.](https://help.prusa3d.com/article/first-print-with-prusaslicer_1753)
* Open the OctoPi for your printer, and login (ask if you don't have the password).
* Drag the sliced GCode file to the OctoPi server.
* Turn on the printer.
* Ensure filament is loaded.
* Click on the file in OctoPi to load, print your file from OctoPi.
* Keep an eye on OctoPi and the printer as your file is printing.

Our printers:

## 3D-1 - Makerbot Replicator 2

* The Makerbot Replicator 2 is only suitable for **PLA** printing with 1.75mm filament.
* The OctoPi will accept **GCode** files sliced with the linked PrusaSlicer profile.

* This printer is great for rapid first draft prints.

* [OctoPi](http://3d-1.int.leighhack.org) (link only accessible from LeighHack network)
* [Manual](manuals/makerbot_replicator2.pdf)
* [PrusaSlicer Profile](https://github.com/qratz/replicator2_PrusaSlicer)

OctoPi on 3D-1 is configured to accept gcode files in RepRap format.  
If configuring your own profile, please ensure "G-code flavour" is set to "RepRap Firmware".


## 3D-2 - Ender 3 Pro

* The Ender 3 Pro is suitable for **PLA** and **PETG** printing with 1.75mm filament.
* Please only leave **PLA** filament in the printer when not printing.

* This printer is great for all types of prints, but especially detail prints.

* [OctoPi](http://3d-2.int.leighhack.org) (link only accessible from LeighHack network)
* [Manual](manuals/ender3.pdf)
* [PrusaSlicer Profile](https://github.com/sn4k3/Ender3)

## 3D-3 - Anycubic Vyper


* The Anycubic Vyper is suitable for **PLA** and **PETG** printing with 1.75mm filament.
* Please only leave **PLA** filament in the printer when not printing.

* This printer is great for all types of prints, but especially detail prints.

* [OctoPi](http://3d-3.int.leighhack.org) (link only accessible from LeighHack network)

* [Manual](manuals/anycubic_vyper.pdf)
* [Official Support Page](https://www.anycubic.com/pages/firmware-software)
* [PrusaSlicer Profile](https://github.com/igrowing/sharing_is_caring/tree/main/3d_print/Anycubic%20Vyper)

