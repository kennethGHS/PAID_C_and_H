clear;
clc;
close all;
pkg load image;

%Metodo del Histograma Basico Global
%Algoritmo separa los valores de los pixeles en 2 grupos
%Entradas: Imagen a segmentar
%Salida: imagen segmentada

%Leemos la imagen
A = imread('imagen4.jpg');
subplot(2,2,1);
imshow(A);
title('Imagen Original');
%Obtenemos las dimensiones de la imagen
[m,n] = size(A);

subplot(2,2,2);
%Obtenemos el histograma de la imagen mediante la funcion de octave
imhist(A);
title('Histograma de la imagen original');

%Definimos una cierta cantidad de iteraciones
T = 165; %Seleccionamos el T0
iter = 15; %Definimos la cantidad de iteraciones

for k = 1:iter
  I1 = (A>T); %Obtenemos la mascara 1
  I2 = (A<=T);  %Obtenemos la mascara 2
  B1 = A.*I1; %Dividimos la imagen en 1 bloque
  B2 = A.*I2; %Dividimos la imagen en otro bloque
  m1 = sum(sum(B1))/sum(sum(I1)); %Calculamos el promedio de la intensidad de la imagen B1
  m2 = sum(sum(B2))/sum(sum(I2)); %Calculamos el promedio de la intensidad de la imagen B2
  T = 0.5 *(m1 + m2); %Actualizamos el valor del umbral
 endfor
 
 C = zeros(m,n);
 C(A>T) = 1;
 C(A<=T) = 0;
 
 subplot(2,2,3);
 imshow(C);
 title(['Umbral basico T=' num2str(T)]);
 