function P2
  %Executes the different tests
 c =imread("C:/Users/kenne/OneDrive/Desktop/Pag.png");
 %transformation of 2Mx2N
 disp("Result 1")
 test_transform1(c);
 %Transformation of 2MxN*3/2
  disp("Result 2")
 test_transform2(c);
 %Transformation of Mx3N
  disp("Result 3")
 test_transform3(c);
 %Transformation of 3MxN
  disp("Result 4")
 test_transform4(c);
  endfunction

function [M] = alpha_root(alpha,Mat)
  %Applies the alpha root transformation
  [m,n] = size(Mat);
  value = fft2(Mat);
  angles = arg(value);
  absolutes = abs(value);
  %Applies the alpha root to each value
  for i = 1:m
    for j = 1:n
      absolutes(i,j) = absolutes(i,j)^alpha;
      value = absolutes(i,j)*e^(angles(i,j) * 1i);
    endfor
  endfor
  %Restores the value
  value = absolutes.*e.^(angles * 1i);
  M = uint8(abs(ifft2(value)));
endfunction

function [R,G,B,I] = get_RGBI(image)
  %Gets the RGBI values
  R = double(image(:,:,1));
  G = double(image(:,:,2));
  B = double(image(:,:,3));
  I = double(R*0.3 + B*0.11 + G*0.59); 
  
endfunction

function [image] = reform_RGB(R,G,B)
  %Restores the Image to RGB
  [m,n] = size(R);
  image = uint8(cat(3,R,G,B));
endfunction

function [M] = transform1(image)
  %Applies the transformation of 2Nx2M
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  %Creates the atrix to be filled
  M =double(zeros(m*2,n*2));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  while row_old <= m
    while index_old <= n
      %Populates the new matrix with the values
      M(row_new:row_new + 1,index_new : index_new + 1)= [I(row_old,index_old) G(row_old,index_old) ; R(row_old,index_old) B(row_old,index_old)];
      index_old = index_old + 1;
      index_new = index_new + 2;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 2;
    row_old = row_old +1;
  endwhile
  M = uint8(M);
endfunction

function [image] = untransform1(M)
  %Restores the RGB matrix from the tranformed one 
  [m_new,n_new] = size(M);
  %Creates the matrces to be restores
  R = zeros(m_new/2,n_new/2);
  G = R;
  B = R;
  I = R;
  [m,n] = size(R);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  while row_old != m
    while index_old <= n
      %Fills the matrices from the matrix that has all the values
      mat = M(row_new:row_new + 1,index_new : index_new + 1) ;
      I(row_old,index_old) = mat(1,1);
      G(row_old,index_old) = mat(1,2); 
      R(row_old,index_old) = mat(2,1);
      B(row_old,index_old) = mat(2,2);
      index_old = index_old + 1;
      index_new = index_new + 2;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 2;
    row_old = row_old +1;
  endwhile
  image = reform_RGB(R,G,B);
endfunction

function cell = mat_to_cell(mat,k)
%Transforms a matrix to a cell of dimensions kxk
a  = size(mat, 1);
b  = size(mat, 2);
numParts = k;
c = floor(a/numParts);
d = rem(a, numParts);
partition_a = ones(1, numParts)*c;
partition_a(1:d) = partition_a(1:d)+1;
e = floor(b/numParts);
f = rem(b, numParts);
partition_b = ones(1, numParts)*e;
partition_b(1:f) = partition_b(1:f)+1;
cell = mat2cell(mat, partition_a, partition_b);
endfunction

function EME = calculate_eme(matrix,k)
  [m,n] = size(matrix);
  %Divides the matrix in mxm values
  C = mat_to_cell(matrix,floor(n/k));
  [k1,k2] = size(C);
  sum = 0.0;
  %Calculates the sum of values
  for quadrant_i = 1:k1
    for quadrant_j = 1:k2
      B = cell2mat (C(quadrant_i,quadrant_j));
      if (min(B(:)) == 0 || max(B(:)) == 0 )
       if(max(B(:)) == 0)
          %In case is 0 it gets the maximum
          value = log10(255)*20;
          sum = sum + value/(k1*k2);
        else
      %Gets the max value in case the min is 0  
      value = log10(max(B(:)))*20;
      sum = sum + value/(k1*k2);
       endif
     else
       %Calculates the normal value
       value = log10(max(B(:))/min(B(:)))*20;
      sum = sum + value/(k1*k2);
      endif
    endfor
  endfor
  sum = sum;
  EME = sum;
