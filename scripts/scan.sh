#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

# Get the folder path
folder="$1"

# Check if the folder exists
if [ ! -d "$folder" ]; then
    echo "Folder $folder does not exist."
    exit 1
fi

# Loop through each subfolder
for subfolder in "$folder"/*/; do
    # Call field_duplicates with the subfolder as argument
    ./find_duplicates "${subfolder}params" -w "-s=${subfolder}readme.md" -v -c
done

echo "Done."

