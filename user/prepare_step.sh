#!/bin/bash

### Check if no argument passed ###
if [ $# -eq 0 ]; then
	echo "Error, step folder is not specified"
	exit 1
else
	echo -e "\n##### Start step number ${1} #####\n"
	step_folder=step${1}/
	cd ${step_folder}
fi

# COMMANDS
crypt="gramine-sgx-pf-crypt encrypt -w ../server/ provisioning_key"
cp_cipher="scp -r ${ENC_PATH}outs/* ${CSP_SERVER}:${CSP_PATH}${ENC_PATH}"
cp_plain="scp -r ${PLAIN_PATH}* ${CSP_SERVER}:${CSP_PATH}${PLAIN_PATH}"
cp_source="scp $SOURCE_CODE ${CSP_SERVER}:${CSP_PATH}${ SOURCE_CODE}entry.${PROCESS_LABEL}"

### All input files in $ENC_PATH are encrypted in $ENC_PATH/outs/ ###

#before starting encrypting, clear folders outs/ and tmps/
if [ -d "${ENC_PATH}outs/" ]; then
	rm -r ${ENC_PATH}outs/
fi

if [ -d "${ENC_PATH}tmps/" ]; then
	rm -r ${ENC_PATH}tmps/
fi

files=($(ls ${ENC_PATH}))
mkdir ${ENC_PATH}tmps/
mkdir ${ENC_PATH}outs/
#for each file in $ENC_PATH:
#1. mv the file in a temporary location (e.g. enc/tmps/1.txt)
#2. encrypt this file to an original location (e.g. enc/1.txt)
#3. move the encrypted file to output location
#4. restore the original location of the plain file
for file in ${files[@]}
do
	echo "mv ${ENC_PATH}$file ${ENC_PATH}tmps/$file"
	mv ${ENC_PATH}$file ${ENC_PATH}tmps/$file

	echo -e "Encrypting $file ... $crypt -i ${ENC_PATH}tmps/$file -o ${ENC_PATH}$file"
	$($crypt -i ${ENC_PATH}tmps/$file -o ${ENC_PATH}$file > /dev/null)

	echo -e "mv ${ENC_PATH}$file ${ENC_PATH}outs/$file"
	mv ${ENC_PATH}$file ${ENC_PATH}outs/$file

	echo -e "mv ${ENC_PATH}tmps/$file ${ENC_PATH}$file\n"
	mv ${ENC_PATH}tmps/$file ${ENC_PATH}$file
done
rm -r ${ENC_PATH}tmps/

### Copy input files (encrypted and plain) and source code from local to remote C3 ###
./../clean_remote.sh #before copy, cleaning remote machines (C3 and SGX)
$($cp_cipher)
$($cp_plain)
$($cp_source)