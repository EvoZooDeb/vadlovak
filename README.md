
# Wildhorse
AI project for tracking and identifying przewalski horses
## Recommended tools to test
IMPORTANT: Not tested with other environments than listed below! We used 4K Aerial footage and the scripts prepared only for this resoultion. 
These scripts contains a lots of constant variables, which means you have to modify some of them if you would like to use this method.
### Used enviroments:
 * NVIDIA tools:
    + Driver version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;440.82
    + CUDA compiler driver:&emsp;&emsp;&nbsp;&nbsp;v10.1.168
    + cuDNN driver:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;7.6.5
 * Python3 version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3.8
 * Python packages:
    + Pip version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;20.1
    + Tensorflow-gpu version:&emsp;&nbsp;&nbsp;&nbsp;2.2.0-rc4
    + Keras version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2.3.0-tf
    + Numpy version:&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.17.4
    + Conda version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;4.8.2
    + Pillow version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;7.0.0
    + h5py version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;2.10.0
 * Bash version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;5.0.16
 * ffmpeg version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.2.2
 * R version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;3.6.3
 * Julia version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;1.4.1
## Test run
1) Download and install retinanet.\
`git clone https://github.com/fizyr/keras-retinanet`
2) Run `./data_prepare.sh` script. It will save automatically video frames and generates ".csv" files for retinanet.\
fomat: `./data_prepare.sh <video_file> <output_frame_folder> <bounding_box_coordinates>`\
e.g: `./data_prepare.sh sample_data/wildhorse.mp4 sample_data/coordinates.txt` The script will generate 3 new folders and a result_dataset.csv file:
     * frames/
     * crop/
     * 4pieces/
     * result_dataset.csv
3) Check the data validity with `retinanet-debug`.\
format: `retinanet-debug --show-annotation csv <data_stucture> <object_identifier>`\
e.g: `retinanet-debug --show-annotation csv result_dataset.csv sample_data/class.csv`
    > If the squares are green and the positions are correct, then you can train your neural network with retinanet-train command.
    HINT: If you used blender to mark objects, then you must reverse y axis.  Take the comment out of line 80 from "`script/fitting_crop.sh`"
4) Start training:
    + For the first time, run the retinanet with `--no-weight` switch.\
    e.g: `retinanet-train --no-weights --epochs 10 csv result_dataset.csv class.csv`
    + If you would like to train your previously trained model:\
    e.g: `retinanet-train --weights snapshot/resnet50_csv_10.h5 --epochs 10 --snapshot-path snapshot/ csv result_dataset.csv class.csv`
5) To test your model, you need to convert it first.\
format: `retinanet-convert-model <weight> <converted model_name>`\
e.g: `retinanet-convert-model snapshots/resnet50_csv_10.h5 snapshots/model_v1_10.h5`
6) Use the attached bash script to draw predicted boxes to a picture. (The main aim of the script is to test accuracy of the model)\
format: `./DBt_picture.sh <converted_model> <input_test_picture> <output_picture>`\
e.g: `./DBt_picture.sh snapshots/model_v1.h5 frames/frame_00001.png draw_boxes.png`
    > If you would like to print the x,y (middle of the squares) position of the boxes, use optional csv parameter. (The first parameter will represent x coordinates and the second will represent y.) XY are pixel coordinates.)\
    format: `./DBt_picture.sh <converted_model> <input_test_picture> <output_picture> <csv_output_path>` \
    e.g: `./DBt_picture.sh snapshots/model_v1.h5 frames/frame_00001.png draw_boxes.png box_pos.csv` 
7) If the results are not satisfying, train the model with the previously calculated weights and use more data. (Repeat step 4)
8) If you would like to draw boxes into the video.\
format: `./DBt_video.sh <converted_model> <input_test_video> <output_video>`\
e.g: `./DBt_video.sh snapshots/model_v1.h5 sample/wildhorse.mp4 wildhorse_with_box.mp4`
    > If you would like to print the x,y (middle of the squares) position of the boxes, use optional csv parameter. (The first parameter will represent frame number, the second and third will represent x & y coordinates. XY are pixel coordinates.)\
    format: `./DBt_picture.sh <converted_model> <input_test_video> <output_video> <csv_output_path>` \
    e.g: `./DBt_picture.sh snapshots/model_v1.h5 sample/wildhorse.mp4 wildhorse_with_box.mp4 box_pos.csv`

![Detection result_1](https://github.com/EvoZooDeb/vadlovak/blob/master/sample_data/result.png?raw=true)

Explaination of .csv files:
|csv file generated by DBt_picture |csv file generated by DBt_video|
|--|--|
|<table> <tr><th>X coordinates</th><th>Y coordinates</th></tr><tr><td>1808.49964</td><td>1000.50009</td></tr><tr><td>2033.51234</td><td>816.294393</td></tr><tr><td>2031.65840</td><td>891.907453</td></tr></table>| <table> <tr><th>Frame number</th><th>X coordinates</th><th>Y coordinates</th></tr><tr><td>1</td><td>910.6249</td><td>1326.6198730</td></tr><tr><td>2894</td><td>2170.793457</td><td>1110.695068</td></tr><tr><td>3938</td><td>1752.032226</td><td>1415.895751</td></tr></table>|
