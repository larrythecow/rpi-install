#!/bin/bash



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
#chroot /mnt /root/rpi-install/chroot.sh || exit 1

