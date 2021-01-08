#!/bin/bash

# Randomize and Resize data

min_arg=3
max_arg=4

if [[ ( "$#" -ne $min_arg ) && ( "$#" -ne $max_arg ) ]]; then
    if [ "$#" -gt $max_arg ]; then
        echo -e "Too much arguments!\n"
    else
        echo -e "Not enough arguments!\n"
    fi
    echo -e "Necessary arguments:\n   1: <container_directory>        # Container directory which cointains all frames with the original size. (Must be an existing directory)\n   2: <number_of_random_element>   # This number will determine, how many random pictures will be choosen\n                                   # Set this number to -1 if you would like to use all pictures from the container folder\n   3: <output_directory>           # Path of output frames. (Must be an existing directory)\n"
    echo -e "Optional (Without this parameter, the program won't rescale images):\n   4: <rescale_percent>            # Original size equals 100 (You can use double precission values e.g: 123.24)\n                                   # If you would like to increase the resolution, this number should be greater than 100\n                                   # If you would like to decrease the resolution, this number should be less then 100\n "
    echo "   e.g: ./RandRes_data.sh frames/ 30 test/          # Get 30 random picture from the 'frames/' folder and copy to the 'test/' directory with the original size"
    echo "        ./RandRes_data.sh frames/ -1 test/          # Get every picture from the 'frames/' and copy all of them to the 'test/' directory with the original size"
    echo "        ./RandRes_data.sh frames/ 100 test/ 123.45  # Get 100 random picture from the 'frames/' folder and copy to the 'test/' directory with 123.45% enlargement"
    echo "        ./RandRes-data.sh frames/ 48 test/ 95       # Get 48 random picture from the 'frames/' folder and copy to the 'test/' directory with 95% scaling rate"
    exit 1
fi

# Container directory
if [ ! -d "$1" ]; then
    echo -e "Input file ERROR:\n   \"$1\" is not a valid directory, please check again!"
    exit 1
else
    if [ ${1: -1} != "/" ]; then
        dir=$1"/"
    else
        dir=$1
    fi
fi

# Number of elements in the container directory
elements=$(ls -l $dir | wc -l)
if [ $2 -lt $elements ]; then
    how_many=$2
    if [ $2 -eq -1 ]; then
        how_many=$(($elements-1))
    fi
else
    echo -e "ERROR:The second parameter cannot greater than the numbers of files in the container directory\n   Container directory: '$dir'\n   Numbers of files in the container directory: $(($elements-1))\n   Your value: '$2'\nPlease decrease the value!"
    exit 1
fi

# Check the output argument 
if [ ! -d "$3" ]; then
    echo -e "Input file ERROR:\n   \"$3\" is not a valid directory, please check again!"
    exit 1
else
    if [ ${3: -1} != "/" ]; then
        output=$3"/"
    else
        output=$3
    fi
    # Check is it empty
    if [ $(ls -l $output | wc -l) -ne 1 ]; then
        read -p "The '$3' folder is not empty! Would you like to continue? (y/n)? " answer
        case ${answer:0:1} in
            y|Y )
                echo "The program continues the running"
            ;;
            * )
                echo "Program stopped"
                exit 0
            ;;
        esac
    fi
fi

# Scale number
if [ "$#" -eq $max_arg ]; then
    scale=$4
else
    scale=100
fi
###################################################################################################################################################################
names=$(ls $dir | sort -R | head -n $how_many)
IFS=' '
names=($names)
unset IFS
for i in $names
do
    #echo $dir$i -resize $scale% $output${i::-3}jpg
    convert $dir$i -resize $scale% $output/${i::-3}jpg
done
