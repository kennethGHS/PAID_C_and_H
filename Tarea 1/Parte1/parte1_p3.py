import numpy as np
from PIL import Image
from parte1_p1 import media
from parte1_p2 import mediana
import matplotlib.pyplot as plt

def getNewPos(comp, angle, pix_x, pix_y, rot_x,
              rot_y):  # Makes all the translation of the old components to the rotated components
    if (comp == 'x'):
        a0 = np.cos(angle)
        a1 = np.sin(angle)
        a2 = rot_x - a0 * rot_x - a1 * rot_y
        new_x = round(a0 * pix_x + a1 * pix_y + a2)
        return new_x
    else:
        b0 = -np.sin(angle)
        b1 = np.cos(angle)
        b2 = rot_y - b0 * rot_y - b1 * rot_y
        new_y = round(b0 * pix_x + b1 * pix_y + b2)
        return new_y


def rotacion(I, ang):
    """
    Esta función toma una imagen y la rota con cierto angulo sobre su propio centro. Esto lo logra mediante
    transformaciones y mapeos de todos los pixeles de la imagen.
    :param I: Imagen que se desea rotar
    :param ang: angulo por el que se va a rotar
    :return Y: Imagen rotada
    """
    imageM = np.array(I, dtype=np.uint8)
    max_rows, max_cols = I.size
    imageRot = np.zeros((max_rows, max_cols), dtype=np.uint8)
    centerX = max_rows // 2  # Get the x component center about which it will rotate (use the floor divition operator)
    centerY = max_cols // 2  # Get the y component center about which it will rotate (use the floor divition operator)

    for x in range(max_rows - 1):
        for y in range(max_cols - 1):

            x_new = getNewPos('x', ang, x, y, centerX, centerY)
            y_new = getNewPos('y', ang, x, y, centerX, centerY)

            if x_new >= 0 and y_new >= 0:  ##the transformation is not out of scope
                if x_new < max_rows and y_new < max_cols:  # Checks that the image dont gets out of the matrix size
                    imageRot[x_new, y_new] = np.uint8(imageM[x, y])  # Sets the components
    Y = Image.fromarray(imageRot, 'L')
    return Y

I = Image.open('barbara.jpg', 'r').convert('L')
ang = np.pi / 1.8
Y = rotacion(I, ang)
Y.save("rotation.jpg")

Y_media = media(Y).convert('L')
Y_mediana = mediana(Y).convert('L')

Y_media.save("Y_media.jpg")
Y_mediana.save("Y_mediana.jpg")

canvas = plt.figure()


canvas.add_subplot(1, 3, 1)

plt.imshow(I, cmap='gray')
plt.title("Original")

canvas.add_subplot(1, 3, 2)
plt.imshow(Y_media, cmap='gray')
plt.title("Media")

canvas.add_subplot(1, 3, 3)
plt.imshow(Y_mediana, cmap='gray')
plt.title("Mediana")
plt.show()
