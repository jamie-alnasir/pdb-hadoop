#!/bin/bash
# By Jamie Al-Nasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to clean PDB-Hadoop generated pdb-file by removing
# pdb-id and line-numbers. Also extracts the pdb_id and re-creates
# the pdb-file from the input temporary file


# locate/extract log-segment pdb-id
pdb_id=$(sed '1!d' $1)

# extract text after trailing backslash
pdb_id="${pdb_id##*/}" 
echo "$pdb_id"

$(cut -d- -f2- $1 | cut -d"	" -f2- >$pdb_id)

# remove original file
rm -rf $1
