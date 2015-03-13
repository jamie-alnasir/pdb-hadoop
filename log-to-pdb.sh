#!/bin/bash
# By Jamie Alnasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to convert a PDB-Hadoop generated concatenated log-file
# of legacy job reports into individual pdb-files

echo "Using file $1 as input..."

# split the input log file into individual files
csplit $1 '/^Extracted/' '{*}' -f_pdb

# clean/rename individual files using pdb-clean.sh
find -type f -name '_pdb*' -exec ./pdb-clean.sh {} \;
