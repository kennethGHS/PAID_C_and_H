clc;
clear;
close all;
function equalizator
    A= imread('actor.jpg');
    subplot(3,2,1);
    imshow(A);
    title("Original Image");
    h1 = zeros(256,1);
    [m,n] = size(A);
    for i = 0:255
        h1(i+1) = sum(sum(A==i));
    endfor;
    subplot(3,2,3)
    bar(0:255,h1);
    title('Histogram 1');
    xlim([0 255]);
    v_ac = zeros(256,1);
    for i = 0:255;
        v_ac(i+1) = sum(h1(1:i+1))/(m*n);
    endfor;
    subplot(3,2,4);
    bar(0:255,v_ac);
    title('Distributed accumulation');
    xlim([0 255]);
    B = zeros(m,n);
    A = double(A);
    for x = 1:m;
        for y = 1:n;
            B(x,y) = round(v_ac(A(x,y) + 1) * 255);
        endfor
    endfor

    B = uint8(B);
    subplot(3,2,2);
    imshow(B);
    title("Equalized picture");


endfunction



function [G] = convgray(F)
    rgb=double(F);
    [height,width,c] = size(rgb);
    gray = reshape(rgb,[],3);
    gray = gray * [0.30;0.63;0.07];
    gray = reshape(gray,height,width);
    G = gray;
endfunction