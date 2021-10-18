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
    
    
def fill_image(imagename,iterations=1):
    """
    Fills an image using the application of dilation the ammount of 
    times given by the iteration parameters.
    imagename: The filename of the image to be processed.
    iterations: The ammount of times to be executed the dilation.
    """
    file = ImageOps.grayscale(Image.open(imagename))
    img = np.asarray(file)
    img = to_binary(img)
    kernel = cv.getStructuringElement(cv.MORPH_RECT,(3,3))
    (m,n) = img.shape
    X= img*0
    m = int(m/2)
    n = int(n/2)
    X[m][n] = 1
    for i in range(0,iterations):
        X = cv.dilate(X, kernel, iterations= 1)
        X = X&~img
    cv.imshow("Filled Image", X*255)
    cv.waitKey(0)
    cv.destroyAllWindows()
    
fill_image("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen8.jpg",iterations = 1)
fill_image("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen8.jpg",iterations = 25)
fill_image("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen8.jpg",iterations = 50)
fill_image("C:/Users/kenne/OneDrive/Desktop/Analisis de imagenes/PAID_C_and_H/Catalogue 2/Morfologia/imagen8.jpg",iterations = 75)


