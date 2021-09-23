clc; %limpiar consola
clear;%limpiamos variables
close all; %Cierra todas las figuras

pkg load image;


function p = getPixel(imagen, max_rows, max_cols, row, column)
  if(0 < row && row <= max_rows) && (0 < column && column <= max_cols)
    p = imagen(row, column, 1);
  else
    p = 0;
  endif
endfunction

function window  = getWindow(A,max_rows,max_cols,row,column, window)
      window(1) = getPixel(A, max_rows, max_cols, row-1, column-1);
      window(2) = getPixel(A, max_rows, max_cols, row, column-1);
      window(3) = getPixel(A, max_rows, max_cols, row+1, column-1);
      window(4) = getPixel(A, max_rows, max_cols, row-1, column);
      window(5) = getPixel(A, max_rows, max_cols, row, column);
      window(6) = getPixel(A, max_rows, max_cols, row+1, column);
      window(7) = getPixel(A, max_rows, max_cols, row-1, column+1);
      window(8) = getPixel(A, max_rows, max_cols, row, column+1);
      window(9) = getPixel(A, max_rows, max_cols, row+1, column+1);
      
endfunction
function finalImage  = medianFilter(A)

  [max_rows,max_cols] = size(A); #get the dimentions of the image
  
  finalImage = uint8(zeros(max_rows,max_cols,1)); #set an matrix full of zeros
  
  window = uint8(zeros(1,9));#Set the window frame to 9 pixels
  
  for row = 1: max_rows
    for column = 1: max_cols
      #Get the kernel/window of the pixel
      window = getWindow(A,max_rows,max_cols,row,column, window);
      med =  median(window); #get the median
      finalImage(row,column, 1) = med; #set the actual pixel to the median
    endfor
  endfor
endfunction

originalImage = imread('camarografo.jpg');

dirtyImage = imnoise(originalImage, 'salt & pepper', 0.3);

dirtyImage_b = originalImage(:,:,1);

imagen_limpia = filtro_mediana(dirtyImage_b);

subplot(1,2,1)
imshow(dirtyImage);
title("Dirty Image");
subplot(1,2,2);
imshow(imagen_limpia);
title("Clean Image");