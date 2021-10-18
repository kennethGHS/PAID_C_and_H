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

def basicOP(file = None,filename = None,file2 = None, filename2 = None):
    """
    Arguments:
             file: an image file that is going to be processed
             filename: a filename of the file to be processed
             file2: an image file that is going to be processed
             filename2: a filename of the file to be processed
    Returns:
            Different operations of binary matrices.
    """
    if file  is None and filename is None:
        return "Error, both arguments cant be None"
    if file is None:
        file = ImageOps.grayscale(Image.open(filename))
        
    if file2  is None and filename2 is None:
        return "Error, both arguments cant be None"
    if file2 is None:
        file2 = ImageOps.grayscale(Image.open(filename2))
    image = np.asarray(file)
    image2 = np.asarray(file2)
    image = to_binary(image)
    image2 = to_binary(image2)
    #complement
    complement = to_binary(~image) 
    #union of images
    union = image | image2
    #intersection of images
    intersection = image & image2
    #difference of images
    difference = abs( union - intersection)
    fig = plt.figure(figsize=(10, 7))
    rows = 3
    columns = 2
    #plots all the images
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(image * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original 1")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(image2  * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original 2")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 3)  
    plt.imshow(complement * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Complement")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 4)  
    plt.imshow(union*255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("union")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 5)  
    plt.imshow(intersection * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("intersection")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 6)  
    plt.imshow(difference * 255, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("difference")
    plt.axis('off')
    
    plt.show()
    
basicOP(filename = "C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen2.jpg",filename2= "C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen3.jpg")