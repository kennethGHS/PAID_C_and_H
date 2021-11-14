function P2
  
c =imread("C:/Users/kenne/OneDrive/Desktop/Pag.png");
 value = transform2(c);
 imshow(untransform2(value));
     cosa = calculate_eme(value,4)
 %p = apply_upgrade(0.97,c);
 %imwrite(p,"test.png")
  endfunction

function [M] = alpha_root(alpha,Mat)
  [m,n] = size(Mat);
  value = fft2(Mat);
  angles = arg(value);
  absolutes = abs(value);
  for i = 1:m
    for j = 1:n
      absolutes(i,j) = absolutes(i,j)^alpha;
      value = absolutes(i,j)*e^(angles(i,j) * 1i);
    endfor
  endfor
  value = absolutes.*e.^(angles * 1i);
  M = uint8(abs(ifft2(value)));
endfunction

function [R,G,B,I] = get_RGBI(image)
  R = double(image(:,:,1));
  G = double(image(:,:,2));
  B = double(image(:,:,3));
  I = double(R*0.3 + B*0.11 + G*0.59); 
  
endfunction

function [image] = reform_RGB(R,G,B)
  [m,n] = size(R);
  image = uint8(cat(3,R,G,B));
endfunction

function [M] = transform1(image)
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  M =double(zeros(m*2,n*2));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
  while row_old <= m
    while index_old <= n
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
  [m_new,n_new] = size(M);
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
  imwrite(image,"image.png");

endfunction

function cell = mat_to_cell(mat,k)
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
c = size(cell)
  endfunction

function EME = calculate_eme(matrix,k)
  [m,n] = size(matrix);
  C = mat_to_cell(matrix,floor(n/k));
  [k1,k2] = size(C);
  sum = 0.0;
  for quadrant_i = 1:k1
    for quadrant_j = 1:k2
      B = cell2mat (C(quadrant_i,quadrant_j));
      if (min(B(:)) == 0 || max(B(:)) == 0 )
       if(max(B(:)) == 0)
          value = log10(255)*20;
          sum = sum + value/(k1*k2);
        else
       value = log10(max(B(:)))*20;
      sum = sum + value/(k1*k2);
       endif
       else
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
  [R,G,B,I] = get_RGBI(image);
  [m,n,rgb] = size(image);
  M =0.0*(zeros(m*2,ceil(3*n/2)));
  [m_new,n_new] = size(M);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
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
  [m_new,n_new] = size(M);
  R = zeros(m_new/2,floor(n_new*2/3));
  G = R;
  B = R;
  I = R;
  [m,n,rgb] = size(R);
  row_old = 1;
  index_old = 1;
  row_new = 1;
  index_new = 1;
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