endfunction

function image = apply_upgrade(alpha,image)
    image = transform1(image);
    cosa = calculate_eme(image,4)
    imshow(image);
    image = alpha_root(alpha,image);
    imshow(image);
    cosa = calculate_eme(image,4)
    image = untransform1(image);
endfunction


function M = transform2(image)
  %Applies the transformation of 2*Mx3/2*N
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  %gets the new matrix to be populated
  M =0.0*(zeros(m*2,ceil(3*n/2)));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Populates the new matrix
  while row_old <= m
    while index_old <= n
      M(row_new:row_new + 1,index_new : index_new + 2)= [R(row_old,index_old) G(row_old,index_old) B(row_old,index_old + 1 ) ;
                                                         B(row_old,index_old )  R(row_old,index_old +1) G(row_old,index_old +1)];
      index_old = index_old + 2;
      index_new = index_new + 3;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 2;
    row_old = row_old +1;
  endwhile
  M = uint8(M);
endfunction

function image = untransform2(M)
  %Untransforms the matrix 
  [m_new,n_new] = size(M);
  %Creates the new matrix RGB
  R = zeros(m_new/2,floor(n_new*2/3));
  G = R;
  B = R;
  I = R;
  [m,n,rgb] = size(R);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Refills the RGBI matrices
  while row_old <= m
    while index_old <= n
      values = M(row_new:row_new + 1,index_new : index_new + 2);
      R(row_old,index_old)  = values(1,1);
      G(row_old,index_old)= values(1,2);
      B(row_old,index_old + 1 ) = values(1,3);
      B(row_old,index_old ) = values(2,1);
      R(row_old,index_old +1) = values(2,2);
      G(row_old,index_old +1) = values(2,3);
      index_old = index_old + 2;
      index_new = index_new + 3;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 2;
    row_old = row_old +1;
  endwhile
   image = reform_RGB(R,G,B);
endfunction

function M = transform3(image)
  %Tranforms the RGB matrix to  the 4*MxN
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  M =0.0*(zeros(m*4,n));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Populates the matrix with the IRGB values
  while row_old <= m
    while index_old <= n
      M(row_new:row_new + 3, index_old:index_old)= [ I(row_old,index_old ) R(row_old,index_old) G(row_old,index_old) B(row_old,index_old)];
      index_old = index_old + 1;
      index_new = index_new + 1;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 4;
    row_old = row_old +1;
  endwhile
  M = uint8(M);
endfunction


function image = untransform3(M)
  %Repopulates the RGB matrix from the 4*MxN
  [m_new,n_new] = size(M);
  R = zeros(m_new/4,n_new);
  G = R;
  B = R;
  I = R;
  [m,n,rgb] = size(R);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Repopulates the matrix
  while row_old <= m
    while index_old <= n
      value = M(row_new:row_new + 3, index_old:index_old);
      I(row_old,index_old) = value(1);
      R(row_old,index_old) = value(2);
      G(row_old,index_old) = value(3);
      B(row_old,index_old) = value(4);
      index_old = index_old + 1;
      index_new = index_new + 1;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new + 4;
    row_old = row_old +1;
  endwhile
  image = reform_RGB(R,G,B);
endfunction

function M = transform4(image)
%Transforms the  RGB matrix to the Mx4N
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  M =0.0*(zeros(m,n*4));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Populates the new matrix
  while row_old <= m
    while index_old <= n
      M(row_new:row_new , index_new:index_new + 3)= [ I(row_old,index_old ) ;R(row_old,index_old); G(row_old,index_old); B(row_old,index_old)];
      index_old = index_old + 1;
      index_new = index_new + 4;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new+1;
    row_old = row_old +1;
  endwhile
  M = uint8(M);
endfunction


function image = untransform4(M)
 %Refills the matrices with the RGB values from the Mx4N
  [m_new,n_new] = size(M);
  R = zeros(m_new,n_new/4);
  G = R;
  B = R;
  I = R;
  [m,n,rgb] = size(R);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  %Refills the RGB matrices
  while row_old <= m
    while index_old <= n
      value = M(row_new:row_new , index_new:index_new + 3);
      I(row_old,index_old) = value(1);
      R(row_old,index_old) = value(2);
      G(row_old,index_old) = value(3);
      B(row_old,index_old) = value(4);
      index_old = index_old + 1;
      index_new = index_new + 4;
    endwhile
    index_old = 1;
    index_new = 1;
    row_new = row_new+1;
    row_old = row_old +1;
  endwhile
  image = reform_RGB(R,G,B);
