########################################################################################################################################################################
Step 1:
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p1_[333].txt           # 180817 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p2_[333].txt           # 180824 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p3_[333].txt           # 180905 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p4_[333].txt           # 180913_1 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p5_[333].txt           # 180913_2 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p6_[333].txt           # 180923 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p7_[333].txt           # 181002 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p8_[333].txt           # 190811 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p9_[333].txt           # 190823 vid
    ls $PWD/* | sort -R | head -n 333 >> /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/filename_orig_pic_p10_[333].txt          # 190910 vid
########################################################################################################################################################################
Step 2:
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p1_180817
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p2_180824
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p3_180905
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p4_180913_1
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p5_180913_2
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p6_180923
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p7_181002
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p8_190811
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p9_190823
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/orig_pic_p10_190910
########################################################################################################################################################################
Step 3: Copy files from filelist
    Modify the variables of the "copy_orig_pic.sh" according to the comment for each videos
    ./copy_orig_pic.sh 
########################################################################################################################################################################
Step 4:
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p1_180817
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p2_180824
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p3_180905
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p4_180913_1
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p5_180913_2
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p6_180923
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p7_181002
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p8_190811
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p9_190823
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/crop_orig_pic_p10_190910
########################################################################################################################################################################
Step 5: Crop the black borders from the original 3840x2160 pictures
    Modify the variables of the "mass_crop_black_border.sh" according to the comment for each videos 
    ./mass_crop_black_border.sh
########################################################################################################################################################################
Step 6:
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p1_180817_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p2_180824_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p3_180905_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p4_180913_1_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p5_180913_2_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p6_180923_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p7_181002_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p8_190811_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p9_190823_crop_overlap40
    mkdir /home/wildhorse_project/experimental_attempts/4pieces_way/4pieces_pic_p10_190910_crop_overlap40
########################################################################################################################################################################
Step 7: Dismantle images for 4 pieces (Optional to change resolution)
    Modify the variables of the "4pieces.sh" according to the comment for each videos
    ./4pieces.sh
    ./4pieces_crop.sh
########################################################################################################################################################################
Step 6: Get bounding boxes according to filelist
    Modify the variables of the "get_coordinates.sh" according to the comment for each videos
    ./get_coordinates.sh
########################################################################################################################################################################
Step 7: Classify bounding boxes according to positions and pair the positions with the correct frame. 
    Modify the variables of the "fitting.sh" according to the comment for each videos
    ./fitting.sh
    ./fitting_crop.sh
########################################################################################################################################################################
Step 8: Check each datasets with retinanet-debug
    retinanet-debug csv dataset_180817_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_180824_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_180905_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_180913_1_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_180913_2_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_180923_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_181002_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_190811_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_190823_overlap40.txt /home/wildhorse_project/RETINANET/class.csv
    retinanet-debug csv dataset_190910_overlap40.txt /home/wildhorse_project/RETINANET/class.csv

    If all of the bounding box positions are fine, then jump to Step 9
########################################################################################################################################################################
Step 9: Append each datasets
    cat dataset_180817_overlap40.txt dataset_180824_overlap40.txt \
        dataset_180905_overlap40.txt dataset_180913_1_overlap40.txt \
        dataset_180913_2_overlap40.txt dataset_180923_overlap40.txt \
        dataset_181002_overlap40.txt dataset_190811_overlap40.txt \
        dataset_190823_overlap40.txt dataset_190910_overlap40.txt >> dataset_all.csv
########################################################################################################################################################################
Step 10: Your dataset is ready to train
    retinanet-train --snapshot-path /home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=50_817+824+905+913_1+913_2+923+1002+811+823+910 \
          --batch-size 1 \
          --epochs 50 \
          --steps 13320 \
          --tensorboard-dir /home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=50_817+824+905+913_1+913_2+923+1002+811+823+910/tensorboard \
          --image-min-side 1054 \
          --image-max-side 1960 csv /home/wildhorse_project/experimental_attempts/4pieces_way/dataset/dataset_all.csv /home/wildhorse_project/RETINANET/class.csv
########################################################################################################################################################################