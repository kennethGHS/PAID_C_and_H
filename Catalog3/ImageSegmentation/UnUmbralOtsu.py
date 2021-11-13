import matplotlib.pyplot as plt
import imageio
# from scipy import signal
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
    q, _ = np.histogram(A, bins=255, range=(0, 255))
    # Paso 1: Calculamos el histograma normalizado
    h = (1 / (m * n)) * q

    # Paso 2 : Calculamos el vector de suma acumulada del histograma

    p = np.zeros(255)
    sum = 0
    for k in range(0, 255):
        sum = sum + h[k] #Realizamos la suma acumulada del hk
        p[k] = sum  #Guardamos los valores

    # Paso 3 : Calcular el vector de suma acumulada con peso
    mc = np.zeros(255)
    sum = 0
    for k in range(0, 255):
        sum = sum + (k * h[k])
        mc[k] = sum
    # Paso 4: Calculamos el maximo de mc
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

    maxValue = np.max(delta2b)
    T = (np.where(delta2b == maxValue))[0][0]
    print(T)
    D = np.zeros((m, n, 3))
    D[A > T] = 255
    D[A <= T] = 0
    return D.astype(np.uint8)


A = imageio.imread("imagen4.jpg")
B = umbralUtsu1(A)

plt.figure()
plt.subplot(121)
plt.title("Imagen original")
plt.imshow(A)
plt.subplot(122)
plt.title("1 Umbral de Otsu")
plt.imshow(B, cmap="gray")
plt.show()