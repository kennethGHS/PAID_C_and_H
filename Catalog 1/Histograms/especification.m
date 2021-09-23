clc;
clear;
close all;
pkg load image ; 

function especification
    %This code gets the histogram of one image
    %and applies it to other images

    A = imread('Test1.jpg');
    B= imread('Test2.jpg');
    %applies the histogram 
    [H1,H2,M] = apply_hist(A,B);
    H3 = imhist(M);
    %Plots the results
    subplot(3,2,1);
    imshow(A);
    title('Original Image');

    subplot(3,2,3)
    imshow(B);
    title('Reference Image');
    
    subplot(3,2,5);
    imshow(M);
    title('Result Image');

    subplot(3,2,2);
    bar(0:255,H1);
    xlim([0 255]);
    title(['Histogram original image']);

    subplot(3,2,4);
    bar(0:255,H2);
    xlim([0 255]);
    title(['Histogram reference image']);

    subplot(3,2,6);
    bar(0:255,H3);
    xlim([0 255]);
    title(['Histogram final image']);

endfunction

function [h1,h2,Matrix]=apply_hist(M1,M2)
    %This function applies the histogram of one image 
    %to another.
    %M1 is the target image.
    %M2 is the source image.
    %h1 is the histogram of M1.
    %h2 is the histogram of M2.
    %Matrix is the result of applying the histogram 
    %of one image to another.

    E = zeros(256,1,'uint8');
    %Calculates the histograms
    h1 = imhist(M1);
    h2 = imhist(M2);
    %Computes the values for the transformation
    rf1 = cumsum(h1)/numel(M1);
    rf2 = cumsum(h2)/numel(M2);

    for i = 1:256
    %calculates value of the mapping
        [~,ind] = min(abs(rf1(i) - rf2));
        E(i) = ind-1;
    endfor

    Matrix = E(double(M1)+1);
endfunction
