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
    
    
def erosion_dilation_gradient(imagename):
    """
    Applies the morphological dilation, erosion and gradient to the image given by imagename
    imagename: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(imagename))
    img = np.asarray(file)
    img = to_binary(img)
    #Creates the kernel to apply the effects
    kernel = cv.getStructuringElement(cv.MORPH_RECT,(3,3))
    #Applies erosion
    erosion = cv.erode(img, kernel, iterations = 1)
    #Applies dilation
    dilation = cv.dilate(img, kernel, iterations= 1)
    #Applies gradient
    gradient1 =  dilation&~ erosion
    
    #Plots the different images
    fig = plt.figure(figsize=(10, 7))
    rows = 2
    columns = 2
    
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(img * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(erosion * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("erosion")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 3)  
    plt.imshow(dilation  * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("dilation")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 4)  
    plt.imshow(gradient1 * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("gradient1")
    plt.axis('off')
    
def internal_border(imagename):
    """
    Gets the internal borders of a figure
    imagename: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(imagename))
    img = np.asarray(file)
    img = to_binary(img)
    #Gets the kernel to applie the effects
    kernel = cv.getStructuringElement(cv.MORPH_RECT,(3,3))
    #Applies erosion
    erosion = cv.erode(img, kernel, iterations = 1)
    #Applies substraction to get the border
    result = img & (~erosion)
    #plots the images
    fig = plt.figure(figsize=(10, 7))
    rows = 1
    columns = 2
    
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(img * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(result * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Internal Border")
    plt.axis('off')
    plt.show()
    
def external_border(imagename):
    """
    Gets the external borders of a figure
    imagename: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(imagename))
    img = np.asarray(file)
    img = to_binary(img)
    #Gets the kernel to applie the effects
    kernel = cv.getStructuringElement(cv.MORPH_RECT,(3,3))
    #Applies dilation
    dilate = cv.dilate(img, kernel, iterations = 1)
    #Applies substraction to get the borders
    result = (~img) & dilate
    #Plots the images
    fig = plt.figure(figsize=(10, 7))
    rows = 1
    columns = 2
    
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(img * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(result * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("External Border")
    plt.axis('off')
    plt.show()
    
    
internal_border("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen6.jpg")
external_border("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen6.jpg")