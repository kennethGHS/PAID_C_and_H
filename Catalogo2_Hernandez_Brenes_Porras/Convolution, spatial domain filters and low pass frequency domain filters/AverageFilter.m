clc;
clear;
close all;

pkg load image

A = imread('child.jpg');
subplot(1,2,1);
imshow(A);
title('Original Image')

%Create the average filter mask
B=(1/9)*ones(3,3);
A=im2double(A);
C=conv2(A,B,'same');
C=im2uint8(C);
subplot(1,2,2)
imshow(C);
title('Average Filter')
