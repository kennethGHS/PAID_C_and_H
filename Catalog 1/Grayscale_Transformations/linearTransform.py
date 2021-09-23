import matplotlib.pyplot as plt
import numpy as np


def linearTransform():
    #necessary configuration of pyplot to see the images in grayscale
    plt.rcParams['image.cmap'] = 'gray'

    image = plt.imread('boat.jpg')
    image = image.astype(float)

    fig = plt.figure()
    
    ########The linear transformation of the image begins#########

    #Varying only c while keeping b constant at a value of 0
    b=0
    for c in np.arange(0,3.1,0.5):
        image_withC=round(c,1)*image+b
        image_withC=np.clip(image_withC, 0, 255)#np.clip is used to limit the values ​​
        #of an array between a range 
        #and if there are values ​​that are passed from those ranges, they are
        #replaced by the maximum or minimum range as the case may be
        image_withC=image_withC.astype(np.uint8)#imagen_withC at the moment is an
        #array of type flot and here it becomes type uint8
        ax1 = fig.add_subplot(1,2,1)
        ax2 = fig.add_subplot(1,2,2)
        ax1.set_title("Imagen Original")
        ax2.set_title("Imagen modificada con c="+str(round(c,1)))
        ax1.imshow(image)
        ax2.imshow(image_withC)
        plt.draw()
        plt.pause(1)
        plt.clf()

    #Varying only b while c remains at a constant value of 1
    c=1
    for b in np.arange(-50,110,50):
        image_withB=c*image+b
        image_withB=np.clip(image_withB, 0, 255)#np.clip is used to limit the values ​
        #of an array between a range 
        #and if there are values ​​that are passed from those ranges, they are
        #replaced by the maximum or minimum range as the case may be 
        image_withB=image_withB.astype(np.uint8)#imagen_withB at the moment is
        #an array of type flot and here it becomes type uint8
        ax1 = fig.add_subplot(1,2,1)
        ax2 = fig.add_subplot(1,2,2)
        ax1.set_title("Imagen Original")
        ax2.set_title("Imagen modificada con b="+str(b))
        ax1.imshow(image)
        ax2.imshow(image_withB,vmin=0,vmax=255)#with vmin and vmax the colors are
        #normalized between the values ​​of vmin and vmax to display them properly
        plt.draw()
        plt.pause(1)
        plt.clf()
linearTransform()
