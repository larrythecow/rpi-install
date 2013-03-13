#!/bin/bash

source $dirname/postinstall.conf

function install_munin(){
	apt-get install munin-node bsd-mailx --yes || exit 1
	sed -i s/localhost.localdomain/${HOSTNAME}.${DOMAIN}/g /etc/munin/munin.conf
	echo "cidr_allow ${VPN_SUBNET}" >> /etc/munin/munin-node.conf
}
