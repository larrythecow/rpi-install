#!/bin/bash

echo -e "\troot pwd, maybe you can del me";
passwd || exit 1

echo -e "\tinstalling base packages"
apt-get update || exit 1
apt-get install git vim unzip || exit 1
apt-get install openssh-server openssh-client || exit 1

echo -e "\tinstalling bootloader and kernel"
cd /usr/src || exit 1
wget https://github.com/raspberrypi/firmware/archive/master.zip || exit 1
unzip master.zip || exit 1
cp /usr/src/firmware-master/boot/* /boot/ || exit 1
cp -av /usr/src/firmware-master/modules/ /lib/ || exit 1

echo -e "\tinstalling config files"
install /root/rpi-install/config/cmdline.txt	/boot/cmdline.txt
install /root/rpi-install/config/fstab		/etc/fstab
install /root/rpi-install/config/inputrc	/etc/inputrc
install /root/rpi-install/config/interfaces	/etc/network/interfaces
install /root/rpi-install/config/vimrc		/etc/vim/vimrc
install /root/rpi-install/config/sshd_config	/etc/ssh/sshd_config
#cp /etc/hosts /mnt/etc/ || exit 1
install /proc/mounts  /etc/mtab

echo -e "\tinstalling tinc"
apt-get install tinc
mkdir -p /etc/tinc/vpn/hosts/
install /root/rpi-install/config/tinc-up	/etc/tinc/vpn/tinc-up
install /root/rpi-install/config/tinc.conf	/etc/tinc/vpn/tinc.conf
tincd -K -n vpn
cat /root/rpi-install/config/pi_sid >> /etc/tinc/vpn/hosts/pisid
install /root/rpi-install/config/main /etc/tinc/vpn/hosts/main
echo "vpn" >> /etc/tinc/nets.boot
