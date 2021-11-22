function C=binary_image(A)
   [m,n,r]=size(A);
   mask=((A(:, :, 1)>=100) | (A(:, :, 2)<150) | (A(:, :, 3)>=100));
   C=mask;
endfunction