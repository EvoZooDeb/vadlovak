# Wildhorse
AI project for tracking and identifying przewalski horses
## Recommended tools to test
IMPORTANT: Not tested with other environments than listed below!
### Used enviroments:
* NVIDIA tools (Tested with RTX2070 or K80):
    + Driver version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;460.39
    + CUDA compiler driver:&emsp;&emsp;&nbsp;&nbsp;v11.2
    + cuDNN driver:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;8.1.0.77
* Python version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3.7.9
* Python packages:
    + pip:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;20.3.3
    + tensorflow:&emsp;&nbsp;&nbsp;&nbsp;2.4.1
    + tensorflow-gpu:&emsp;&nbsp;&nbsp;&nbsp;2.4.1
    + keras:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2.4.3
    + keras-retinanet:&emsp;&emsp;&emsp;&emsp;1.0.0
    + matplotlib:&emsp;&nbsp;&nbsp;&nbsp;3.3.4
    + opencv-python:&emsp;&nbsp;&nbsp;&nbsp;4.5.1.48
* Bash version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;5.1.0
* ffmpeg version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.2.2
* R version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;4.0.3
* Julia version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;1.4.1
## Test run
1) Create environment with conda and install dependency \
    `conda create --name RETINANET python=3.7.9` \
    &emsp;`conda activate RETINANET` \
    &emsp;&emsp;`pip install tensorflow==2.4.1` \
    &emsp;&emsp;`pip install tensorflow-gpu==2.4.1` \
    &emsp;&emsp;`pip install keras==2.4.3` \
    &emsp;&emsp;`pip install keras_retinanet==1.0.0` \
    &emsp;&emsp;`pip install matplotlib==3.3.4` \
    &emsp;&emsp;`pip install opencv-python==4.5.1.48` \
  If you would like to train with CPU, install "tensorflow-cpu" instead of "tensorflow-gpu". \
    &emsp;&emsp;`pip install tensorflow-cpu==2.4.1` \
2) Run `./data_prepare.sh` script. It will save automatically video frames and generates ".csv" files for retinanet.\
fomat: `./data_prepare.sh <video_file> <output_frame_folder> <bounding_box_coordinates>`\
e.g: `./data_prepare.sh sample_data/wildhorse.mp4 frames/ sample_data/coordinates.txt`
    > After the first run you will find two files:
    > + original_frames_map.csv &emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;#Contains premapped positions with file path
    > + retinanet_class.csv &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;#Contains the predefined classes
3) Check the data validity with `retinanet-debug`.\
format: `retinanet-debug csv <data_stucture> <object_identifier>`\
e.g: `retinanet-debug csv frames_retinenet_map.csv retinanet_class.csv`
    > If the squares are green, then you can train your neural network with retinanet-train command.
4) Start training:
    + For the first time, run the retinanet with `--no-weight` switch.\
    e.g: `retinanet-train --no-weights --epochs 10 csv frames_retinenet_map.csv retinanet_class.csv`
    + If you would like to train your previously trained model:\
    e.g: `retinanet-train --weights snapshot/resnet50_csv_10.h5 --epochs 10 --snapshot-path snapshot/ csv frames_retinenet_map.csv retinanet_class.csv`
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

Explaination of .csv files:
|csv file generated by DBt_picture |csv file generated by DBt_video|
|--|--|
|<table> <tr><th>X coordinates</th><th>Y coordinates</th></tr><tr><td>1808.49964</td><td>1000.50009</td></tr><tr><td>2033.51234</td><td>816.294393</td></tr><tr><td>2031.65840</td><td>891.907453</td></tr></table>| <table> <tr><th>Frame number</th><th>X coordinates</th><th>Y coordinates</th></tr><tr><td>1</td><td>910.6249</td><td>1326.6198730</td></tr><tr><td>2894</td><td>2170.793457</td><td>1110.695068</td></tr><tr><td>3938</td><td>1752.032226</td><td>1415.895751</td></tr></table>|