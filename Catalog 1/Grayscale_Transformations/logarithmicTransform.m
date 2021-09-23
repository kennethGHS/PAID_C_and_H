clc;
clear;
close all;

pkg load image;

A=imread('log.jpg');
subplot(1,2,1);
imshow(A);
title('Imagen Original');

%Tip: work with values in double
A=double(A);
[m,n]=size(A);
B=zeros(m,n);

for c=0:0.05:0.5
  B=c*log(1+A);
  B=im2uint8(B);
  subplot(1,2,2);
  imshow(B);
  title(['Imagen Modificada: c = ' num2str(c)]);
  pause(0.1);
endfor


