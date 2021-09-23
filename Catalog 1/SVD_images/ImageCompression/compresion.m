%Objetivo: Ingresar una imagen A y obtener las matrices BC que aproximan a la imagen A 

clc; %limpiar consola
clear;%limpiamos variables
close all; %Cierra todas las figuras

pkg load image


function [B,C] = compresionImagen(A)
  

  [U,S,V] = svd(A);

  k = 50;
  Uk = U(:,1:k); 
  Vk = V(:,1:k);
  Sk = S(1:k,1:k);

  B =  Uk*Sk;
  C = Vk';
  F = B*C;
  F =  im2uint8(F);
  subplot(1,2,1);
  imshow(A);
  subplot(1,2,2);
  imshow(F);

endfunction
I =  imread('camarografo.jpg');
I = im2double(I);

A = I(:, :, 1);
[B,C] = compresionImagen(A);
