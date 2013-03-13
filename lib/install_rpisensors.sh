#!/bin/bash

install_rpisensors(){
	cd /opt
	git clone https://github.com/larrythecow/rpi-sensors.git
	cp /opt/rpi-sensors/template/etc/cron.d/sensors /etc/cron.d/
}
