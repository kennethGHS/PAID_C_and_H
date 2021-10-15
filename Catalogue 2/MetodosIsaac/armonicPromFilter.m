clc; 
clear; 
close all;
pkg load image;
 



function A_t = filt_prom_arm(B)

  B = double(B);
  [m,n] = size(B);
  A_t = zeros(m,n);

  B_i = B.^ - 1;
  mask = isinf(B_i);
  B_i(mask) = 0.0; 

  
  W = B_i(1,1) + B_i(1,2) + B_i(2,1) + B_i(2,2);
  A_t(1,1) = 4/W;

  W = B_i(1,n) + B_i(1,n - 1) + B_i(2,n) + B_i(2,n - 1);
  A_t(1,n) = 4/W;

  
  W = B_i(m,1) + B_i(m,2) + B_i(m - 1,1) + B_i(m - 1,2);
  A_t(m,1) = 4/W;

  
  W = B_i(m,n) + B_i(m,n - 1) + B_i(m - 1,n) + B_i(m - 1,n - 1);
  A_t(m,n) = 4/W;

  

  for y = 2:n - 1
    Wnf1 = B_i(1,y - 1) + B_i(1,y) + B_i(1,y + 1); 
    Wnf2 = B_i(2,y - 1) + B_i(2,y) + B_i(2,y + 1); 
    A_t(1,y) = 6/(Wnf1 + Wnf2);

    Wnf1 = B_i(m - 1,y - 1) + B_i(m - 1,y) + B_i(m - 1,y + 1);
    Wnf2 = B_i(m,y - 1) + B_i(m,y) + B_i(m,y + 1); 
    A_t(m,y) = 6/(Wnf1 + Wnf2);
  endfor
 
  for x = 2:m - 1
    Wnc1 = B_i(x - 1,n - 1) + B_i(x,n - 1) + B_i(x + 1,n - 1); 
    Wnc2 = B_i(x - 1,n) + B_i(x,n) + B_i(x + 1,n); 
    A_t(x,n) = 6/(Wnc1 + Wnc2);
  
    Wnc1 = B_i(x - 1,1) + B_i(x,1) + B_i(x + 1,1); 
    Wnc2 = B_i(x - 1,2) + B_i(x,2) + B_i(x + 1,2); 
    A_t(x,1) = 6/(Wnc1 + Wnc2);
  endfor

  for x = 2:m - 1
    for y = 2:n - 1
      Wf1 = B_i(x - 1,y - 1) + B_i(x - 1,y) + B_i(x - 1,y + 1); 
      Wf2 = B_i(x,y - 1) + B_i(x,y) + B_i(x,y + 1); 
      Wf3 = B_i(x + 1,y - 1) + B_i(x + 1,y) + B_i(x + 1,y + 1); 
      A_t(x,y) = 9/(Wf1 + Wf2 + Wf3);
    endfor
  endfor

  A_t = uint8(A_t);
endfunction




A = imread('gaussianNoise.jpg'); 

subplot(1,2,1) 
imshow(A)
title('Original Image')
  
A_t = filt_prom_arm(A);
  
subplot(1,2,2)
imshow(A_t)
title('Mean Armonic Filter')

