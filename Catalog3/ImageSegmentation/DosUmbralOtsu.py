import matplotlib.pyplot as plt
import imageio
import cv2
import numpy as np


def umbralUtsu2(A):
    '''
    Funcion que realiza dos cortes de una imagen para poder segmentarla en tres tonos de gris
    :param A: imagen a procesar
    :return: imagen procesada con 3 tonos
    '''

    m = len(A)
    n = len(A[0])
    # Paso 0: Calculamos el hisotgrama
    q = cv2.calcHist([A], [0], None, [256], [0, 256])
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

    for k in range(0, 255):
        sum = 0
        for i in range(0 ,k):
            sum = sum + (i * h[k])
        mc[k] = sum
    # Paso 4: Calculamos el maximo de mc
    mg = mc[-1] #Extraemos el ultimo elemento por ser el una suma acumulada
    # Paso 5: Calcular el vector de varianza entre clases
    delta2b = np.zeros((255,255))
    for k1 in range(0, 255): #Definimos los limites sobre los cuales van a iterar k1
        for k2 in range(0, 255): #Definimos los limites sobre los cuales van a iterar k2
            if k1 < k2:
                #Paso 6: Calculamos las sumatorias
                P1 = np.sum(h[0:k1]) #Definimos los rangos intermedios
                P2 = np.sum(h[k1+1:k2]) #Definimos los rangos intermedios
                P3 = np.sum(h[k2+1:255]) #Definimos los rangos intermedios

                # Paso 7: Calculamos los mi
                m1 = 0
                m2 = 0
                m3 = 0
                for i in range(0, k1):
                    m1 = m1 + (i - 1) * h[i]

                for i in range(k1, k2):
                    m2 = m2 + (i - 1) * h[i]

                for i in range(k2, 255):
                    m3 = m3 + (i - 1) * h[i]

                #Paso 8: Calcular
                if P1 != 0:
                    m1 = m1 / P1 #En caso de que el P1 es cero se omite la formula
                if P2 != 0:
                    m2 = m2 / P2 #En caso de que el P2 es cero se omite la formula
                if P3 != 0:
                    m3 = m3 / P3 #En caso de que el P3 es cero se omite la formula

                delta2b[k1, k2] = (P1 * (m1 - mg) ** 2) + (P2 * (m2 - mg) ** 2) + (P3 * (m3 - mg) ** 2)


    # Paso 9:  Obtener los humbrales T1 y T2
    maxValue = np.max(delta2b)
    T1, T2 = np.where(delta2b == maxValue)
    T1 = T1[0]
    T2 = T2[0]
    D = np.zeros((m, n, 3))

    D[A > T2] = 255 #Primera tono de gris
    cond1 = T1 < A
    cond2 = A <= T2
    operation = np.logical_and(cond1,cond2)
    D[operation] = 255 // 2 #Segundo tono de gris
    D[A < T1] = 0 #Tercer tono de gris
    return D.astype(np.uint8),T1,T2

A = cv2.imread('imagen4.jpg', cv2.IMREAD_GRAYSCALE)
A_p = imageio.imread("imagen4.jpg")
B,T1,T2 = umbralUtsu2(A)

plt.figure()
plt.subplot(121)
plt.title("Imagen original")
plt.imshow(A_p)
plt.subplot(122)
plt.title("2 Umbral de Otsu(T1= "+str(T1)+", T2= "+str(T2)+")")
plt.imshow(B, cmap="gray")
plt.show()