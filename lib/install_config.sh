#!/bin/bash

source $dirname/postinstall.conf

function install_config(){
	rsync -a $dirname/config/* /
	install /proc/mounts  /etc/mtab
	echo ${HOSTNAME} > /etc/hostname
	locale-gen
}
