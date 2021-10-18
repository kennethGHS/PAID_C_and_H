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

def open_grey(image):
    """
    image: the filename of the image to  be processed
    """
    file = ImageOps.grayscale(Image.open(image))
    image = np.asarray(file)
    cv.imshow("Image", image)
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (3, 3))
    #Applies the morphology close operation
    binary = cv.morphologyEx(image, cv.MORPH_OPEN, kernel)
    cv.imshow("open-result", binary)
    cv.waitKey(0)
    cv.destroyAllWindows()

def close_grey(image):
    """
    image: the filename of the image to  be processed
    """
    file = ImageOps.grayscale(Image.open(image))
    image = np.asarray(file)
    cv.imshow("Image", image)
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (2, 2))
    #Applies the morphology close operation
    binary = cv.morphologyEx(image, cv.MORPH_CLOSE, kernel)
    cv.imshow("close-result", binary)
    cv.waitKey(0)
    cv.destroyAllWindows()
    
    
open_grey("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen11.jpg")
close_grey("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen11.jpg")
