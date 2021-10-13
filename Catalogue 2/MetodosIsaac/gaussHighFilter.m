
clc; 
clear;
close all;
pkg load image

A=imread('image.jpg');

A_o = im2double(A);

A = fftshift(fft2(A_o));

[m,n]=size(A);
fc=1;
H=zeros(m,n);
for u=1:m
  for v=1:n
    
    D_uv=sqrt(u^2+v^2);
    
    H(u,v)=1-e^(-(D_uv**2/(2*fc**2)));
  endfor
endfor 
 

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


subplot(2,1,1)
imshow(A_o)
title('Imagen Original')



A_f=im2uint8(real(A_f));
subplot(2,1,2)
imshow(A_f)
title('Imagen recontruida')