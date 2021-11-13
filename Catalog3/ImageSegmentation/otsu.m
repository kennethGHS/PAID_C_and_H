clear;
clc;
close all;
pkg load image;
A = imread('imagen4.jpg');
subplot(2,2,1);
imshow(A);
title('Imagen Original');

[m,n] = size(A);

subplot(2,2,2);
imhist(A);
title('Histograma de la imagen original');

T = 165;
iter = 15;

for k = 1:iter
  I1 = (A>T);
  I2 = (A<=T);
  B1 = A.*I1;
  B2 = A.*I2;
  m1 = sum(sum(B1))/sum(sum(I1));
  m2 = sum(sum(B2))/sum(sum(I2));
  T = 0.5 *(m1 + m2);
 endfor
 
 C = zeros(m,n);
 C(A>T) = 1;
 C(A<=T) = 0;
 
 subplot(2,2,3);
 imshow(C);
 title(['Umbral basico T=' num2str(T)]);
 
[q,~] = imhist(A);
q
h = [1/(m*n)] * q;
p = zeros(256,1);
for k = 1:256
  p(k) = sum(h(1:k));
 endfor
suma = p(256)
 mc =  zeros(255,1);
 for k = 1 : 256
   %sum((0:k-1)'.*h(1:k))
   mc(k) = sum((0:k-1)'.*h(1:k));
 endfor
 mg = mc(256);
 mg
