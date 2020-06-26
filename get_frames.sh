#!/bin/bash

# Standard message
if [ "$#" -ne 2 ]; then
    if [ "$#" -gt 2 ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo "The first argumentum must be the input file and the second one is the output directory"
    echo "	e.g: ./get_frames.sh test/wildhorse.mp4 frames/"
    exit 1
fi

# Save arguments
input_file=$1
output_folder=$2

# Check the first argument <input_file>
if [ ! -f "$input_file" ]; then
    echo "\"$input_file\" is not a valid file, please check again!"
    exit 1
fi

# Check the second argument <output_folder>
if [ ! -d "$output_folder" ]; then
    echo "\"$output_folder\" is not a directory, please create an empty folder!"
    exit 1
fi

# Correct the path if it necessary
if [ ${output_folder: -1} != "/" ]; then
    output_folder+="/"
fi

# Append filename
output_folder+="frame_%05d.png"

# Run command
cmd="ffmpeg -i $input_file $output_folder"
eval $cmd