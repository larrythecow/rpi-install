#!/bin/bash

dirname=`dirname $0`
source $dirname/postinstall.conf

# check if variable is empty
function configure_net(){
	if ( [ $ADDRESS == "DHCP" ]  || [ $ADDRESS == "dhcp" ] ); then
		echo -e "auto eth0\niface eth0 inet dhcp" >> /etc/network/interfaces
	else
		echo "iface eth0 inet static" >> /etc/network/interfaces
		echo -e "address $ADDRESS"  >> /etc/network/interfaces
		echo -e "netmask $NETMASK"  >> /etc/network/interfaces
		echo -e "address $GATEWAY"  >> /etc/network/interfaces
	fi
}

