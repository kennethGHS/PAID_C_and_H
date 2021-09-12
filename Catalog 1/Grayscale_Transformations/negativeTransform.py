import matplotlib.pyplot as plt
import numpy as np

def negativeTransform():
    #necessary configuration of pyplot to see the images in grayscale
    plt.rcParams['image.cmap'] = 'gray'

    image = plt.imread('boat.jpg')


    ########The negative transformation of the image begins#########

    '''
    To obtain the negative of the image in this case, a -1 is assigned to c
    (variable that multiplies) and a 255 a b (variable that adds)
    '''
    b=255
    c=-1
    fig = plt.figure()
    image_negative=round(c,1)*image+b
    image_negative=np.clip(image_negative, 0, 255)#np.clip is used to limit the values
    #of an array between a range  
    #and if there are values ​​that are passed from those ranges, they are replaced by
    #the maximum or minimum range as the case may be 
    image_negative=image_negative.astype(np.uint8)#image_negative at the moment is
    #an array of type flot and here it becomes type uint8
    ax1 = fig.add_subplot(1,2,1)
    ax2 = fig.add_subplot(1,2,2)
    ax1.set_title("Imagen Original")
    ax2.set_title("Negativo de la imagen")
    ax1.imshow(image)
    ax2.imshow(image_negative,vmin=0,vmax=255)#with vmin and vmax the colors are
    #normalized between the values ​​of vmin and vmax to display them properly
    plt.show()
negativeTransform()
