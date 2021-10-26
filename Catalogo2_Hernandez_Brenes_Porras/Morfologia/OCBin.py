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
    
def open_bin(image):
    """
    Applies the apperture effect to a binary image
    image: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(image))
    image = np.asarray(file)
    binary = to_binary(image)
    #plots the image
    cv.imshow("binary image", binary*255)
    #Gets the kernel to use
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (2, 2))
    #Applies the apperture effect
    binary = cv.morphologyEx(binary, cv.MORPH_OPEN, kernel)
    cv.imshow("open-result", binary*255)
    cv.waitKey(0)
    cv.destroyAllWindows()

def close_bin(image):
    """
    Applies the closure effect to a binary image
    image: The filename of the image to be processed.
    """
    file = ImageOps.grayscale(Image.open(image))
    image = np.asarray(file)
    binary = to_binary(image)
    #plots the image
    cv.imshow("binary image", binary*255)
    #Gets the kernel to use
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (2, 2))
    #Applies the closure effect
    binary = cv.morphologyEx(binary, cv.MORPH_CLOSE, kernel)
    cv.imshow("close-result", binary*255)
    cv.waitKey(0)
    cv.destroyAllWindows()
    
open_bin("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen11.jpg")
close_bin("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen11.jpg")
