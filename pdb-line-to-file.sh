#!/bin/bash
# By Jamie Alnasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to convert a single-line, ^| delimited PDB into a
# Brookhaven PDB (Protein Databank file)


while read PDB; do

	# Convert the customised line delimiter (^|) into \n
        # Read 1st line which is the PDB_ID (original pdb filename)
	PDB_FILE=$(echo $PDB | sed 's/\^|/\n/g' | head -n1)

	echo "Extracted/writing file $PDB_FILE"

	# Convert the customised line delimiter (^|) into \n and save to temp file
	# NB: tail is to remove the first line, which stores the original
	# pdb filename
	$(echo "$PDB" | sed 's/\^|/\n/g' | tail -n +2 >$PDB_FILE)

done

