#!/bin/bash

# Logic behind the script
#   ____________________1920___________________
#   |                  | ' |                  |             LT & RT & LB & RB pictures size: 1960x1054 (wider & higher with 40px)
#   |                  | ' |                  |
#   |        LT        | ' |        RT        |
#   |                  |_'_|                  |
#   |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾'‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
#   |- - - - - - - - - |-'-| - - - - - - - - -| 1014        LT = Left Top
#   |                  |_'_|                  |             RT = Right Top
#   |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾'‾|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|             LB = Left Bottom
#   |        LB        | ' |        RB        |             RB = Right Bottom
#   |                  | ' |                  |
#   |__________________|_'_|__________________|
#



# Output path with the first part of the file name
main_name=$(realpath $0 | awk -F 'scripts/fitting_crop.sh' '{ print $1 }')"4pieces/frame_"

# Trainset output location
output_file=$(realpath $0 | awk -F 'scripts/fitting_crop.sh' '{ print $1 }')"result_dataset.csv"

# Read bounding boxes
filename=$1

# Parameters of tiles. Change these parameters if you want to change the size of pictures
tile_pic_x=1920        # Size of tiles in X axis
tile_pic_y=1014        # Size of tiles in Y axis
overlap=40             # in pixel
height_of_crop=66      # in pixel (height of the top border crop)
half_box_px=18         # Exact bounding box size, this parameter doubles the value e.g: half_box_px=18 means 36x36 boundig box

# LT calculation
lt_pic_x=$(($tile_pic_x+$overlap))
lt_pic_y=$(($tile_pic_y+$overlap))

# RT calculation
rt_pic_x=$(($tile_pic_x-$overlap))
rt_pic_y=$(($tile_pic_y+$overlap))

# LB calculation
lb_pic_x=$(($tile_pic_x+$overlap))
lb_pic_y=$(($tile_pic_y-$overlap))

# RB calculation
rb_pic_x=$(($tile_pic_x-$overlap))
rb_pic_y=$(($tile_pic_y-$overlap))

# Initialize counters
t1=0                   # LT
t2=0                   # RT
t3=0                   # LB
t4=0                   # RB

# Read coordinates
while IFS= read -r line
do
  #echo $line
  tile=0
  frame=$(awk -F, '{print $1}' <<< $line)                              # Get frame number
  case "${#frame}" in
  "1")
    frame="0000"$frame
    ;;
  "2")
    frame="000"$frame
    ;;
  "3")
    frame="00"$frame
    ;;
  "4")
    frame="0"$frame
    ;;
  esac
  x=$(awk -F. '{print $1}' <<< $(awk -F, '{print $2}' <<< $line))      # Get X
  y=$(awk -F. '{print $1}' <<< $(awk -F, '{print $3}' <<< $line))      # Get Y
  #y=$((216-$y))
  y=$(($y-$height_of_crop))                                                       # Normalize y

  #LT
  if [ $x -le $lt_pic_x ] && [ $y -le $lt_pic_y ]; then
    t1=$(($t1+1))
    tile=LT
    new_x=$x
    new_y=$y
    echo $main_name$frame"_LT.png",$(($new_x-$half_box_px)),$(($new_y-$half_box_px)),$(($new_x+$half_box_px)),$(($new_y+$half_box_px)),'"horse"' >> $output_file
  fi
  #RB
  if [ $x -ge $rb_pic_x ] && [ $y -ge $rb_pic_y ]; then
    t4=$(($t4+1))
    tile=RB
    new_x=$(($x-$rb_pic_x))
    new_y=$(($y-$rb_pic_y))
    echo $main_name$frame"_RB.png",$(($new_x-$half_box_px)),$(($new_y-$half_box_px)),$(($new_x+$half_box_px)),$(($new_y+$half_box_px)),'"horse"' >> $output_file
  fi
  #LB
  if [ $x -le $lb_pic_x ] && [ $y -ge $lb_pic_y ]; then
    t3=$(($t3+1))
    tile=LB
    new_x=$x
    new_y=$(($y-$lb_pic_y))
    echo $main_name$frame"_LB.png",$(($new_x-$half_box_px)),$(($new_y-$half_box_px)),$(($new_x+$half_box_px)),$(($new_y+$half_box_px)),'"horse"' >> $output_file
  fi
  #RT
  if [ $x -ge $rt_pic_x ] && [ $y -le $rt_pic_y ]; then
    t2=$(($t2+1))
    tile=RT
    new_x=$(($x-$rt_pic_x))
    new_y=$y
    echo $main_name$frame"_RT.png",$(($new_x-$half_box_px)),$(($new_y-$half_box_px)),$(($new_x+$half_box_px)),$(($new_y+$half_box_px)),'"horse"' >> $output_file
  fi
done < "$filename"

# Some basic information
echo "---------------------------------------------"
echo "LT:" $t1
echo "RT:" $t2
echo "LB:" $t3
echo "RB:" $t4
echo "---------------------------------------------"
echo "Overall:" $(($t3+$t4+$t1+$t2))
