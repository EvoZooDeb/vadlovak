#!/bin/bash

for i in "$@"
do
    if [[ $i == "-r" || $i == "--rand" ]]; then
        temp=$(($#+1))
        echo ${@[$temp]}
    fi
done