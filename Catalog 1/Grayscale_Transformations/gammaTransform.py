import matplotlib.pyplot as plt
import numpy as np

def gammaTransform():
    #necessary configuration of pyplot to see the images in grayscale
    plt.rcParams['image.cmap'] = 'gray'

    image = plt.imread('boat.jpg')
    fig = plt.figure()

    ########The gamma transformation of the image begins#########

    c=1
    for r in np.arange(0,2.1,0.1):
        image_gamma=c*image**r
        image_gamma=np.clip(image_gamma, 0, 255)#np.clip is used to limit the values ​
        #of an array between a range 
        #and if there are values ​​that are passed from those ranges, they are
        #replaced by the maximum or minimum range as the case may be 
        image_gamma=(np.round(image_gamma)).astype(np.uint8)#imagen_gamma at the
        #moment is an array of type flot and here it becomes type uint8
        ax1 = fig.add_subplot(1,2,1)
        ax2 = fig.add_subplot(1,2,2)
        ax1.set_title("Imagen Original")
        ax2.set_title("Imagen modificada con gamma="+str(round(r,1)))
        ax1.imshow(image)
        ax2.imshow(image_gamma,vmin=0,vmax=255)#with vmin and vmax the colors are
        #normalized between the values ​​of vmin and vmax to display them properly
        plt.draw()
        plt.pause(1)
        plt.clf()
gammaTransform()
