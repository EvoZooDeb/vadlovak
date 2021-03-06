import keras
from keras_retinanet import models
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image
from keras_retinanet.utils.visualization import draw_box, draw_caption
from keras_retinanet.utils.colors import label_color
import matplotlib.pyplot as plt
import math
import cv2
import os
import numpy as np
import time
import sys

import tensorflow as tf

model_path = sys.argv[1]                                                        # Path of neural network (created by retinanet-convert-model)
model = models.load_model(model_path, backbone_name='resnet50')
labels_to_names = {0: 'horse'}                                                  # Model labels and its index value

image_path = sys.argv[2]                                                        # Input image path
output_path = sys.argv[3]
                                                   # Output image path
number_of_arguments = len(sys.argv)-1
csv_file_path=""

if number_of_arguments == 4:
    csv_file_path = sys.argv[4]
    text_file = open(sys.argv[4], "w")

def detection_on_image(image_path):

        image = cv2.imread(image_path)                                          # Read file

        draw = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

        image = preprocess_image(image)
        image, scale = resize_image(image)

        boxes, scores, labels = model.predict_on_batch(np.expand_dims(image, axis=0))
        boxes /= scale
        counter=0
        for box, score, label in zip(boxes[0], scores[0], labels[0]):
        #  Print middle of the box. frame,x,y
            if len(csv_file_path) != 0:
                exact_x = (box[0] + box[2])/2
                exact_y = (box[1] + box[3])/2
                text_file.write("{},{}\n".format(exact_x,exact_y))
        # Threshold value
            if score < 0.01:
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
        # Check values
            # for i in range(4):                                                # Print coordinates to console
            #     print(b[i], " ", sb[i])
        # Print some information about the identified objects
            #caption = "{} {:.3f}".format(labels_to_names[label], score)        # Format of the header
            #draw_caption(draw, b, caption)                                     # Draw header to top of the square

        cv2.putText(draw, "Horses: {}".format(counter), (100, 250), cv2.FONT_HERSHEY_PLAIN, 8, (0, 0, 0), 5)
        cv2.putText(draw, "Horses: {}".format(counter), (100, 250), cv2.FONT_HERSHEY_PLAIN, 8, (255,51,0), 4)
        detected_img =cv2.cvtColor(draw, cv2.COLOR_RGB2BGR)
        cv2.imwrite(output_path, detected_img)
        if len(csv_file_path) != 0:
            text_file.close()                                  # Save jpg file
        #detected_img=cv2.resize(detected_img, (1920, 1080))                     # Simple resize, easier to use with ssh -X
        #cv2.imshow('Detection',detected_img)                                    # Show edited image in a window with "Detection" name
        cv2.waitKey(0)
        cv2.destroyAllWindows()
        cv2.waitKey(1)

detection_on_image(image_path)
