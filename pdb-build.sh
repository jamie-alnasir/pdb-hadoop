#!/bin/bash
# By Jamie Alnasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to recursively unzip ent.gz gzipped
# Brookhaven PDB (Protein Databank) files in folder provided

if [ "$#" -ne 2 ]; then
    printf "\nExpected parameters!\n\n"
    printf "Usage pdb-build.sh <pdb-folder> <pdb-out-file>\n\n"
	exit
fi

printf "Building single concatenated pdb-file: $1\n"

find $1 -type f -name '*.ent' -exec ./pdb-to-line.sh {} >$2 \;

printf "Done.\n"

