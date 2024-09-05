#!/bin/bash

### Check if no argument passed ###
if [ $# -eq 0 ]; then
	echo "Error, step is not specified"
	exit 1
else
	step_folder=step${1}/
	cd ${step_folder}
fi

### Move decrypted_ files to next step intermediate folder
echo -e "Moving results file to next pipeline step..."
for file in "${RESULTS_PATH}"decrypted_*; do
	filename=$(basename "$file")
	original="${filename#decrypted_}"
	cp "$file" "../step$((${1}+1))/${ENC_PATH}${original}"
done
echo -e "\n##### Step number ${1} is terminated #####\n"