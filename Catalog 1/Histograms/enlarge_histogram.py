import numpy as np
from PIL import Image, ImageOps
import matplotlib.pyplot as plt

def enlarge_histogram(file = None,filename = None):
    """
    Arguments:
             file: an image file that is going to be processed
             filename: a filename of the file to be processed
    Returns:
            The same input image but with its histogram enlarged.
    """
    if file  is None and filename is None:
        return "Error, both arguments cant be None"
    if file is None:
        file = ImageOps.grayscale(Image.open(filename))
    
    #Creates a figure to plot the values
    fig = plt.figure(figsize=(10, 7))
    rows = 2
    columns = 2
    
    image = np.asarray(file)
    original_shape = image.shape
    backup = image
    image = image.ravel()
    s_values, bin_idx, s_counts = np.unique(image, return_inverse=True,return_counts=True)
    r_max = np.amax(image)
    r_min = np.amin(image)
    if(r_min == 0):
        r_min = 1
    zeros_matrix = np.zeros(original_shape)
    #Enlarges the histogram
    B = (255/(r_max - r_min)) * backup
    B = B.astype(np.uint8)
    #Calculates the new histogram
    b_values, bin_idx, b_counts = np.unique(B.ravel(), return_inverse=True,return_counts=True)
    #plots the images
    fig.add_subplot(rows, columns, 1)  
    plt.imshow(backup, cmap = 'gray',vmin = 0,vmax = 255)
    plt.title("Original")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 2)  
    plt.imshow(B, cmap = 'gray',vmin = 0,vmax = 300)
    plt.title("Enlarged image")
    plt.axis('off')
    
    fig.add_subplot(rows, columns, 3)  
    plt.bar(s_values,s_counts,align='center')
    plt.title("Original Histogram")
    plt.xlabel("Grey scale")
    plt.ylabel("Repetitions")
    
    fig.add_subplot(rows, columns, 4)  
    plt.bar(b_values,b_counts,align='center')
    plt.title("Enlarged Histogram")
    plt.xlabel("Grey scale")
    plt.ylabel("Repetitions")
    plt.show()
    return B
       