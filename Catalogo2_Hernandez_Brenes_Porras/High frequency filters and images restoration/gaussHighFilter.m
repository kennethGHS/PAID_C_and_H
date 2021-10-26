
clc; 
clear;
close all;
pkg load image
#High pass filter using gauss
#Inputs - A: An image to filter
#Outputs - A_f: final image that applied a filter to A 

A=imread('image.jpg');

A_o = im2double(A);
#Get the fourier transform
A = fftshift(fft2(A_o));
#Get the size
[m,n]=size(A);
fc=1;
H=zeros(m,n);
#Masc applied to image
for u=1:m
  for v=1:n
    
    D_uv=sqrt(u^2+v^2);
    
    H(u,v)=1-e^(-(D_uv**2/(2*fc**2)));
  endfor
endfor 
 
#Complete the masc of the filter
for x=1:round(m/2)
  for y=1:round(n/2)
    
    H(m-x+1,n-y+1)=H(x,y);
    H(m-x+1,y)=H(x,y);
    H(x,n-y+1)=H(x,y);
  endfor
endfor
H = fftshift(H);

G = A.*H;

G=fftshift(G);

A_f=ifft2(G);

#Original Image
subplot(2,1,1)
imshow(A_o)
title('Imagen Original')
#Final image
A_f=im2uint8(real(A_f));
subplot(2,1,2)
imshow(A_f)
title('Imagen con el filtro de gauss paso alto')