import os
from glob import glob

import re

import tensorflow as tf
tf.config.experimental.set_memory_growth(tf.config.list_physical_devices('GPU')[0], True)

import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K

from sklearn.metrics import confusion_matrix

import numpy as np
#import matplotlib.pyplot as plt

import PIL
from PIL import Image

import numpy as np

maxsize = 32, 32
maxsize_w, maxsize_h = maxsize

def read_img(path, maxsize):
		img = Image.open(path)   
		WIDTH, HEIGHT = img.size
		if WIDTH != HEIGHT:
			m_min_d = min(WIDTH, HEIGHT)
			img = img.crop((0, 0, m_min_d, m_min_d))
		img.thumbnail(maxsize, PIL.Image.ANTIALIAS)
		img_rotate = img.transpose(method=PIL.Image.FLIP_LEFT_RIGHT)
		return (np.asarray(img), np.asarray(img_rotate))

def load_image_dataset(path_dir, maxsize, reshape_size, species, invert_image=False):
	images = []
	labels = []
	names  = []
	files = []; pattern   = "*.png"
	for dir,_,_ in os.walk(path_dir):
		files.extend(glob(os.path.join(dir,pattern))) 
	for file in files:
		(img, img_rotate) = read_img(file, maxsize)
		if img.shape!=(32,32,3):        
		    continue;
		img = img / 255
		img_rotate = img_rotate/255
		for i in list(range(0,np.size(species))):     
			if re.search(species[i], file):
				images.append(img.reshape(reshape_size))
				labels.append(i)
				names.append(file)
				if invert_image:
					images.append(img_rotate.reshape(reshape_size))
					labels.append(i)
	return (np.asarray(images), np.asarray(labels), names)

species1 = ['hrs_train0','not_train0']

(x_train, y_train, n_train) = load_image_dataset(
	path_dir='/home/wildhorse_project/random/test_pics',
	maxsize=maxsize,    
	reshape_size=(maxsize_w, maxsize_h, 3),
	species=species1,    
	invert_image=True)

species2 = ['hrs_test0','not_test0']

(x_test, y_test, n_test) = load_image_dataset(
	path_dir='/home/wildhorse_project/random/test_pics',
	maxsize=maxsize,
	reshape_size=(maxsize_w, maxsize_h, 3),
	species=species2,    
	invert_image=False)

np.unique(y_train, return_counts=True)
np.unique(y_test, return_counts=True)

print(x_train.shape)
print(x_test.shape)

batch_size = 64
num_classes = np.size(species1)
epochs = 16

img_rows, img_cols = maxsize

if K.image_data_format() == 'channels_first':
    x_train = x_train.reshape(x_train.shape[0], 3, img_rows, img_cols)
    x_test = x_test.reshape(x_test.shape[0], 3, img_rows, img_cols)
    input_shape = (3, img_rows, img_cols)
else:
    x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 3)
    x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 3)
    input_shape = (img_rows, img_cols, 3)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')

y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

layer1 = Conv2D(128, kernel_size=(3, 3),activation='relu',input_shape=input_shape)
layer2 = MaxPooling2D(pool_size=(2, 2))
layer3 = Dropout(0.25)
layer4 = Conv2D(64, kernel_size=(3,3),activation='relu')
layer5 = MaxPooling2D(pool_size=(2,2))
layer32 = Dropout(0.25)
layer42 = Conv2D(32, kernel_size=(3,3),activation='relu')
layer52 = MaxPooling2D(pool_size=(2,2))
layer6 = Flatten()
layer7 = Dense(128, activation='relu')
layer8 = Dropout(0.5)
layer9 = Dense(64,activation='relu')
layer10 = Dropout(0.25)
layer11 = Dense(num_classes, activation='softmax')

model = Sequential()
model.add(layer1)
model.add(layer2)
model.add(layer3)
model.add(layer4)
model.add(layer5)
model.add(layer32)
model.add(layer42)
model.add(layer52)
model.add(layer6)
model.add(layer7)
model.add(layer8)
model.add(layer9)
model.add(layer10)
model.add(layer11)

model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.SGD(lr=0.05, momentum=0.01),
              metrics=['accuracy'])

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_test, y_test))
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])

y_pred = model.predict(x_test)
matrix = confusion_matrix(y_test.argmax(axis=1), y_pred.argmax(axis=1))
matrix

