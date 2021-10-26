import imageio
import matplotlib.pyplot as plt
import numpy as np


def idealHighPassFilter(I):
    """
    High pass filter using the fourier transform
    :param I: Image to filter
    :return: Plot of two images (original and filtered)
    """
    # Get the size of the image
    M = I.shape[0]
    N = I.shape[1]
    # Get the Fourier Transform of the image
    fourierTransform = np.fft.fftshift(np.fft.fft2(I[:,:,1]))
    # Asign the cut-off frequency
    D0 = 1
    # Get Euclidean Distance
    D = np.zeros([M, N])
    for u in range(M):
        for v in range(N):
            # distance calculation
            D[u, v] = np.sqrt(u ** 2 + v ** 2)

    H = D > D0
    # Masc applied to image
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

    I_f = np.fft.ifft2(G_T)
    plt.figure()
    # Original Image
    plt.subplot(1, 2, 1), plt.title("Imagen original")
    plt.imshow(I, cmap='gray')
    # Output image
    plt.subplot(1, 2, 2), plt.title("Imagen transformada inversa")
    plt.imshow(np.uint8(np.abs(I_f)), cmap='gray')
    plt.show()

I = imageio.imread("image.jpg")
idealHighPassFilter(I)