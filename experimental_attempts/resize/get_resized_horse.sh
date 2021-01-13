#!/bin/bash

element=400
dir=/home/wildhorse_project/resized/
###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180817_1_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180817_1_12fps_4k_frames/$i -resize 156.25% $dir/resized_180817/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180824_2_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180824_2_12fps_4k_frames/$i -resize 156.25% $dir/resized_180824/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180905_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180905_12fps_4k_frames/$i -resize 156.25% $dir/resized_180905/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180913_1h_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180913_1h_12fps_4k_frames/$i -resize 156.25% $dir/resized_180913_1/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180913_2_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180913_2_12fps_4k_frames/$i -resize 156.25% $dir/resized_180913_2/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V180923_1_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V180923_1_12fps_4k_frames/$i -resize 156.25% $dir/resized_180923/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V181002_1_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V181002_1_12fps_4k_frames/$i -resize 156.25% $dir/resized_181002/${i::-3}jpg
done

###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V190811_1_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V190811_1_12fps_4k_frames/$i -resize 156.25% $dir/resized_190811/${i::-3}jpg
done
###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V190823_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V190823_12fps_4k_frames/$i -resize 156.25% $dir/resized_190823/${i::-3}jpg
done
###################################################################################################################################################################
names=$(ls /home/wildhorse_project/V190910_1_12fps_4k_frames/ | sort -R | head -n $element)
IFS=' '
names=($names)
unset IFS

for i in $names
do
    convert /home/wildhorse_project/V190910_1_12fps_4k_frames/$i -resize 156.25% $dir/resized_190910/${i::-3}jpg
done