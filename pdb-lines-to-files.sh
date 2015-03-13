#!/bin/bash
# By Jamie Alnasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to convert a multi-line file of single-line, ^| delimited PDB
# enties into a # Brookhaven PDB (Protein Databank file)


echo "Using file $1 as input..."

while read p; do
  echo "$p" | ./PDB-hadoop.py
done <$1
