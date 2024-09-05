#!/bin/bash

### EXPORTS ###
export PLAIN_PATH="input/plain/"
export ENC_PATH="input/enc/"
export RESULTS_PATH="results/"
export CSP_SERVER="user@server" ### CUSTOMIZE
export CSP_BASE_PATH="path/" ### CUSTOMIZE

### FULL CLEAN LOCAL WORKFLOW ###
./clean_local.sh

### OBTAIN STEP FOLDERS ###
arr=(./*/) #This creates an array of the full paths to all subdirs
arr=("${arr[@]%/}") #This removes the trailing slash on each item
arr=("${arr[@]##*/}") #This removes the path prefix, leaving just the dir names
steps_dir=()
for dir in "${arr[@]}"
do
        if [[ "$dir" == "step"* ]]; then
                steps_dir+=(${dir}/)
        fi
done

### LOOP OVER ALL STEP FOLDERS ###
len=${#steps_dir[@]}
for (( i=1; i<=$len; i++ ))
do
	export PROCESS_LABEL=$(head -n 1 step${i}/info.conf)
	export CSP_PATH="${CSP_BASE_PATH}${PROCESS_LABEL}/"
	export SOURCE_CODE=$(head -n2 step${i}/info.conf | tail -n1)

	./prepare_step.sh ${i}
	./enclave_step.sh
	./write_back_step.sh ${i}

	#if it is not last step
	if [[ $i -ne $len ]]; then
		./next_step.sh ${i}
	else
		echo -e "\n##### Last step (number ${i}) is terminated #####\n"
	fi

	./clean_remote.sh
done