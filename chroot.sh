#!/bin/bash

apt-get update || exit 1
apt-get install git vim unzip || exit 1
apt-get install openssh-server openssh-client || exit 1

cd /usr/src || exit 1
wget https://github.com/raspberrypi/firmware/archive/master.zip || exit 1
unzip master.zip || exit 1
cp /usr/src/firmware-master/boot/* /boot/ || exit 1
cp -av /usr/src/firmware-master/modules/ /lib/ || exit 1

