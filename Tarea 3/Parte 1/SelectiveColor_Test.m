clc;
clear;
close all;
pkg load image;
pkg load video;

%%%% SelectiveColor %%%%
B = imread('Kenneth.jpg');
%Get the image in grayscale only with the choosed color
D = SelectiveColor(B);
subplot(1,2,1);
imshow(B);
title("Imagen Original");
subplot(1,2,2);
imshow(D);
title("Color Resaltado");