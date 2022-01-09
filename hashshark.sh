#!/bin/bash
wordlists=../wordlists/pass/fast/*
iter=0

function hashcatfunc {
	local fmode=$1
	local workhash=$2

	./hashcat-6.2.5/hashcat.bin -a 0 -m $fmode --force $workhash $wordlists > /dev/null
	result="$(./hashcat-6.2.5/hashcat.bin -a 0 -m $fmode $workhash --show)"
	if [ ! -z "$result" ]; then
		password="$(echo $result | rev | cut -f 1 -d ":" | rev)"
		echo [+] Cracked: $password 
		echo ${hash#*InputHash/}:$password >> cracked.txt
	else
		echo [-] No password found
	fi
}

function main() {
	for hash in ./InputHash/*; do
		if [ "$(ls -A ${hash%/*})" ]; then
			echo [*] Cracking: "${hash#*InputHash/}"
			if [[ $hash == *.cap ]]; then
				mode=22000
				echo [+] Hash Mode: $mode
				newname="${hash/InputHash/.WorkHash}"
				newname="${newname%.cap}".hc22000  
				./hcxpcapngtool $hash -o $newname > /dev/null
				mv $hash "${hash/InputHash/.TrashHash}"
				hashcatfunc $mode $newname

			elif [[ $hash == *.hc* ]]; then
				mode="${hash#*.hc}"
				echo [+] Hash Mode: $mode
				newname="${hash/InputHash/.WorkHash}"
				cp $hash $newname
				mv $hash "${hash/InputHash/.TrashHash}"
				hashcatfunc $mode $newname 
			else
				echo [-] ERROR: Unindentified Hash!!!
				mv $hash "${hash/InputHash/.TrashHash}"
			fi
		fi
	done
}

while true; do main; sleep 30; done
