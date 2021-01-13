#!/bin/bash

# Logic behind the script
#   __________________________________________
#   |                   |  |                 |             LT & RB pictures size: 1950x1110 (wider & higher with 30px)
#   |                   |  |                 |             RT & LB pictures size: 1920x1080
#   |         LT        |  |       RT        |
#   |                ___|__|_________________|             LT = Left Top
#   |                |  |  |                 |             RT = Right Top
#   |‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|‾‾|‾‾‾                 |             LB = Left Bottom
#   |         LB     |  |         RB         |             RB = Right Bottom
#   |                |  |                    |
#   |________________|__|____________________|
#
#   Cases:
#      LT:                             RB:                             LB:                             RT:
#        - LT intersection RT = LT       - RB intersection LT = LT       - LB intersection LT = LT       - RT intersection LT = LT
#        - LT intersection LB = LT       - RB intersection LB = RB       - LB intersection RB = RB       - RT intersection RB = RB
#        - LT intersection RB = LT       - RB intersection RT = RB

# Read argument
filename=$1

# Parameters of tiles. Change these parameters if you want to change the size of pictures
tile_pic_x=1920        # Size of tiles in X axis
tile_pic_y=1080        # Size of tiles in Y axis
overlap=30             # in pixel

# LT calculation
lt_pic_x=$(($tile_pic_x+$overlap))
lt_pic_y=$(($tile_pic_y+$overlap))

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
  tile=0
  x=$(awk -F. '{print $1}' <<< $(awk -F, '{print $2}' <<< $line))      # Get X
  y=$(awk -F. '{print $1}' <<< $(awk -F, '{print $3}' <<< $line))      # Get Y
  y=$((2160-$y))                                                       # Normalize y

  #LT
  if [ $x -le $lt_pic_x ] && [ $y -lt $lt_pic_y ]; then
    t1=$(($t1+1))
    tile=LT
    new_x=$x
    new_y=$y
    echo '"/home/wildhorse_project/V180817_12fps_4k_frames_4pieces/LT.png"',$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> uj_fajl.txt
  fi
  #RB
  if [ $x -ge $rb_pic_x ] && [ $y -ge $rb_pic_y ]; then
    t4=$(($t4+1))
    tile=RB
    new_x=$(($x-$rb_pic_x))
    new_y=$(($y-$rb_pic_y))
    echo '"/home/wildhorse_project/V180817_12fps_4k_frames_4pieces/RB.png"',$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> uj_fajl.txt
  fi
  #LB
  if [ $x -le 1920 ] && [ $y -ge 1080 ]; then
    t3=$(($t3+1))
    tile=LB
    new_x=$x
    new_y=$(($y-1080))
    echo '"/home/wildhorse_project/V180817_12fps_4k_frames_4pieces/LB.png"',$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> uj_fajl.txt
  fi
  #RT
  if [ $x -gt 1920 ] && [ $y -lt 1080 ]; then
    t2=$(($t2+1))
    tile=RT
    new_x=$(($x-1920))
    new_y=$y
    echo '"/home/wildhorse_project/V180817_12fps_4k_frames_4pieces/RT.png"',$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> uj_fajl.txt
  fi

done < "$filename"
#Some basic information
echo "---------------------------------------------"
echo "LT:" $t1
echo "RT:" $t2
echo "LB:" $t3
echo "RB:" $t4
echo "---------------------------------------------"
echo "Overall:" $(($t3+$t4+$t1+$t2))
