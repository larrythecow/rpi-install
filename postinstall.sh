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

function echocolor {
        echo -e "\033[32m$1\033[0m";
}
function cleanup {
        echo -e "\033[31minstallation canceled\033[0m";
}
trap cleanup EXIT;


source /root/rpi-install/postinstall.conf

echocolor "please enter new root password";
passwd 

echocolor "installing base packages"
apt-get update || exit 1
apt-get install ${Packages} || exit 1

echocolor "installing bootloader and kernel"
cd /usr/src || exit 1
wget -c https://github.com/raspberrypi/firmware/archive/master.zip || exit 1
unzip -qq master.zip || exit 1
rsync -a /usr/src/firmware-master/boot/* /boot/ || exit 1
rsync -a /usr/src/firmware-master/modules/ /lib/ || exit 1

echocolor "installing config files"
rsync -a /root/rpi-install/config/* /
install /proc/mounts  /etc/mtab
echo ${hostname} > /etc/hostname
locale-gen

echocolor "configuring tinc"
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

echocolor "you have to copy your public key to server!!!!\nplease ignore the following failture message";
