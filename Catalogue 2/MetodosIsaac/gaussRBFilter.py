import imageio
import matplotlib.pyplot as plt
import numpy as np


def gaussRBFilter(I):
    #Get the size of the image
    M = I.shape[0]
    N = I.shape[1]
    #Get the Fourier Transform of the image
    fourierTransform = np.fft.fftshift(np.fft.fft2(I[:,:]))
    #Asign the cut-off frequency
    D0 = 58
    W = 10
    #Get Euclidean Distance
    D = np.zeros([M, N])
    for u in range(M):
        for v in range(N):
            # Calculo de distancias
            D_temp = np.sqrt(u ** 2 + v ** 2)
            D[u, v] = 1-np.exp(-(1/2)*((D_temp**2-D0**2)/(D_temp*W))**2)

    H = D
    #Realizacion de la mascara
    m_masc = H.shape[0]
    n_masc = H.shape[1]

    for x in range(int(m_masc / 2)):
        for y in range(int(n_masc / 2)):
            H[m_masc - x - 1, n_masc - y - 1] = H[x, y]
            H[m_masc - x - 1, y] = H[x, y]
            H[x, n_masc - y - 1] = H[x, y]

    H = np.fft.fftshift(H)

    G_T = fourierTransform * H

    G = np.fft.fftshift(G_T)

    I_f = np.fft.ifft2(G)
    plt.figure()
    # Imagen original
    plt.subplot(1, 2, 1), plt.title("Imagen original")
    plt.imshow(I, cmap='gray')
    # Imagen con fft2 inversa
    plt.subplot(1, 2, 2), plt.title("Imagen con filtro RB de Gauss")
    plt.imshow(np.uint8(np.abs(I_f)), cmap='gray')
    plt.show()

I = imageio.imread("image_gauss.png")
gaussRBFilter(I)