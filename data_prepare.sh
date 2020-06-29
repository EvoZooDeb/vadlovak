#!/bin/bash

min_arg=3

# Standard message
if [ "$#" -ne $min_arg ]; then
    if [ "$#" -gt $min_arg ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo -e "Arguments explanation:\n   1: input video\n   2: frames output directory\n   3: coordinates location"
    echo "	e.g: ./data_prepare.sh sample/wildhorse.mp4 frames/ sample/coordinates.txt"
    exit 1
fi

# Save arguments
input_file=$(realpath $1)
output_folder=$(realpath $2)
coord_loc=$(realpath $3)

# Check the first argument <input_file>
if [ ! -f "$input_file" ]; then
    echo -e "Input file ERROR:\n   \"$input_file\" is not a valid file, please check again!"
    exit 1
fi

# Check the second argument <output_folder>
if [ ! -d "$output_folder" ]; then
    mkdir $output_folder
fi

# Check the first argument <coord_loc>
if [ ! -f "$coord_loc" ]; then
    echo -e "Coordinates location ERROR:\n   \"$coord_loc\" is not a valid file, please check again!"
    exit 1
fi


# Correct the path if it necessary
if [ ${output_folder: -1} != "/" ]; then
    output_folder+="/"
fi

# Append filename
frame_out=$output_folder"frame_%05d.png"

# Run command
cmd="ffmpeg -i $input_file $frame_out"
eval $cmd

#Rscript file path
gen_csv_path=$(dirname $(realpath $0))"/scripts/generate_csv.R"

Rscript $gen_csv_path $coord_loc $output_folder