clc;
clear;
close all;
pkg load image; 

  

function A_t=filt_punt_med(B)

  
  B=im2double(B); 
  [m,n]=size(B); 
  A_t=zeros(m,n); 


  Wmax=max(max(B(1:2,1:2))); 
  Wmin=min(min(B(1:2,1:2))); 
  A_t(1,1)=(Wmax+Wmin)/2;


  Wmax=max(max(B(1:2,n-1:n))); 
  Wmin=min(min(B(1:2,n-1:n))); 
  A_t(1,n)=(Wmax+Wmin)/2;


  Wmax=max(max(B(m-1:m,1:2))); 
  Wmin=min(min(B(m-1:m,1:2))); 
  A_t(m,1)=(Wmax+Wmin)/2;


  Wmax=max(max(B(m-1:m,n-1:n))); 
  Wmin=min(min(B(m-1:m,n-1:n))); 
  A_t(m,n)=(Wmax+Wmin)/2;



  for y=2:n-1
    Wmax=max(max(B(1:2,y-1:y+1))); 
    Wmin=min(min(B(1:2,y-1:y+1))); 
    A_t(1,y)=(Wmax+Wmin)/2;

    Wmax=max(max(B(m-1:m,y-1:y+1)));
    Wmin=min(min(B(m-1:m,y-1:y+1))); 
    A_t(m,y)=(Wmax+Wmin)/2;
  endfor

  for x=2:m-1
    Wmax=max(max(B(x-1:x+1,n-1:n))); 
    Wmin=min(min(B(x-1:x+1,n-1:n))); 
    A_t(x,n)=(Wmax+Wmin)/2;

    Wmax=max(max(B(x-1:x+1,1:2)));
    Wmin=min(min(B(x-1:x+1,1:2))); 
    A_t(x,1)=(Wmax+Wmin)/2;
  endfor

  
  for x=2:m-1
    for y=2:n-1
      Wmax=max(max(B(x-1:x+1,y-1:y+1))); 
      Wmin=min(min(B(x-1:x+1,y-1:y+1))); 
      A_t(x,y)=(Wmax+Wmin)/2.0;
    endfor
  endfor

  A_t=im2uint8(A_t);
endfunction



A=imread('imageSandP.jpg'); %lectura de imagen escala a grises
%Crear un ruido del tipo sal y pimienta con la funcion de Octave imnoise



subplot(1,2,1) %posicionamiento de imagen en el grafico
imshow(A)
title('Imagen con Ruido Sal y Pimienta')
  
A_t=filt_punt_med(A); %llamado de la funcion Filtro Punto Medio
  
subplot(1,2,2)
imshow(A_t)
title('Imagen Filtrada Punto Medio')
