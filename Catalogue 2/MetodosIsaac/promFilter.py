import numpy as np
import imageio as im
import matplotlib.pyplot as plt

def filter(side,B,A_t,m,n):
    if side == "E1":
        W = B[0, 0] + B[0, 1] + B[1, 0] + B[1, 1]
        A_t[0, 0] = (1 / 4) * W
    elif side == "E2":
        W = B[0, n - 1] + B[0, n - 2] + B[1, n - 1] + B[1, n - 2]
        A_t[0, n - 1] = (1 / 4) * W
    elif side == "E3":
        W = B[m - 1, 0] + B[m - 1, 1] + B[m - 2, 0] + B[m - 2, 1]
        A_t[m - 1, 0] = (1 / 4) * W
    elif side == "E4":
        W = B[m - 1, n - 1] + B[m - 1, n - 2] + B[m - 2, n - 1] + B[m - 2, n - 2]
        A_t[m - 1, n - 1] = (1 / 4) * W
    elif side == "BU":
        for y in range(1, n - 1):
            Wf1 = B[0, y - 1] + B[0, y] + B[0, y + 1]
            Wf2 = B[1, y - 1] + B[1, y] + B[1, y + 1]
            A_t[0, y] = (1 / 6) * (Wf1 + Wf2)
    elif side == "BD":
        for y in range(1, n - 1):
            Wf1 = B[m - 2, y - 1] + B[m - 2, y] + B[m - 2, y + 1]
            Wf2 = B[m - 1, y - 1] + B[m - 1, y] + B[m - 1, y + 1]
            A_t[m - 1, y] = (1 / 6) * (Wf1 + Wf2)
    elif side == "BR":
        for x in range(1, m - 1):
            Wc1 = B[x - 1, n - 2] + B[x, n - 2] + B[x + 1, n - 2]
            Wc2 = B[x - 1, n - 1] + B[x, n - 1] + B[x + 1, n - 1]
            A_t[x, n - 1] = (1 / 6) * (Wc1 + Wc2)

    elif side == "BL":
        for x in range(1, m - 1):
            Wc1 = B[x - 1, 0] + B[x, 0] + B[x + 1, 0]
            Wc2 = B[x - 1, 1] + B[x, 1] + B[x + 1, 1]
            A_t[x, 0] = (1 / 6) * (Wc1 + Wc2)
    elif side == "C":
        for x in range(1, m - 1):
            for y in range(1, n - 1):
                Wf1 = B[x - 1, y - 1] + B[x - 1, y] + B[x - 1, y + 1]  # Fila 1
                Wf2 = B[x, y - 1] + B[x, y] + B[x, y + 1]  # Fila 2
                Wf3 = B[x + 1, y - 1] + B[x + 1, y] + B[x + 1, y + 1]  # Fila 3
                A_t[x, y] = (1 / 9) * (Wf1 + Wf2 + Wf3)
def promFilter(B):


    (m, n) = B.shape
    A_t = np.zeros((m, n))

    filter("E1", B, A_t, m, n)
    filter("E2", B, A_t, m, n)
    filter("E3", B, A_t, m, n)
    filter("E4", B, A_t, m, n)

    filter("BU", B, A_t, m, n)
    filter("BD", B, A_t, m, n)


    filter("BR", B, A_t, m, n)
    filter("BL", B, A_t, m, n)

    filter("C", B, A_t, m, n)

    imgDT = np.iinfo(np.uint8)
    imax = A_t * imgDT.max
    imax[imax > imgDT.max] = imgDT.max
    imax[imax < imgDT.min] = imgDT.min
    return imax.astype(np.uint8)




I = im.imread("filename.jpg") # lectura de imagen en escala a grises

info = np.iinfo(I.dtype)
I = I.astype(np.float64) / info.max


imgDT = np.iinfo(np.uint8)
imax = I * imgDT.max
imax[imax > imgDT.max] = imgDT.max
imax[imax < imgDT.min] = imgDT.min
A = imax.astype(np.uint8)



plt.figure(1) # creacion de nueva figura para graficado
plt.subplot(121) # posicionamiento de imagen
plt.title("Imagen con ruido")
plt.imshow(A, cmap='gray', vmin = 0, vmax = 255, interpolation='none')
# muestra matriz como imagen

# Filtro Promedio
B = promFilter(I)

plt.subplot(122) # posicionamiento de la nueva imagen
plt.title("Imagen Filtrada Promedio")
plt.imshow(B, cmap='gray', vmin = 0, vmax = 255, interpolation='none')
# muestra matriz como imagen

plt.show() # despliega la grafica