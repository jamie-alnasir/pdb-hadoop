#!/bin/bash
# By Jamie Alnasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to convert a Brookhaven PDB (Protein Databank file) ATOM records into a single
# line with it's original \n lines delimited by ^|


# extract text after trailing backslash
pdb_id="${1##*/}" 
# convert \n into ^| delimiter
echo -n "$pdb_id^|"
sed ':a;N;$!ba;s/\n/^|/g' $1 | tr -d '\r'

#tr '\n' '\r' < $1 | sed -e 's/\r/^|/g'
