clc;
clear;
close all;

pkg load image

A = imread('edificio_china.jpg');

[m,n] = size(A);

subplot(2,2,1)
imshow(A)
title('Original Image')

A = im2double(A);

%Calculation of DFT-2D
F = fft2(A);
F_shift = fftshift(F);
subplot(2,2,2)
imshow(log(1+abs(F_shift)), [])
title('Image DFT-2D (Shift)')

dist = zeros(m,n);
for i = 1:m
  for j = 1:n
    dist(i,j) = sqrt(i^2+j^2);
  endfor
endfor

H = zeros(m,n); D0 = 50; orden = 2;
H = 1 ./(1+(D0./dist).^(-2*orden));

HSI = H(1:floor(m/2), 1:floor(n/2));

HSD = imrotate(HSI, 90)';
HID = imrotate(HSI, 180);
HII = imrotate(HSI, 270)';

[m1, n1] = size(HSI);
H(1:m1, n-n1+1:n) = HSD;
H(m-m1+1:m, n-n1+1:n) = HID;
H(m-m1+1:m, 1:n1) = HII;

% Apply the filter
H_shift = fftshift(H);
DFT2_filt = F.*H;
FM_shift =  fftshift(DFT2_filt);
subplot(2,2,3)
imshow(log(1+abs(FM_shift)), [])
title('Image DFT-2D with Butterworth Filter')


%Image Filtered
I_new = abs(ifft2(DFT2_filt));
subplot(2,2,4)
imshow(I_new)
title('Image with Butterworth Filter');