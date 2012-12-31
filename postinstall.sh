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

source /root/rpi-install/postinstall.conf

echo "${Packages}"
echo -e "\tplease enter new root password";
passwd || exit 1

echo -e "\tinstalling base packages"
apt-get update || exit 1
apt-get install ${Packages} || exit 1
dpkg-reconfigure locales

echo -e "\tinstalling bootloader and kernel"
cd /usr/src || exit 1
wget -c https://github.com/raspberrypi/firmware/archive/master.zip || exit 1
unzip -qq master.zip || exit 1
cp /usr/src/firmware-master/boot/* /boot/ || exit 1
cp -a /usr/src/firmware-master/modules/ /lib/ || exit 1

echo -e "\tinstalling config files"
rsync -a /root/rpi-install/config/* /
install /proc/mounts  /etc/mtab
echo ${hostname} > /etc/hostname


echo -e "\tconfiguring tinc"
# update tinc.conf
sed -i s/HOSTNAME/${hostname}/g /etc/tinc/vpn/tinc.conf
sed -i s/VPN_DEV/${VPN_DEV}/g /etc/tinc/vpn/tinc.conf
# update tinc-up
sed -i s/VPN_DEV/${VPN_DEV}/g /etc/tinc/vpn/tinc-up
sed -i s/VPN_IP/${VPN_IP}/g /etc/tinc/vpn/tinc-up
sed -i s/VPN_Netmask/${VPN_Netmask}/g /etc/tinc/vpn/tinc-up
# generate keys
tincd -K -n vpn
# update public key
echo "Address=${IP}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Port=${VPN_Port}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Subnet=${VPN_Subnet}" >> /etc/tinc/vpn/hosts/${hostname};
echo "Compression=9" >> /etc/tinc/vpn/hosts/${hostname};

echo -e "\tyou have to copy your public key to server!!!!";
