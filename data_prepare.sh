#!/bin/bash

min_arg=2

# Standard message
if [ "$#" -ne $min_arg ]; then
    if [ "$#" -gt $min_arg ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo -e "Arguments explanation:\n   1: input video\n   2: frames output directory\n   3: coordinates location"
    echo "	e.g: ./data_prepare.sh sample_data/wildhorse.mp4 frames/ sample_data/coordinates.txt"
    exit 1
fi

# Save arguments
start_script_path=$(realpath $0)
new_folder_frames=$(echo $start_script_path | awk -F 'data_prepare.sh' '{ print $1 }')"frames/"
new_folder_crop=$(echo $start_script_path | awk -F 'data_prepare.sh' '{ print $1 }')"crop/"
new_folder_4pieces=$(echo $start_script_path | awk -F 'data_prepare.sh' '{ print $1 }')"4pieces/"
script_path=$(echo $start_script_path | awk -F 'data_prepare.sh' '{ print $1 }')"scripts/"

#Arguments
input_file=$(realpath $1)
coord_loc=$(realpath $2)

#Script defininitons
script_crop_black=$script_path"mass_crop_black_border.sh"
script_4pieces=$script_path"4pieces_crop.sh"
script_fitting=$script_path"fitting_crop.sh "$coord_loc

input_file=$(realpath $1)
coord_loc=$(realpath $2)

# Check the first argument <input_file>
if [ ! -f "$input_file" ]; then
    echo -e "Input file ERROR:\n   \"$input_file\" is not a valid file, please check again!"
    exit 1
fi


# Create folder <new_folder_frames>
echo "############################################################"
if [ ! -d "$new_folder_frames" ]; then
    mkdir $new_folder_frames
    echo $new_folder_frames " - CREATED SUCCESFULLY"
else
    echo $new_folder_frames " - FOLDER CHECKED"
fi
echo "############################################################"

# Check the first argument <coord_loc>
if [ ! -f "$coord_loc" ]; then
    echo -e "Coordinates location ERROR:\n   \"$coord_loc\" is not a valid file, please check again!"
    exit 1
fi

# Append filename
frame_out=$new_folder_frames"frame_%05d.png"

# Run command
echo "GENERATING FRAMES INTO THE "\"$new_folder_frames"\" FOLDER"
echo "############################################################"
echo "FFMPEG EXECUTION....."
cmd="ffmpeg -i $input_file $frame_out"
eval $cmd
echo "############################################################"

if [ ! -d "$new_folder_crop" ]; then
    mkdir $new_folder_crop
    echo $new_folder_crop " - CREATED SUCCESFULLY"
else
    echo $new_folder_crop " - FOLDER CHECKED"
fi
echo "############################################################"

if [ ! -d "$new_folder_4pieces" ]; then
    mkdir $new_folder_4pieces
    echo $new_folder_4pieces " - CREATED SUCCESFULLY"
else
    echo $new_folder_4pieces " - FOLDER CHECKED"
fi
echo "############################################################"

echo "EXECUTION OF "\"$script_crop_black"\" IS RUNNING (Remove black borders from top and bottom)"
echo "(Please wait!!!)"
cmd=$script_crop_black
eval $cmd
echo "############################################################"

echo "EXECUTION OF "\"$script_4pieces"\" IS RUNNING (Cut the previously generated pictures into 4 pieces)"
echo "(Please wait!!!)"
cmd=$script_4pieces
eval $cmd
echo "############################################################"

echo "EXECUTION OF "\"$script_fitting"\" IS RUNNING (Create dataset. Pair the coordinates with pictures.)"
echo "(Please wait!!!)"
cmd=$script_fitting
eval $cmd
path_of_results=$(echo $start_script_path | awk -F 'data_prepare.sh' '{ print $1 }')"result_dataset.csv"
echo "Generation successfully! You will find the \"csv\" in $path_of_results
echo "############################################################"