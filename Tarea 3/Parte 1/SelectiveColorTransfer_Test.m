clc;
clear;
close all;
pkg load image;

%%%% SelectiveColorTransfer %%%%
img = imread('IsaacFondo.png');
%Change color of the background image to green     
person_green = SelectiveColorTransfer(img);
%Get the borders of the person
border_person=edge(rgb2gray(img),"Canny");
%Apply convolution between the green person image and the borders of 
%the person
convolution = conv2_border(person_green,border_person,10);
subplot(1,2,1);
imshow(img);
title("Imagen Original");
subplot(1,2,2);
imshow(convolution);
title("Color cambiado a verde");