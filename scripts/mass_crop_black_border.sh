#!/bin/bash

# The input file must be a list, which contains the orignal place of the pictures.                
    input=$(realpath $0 | awk -F 'scripts/mass_crop_black_border.sh' '{ print $1 }')"frames/"   		      # MUST MODIFY
# Output file
    output=$(realpath $0 | awk -F 'scripts/mass_crop_black_border.sh' '{ print $1 }')"crop/"                          # MUST MODIFY

number_of_proc=4
cd $input
find . -name "*.png" | parallel -j $number_of_proc -I% convert % -crop 3840x2028+0+66 $output$(basename %)
