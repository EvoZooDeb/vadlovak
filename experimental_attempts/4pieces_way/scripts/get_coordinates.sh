#!/bin/bash

# Input directory which contains pictures
    input_pic_dir="/home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p10_190910/"                                   # MUST MODIFY
# Number of elements which will be taken from the input directory
    max_element=350                                                                                                                 # MUST MODIFY
# Coordinate.txt file which contains all bounding boxes (raw data from Kata)
    input_coord_file="/home/wildhorse_project/horse_coordinates/horse_coordinates/190910/horse_coordinates.txt"                     # MUST MODIFY
# output results txt file 
    output_txt="/home/wildhorse_project/experimental_attempts/4pieces_way/dataset/bounding_box_orig_coord_p10_[Bbox]_re.txt"           # MUST MODIFY

# Take the frame identified from the name of the picture and append it to a list
    for i in $input_pic_dir/*
    do
        just_name=$(basename $i)
        a=${just_name: -8}
        b=${a:: -4}
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
