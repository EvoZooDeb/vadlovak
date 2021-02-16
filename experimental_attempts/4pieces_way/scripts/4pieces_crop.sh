#!/bin/bash

# Input argument, this variable must be a directory which contains the pictures
    foldername="/home/big/AI/test2"
    #foldername="/home/dkatona/temp/"
# Output folder name where the program will crop the original 4k pictures
    output_folder="/home/big/AI/test_pieces2/"               # MUST MODIFY
    #output_folder="/home/dkatona/temp/"

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

# Two resolution
#    - 1920x1054

#cd $foldername
#var=$(find . -name "*.png")
#convert $var +repage -crop 1960x1054+0+0 $output_folder"/LT.png"
#convert $var +repage -crop 1960x1054+1880+0 $output_folder"/RT.png"
#convert $var +repage -crop 1960x1054+0+974 $output_folder"/LB.png"
#convert $var +repage -crop 1960x1054+1880+974 $output_folder"/RB.png"

#exit 0
number_of_proc=4

cd $foldername

find . -name "*.png" | parallel -j $number_of_proc -I% convert % +repage -crop 1960x1054+0+0 $output_folder"/"{.}"_LT.png"
find . -name "*.png" | parallel -j $number_of_proc -I% convert % +repage -crop 1960x1054+1880+0 $output_folder"/"{.}"_RT.png"
find . -name "*.png" | parallel -j $number_of_proc -I% convert % +repage -crop 1960x1054+0+974 $output_folder"/"{.}"_LB.png"
find . -name "*.png" | parallel -j $number_of_proc -I% convert % +repage -crop 1960x1054+1880+974 $output_folder"/"{.}"_RB.png"

#  name=$(echo "$(basename $file)" | cut -f 1 -d '.')
#  convert $file -crop 1960x1054+0+0 $output_folder"/"$name"_LT.png"
#  convert $file -crop 1960x1054+1880+0 $output_folder"/"$name"_RT.png"
#  convert $file -crop 1960x1054+0+974 $output_folder"/"$name"_LB.png"
#  convert $file -crop 1960x1054+1880+974 $output_folder"/"$name"_RB.png"