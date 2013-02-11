#!/bin/bash

# Copyright (C) 2012/2013  Imran Shamshad <sid@projekt-turm.de>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>


dirname=`dirname $0`

source $dirname/lib/echocolor.sh
source $dirname/postinstall.conf

echo -e "\033[32m";
read -e -p "please enter device [/dev/sd[a-z]]: " device;
echo -e "\n\033[1;31mWARNING!\033[0;32m";
echo -e "========";
echo -e "This will overwrite data on \033[1;31m${device}\033[0;32m irrevocably.";
read -p "Are you sure? (Type uppercase yes): " input;
if [[ $input != "YES" ]] ; then
	# check if device exist
	echo -e "\033[31m\tERROR\nIf you are sure, please type UPPERCASE yes\033[0m"
	echoexit "Installation aborted";
fi
echo -e "\033[0m";

echok "installing necessery applications";
apt-get update || exit 1
apt-get install debootstrap dosfstools bc --yes || echoexit "unable to install installation packages"

echok "partitioning, formating and mounting disk";
$dirname/lib/3rdparty/omap3-mkcard.sh ${device} || echoexit "unable to partition disk"

echok "mounting disks"
source lib/mount_disk.sh
mount_disk $device

echok "running debootstrap";
time debootstrap --arch armhf wheezy /mnt/ http://mirrordirector.raspbian.org/raspbian/  || echoexit "error while running debootstrap"

echok "running some postinstall and enter chroot";
# copy apt only temporary because of public key of apt server!
# cp -a /etc/apt/* /mnt/etc/apt/ || exit 1
apt-get install raspbian-archive-keyring
cp -a $dirname/../rpi-install  /mnt/root/

chroot /mnt /root/rpi-install/postinstall.sh || echoexit "postinstall returned error"
