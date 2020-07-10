#!/bin/bash
#Draw Boxes to picture

min_arg=3
max_arg=4

if [[ ( "$#" -ne $min_arg ) && ( "$#" -ne $max_arg ) ]]; then
    if [ "$#" -gt $max_arg ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo -e "Necessary arguments:\n   1: <input_model_path>   #Result of 'retinanet-convert-model' command\n   2: <input_frame_path>   #Choose a random test frame\n   3: <output_file>        #Choose file path & name\nOptional:\n   4: <output_csv_path>    #Create a csv file, which contain the bounding box information: \"x\",\"y\"\n"
    echo "      e.g: ./DBt_picture.sh snapshots/model_v1.h5 frames/frame_00001.png frame_00001_with_boxes.png"
    echo "           ./DBt_picture.sh snapshots/model_v1.h5 frames/frame_00001.png frame_00001_with_boxes.png frame_00001_bounding_box.csv"
    exit 1
fi

# Check the first argument <input_model>
if [ ! -f "$1" ]; then
    echo -e "Input file ERROR:\n   \"$1\" is not a valid file, please check again!"
    exit 1
fi

# Check the first argument <input_frame>
if [ ! -f "$2" ]; then
    echo -e "Input file ERROR:\n   \"$2\" is not a valid file, please check again!"
    exit 1
fi

# Save arguments
input_model=$(realpath $1)
input_frame=$(realpath $2)
draw_boxes=$(realpath $3)

# Save optional parameters
csv_path=""
if [ "$#" -eq $max_arg ]; then
    csv_path=$(realpath $4)
fi

#Python script file path
draw_path=$(dirname $(realpath $0))"/scripts/make_pic.py"

#Run
python3 $draw_path $input_model $input_frame $draw_boxes $csv_path