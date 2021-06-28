#!/bin/bash

# Input directory which contains pictures
    input_pic_dir="../4pieces/"                                   # MUST MODIFY
# Number of elements which will be taken from the input directory
    max_element=350                                                                                                                 # MUST MODIFY
# Coordinate.txt file which contains all bounding boxes (raw data from Kata)
    input_coord_file="../sample_data/coordinates.txt"                     # MUST MODIFY
# output results txt file 
    output_txt="../bounding_box.txt"           # MUST MODIFY

# Take the frame identified from the name of the picture and append it to a list
    for i in $input_pic_dir/*
    do
        just_name=$(basename $i)
        a=${just_name: -12}  # -8
        b=${a:: -7}         # -4
	echo $a $b
        list_of_files=$list_of_files" "$b" "
    done

# Tokenize the list via white space
    IFS=" "
    list_of_files=($list_of_files)
    unset IFS

# Read the coordinates and pair the elements of the list.
#  - In the list, in front of the extension the last 4 number will determine the frame number
#  - In the coordinates, the number before the first comma will determine the frame number
#
# Simple condition check:
# e.g: V180817_1_12fps_4k_0005.png == 5,2727.392807006836,927.0901393890381
#          The condition result will be TRUE, because 0005 equal 5
#      V180817_1_12fps_4k_0005.png == 1,2338.392807006836,495.0901393890381
#          The condition result will be FALSE, because 0005 not equal 1
#
# The program automatically prints each coordinates row, where the conditions were TRUE.

echo -n "" > $output_txt
for f in ${list_of_files[@]}
do
    temp=$(echo $f | sed 's/^0*//')
    grep "^$temp," $input_coord_file >> $output_txt
done
