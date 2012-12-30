#!/bin/bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    Author: imran shamshad
#    Email: sid@projekt-turm.de

read -p "please enter device [/dev/sd[a-z]] " device;
echo -e "WARNING!";
echo -e "========";
echo -e "This will overwrite data on $device irrevocably.\n";
read -p "Are you sure? (Type uppercase yes): " input;
if [[ $input = YES ]] ; then
	echo -e "\tOK";
else
	echo -e "\tERROR\n\tIf you are sure, please type UPPERCASE yes";
	exit 1;
fi

echo -e "\tformating disk";
mkfs.vfat "${device}1" || exit 1
mkfs.ext4 "${device}2" || exit 1

echo -e "\tmounting disk";
mount "${device}2" /mnt || exit 1
mkdir /mnt/boot || exit 1
mount "${device}1" /mnt/boot || exit 1

echo -e "\trunning debootstrap";
apt-get update || exit 1
apt-get install debootstrap || exit 1
time debootstrap --arch armhf wheezy /mnt/ http://mirrordirector.raspbian.org/raspbian/  || exit 1

# copy apt only temporary because of public key of apt server!
cp -a /etc/apt/* /mnt/etc/apt/ || exit 1
cp -a /root/rpi-install  /mnt/root/  || exit 1

mount --bind /dev/ /mnt/dev/ || exit 1
mount --bind /proc/ /mnt/proc/ || exit 1
mount --bind /sys/ /mnt/sys/ || exit 1
chroot /mnt /root/rpi-install/chroot.sh || exit 1

