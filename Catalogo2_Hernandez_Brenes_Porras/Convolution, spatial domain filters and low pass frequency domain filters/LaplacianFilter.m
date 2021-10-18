clc;
clear;
close all;

pkg load image

A = imread('child2.jpg');
subplot(1,2,1);
imshow(A);
title('Original Image')

%Laplacian filter mask
B=[1 1 1;1 -8 1;1 1 1];
A=im2double(A);
%C=conv2(A,B,'same');
C=Convolution(A,B,'same');
subplot(1,2,2)
imshow(C);
title('Laplacian Filter')
