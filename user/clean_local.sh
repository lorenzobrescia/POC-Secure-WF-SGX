#!/bin/bash

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

# Per tutte le cartelle step*/
for dir in "${steps_dir[@]}"
do
	echo -e "### Cleaning Local Machine (folder $dir) ###"
	echo -e "Cleaning folder results/"
	rm -f ${dir}results/*

	echo -e "Cleaning temporary folder enc/tmps"
	if [ -d "${dir}input/enc/tmps/" ]; then
		rm -r ${dir}input/enc/tmps/
	fi

	echo -e "Cleaning folder enc/outs"
	if [ -d "${dir}input/enc/outs/" ]; then
		rm -r ${dir}input/enc/outs/
	fi

	echo -e "Cleaning previous steps ' result, (input/enc/decrypted_*)\n"
	rm -f ${dir}input/enc/decrypted_*
done