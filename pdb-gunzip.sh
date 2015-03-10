#!/bin/bash
# By Jamie Al-Nasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to recursively unzip ent.gz gzipped
# Brookhaven PDB (Protein Databank) files in folder provided

if [ "$#" -ne 1 ]; then
    printf "\nExpected a parameter!\n\n"
    printf "Usage pdb-gunzip.sh <pdb-folder>\n\n"
	exit
fi

find $1 -type f -name '*.ent.gz' -exec echo "extracting {}" \; -exec gunzip {} \;

printf "Done.\n"

