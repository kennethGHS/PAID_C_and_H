import imageio
import matplotlib.pyplot as plt
import numpy as np


def idealRBFilter(I, f_c, w):
    """
    Ideal bandwith filter using fourier transformrs
    :param I: image to filter
    :return: filtered image
    """
    #Get the size of the image
    M = I.shape[0]
    N = I.shape[1]
    #Get the Fourier Transform of the image
    fourierTransform = np.fft.fftshift(np.fft.fft2(I[:, :]))
    #Asign the cut-off frequency
    D0 = f_c
    #Get Euclidean Distance
    D = np.zeros([M, N])
    for u in range(M):
        for v in range(N):
            # Calculo de distancias
            D[u, v] = np.sqrt(u ** 2 + v ** 2)

    H = np.ones([M, N])
    W = w
    indx = D0-W/2< D
    indy = D0+W/2 >= D
    index = np.logical_and(indx,indy)
    H[index] = 0

    #Applying the masc
    m_masc = H.shape[0]
    n_masc = H.shape[1]

    for x in range(int(m_masc / 2)):
        for y in range(int(n_masc / 2)):
            H[m_masc - x - 1, n_masc - y - 1] = H[x, y]
            H[m_masc - x - 1, y] = H[x, y]
            H[x, n_masc - y - 1] = H[x, y]

    H = np.fft.fftshift(H)

    G_T = fourierTransform * H

    G = np.fft.ifft2(G_T)
    plt.figure()
    # original image
    plt.subplot(1, 2, 1), plt.title("Original Image")
    plt.imshow(I, cmap='gray')
    # final image
    plt.subplot(1, 2, 2), plt.title("Idea RB Filter final image")
    plt.imshow(np.uint8(np.abs(G)), cmap='gray')
    plt.show()

I = imageio.imread("idealRB.jpg")
idealRBFilter(I, 58, 10)