# Wildhorse
AI project for tracking and identifying przewalski horses
## Recommended tools to test
IMPORTANT: Not tested with other environments than listed below!
### Used enviroments:
* NVIDIA tools:
    + Driver version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;440.82
    + CUDA compiler driver:&emsp;&emsp;&nbsp;&nbsp;v10.1.168
    + cuDNN driver:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;7.6.5
* Python3 version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;3.8
* Python packages:
    + Tensorflow-gpu version:&emsp;&nbsp;&nbsp;&nbsp;2.2.0-rc4
    + Keras version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;2.3.0-tf
    + Numpy version:&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.17.4
    + Conda version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;4.8.2
    + Pillow version:&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;7.0.0
    + h5py version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;2.10.0
* Bash version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;5.0.16
* ffmpeg version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.2.2
* R version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;3.6.3
* Julia version:&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;1.4.1
## Test run
1) Download and install retinanet.\
`git clone https://github.com/fizyr/keras-retinanet`
2) Run `./data_prepare.sh` script. It will save automatically video frames and generates ".csv" files for retinanet.\
fomat: `./data_prepare.sh <video_file> <output_frame_folder> <bounding_box_coordinates>`\
e.g: `./data_prepare.sh sample/wildhorse.mp4 frames/ sample/coordinates.txt`
    > After the first run you will find two files:
    > + frames_retinenet_map.csv &emsp;&emsp;&nbsp;&nbsp;&nbsp;#Contains premapped positions with file path
    > + retinanet_class.csv &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;#Contains the predefined classes
3) Check the data validity with `retinanet-debug`.\
format: `retinanet-debug csv <data_stucture> <object_identifier>`\
e.g: `retinanet-debug csv frames_retinenet_map.csv retinanet_class.csv`
    > If the squares are green, then you can train your neural network with retinanet-train command.
4) For the first time, run the retinanet with `--no-weight` switch.\
e.g: `retinanet-train --no-weights --epochs 10 csv frames_retinenet_map.csv retinanet_class.csv`
5) If you would like to test the model, then convert the model first.\
e.g: `retinanet-convert-model snapshots/resnet50_csv_10.h5 snapshots/model_v1_10.h5`
6) Use the attached bash script to draw boxes. (This is just a test script, where you can check the accuracy)\
e.g: `./DBt_picture.sh snapshots/model_v1.h5 frames/frame_00001.png draw_boxes.png`
7) If the results are not satisfying, then train the model with the previously calculated weights and use more data.\
e.g: `retinanet-train --weights snapshots/resnet50_csv_10.h5--epochs 10 csv frames_retinenet_map.csv retinanet_class.csv`
8) If you would like to draw boxes into the video.\
e.g: `./DBt_video.sh snapshots/model_v1.h5 sample/wildhorse.mp4 wildhorse_with_box.mp4`