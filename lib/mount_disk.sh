#!/bin/bash

mount_disk(){
if [ $# -lt 2 ]
then
	echo usage ./$0 device
fi

mount "${1}2" /mnt || exit 1
mkdir /mnt/boot || exit 1
mount "${$1}1" /mnt/boot || exit 1
mount --bind /dev/ /mnt/dev/ || exit 1
mount --bind /proc/ /mnt/proc/ || exit 1
mount --bind /sys/ /mnt/sys/ || exit 1
}
