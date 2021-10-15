import numpy as np
import imageio as im
import matplotlib.pyplot as plt

def filter(side,B,A_t,m,n,R):
    BR1 = np.power(B, R + 1)
    BR = np.power(B, R)

    if side == "E1":
        Wn = BR1[0, 0] + BR1[0, 1] + BR1[1, 0] + BR1[1, 1]
        Wd = BR[0, 0] + BR[0, 1] + BR[1, 0] + BR[1, 1]
        A_t[0, 0] = Wn / Wd
    elif side == "E2":
        Wn = BR1[0, n - 1] + BR1[0, n - 2] + BR1[1, n - 1] + BR1[1, n - 2]
        Wd = BR[0, n - 1] + BR[0, n - 2] + BR[1, n - 1] + BR[1, n - 2]
        A_t[0, n - 1] = Wn / Wd
    elif side == "E3":
        Wn = BR1[m - 1, 0] + BR1[m - 1, 1] + BR1[m - 2, 0] + BR1[m - 2, 1]
        Wd = BR[m - 1, 0] + BR[m - 1, 1] + BR[m - 2, 0] + BR[m - 2, 1]
        A_t[m - 1, 0] = Wn / Wd
    elif side == "E4":
        Wn = BR1[m - 1, n - 1] + BR1[m - 1, n - 2] + BR1[m - 2, n - 1] + BR1[m - 2, n - 2]
        Wd = BR[m - 1, n - 1] + BR[m - 1, n - 2] + BR[m - 2, n - 1] + BR[m - 2, n - 2]
        A_t[m - 1, n - 1] = Wn / Wd
    elif side == "BU":
        for y in range(1, n - 1):

            Wnf1 = BR1[0, y - 1] + BR1[0, y] + BR1[0, y + 1]
            Wnf2 = BR1[1, y - 1] + BR1[1, y] + BR1[1, y + 1]
            Wn = Wnf1 + Wnf2

            Wdf1 = BR[0, y - 1] + BR[0, y] + BR[0, y + 1]
            Wdf2 = BR[1, y - 1] + BR[1, y] + BR[1, y + 1]
            Wd = Wdf1 + Wdf2
            A_t[0, y] = Wn / Wd
    elif side == "BD":
        for y in range(1, n - 1):
            Wnf1 = BR1[m - 2, y - 1] + BR1[m - 2, y] + BR1[m - 2, y + 1]
            Wnf2 = BR1[m - 1, y - 1] + BR1[m - 1, y] + BR1[m - 1, y + 1]
            Wn = Wnf1 + Wnf2
            Wdf1 = BR[m - 2, y - 1] + BR[m - 2, y] + BR[m - 2, y + 1]
            Wdf2 = BR[m - 1, y - 1] + BR[m - 1, y] + BR[m - 1, y + 1]
            Wd = Wdf1 + Wdf2
            A_t[m - 1, y] = Wn / Wd
    elif side == "BR":
        for x in range(1, m - 1):

            Wnc1 = BR1[x - 1, n - 2] + BR1[x, n - 2] + BR1[x + 1, n - 2]
            Wnc2 = BR1[x - 1, n - 1] + BR1[x, n - 1] + BR1[x + 1, n - 1]
            Wn = Wnc1 + Wnc2

            Wdc1 = BR[x - 1, n - 2] + BR[x, n - 2] + BR[x + 1, n - 2]
            Wdc2 = BR[x - 1, n - 1] + BR[x, n - 1] + BR[x + 1, n - 1]
            Wd = Wdc1 + Wdc2
            A_t[x, n - 1] = Wn / Wd

    elif side == "BL":
        for x in range(1, m - 1):

            Wnc1 = BR1[x - 1, n - 2] + BR1[x, n - 2] + BR1[x + 1, n - 2]
            Wnc2 = BR1[x - 1, n - 1] + BR1[x, n - 1] + BR1[x + 1, n - 1]
            Wn = Wnc1 + Wnc2

            Wdc1 = BR[x - 1, n - 2] + BR[x, n - 2] + BR[x + 1, n - 2]
            Wdc2 = BR[x - 1, n - 1] + BR[x, n - 1] + BR[x + 1, n - 1]
            Wd = Wdc1 + Wdc2
            A_t[x, n - 1] = Wn / Wd

            Wnc1 = BR1[x - 1, 0] + BR1[x, 0] + BR1[x + 1, 0]
            Wnc2 = BR1[x - 1, 1] + BR1[x, 1] + BR1[x + 1, 1]
            Wn = Wnc1 + Wnc2

            Wdc1 = BR[x - 1, 0] + BR[x, 0] + BR[x + 1, 0]
            Wdc2 = BR[x - 1, 1] + BR[x, 1] + BR[x + 1, 1]
            Wd = Wdc1 + Wdc2
            A_t[x, 0] = Wn / Wd
    elif side == "C":
        for x in range(1, m - 1):
            for y in range(1, n - 1):

                Wnf1 = BR1[x - 1, y - 1] + BR1[x - 1, y] + BR1[x - 1, y + 1]
                Wnf2 = BR1[x, y - 1] + BR1[x, y] + BR1[x, y + 1]
                Wnf3 = BR1[x + 1, y - 1] + BR1[x + 1, y] + BR1[x + 1, y + 1]
                Wn = Wnf1 + Wnf2 + Wnf3

                Wdf1 = BR[x - 1, y - 1] + BR[x - 1, y] + BR[x - 1, y + 1]
                Wdf2 = BR[x, y - 1] + BR[x, y] + BR[x, y + 1]
                Wdf3 = BR[x + 1, y - 1] + BR[x + 1, y] + BR[x + 1, y + 1]
                Wd = Wdf1 + Wdf2 + Wdf3

                A_t[x, y] = Wn / Wd
def promGeoFilter(B):

    R = 1
    (m, n) = B.shape
    A_t = np.zeros((m, n))

    filter("E1", B, A_t, m, n,R)
    filter("E2", B, A_t, m, n,R)
    filter("E3", B, A_t, m, n,R)
    filter("E4", B, A_t, m, n,R)

    filter("BU", B, A_t, m, n,R)
    filter("BD", B, A_t, m, n,R)


    filter("BR", B, A_t, m, n,R)
    filter("BL", B, A_t, m, n,R)

    filter("C", B, A_t, m, n,R)

    imgDT = np.iinfo(np.uint8)
    imax = A_t * imgDT.max
    imax[imax > imgDT.max] = imgDT.max
    imax[imax < imgDT.min] = imgDT.min
    return imax.astype(np.uint8)




I = im.imread("filename.jpg")

info = np.iinfo(I.dtype)
I = I.astype(np.float64) / info.max


imgDT = np.iinfo(np.uint8)
imax = I * imgDT.max
imax[imax > imgDT.max] = imgDT.max
imax[imax < imgDT.min] = imgDT.min
A = imax.astype(np.uint8)



plt.figure(1)
plt.subplot(121)
plt.title("Imagen con ruido")
plt.imshow(A, cmap='gray', vmin = 0, vmax = 255, interpolation='none')



B = promGeoFilter(I)

plt.subplot(122)
plt.title("Imagen Filtrada Promedio")
plt.imshow(B, cmap='gray', vmin = 0, vmax = 255, interpolation='none')


plt.show()