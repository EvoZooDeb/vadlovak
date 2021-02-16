
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
import math

import tensorflow as tf

def get_session():
    config = tf.compat.v1.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.compat.v1.Session(config=config)

#tf.compat.v1.disable_eager_execution()
#import tensorflow.python.keras.backend as K
#sess = K.get_session()
#keras.backend.tensorflow_backend.set_session(sess)
#keras.backend.tensorflow_backend.set_session(get_session())

#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/raw_data/snapshot_!resize_4pieces_ep=20/tf_20.h5'    ## replace this with your model path
#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=20_824+905/tf_20.h5'    ## replace this with your model path
#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=20_824+905_cont_with_823+910/tf_20.h5'    ## replace this with your model path
#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=20_824+905_cont_with_823+910_cont_824+824_orig/tf_20.h5'
#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=20_824+905_cont_with_823+910_cont_913_1+913_2+noise_500/tf_20.h5'
model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/resize_4pieces_ep=20_824+905_cont_with_823+910_cont_1002+811/tf_20.h5'
#model_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/raw_data/snapshot_resize_4pieces_ep=20_anc/tf_20.h5'
#model_path =  '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/!resize_4pieces_ep=50_824+905/tf_50.h5'
#model_path =  '/home/wildhorse_project/experimental_attempts/4pieces_way/results_NN/!resize_4pieces_ep=50_824+905/tf_25.h5'
#model_path = '/home/wildhorse_project/RETINANET/snapshot_random/modelv3.h5'

model = models.load_model(model_path, backbone_name='resnet50')
labels_to_names = {0: 'horse'}                    ## replace with your model labels and its index value

#image_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/raw_data/4pieces_pic_all/V180824_2_12fps_4k_0585_RB.png'  ## replace with input image path
#image_path = '/home/wildhorse_project/V180817_1_12fps_4k_frames/V180817_1_12fps_4k_0005.png'
#image_path = '/home/dkatona/test/frame_00001.png'
#image_path = '/home/dkatona/test/frame_00001_LB.png'
#image_path = '/home/dkatona/test/frame_00001_LT.png'
#image_path = '/home/dkatona/test/frame_00001_RT.png'
#image_path = '/home/dkatona/test/frame_00001_RB.png'
#image_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/raw_data/4pieces_pic_p1/V180817_1_12fps_4k_0005_LB.png'

#output_path = '/home/dkatona/test/190911_00001.jpg'   ## replace with output image path
#output_path = '/home/dkatona/test/190911_00001_LB.jpg'   ## replace with output image path
#output_path = '/home/dkatona/test/190911_00001_LT.jpg'   ## replace with output image path
#output_path = '/home/dkatona/test/190911_00001_RT.jpg'   ## replace with output image path
#output_path = '/home/dkatona/test/190911_00001_RB.jpg'   ## replace with output image path


#image_path = '/home/dkatona/temp/orig_frame_00181.png'
#image_path = '/home/dkatona/temp/LB.png'
#image_path = '/home/dkatona/temp/LT.png'
#image_path = '/home/dkatona/temp/RT.png'
image_path = '/home/dkatona/temp/RB.png'
#image_path = '/home/wildhorse_project/experimental_attempts/4pieces_way/raw_data/4pieces_pic_p1/V180817_1_12fps_4k_0005_LB.png'
#output_path = '/home/dkatona/temp/1_frame_00181_190811.png'   ## replace with output image path
#output_path = '/home/dkatona/temp/1_LB.jpg'   ## replace with output image path
#output_path = '/home/dkatona/temp/1_LT.jpg'   ## replace with output image path
#output_path = '/home/dkatona/temp/1_RT.jpg'   ## replace with output image path
output_path = '/home/dkatona/temp/1_RB.jpg'   ## replace with output image path




def detection_on_image(image_path):

        image = cv2.imread(image_path)
        # Count boxes
        counter=0

        draw = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image = preprocess_image(image)
        image, scale = resize_image(image)
        boxes, scores, labels = model.predict_on_batch(np.expand_dims(image, axis=0))
        boxes /= scale
        for box, score, label in zip(boxes[0], scores[0], labels[0]):

            if score < 0.4:
                break

            # Auxilary variables
            big_square = [31,0,255]                                             # Blue color definition
            small_square = [255,51,0]                                           # Red color definition
            b = box.astype(int)                                                 # Round values to int
            sb = [0] * 4                                                        # Declare empty array (sb = small box)
        # Calculate rectangle sides
            corrigate_pixel = 6
            a_side = (math.sqrt(pow((b[0]-b[0]),2)+pow((b[3]-b[1]),2))/2)-corrigate_pixel     # Calculate distance between points. We need half of this distance
            b_side = (math.sqrt(pow((b[2]-b[0]),2)+pow((b[3]-b[3]),2))/2)-corrigate_pixel     # Calculate distance between points. We need half of this distance
        # Generate small square coordinates
            sb[0] = b[0]+b_side                                                 # small box x1
            sb[1] = b[1]+a_side                                                 # small box y1
            sb[2] = b[2]-b_side                                                 # small box x2
            sb[3] = b[3]-a_side                                                 # small box y2
        # Resize the orignal big square
            b[0] = b[0]+6                                                      # x1
            b[1] = b[1]+6                                                      # y1
            b[2] = b[2]-6                                                      # x2
            b[3] = b[3]-6                                                      # y2
        # Draw boxes
            draw_box(draw, b, color=big_square)                                 # Draw big square
            draw_box(draw, sb, color=small_square)                              # Draw small square
            #color = label_color(label)
            b = box.astype(int)
            #draw_box(draw, b, color=big_square)


            caption = "{} {:.3f}".format(labels_to_names[label], score)
            draw_caption(draw, b, caption)

            counter+=1

        cv2.putText(draw, "Horses: {}".format(counter), (40, 50), cv2.FONT_HERSHEY_PLAIN, 3, (0, 0, 0), 5)
        cv2.putText(draw, "Horses: {}".format(counter), (40, 50), cv2.FONT_HERSHEY_PLAIN, 3, (255,51,0), 4)
        detected_img =cv2.cvtColor(draw, cv2.COLOR_RGB2BGR)
        cv2.imwrite(output_path, detected_img)
        cv2.imshow('Detection',detected_img)
        cv2.waitKey(0)
detection_on_image(image_path)
