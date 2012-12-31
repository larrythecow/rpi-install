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
#
#    Author: imran shamshad
#    Email: sid@projekt-turm.de

source=setup.conf || echo "could not find configfile" ; exit 1

echo -e "\tplease enter new root password";
passwd || exit 1

echo -e "\tinstalling base packages"
apt-get update || exit 1
apt-get install git vim unzip openssh-server openssh-client tinc rsync|| exit 1

echo -e "\tinstalling bootloader and kernel"
cd /usr/src || exit 1
wget https://github.com/raspberrypi/firmware/archive/master.zip || exit 1
unzip -q master.zip || exit 1
cp /usr/src/firmware-master/boot/* /boot/ || exit 1
cp -av /usr/src/firmware-master/modules/ /lib/ || exit 1

echo -e "\tinstalling config files"
rsync  /root/rpi-install/config/* / -av
install /proc/mounts  /etc/mtab
echo ${hostname} > /etc/hostname


echo -e "\tconfiguring tinc"
sed s/HOSTNAME/${hostname}/ /etc/tinc/vpn/tinc.conf > /etc/tinc/vpn/tinc.conf
tincd -K -n vpn
echo "Address=${IP}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Port=${VPN_Port}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Subnet=${VPN_Subnet}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Compression=9" >> /etc/tinc/vpn/hosts/${hostname};

echo -e "\tyou have to copy your public key to server!!!!";
