import numpy as np
from PIL import Image, ImageOps
import matplotlib.pyplot as plt

def reduce_histogram(val1,val2,file = None,filename = None):
    """
    Arguments:
             file: an image file that is going to be processed
             filename: a filename of the file to be processed
    Returns:
            The same input image but with its histogram reduced.
    """
    
    if file  is None and filename is None:
        return "Error, both arguments cant be None"
    if file is None:
        file = ImageOps.grayscale(Image.open(filename))
        
    fig = plt.figure(figsize=(10, 7))
    rows = 2
    columns = 2
    image = np.asarray(file)
    original_shape = image.shape
    backup = image
    image = image.ravel()
    
    #gets histogram of original image
    s_values, bin_idx, s_counts = np.unique(image, return_inverse=True,return_counts=True)
    #Calculates the values of the reduction
    r_max = np.amax(image)
    r_min = np.amin(image)
    s_min = r_min + val1
    s_max = r_max - val2
    #Verifies if the values are valid
    if s_min >= s_max or s_min > 255 or s_max < 0:
        print("Intervals cannot be used")
        return
    
    zeros_matrix = np.zeros(original_shape)
    #Reduces the image
    B = ((s_max - s_min) / (r_max - r_min)) * (backup - r_min) + s_min
    B = B.astype(np.uint8)
    #Gets the histogram of the reducted image
    b_values, bin_idx, b_counts = np.unique(B.ravel(), return_inverse=True,return_counts=True)
    
    #Plots the images and histograms
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(backup, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(B, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Reduced image")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 3)  
    plt.bar(s_values,s_counts,align='center')
    plt.title("Original Histogram")
    plt.xlabel("Grey scale")
    plt.ylabel("Repetitions")
    
    fig.add_subplot(rows, columns, 4)  
    plt.bar(b_values,b_counts,align='center')
    plt.title("Reduced Histogram")
    plt.xlabel("Grey scale")
    plt.ylabel("Repetitions")
    plt.show()
    return B
    