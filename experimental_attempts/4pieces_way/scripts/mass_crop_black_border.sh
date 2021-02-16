#!/bin/bash

# The input file must be a list, which contains the orignal place of the pictures.
    #input="/home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p1_180817_backup/"                # MUST MODIFY
    input="/home/wildhorse_project/tes/"
# Output file
    #output="/home/wildhorse_project/experimental_attempts/4pieces_way/test_dir/"                # MUST MODIFY
    output="/home/big/AI/"

number_of_proc=4
cd $input
find . -name "*.png" | parallel -j $number_of_proc -I% convert % -crop 3840x2028+0+66 $output$(basename %)
