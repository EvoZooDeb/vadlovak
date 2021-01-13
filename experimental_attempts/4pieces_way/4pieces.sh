#!/bin/bash

# Read argument
foldername=$1
output_folder="/home/wildhorse_project/V180905_12fps_4k_frames_4pieces"

# Check the second argument <output_folder>
if [ ! -d "$foldername" ]; then
    echo "\"$foldername\" is not a directory, please create it!"
    exit 1
fi
# Get absoult path
foldername=$(realpath $foldername)

# Correct the path if it necessary
if [ ${foldername: -1} != "/" ]; then
    foldername+="/"
fi

for file in $foldername*
do
  name=$(echo "$(basename $file)" | cut -f 1 -d '.')
  convert $file -crop 1950x1110+0+0 $output_folder"/"$name"_LT.png"
  convert $file -crop 1920x1080+1920+0 $output_folder"/"$name"_RT.png"
  convert $file -crop 1920x1080+0+1080 $output_folder"/"$name"_LB.png"
  convert $file -crop 1950x1110+1890+1050 $output_folder"/"$name"_RB.png"
done
