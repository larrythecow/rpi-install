#!/bin/bash

#mkfs.vfat /dev/sda1 || exit 1
#mkfs.ext4 /dev/sda2 || exit 1
#mkswap /dev/sda3 || exit 1

#mount /dev/sda2 /mnt || exit 1
#mkdir /mnt/boot || exit 1
#mount /dev/sda1 /mnt/boot || exit 1
#apt-get install debootstrap
#time debootstrap --arch armhf wheezy /mnt/ http://mirrordirector.raspbian.org/raspbian/  || exit 1

#cp /etc/fstab etc/fstab || exit 1
#cp /etc/hosts /mnt/etc/ || exit 1
#cp /proc/mounts  /etc/mtab || exit 1
#cp -a /etc/apt/* /mnt/etc/apt/ || exit 1

mount --bind /dev/ /mnt/dev/ || exit 1
mount --bind /proc/ /mnt/proc/ || exit 1
mount --bind /sys/ /mnt/sys/ || exit 1
cp -a /root/rpi-install  /mnt/root/  || exit 1
chroot /mnt /root/rpi-install/chroot.sh || exit 1