endfunction


function [Max,Min] = get_max_and_min(R,G,B)
  %Gets max and mins from the RGB values
  Max = [max(R) max(G) max(B)];
  Max = max(Max);
  Min = [min(R) min(G) min(B)];
  Min = min(Min);
endfunction


function CEME = calculate_ceme(image,k)
  %Calculates the Ceme values
  [R,G,B,I] = get_RGBI(image);
  [m,n] = size(R);
  %Turns the matrices to cells
  R = mat_to_cell(R,floor(n/k));
  G = mat_to_cell(G,floor(n/k));
  B = mat_to_cell(B,floor(n/k));
  [k1,k2] = size(R);
  sum = 0.0;
  for quadrant_i = 1:k1
    for quadrant_j = 1:k2
      %Gets each matrix
      R_b = cell2mat (R(quadrant_i,quadrant_j));
      G_b = cell2mat (G(quadrant_i,quadrant_j));
      B_b = cell2mat (B(quadrant_i,quadrant_j));
      %gets the max and min values
      [max_v,min_v] = get_max_and_min(R_b,G_b,B_b);
      if (min_v == 0 || max_v == 0 )
       if(max_v == 0)
          value = log10(255)*20;
          sum = sum + value/(k1*k2);
        else
       value = log10(max_v)*20;
       sum = sum + value/(k1*k2);
       endif
       else
       value = log10(max_v/min_v)*20;
      sum = sum + value/(k1*k2);
      endif
    endfor
  endfor
  CEME = sum;
endfunction

function [value] = test_transform1(image)
  %calculates and plots the values of the transform1
   imageresult_1_ceme = calculate_ceme(image,8)
   subplot(2,2,1),title("Original"),imshow(image);
   image = transform1(image);
   imageresult_2_eme = calculate_eme(image,8)
   subplot(2,2,2),title("Original Grey"),imshow(image);
   image = alpha_root(0.97,image);
   subplot(2,2,3),title("Original Grey alpha"),imshow(image);
   imageresult_2_eme2 = calculate_eme(image,8)
   image = untransform1(image);
   subplot(2,2,4),title("Original alpha"),imshow(image);
   imageresult_1_ceme2 = calculate_ceme(image,8)
endfunction


function [value] = test_transform2(image)
  %Calculates and plots the values of the transform2
   imageresult_1_ceme = calculate_ceme(image,8)
   subplot(2,2,1),title("Original"),imshow(image);
   image = transform2(image);
   imageresult_2_eme = calculate_eme(image,8)
   subplot(2,2,2),title("Original Grey"),imshow(image);
   image = alpha_root(0.97,image);
   imageresult_2_eme2 = calculate_eme(image,8)
   subplot(2,2,3),title("Original Grey alpha"),imshow(image);
   image = untransform2(image);
   subplot(2,2,4),title("Original alpha"),imshow(image);
   imageresult_1_ceme2 = calculate_ceme(image,8)
endfunction


function [value] = test_transform3(image)
  %Calculates and plots the values of the transform3
   imageresult_1_ceme = calculate_ceme(image,8)
   subplot(2,2,1),title("Original"),imshow(image);
   image = transform3(image);
   imageresult_2_eme = calculate_eme(image,8)
   subplot(2,2,2),title("Original Grey"),imshow(image);
   image = alpha_root(0.97,image);
   imageresult_2_eme2 = calculate_eme(image,8)
   subplot(2,2,3),title("Original Grey alpha"),imshow(image);
   image = untransform3(image);
   subplot(2,2,4),title("Original alpha"),imshow(image);
   imageresult_1_ceme2 = calculate_ceme(image,8)
endfunction



function [value] = test_transform4(image)
  %Calcualtes and plots the values of the transform4
   imageresult_1_ceme = calculate_ceme(image,8)
   subplot(2,2,1),title("Original"),imshow(image);
   image = transform4(image);
   imageresult_2_eme = calculate_eme(image,8)
   subplot(2,2,2),title("Original Grey"),imshow(image);
   image = alpha_root(0.97,image);
   imageresult_2_eme2 = calculate_eme(image,8)
   subplot(2,2,3),title("Original Grey alpha"),imshow(image);
   image = untransform4(image);
   subplot(2,2,4),title("Original alpha"),imshow(image);
   imageresult_1_ceme2 = calculate_ceme(image,8)
endfunction