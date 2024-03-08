#!/bin/bash

ssh -q ${C3_SERVER} bash <<-EOF
cd ${C3_PATH}
echo -e "\nStart cleaning C3 machine..."
./clean.sh
echo -e "C3 machine: cleaning done"
	ssh -q ${SGX01_SERVER} bash <<-EOF2
	cd ${SGX01_PATH}
	echo -e "\nStart cleaning SGX machine..."
	./clean.sh
	echo -e "SGX machine: cleaning done\n"
	exit
	EOF2
exit
EOF