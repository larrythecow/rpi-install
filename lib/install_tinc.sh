#!/bin/bash

source $dirname/postinstall.conf
dirname=`dirname $0`

function install_tinc(){
	apt-get install liblzo2-2
	dpkg -i $dirname/packages/tinc_1.1pre4-1_armhf.deb
	# update tinc.conf
	sed -i s/HOSTNAME/${HOSTNAME}/g /etc/tinc/vpn/tinc.conf
	sed -i s/VPN_DEV/${VPN_DEV}/g /etc/tinc/vpn/tinc.conf
	# update tinc-up
	sed -i s/VPN_DEV/${VPN_DEV}/g /etc/tinc/vpn/tinc-up
	sed -i s/VPN_IP/${VPN_IP}/g /etc/tinc/vpn/tinc-up
	sed -i s/VPN_NETMASK/${VPN_NETMASK}/g /etc/tinc/vpn/tinc-up
	# generate keys
	#tincd -K -n vpn
	echo -ne '\n' |tincctl generate-keys -n vpn
	# update public key
	echo "Port=${VPN_PORT}" >> /etc/tinc/vpn/hosts/${HOSTNAME};
	echo "Subnet=${VPN_SUBNET}" >> /etc/tinc/vpn/hosts/${HOSTNAME};
	echo "Compression=9" >> /etc/tinc/vpn/hosts/${HOSTNAME};
}
