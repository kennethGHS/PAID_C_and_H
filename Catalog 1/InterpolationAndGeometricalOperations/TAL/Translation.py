import numpy as np  # Libreria matematica para operaciones con matrices.
import matplotlib.pyplot as plt  # Manejo de graficos
from PIL import Image  # Cargar y creacion de imagenes


def traslacion(img,deltax, deltay):
    imageM = np.array(img)
    rows, columns = img.size #Get the dimentions of the image
    translateM = np.zeros((rows, columns), dtype=np.uint8) #Set the output image
    for pix_x in range(rows - 1):
        for pix_y in range(columns - 1):
            x_new = pix_x + deltax
            y_new = pix_y + deltay
            if x_new < rows and y_new < columns:
                translateM[x_new][y_new] = np.uint8(imageM[pix_x, pix_y])
    finalImage = Image.fromarray(translateM, 'L')

    return finalImage
def draw():
    gf = plt.figure()
    img = Image.open('landscape.jpg', 'r').convert('L')
    finalImage = traslacion(img, 20, 25)
    finalImage.save('translateImage.jpg')
    gf.add_subplot(1, 2, 1)
    plt.imshow(img.convert('L'), cmap='gray')
    plt.title("Original")
    gf.add_subplot(1, 2, 2)
    plt.imshow(finalImage.convert('L'), cmap='gray')
    plt.title("Translated")
    plt.show()
draw()