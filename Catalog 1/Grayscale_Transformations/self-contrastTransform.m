clc;
clear;
close all;

pkg load image;

A= imread('boat_new.jpg');
subplot(1,2,1);
imshow(A);
title('Imagen Original');

%Tip: work with values in double
A=double(A);
[m,n]=size(A);
B= zeros(m,n);

%auto-contrast parameters
rmin=min(min(A));
rmax=max(max(A));

alpha=255/(rmax-rmin);
beta=rmin;

B=alpha*(A-beta);
B=uint8(B);
subplot(1,2,2);
imshow(B);
title('Imagen Modificada');
