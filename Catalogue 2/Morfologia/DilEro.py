import numpy as np
from PIL import Image, ImageOps
import matplotlib.pyplot as plt
import cv2 as cv

def to_binary(x):
    """ 
    Turn a array into a CV binary array to be processed and return it
    """
    f,x = cv.threshold(x, 0, 1, cv.THRESH_BINARY | cv.THRESH_OTSU)
    return x    

    
def dilation_erosion_grey(imagename):
    """
    Applies the dilation and erosion to a grey image
    imagename: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(imagename))
    img = np.asarray(file)
    kernel = cv.getStructuringElement(cv.MORPH_RECT,(3,3))
    cv.imshow("binary image", img)
    #Applies the erosion effect
    erosion = cv.erode(img, kernel, iterations = 1)
    #Applies the dilation Effect
    dilation = cv.dilate(img, kernel, iterations= 1)
    #calculates the gradient
    gradient1 =  dilation - erosion
    
    #plots the images
    fig = plt.figure(figsize=(10, 7))
    rows = 2
    columns = 2
    
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(img , cmap = 'gray',vmin = 0,vmax = 256)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(erosion , cmap = 'gray',vmin = 0,vmax = 256)
    plt.title("erosion")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 3)  
    plt.imshow(dilation  , cmap = 'gray',vmin = 0,vmax = 256)
    plt.title("dilation")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 4)  
    plt.imshow(gradient1 , cmap = 'gray',vmin = 0,vmax = 256)
    plt.title("gradient")
    plt.axis('off')
    plt.show()

    
dilation_erosion_grey("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen11.jpg")