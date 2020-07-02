#!/bin/bash

min_arg=3

# Standard message
if [ "$#" -ne $min_arg ]; then
    if [ "$#" -gt $min_arg ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo -e "Arguments explanation:\n   1: input model path\n   2: input video path\n   3: output file path"
    echo "	e.g: ./test_draw.sh snapshots/model_v1.h5 frames/frame_00001.png draw_boxes.png"
    exit 1
fi

# Save arguments
input_model=$(realpath $1)
input_video=$(realpath $2)
draw_boxes=$(realpath $3)

# Check the first argument <input_model>
if [ ! -f "$input_model" ]; then
    echo -e "Input file ERROR:\n   \"$input_model\" is not a valid file, please check again!"
    exit 1
fi

# Check the first argument <input_frame>
if [ ! -f "$input_video" ]; then
    echo -e "Input file ERROR:\n   \"$input_video\" is not a valid file, please check again!"
    exit 1
fi

#Python script file path
make_vid=$(dirname $(realpath $0))"/scripts/make_video.py"

python3 $make_vid $input_model $input_video $draw_boxes