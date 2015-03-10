#!/bin/bash
# By Jamie Al-Nasir, 18/01/2014
# Dept. of Computer Science, Royal Holloway University
#
# A script to convert a single-line, ^| delimited PDB into a
# Brookhaven PDB (Protein Databank file)


#//------------------------------------------------------------------------------
# Use _LEGACY_PROGRAM_ to define the Legacy program you wish to parallelise
# using Hadoop. Provide the filepath to the program and any command-line options
_LEGACY_PROGRAM_="timeout 10m /home/local/mxba001/docking/PDB-hadoop-dock.sh"

# Use _POST_PROC_PROGRAM_ to define the Legacy program/script you wish to use
# to process the output from the parallelised Legacy program above
_POST_PROC_PROGRAM_="/home/local/mxba001/PDB-hadoop/post-proc.sh"

# Use _TEMP_FOLDER_ to define a readable folder for this program to work in
# ** Ensure there is a trailing /
_TEMP_FOLDER_="/tmp/"

# Use _MAX_PDB_SIZE_ to ignore processing of files > given size (in bytes)
_MAX_PDB_SIZE_=2097152
#//------------------------------------------------------------------------------
EXEC_DATE=$(date)
EXEC_HOST=$(hostname)

echo "PDB-Hadoop executing job on $EXEC_DATE using host-node: $EXEC_HOST"
echo

while read PDB; do

	# Convert the customised line delimiter (^|) into \n
    # Read 1st line which is the PDB_ID (original pdb filename)
	PDB_FILE=$(echo $PDB | sed 's/\^|/\n/g' | head -n1)

	# Remove any temp file with the same name from the temp folder
	rm -f $_TEMP_FOLDER_$PDB_FILE

	echo "Extracted/writing file $_TEMP_FOLDER_$PDB_FILE"

	# Convert the customised line delimiter (^|) into \n and save to temp file
	# NB: tail is to remove the first line, which stores the original
	# pdb filename
	$(echo "$PDB" | sed 's/\^|/\n/g' | tail -n +2 >$_TEMP_FOLDER_$PDB_FILE)
		        

	# Check if PDB max file size limit set, execute the Legacy program...
	if [[ -n $_MAX_PDB_SIZE_ ]]; then
        	PDB_SIZE=$(stat -c%s $_TEMP_FOLDER_$PDB_FILE)
	        echo PDB_SIZE=$PDB_SIZE
	        if [ $PDB_SIZE -le $_MAX_PDB_SIZE_ ]; then

                # Execute the legacy job, PDB < $_MAX_PDB_SIZE_
                PRE_OUTPUT=$($_LEGACY_PROGRAM_ $_TEMP_FOLDER_$PDB_FILE);
	        else

        	        echo "Skipped processing $PDB_FILE as filesize ($PDB_SIZE bytes) > _MAX_PDB_SIZE_ ($_MAX_PDB_SIZE_ bytes)"
	        fi

	else
		# Execute the legacy job, regardless of PDB file size
		PRE_OUTPUT=$($_LEGACY_PROGRAM_ $_TEMP_FOLDER_$PDB_FILE)
	fi

	# Handle abnormal, non-zero exit code state from legacy program
	# Write this to results and continue
	if [[ $? != 0 ]] ; then
		echo "Error: Legacy program exited abnormally with an exit status: $?"

		# Remove any temp file
		rm -f $_TEMP_FOLDER_$PDB_FILE
	fi


	# Execute the post-processing script...
	if [ -n "$_POST_PROC_PROGRAM_" ]; then
		echo "Initiating post-processing..."
 	        POST_PDB_FILE="__$PDB_FILE"
		$(echo "$PRE_OUTPUT" >$_TEMP_FOLDER_$POST_PDB_FILE)
		PRE_OUTPUT=$($_POST_PROC_PROGRAM_ $_TEMP_FOLDER_$POST_PDB_FILE)

		# Handle abnormal, non-zero exit code state from legacy program
		# Write this to results and continue
		if [[ $? != 0 ]] ; then
			echo "Error: Post-processing program exited abnormally with an exit status: $?"

			# Remove any temp file
			rm -f $_TEMP_FOLDER_$POST_PDB_FILE
		fi
	fi


	# Add line numbers and filename to each result line for Map operation sorting
	PRE_OUTPUT=$(echo "$PRE_OUTPUT" | nl -w10 -nrz)
	OUTPUT=$(echo "$PRE_OUTPUT" | sed "s/^/$PDB_FILE-/")

	# Return the result to Hadoop...
	echo "$OUTPUT"

done

# Remove any temp file
rm -f $_TEMP_FOLDER_$PDB_FILE
