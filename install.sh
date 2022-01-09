#!/bin/bash

if [ "$USER" == root ] 
then
	echo Do not run this script as root
else
	# install dependencies for compiling 
	sudo apt update && sudo apt install gcc libssl-dev libcurl4-openssl-dev p7zip wget
	wget https://github.com/hashcat/hashcat/releases/download/v6.2.5/hashcat-6.2.5.7z
	p7zip -d hashcat-6.2.5.7z
	wget https://raw.githubusercontent.com/ZerBea/hcxtools/master/hcxpcapngtool.c
	gcc hcxpcapngtool.c -o hcxpcapngtool
	mkdir InputHash .WorkHash .TrashHash
fi
