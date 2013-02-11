#!/bin/bash

#function echocolor() {
#        echo -e "\033[32m$1\033[0m";
#}

function echok() {
        echo -e "\033[32m$1\033[0m";
}


function echowarn(){
	echo -e "\033[31m$1\033[0m";
}

function echoexit(){
	echo -e "\033[31m$1\033[0m";
	exit 1;
}
