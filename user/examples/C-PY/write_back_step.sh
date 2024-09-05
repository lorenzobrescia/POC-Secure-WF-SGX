#!/bin/bash

### Check if no argument passed ###
if [ $# -eq 0 ]; then
	echo "Error, step is not specified"
	exit 1
else
	step_folder=step${1}/
	cd ${step_folder}
fi

# COMMANDS
decrypt="gramine-sgx-pf-crypt decrypt -w ../server/provisioning_key"
cp_results_back="scp -r ${CSP_SERVER}:${CSP_PATH}${RESULTS_PATH}* ${RESULTS_PATH}"

# Retrieve output from remote CSP to local machine
$($cp_results_back)

### Decrypting results files ###
files=($(ls results/))
for file in ${files[@]}
do
	$($decrypt -i ${RESULTS_PATH}$file -o ${RESULTS_PATH} decrypted_${file})
done
echo -e "The resulting file are located in ${RESULTS_PATH} folder"