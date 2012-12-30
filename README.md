RPI Setup Script
================

USAGE
-----
  ./setup
This script will debootstrap a debian from a raspberry system to a external drive. please note, that the current u-boot sytem will only boot from a mmc disk
It will ask for a device and uppercase yes.

ToDo
----
* automatically partiton and format disk
* automatically copy files from PWD/config to /etc
* set hosts hostname and so on
* we want color
* finish tinc installation
* add debugflag, and print to stdout and stderr
* set locale
