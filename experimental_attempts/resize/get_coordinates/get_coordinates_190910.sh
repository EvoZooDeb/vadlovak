#!/bin/bash

max_element=400

for i in /home/wildhorse_project/resized/resized_190910/*
do
    just_name=$(basename $i)
    just_name=${just_name:6:5}
    list_of_files=$list_of_files" "$just_name" "
done

IFS=" "
list_of_files=($list_of_files)
unset IFS

counter=0
bool_test=0
while IFS= read -r coor; do
    prev_bool=$bool_test

    IFS=","
    row=($coor)
    unset IFS

    frame_num=${row[0]}
    valt=$(expr ${list_of_files[$counter]} + 0)

    if [[ frame_num -eq $valt ]]; then
        bool_test=1
        echo $coor >> "/home/wildhorse_project/resized/190910_coordinates.txt"
    else
        bool_test=0
    fi

    if [[ $prev_bool -eq 1 && $bool_test -eq 0 ]]; then
        counter=$((counter+1))
        valt=$(expr ${list_of_files[$counter]} + 0)
        if [[ $counter -eq $max_element ]]; then
            break
        else
            if [[ $frame_num -eq $valt ]]; then
                bool_test=1
                echo $coor >> "/home/wildhorse_project/resized/190910_coordinates.txt"
            else
                bool_test=0
            fi
        fi
    fi
done < "/home/wildhorse_project/horse_coordinates/horse_coordinates/190910_1/horse_coordinates.txt"