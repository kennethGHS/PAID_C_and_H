clear;
clc;
close all;
pkg load image;

function skeleton(imagename)
  %Reads the image
  A= imread(imagename);
  A = im2bw (A);
  %applies the skeleton transformation
  skeleton = bwmorph(A,'skel',Inf);
  %plots the skeleton
  imshow(skeleton)
 endfunction
 
 skeleton("spooky.jpg")