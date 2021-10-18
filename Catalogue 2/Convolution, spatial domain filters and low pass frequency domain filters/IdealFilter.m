clear;
clc;
close all;

pkg load image;

A=imread('edificio_china.jpg');
subplot(2,2,1);
imshow(A);
title('Original Image');

%Calculation of DFT-2D

A=im2double(A);
F=fft2(A);
F_A=fftshift(F);
subplot(2,2,2);
imshow(log(1+abs(F_A)),[]);
title('Image DFT-2D (Shift)');

%Apply the filter using the convolution theorem

%Calculate the filter mask
[m,n]=size(A);
D=zeros(m,n);
for u=1:m
  for v=1:n
    D(u,v)=sqrt(u^2+v^2);
  endfor
endfor


H = zeros(m,n); D0 = 100; ind = (D<=D0); H(ind) = 1;

HSI = H(1:floor(m/2), 1:floor(n/2));

HSD = imrotate(HSI, 90)'; % Upper Right
HID = imrotate(HSI, 180); % Upper Right
HII = imrotate(HSI, 270)'; % Lower Left

[m1, n1] = size(HSI);
H(1:m1, n-n1+1:n) = HSD;
H(m-m1+1:m, n-n1+1:n) = HID;
H(m-m1+1:m, 1:n1) = HII;

% Apply the filter
H_shift = fftshift(H);
DFT2_filt = F.*H;
FM_shift = fftshift(DFT2_filt);
subplot(2,2,3)
imshow(log(1+abs(FM_shift)), [])
title('Image DFT-2D with Ideal Filter')


%Image Filtered
I_new = abs(ifft2(FM_shift));
subplot(2,2,4)
imshow(I_new)
title('Image with Ideal Filter');