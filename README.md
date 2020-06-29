# Wildhorse
AI project for tracking and identifying przewalski horses

## Recommended tools to test
Used enviroments:
*NVIDIA Driver Version:              440.82
*NVIDIA CUDA Compiler Driver:        V10.1.168
*NVIDIA cuDNN Driver:                7.6.5
*Python3 Version:                    20.1
*Tensorflow Version:                 2.2.0-rc4
*Keras Version:                      2.3.0-tf
*Numpy Version:                      1.17.4
*Conda Version:                      4.8.2
*Bash Version:                       5.0.16(1)-release
*ffmpeg Version:                     4.2.2
*R Version:                          3.6.3

IMPORTANT: Not tested with other environments than listed above!

## Test run
1) Download and install retinanet
    `git clone https://github.com/fizyr/keras-retinanet`
2) Run ./data_prepare.sh script...
    Automatically save video frames and generates ".csv" files for retinanet
    e.g: `./data_prepare.sh sample/wildhorse.mp4 frames/ sample/coordinates.txt`
3) Check the data validity with retinanet-debug
    retinanet-debug csv <data_stucture> <object_identifier>
    e.g: `retinanet-debug csv frames_retinenet_map.csv retinanet_class.csv`

    If the squares are green, then you can train your neural network with retinanet-train command.
4) For the first time run the retinanet with --no-weight switch
    e.g: `retinanet-train --no-weights --epochs 10 csv frames_retinenet.csv class_retinanet.csv`
5) If you would like to test the model, then convert the model first
    e.g: `retinanet-convert-model snapshots/resnet50_csv_10.h5 snapshots/model_v1_10.h5`
6) Use the attached bash script to draw boxes. (This is just a test script, where you can check the accuracy)
    e.g: `./test_draw.sh snapshots/model_v1.h5 frames/frame_00001.png draw_boxes.png`
7) If the results are not satisfying, then train the model with the previously calculated weights and use more data.
    e.g: `retinanet-train --weights snapshots/resnet50_csv_10.h5--epochs 10 csv frames_retinenet.csv class_retinanet.csv`
