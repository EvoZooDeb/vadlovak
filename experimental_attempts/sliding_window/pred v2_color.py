import matplotlib.pyplot as plt

path='/home/wildhorse_project/V180824_2_12fps_4k_frames/V180824_2_12fps_4k_0001.png'

img = Image.open(path)


images = []
for i in range(67):
    for j in range(120):
        img0 = img.crop((j*32, i*32,j*32+32,i*32+32))
        img0 = np.asarray(img0)
        images.append(img0.reshape((32,32,3)))

images = np.asarray(images)
images = images.reshape(67*120,32,32,3)
img = np.array(Image.open(path))

y_pred = model.predict(images)

t_f = y_pred[:,0]>0.6

for i in range(66):
    for j in range(119):
        n = i*120+j
        if t_f[n]:
            img[(i*32):(i*32+32),j*32,1]=np.zeros(32)
            img[(i*32):(i*32+32),j*32+32,1]=np.zeros(32)
            img[i*32,(j*32):(j*32+32),1]=np.zeros(32)
            img[i*32+32,(j*32):(j*32+32),1]=np.zeros(32)
            img[(i*32):(i*32+32),j*32+1,1]=np.zeros(32)
            img[(i*32):(i*32+32),j*32+31,1]=np.zeros(32)
            img[i*32+1,(j*32):(j*32+32),1]=np.zeros(32)
            img[i*32+31,(j*32):(j*32+32),1]=np.zeros(32)
            
            


img1 = Image.fromarray(img)
img1.save('/home/abarta/test.jpg')
img1.show()  
