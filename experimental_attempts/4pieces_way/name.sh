#!/bin/bash


directory=$1
coordinates=$2

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

while IFS= read -r line
do
  frame_num=$(awk -F, '{print $1}' <<< $line)
  x=$(awk -F. '{print $1}' <<< $(awk -F, '{print $2}' <<< $line))      # Get X
  y=$(awk -F. '{print $1}' <<< $(awk -F, '{print $3}' <<< $line))      # Get Y
  y=$((2160-$y))                                                       # Normalize y

  for i in $directory/*
  do
    frame=${i: -11: 4}
    name=${i::-7}
    multiple_counter=0
    multiple=""
    if [ $frame -eq $frame_num ]; then
      #LT
      if [ $x -le $lt_pic_x ] && [ $y -lt $lt_pic_y ]; then
        multiple+="'"$name"_LT.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"'"\n"
        multiple_counter=$((multiple_counter+1))

        t1=$(($t1+1))
        new_x=$x
        new_y=$y
        echo "'"$name"_LT.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> LT.csv
        echo $line "LT"
      fi
      #RB
      if [ $x -ge $rb_pic_x ] && [ $y -ge $rb_pic_y ]; then
        multiple+="'"$name"_RB.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"'"\n"
        multiple_counter=$((multiple_counter+1))

        t4=$(($t4+1))
        new_x=$(($x-$rb_pic_x))
        new_y=$(($y-$rb_pic_y))
        echo "'"$name"_RB.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> RB.csv
        echo $line "RB"
      fi
      #LB
      if [ $x -le 1920 ] && [ $y -ge 1080 ]; then
        multiple+="'"$name"_LB.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"'"\n"
        multiple_counter=$((multiple_counter+1))

        t3=$(($t3+1))
        new_x=$x
        new_y=$(($y-1080))
        echo "'"$name"_LB.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> LB.csv
        echo $line "LB"
      fi
      #RT
      if [ $x -gt 1920 ] && [ $y -lt 1080 ]; then
        multiple+="'"$name"_RT.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"'"\n"
        multiple_counter=$((multiple_counter+1))

        t2=$(($t2+1))
        new_x=$(($x-1920))
        new_y=$y
        echo "'"$name"_RT.png'",$(($new_x-20)),$(($new_y-20)),$(($new_x+20)),$(($new_y+20)),'"horse"' >> RT.csv
        echo $line "RT"
      fi
      if [ $multiple_counter -gt 1 ]; then
        echo -e $multiple"--------------------------------------------------------------------------------" >> multiple.csv
      fi
      break
    fi
  done
done < "$coordinates"
#Some basic information
echo "---------------------------------------------"
echo "LT:" $t1
echo "RT:" $t2
echo "LB:" $t3
echo "RB:" $t4
echo "---------------------------------------------"
echo "Overall:" $(($t3+$t4+$t1+$t2))
