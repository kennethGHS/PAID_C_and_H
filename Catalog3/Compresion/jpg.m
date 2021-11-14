
clc; clear; close all;
pkg load image

function jpg(filename)
  %reads image
  A=imread(filename);
  subplot(121)
  imshow(A)
  title("Imagen Original")

  %Converts to double 
  A=double(A);
  [m,n]=size(A);
  %transform into 8x8 cells
  x=cell(m/8, m/8);

  for i=1:8:m
    for j=1:8:n
      %gets 8x8 section
      T=A(i:i+7,j:j+7);
      %compresses the 8x8 matrix
      x(round(i/8)+1,round(j/8)+1)=jpeg_comp(T);
    endfor
  endfor

  %Reconstructs image
  C=zeros(m,n);
  for i=1:8:m
    for j=1:8:n
      %Decompress 8x8 vallues
      B=decompress_jpeg(cell2mat(x(round(i/8)+1,round(j/8)+1)));
      C(i:i+7,j:j+7)=B;
    endfor

  endfor

  D=uint8(C);
  subplot(122)
  imshow(D)
  title("Decompressed")
endfunction

function Q50 = get_q50()
%just gets the quantification matrix
  Q50=[16 11 10 16 24 40 51 61;
       12 12 14 19 26 58 60 55;
       14 13 16 24 40 57 59 56;
       14 17 22 29 51 87 80 62;
       18 22 37 56 68 109 103 77;
       24 35 55 64 81 104 113 92;
       49 64 78 87 103 121 120 101;
       72 92 95 98 112 100 103 99];
endfunction

function DCJPG=decompress_jpeg(x)
  pkg load signal
  %Vector to 8x8`
  m=vectortomatrix(x);
  %gets the values and multiplies the quantization 
  Q=get_q50();
  M=m.*Q;
  %Applies the invers cosine transform
  P=idct2(M);
  %adds 128 and rounds the value
  DCJPG=round(P)+128;
endfunction

function mat = vectortomatrix(x)
  mat = zeros(8,8);
  for i = 1:8*8
    mat(i) = x(i);
  endfor
endfunction

function CJPG=jpeg_comp(A)
  pkg load signal 
  %Reduce the matrix
  M=A-128;
  %applies the cosine transform
  D=dct2(M);
  %get the quantification matrix
  Q=get_q50();
  %Quantify matrix
  C=round(D./Q);
  %Turns matrix to vector
  CJPG=matrix2vector(C);
endfunction

function vec = matrix2vector(x)
  vec = zeros(1,8*8);
    for i = 1:8*8
    vec(i) = x(i);
  endfor
endfunction


jpg("flores.bmp");