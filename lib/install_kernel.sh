#!/bin/bash

install_kernel(){
	wget -c https://github.com/raspberrypi/firmware/archive/master.zip -O /usr/src/master.zip|| exit 1
	unzip -qq /usr/src/master.zip -d /usr/src/ || exit 1
	rsync -a /usr/src/firmware-master/boot/* /boot/ || exit 1
	rsync -a /usr/src/firmware-master/modules /lib/ || exit 1
	rsync  -a /usr/src/firmware-master/hardfp/opt/vc /opt/ || exit 1
}
