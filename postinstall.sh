#!/bin/bash

# Copyright (C) 2012/2013  Imran Shamshad <sid@projekt-turm.de>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

dirname=`dirname $0`

source $dirname/lib/echocolor.sh 
source $dirname/postinstall.conf

echok "installing base packages"
apt-get update || exit 1
apt-get install ${PACKAGES=} --yes|| echoexit "could not install optional packages"

echok "installing bootloader and kernel"
source $dirname/lib/install_kernel.sh || echoexit "could not install kernel"
install_kernel

echok "installing config files"
source $dirname/lib/install_config.sh || echoexigt "error while copying config files"
install_config

echok "configuring network"
source $dirname/lib/configure_net.sh || echoexit "could not configure network"
configure_net

echok "configuring tinc"
source $dirname/lib/install_tinc.sh || echowarn "error while tinc configuration\nVPN will probally not work"
install_tinc

echok "install munin"
source $dirname/lib/install_munin.sh || echowarn "error while munin configuration"
install_munin

echok "configure avahi"
sed -i s/"#allow-interfaces=eth0"/"allow-interfaces=vpn-dev"/g /etc/avahi/avahi-daemon.conf

echok "install rpisensors"
source $dirname/lib/install_rpisensors.sh || echoexit "could not install rpi-sensors"
install_rpisensors

# random passwd or thread OR move to end 
echok "please enter new root password";
passwd || echowarn "error while setting password\n please set it manually"

echok "you have to copy your public key to server!!!!;
