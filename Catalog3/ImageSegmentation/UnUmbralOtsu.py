import matplotlib.pyplot as plt
import imageio
import cv2
import numpy as np


def umbralUtsu1(A):
    '''
        Funcion que realiza un corte de una imagen para poder segmentarla en dos tonos de gris
        :param A: imagen a procesar
        :return: imagen procesada con 3 tonos
        '''
    m = len(A)
    n = len(A[0])
    # Paso 0: Calculamos el hisotgrama
    q = cv2.calcHist([A], [0], None, [256], [0, 256])
    #q, _ = np.histogram(A, range=(0, 255))
    # Paso 1: Calculamos el histograma normalizado
    h = (1 / (m * n)) * q
    print(q)
    # Paso 2 : Calculamos el vector de suma acumulada del histograma

    p = np.zeros(255)
    sum = 0
    for k in range(0, 255):
        sum += h[k] #Realizamos la suma acumulada del hk
        print(sum)
        p[k] = sum  #Guardamos los valores

    # Paso 3 : Calcular el vector de suma acumulada con peso
    print('sum: ' + str(sum))
    mc = np.zeros(255)
    sum = 0
    #print(p)
    for k in range(0, 255):
        sum = sum + np.dot(k, h[k], out=None)
        mc[k] = sum
    # Paso 4: Calculamos el maximo de mc
    #print('sum: ' +str(sum))
    mg = mc[-1] #Extraemos el ultimo elemento por ser el una suma acumulada

    # Paso 5: Calcular el vector de varianza entre clases
    delta2b = np.zeros(255)
    for i in range(0, 255):
        N = (mg * p[i] - mc[i]) ** 2
        D = p[i] * (1 - p[i])
        if D == 0: #Verificamos que no exista una division entre cero
            delta2b[i] = 0
        else:
            delta2b[i] = N / D

    # Paso 6:  Posicion maxima del vector delta2b
    T = np.argmax(delta2b)


    D = np.zeros((m, n, 3))
    D[A > T] = 255
    D[A <= T] = 0
    return D.astype(np.uint8),T

A = cv2.imread('imagen4.jpg', cv2.IMREAD_GRAYSCALE)
A_p = imageio.imread("imagen4.jpg")
B,T = umbralUtsu1(A)

plt.figure()
plt.subplot(121)
plt.title("Imagen original")
plt.imshow(A_p)
plt.subplot(122)
plt.title("1 Umbral de Otsu, T ="+str(T))
plt.imshow(B, cmap="gray")
plt.show()