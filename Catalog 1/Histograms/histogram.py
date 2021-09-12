import numpy as np
from PIL import Image, ImageOps
import matplotlib.pyplot as plt

def calculate_histogram(file = None,filename = None):
    """
    Arguments:
             file: an image file that is going to be processed
             filename: a filename of the file to be processed
    Returns:
            A touple that contains a list of the values
            and the ammout of repetitions of themselves
    """
    if file is None and filename is None:
        return 'Both values cannot be None'
    if file is None:
        file = ImageOps.grayscale(Image.open(filename))
    image = np.asarray(file)
    original_shape = image.shape
    image = image.ravel()
    #Gets the count of each unique value in the matrix
    s_values, bin_idx, s_counts = np.unique(image,
                                    return_inverse=True,return_counts=True)
    plt.bar(s_values,s_counts,align='center')
    plt.title("Histogram")
    plt.xlabel("Grey scale")
    plt.ylabel("Repetitions")
    plt.show()
    return (s_counts,s_values)