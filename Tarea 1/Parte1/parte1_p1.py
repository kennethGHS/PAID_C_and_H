import numpy as np
from PIL import Image
import matplotlib.pyplot as plt

def getPixel(M, r_m, c_m, x, y):
    """
        Est función verifica que se pueda acceder a un pixel de la imagen y que no se salga
        :param M: Matrix
        :param r_m: columnas
        :param c_m:  filas
        :param x: posicion en x
        :param y:  posicion en y
        :return: pixel que se quiere acceder
        """
    if (0 <= x and x < r_m) and (0 <= y and y < c_m):
        return M[x, y]
    else:
        return 0

def media(I):
    """
    Esta función aplica un filtrado a los pixeles de color negro de la imagen y les aplica un promedio de los nueve
    pixeles más cercanos. Luego sustituye el el valor del pixel negro por el valor resultante.
    :param I: imagen que se desea filtrar
    :return Y: imagen filtrada
    """
    rows, columns = I.size

    Y = np.array(I, dtype=np.uint8)

    window = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    for x in range(rows):
        for y in range(columns):
            if Y[x, y] == 0:
                window[0] = getPixel(Y, rows, columns, x, y)
                window[1] = getPixel(Y, rows, columns, x + 1, y)
                window[2] = getPixel(Y, rows, columns, x + 2, y)
                window[3] = getPixel(Y, rows, columns, x, y + 1)
                window[4] = getPixel(Y, rows, columns, x + 1, y + 1)
                window[5] = getPixel(Y, rows, columns, x + 2, y + 1)
                window[6] = getPixel(Y, rows, columns, x, y + 2)
                window[7] = getPixel(Y, rows, columns, x + 1, y + 2)
                window[8] = getPixel(Y, rows, columns, x + 2, y + 2)
                meanValue = np.uint8(np.mean(window))
                Y[x, y] = meanValue

    Y = Image.fromarray(Y, 'L')
    return Y


I = Image.open('imagen1_p.jpg', 'r').convert('L')
Y = media(I)
Y.save("parte1_p1.jpg")



canvas = plt.figure()


canvas.add_subplot(1, 2, 1)

plt.imshow(I, cmap='gray')
plt.title("Original")

canvas.add_subplot(1, 2, 2)
plt.imshow(Y, cmap='gray')
plt.title("Media")


plt.show()
