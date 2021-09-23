import imageio
import numpy as np
import matplotlib.pyplot as plt

def drawCanvas(M_original, M_modified):
    plt.figure(1)
    plt.subplot(121)
    plt.title("Original Image")
    plt.imshow(M_original, cmap=plt.get_cmap('gray'))

    plt.subplot(122)
    plt.title("Bilateral Compressed Image")
    plt.imshow(M_modified, cmap=plt.get_cmap('gray'))
    plt.show()

def bilateral_compresion(A, r, p):
    #First step
    n = len(A[1]) #Get de columns of the matrix
    Y2 = np.random.normal(-1, 1, size=(n, r))
    # Second step
    for k in range(0, p):
        Y1 = np.dot(A, Y2)
        AT = A.T
        Y2 = np.dot(AT, Y1)

    #Third step
    (Q, R) = np.linalg.qr(Y2)
    #Fourth step
    Qr = Q[:, 1:r]
    #Fifth step
    B = np.dot(A, Qr)
    C = Qr.T

    return B, C

image = imageio.imread("imagen_color.jpg")
A = image[:, :, 0]
r = 200
p = 2
B2, C2 = bilateral_compresion(A, r, p)
A_compressed = np.dot(B2, C2)

drawCanvas(A, A_compressed)

