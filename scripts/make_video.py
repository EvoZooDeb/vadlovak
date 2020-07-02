
import keras
from keras_retinanet import models
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image
from keras_retinanet.utils.visualization import draw_box, draw_caption
from keras_retinanet.utils.colors import label_color
import matplotlib.pyplot as plt
import cv2
import os
import numpy as np
import time
import sys
import math

import tensorflow as tf

def get_session():
    config = tf.compat.v1.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.compat.v1.Session(config=config)

sess = tf.compat.v1.keras.backend.get_session()
#keras.backend.tensorflow_backend.set_session(sess)
#keras.backend.tensorflow_backend.set_session(get_session())

model_path = sys.argv[1]                                                        # Path of neural network (created by retinanet-convert-model)
model = models.load_model(model_path, backbone_name='resnet50')
labels_to_names = {0: 'horse'}                                                  # Model labels and its index value

image_path = sys.argv[2]                                                        # Input image path
output_path = sys.argv[3]                                                       # Output image path
fps = 25

vcapture = cv2.VideoCapture(video_path)

width = int(vcapture.get(cv2.CAP_PROP_FRAME_WIDTH))  # uses given video width and height
height = int(vcapture.get(cv2.CAP_PROP_FRAME_HEIGHT))
vwriter = cv2.VideoWriter(output_path,cv2.VideoWriter_fourcc(*'mp4v'),fps, (width, height)) #

num_frames = int(vcapture.get(cv2.CAP_PROP_FRAME_COUNT))

def run_detection_video(video_path):
    count = 0
    success = True
    start = time.time()
    while success:
        if count % 100 == 0:
            print("frame: ", count)
        count += 1
        # Read next image
        success, image = vcapture.read()

        if success:

            draw = image.copy()
            draw = cv2.cvtColor(draw, cv2.COLOR_BGR2RGB)

            image = preprocess_image(image)
            image, scale = resize_image(image)

            boxes, scores, labels = model.predict_on_batch(np.expand_dims(image, axis=0))

            boxes /= scale
            counter=0
            for box, score, label in zip(boxes[0], scores[0], labels[0]):

            # Threshold value
                if score < 0.48:
                    break
            # Auxilary variables
                big_square = [31,0,255]                                             # Blue color definition
                small_square = [255,51,0]                                           # Red color definition
                b = box.astype(int)                                                 # Round values to int
                sb = [0] * 4                                                        # Declare empty array (sb = small box)
            # Calculate rectangle sides
                corrigate_pixel = 5
                a_side = (math.sqrt(pow((b[0]-b[0]),2)+pow((b[3]-b[1]),2))/2)-corrigate_pixel     # Calculate distance between points. We need half of this distance
                b_side = (math.sqrt(pow((b[2]-b[0]),2)+pow((b[3]-b[3]),2))/2)-corrigate_pixel     # Calculate distance between points. We need half of this distance
            # Generate small square coordinates
                sb[0] = b[0]+b_side                                                 # small box x1
                sb[1] = b[1]+a_side                                                 # small box y1
                sb[2] = b[2]-b_side                                                 # small box x2
                sb[3] = b[3]-a_side                                                 # small box y2
            # Resize the orignal big square
                b[0] = b[0]+50                                                      # x1
                b[1] = b[1]+50                                                      # y1
                b[2] = b[2]-50                                                      # x2
                b[3] = b[3]-50                                                      # y2
            # Draw boxes
                draw_box(draw, b, color=big_square)                                 # Draw big square
                draw_box(draw, sb, color=small_square)                              # Draw small square
                counter+=1

            cv2.putText(draw, "Horses: {}".format(counter), (100, 250), cv2.FONT_HERSHEY_PLAIN, 8, (0, 0, 0), 5)
            cv2.putText(draw, "Horses: {}".format(counter), (100, 250), cv2.FONT_HERSHEY_PLAIN, 8, (255,51,0), 4)
            detected_frame = cv2.cvtColor(draw, cv2.COLOR_RGB2BGR)
            vwriter.write(detected_frame)  # overwrites video slice

    vcapture.release()
    vwriter.release() 
    end = time.time()

    print("Total Time: ", end - start)

run_detection_video(video_path)
