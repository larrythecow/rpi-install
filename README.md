RPI Setup Script
================

USAGE
-----
./setup

This script will debootstrap a debian from a raspberry system to a external drive. please note, that the current u-boot sytem will only boot from a mmc disk

It will ask for a device and uppercase yes.

the configuration file for postinstall (hostname, VPN, ...) is located at postinstall.conf. 

<pre>
hostname="pisid02"
IP="192.168.1.162"		# external IP (currently only used for TINC!!!), DHCP is running

VPN_DEV="vpn-dev"		# device which will be used (ifconfig)
VPN_IP="192.168.240.50"		# internal IP
VPN_Port="2223"			# VPN Port
VPN_Subnet="192.168.240.0/24"	# VPN NET rename me!
Packages="git vim unzip openssh-server openssh-client tinc rsync locales ntp screen"	# packages which will be installed
</pre>

ToDo
----
* automatically partiton and format disk
* add debugflag, and print to stdout and stderr
* If IP, Subnet, GW is set, change /etc/network/interfaces
