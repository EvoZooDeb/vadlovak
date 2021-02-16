#!/bin/bash

# The input file must be a list, which contains the orignal place of the pictures.
    input="/home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p1_[333].txt"         # MUST MODIFY
# The output must be a directory, where the script will copy the pictures from the list
    output="/home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p1_180817"                # MUST MODIFY

# Simple copy
while IFS= read -r line
do
  a=$(basename $line)
 ln $line $output"/"$a
done < "$input"