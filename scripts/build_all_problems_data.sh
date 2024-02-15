#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

# Get the folder path
folder=$1
# Check if the folder exists
if [ ! -d "$folder" ]; then
    echo "Folder $folder does not exist."
    exit 1
fi

# Loop through each subfolder
for subfolder in "$folder"/*/; do
    ./build_problem_data "${subfolder}" 
done
./problem_summary "$folder"

