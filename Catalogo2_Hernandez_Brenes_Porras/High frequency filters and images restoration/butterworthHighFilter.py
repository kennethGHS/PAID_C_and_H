import imageio
import matplotlib.pyplot as plt
import numpy as np


def butterWorthHighFilter(I):
    """
    ButterWorth High filter applying fourier transform
    :param I: image to filter
    :return: final image
    """
    #Get the size of the image
    M = I.shape[0]
    N = I.shape[1]
    #Get the Fourier Transform of the image
    fourierTransform = np.fft.fftshift(np.fft.fft2(I[:,:,1]))
    #Asign the cut-off frequency
    D0 = 10
    #Get Euclidean Distance
    D = np.zeros([M, N])
    for u in range(M):
        for v in range(N):
            #distance calculation
            D_temp = np.sqrt(u ** 2 + v ** 2)
            D[u,v] = 1/(1+(D0/(1+D_temp)**(2*1))) #Set order to 1
    H = D
    #Masc applied to image
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
    # Original Image
    plt.subplot(1, 2, 1), plt.title("Imagen original")
    plt.imshow(I, cmap='gray')
    # Output image
    plt.subplot(1, 2, 2), plt.title("Butterworth High Pass")
    plt.imshow(np.uint8(np.abs(I_f)), cmap='gray')
    plt.show()

I = imageio.imread("image.jpg")
butterWorthHighFilter(I)