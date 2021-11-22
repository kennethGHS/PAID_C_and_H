function C=image_background(A,B)
   [m,n,r]=size(A);
   C1=uint8(zeros(m,n,r));
   C2=uint8(zeros(m,n,r));
   mask1=((A(:, :, 1)<100) & (A(:, :, 2)>=125) & (A(:, :, 3)<100));
   mask2=-mask1+1;
   %%%Original
   C1(:,:,1)=mask2.*A(:, :, 1);
   C1(:,:,2)=mask2.*A(:, :, 2);
   C1(:,:,3)=mask2.*A(:, :, 3);
   %%%Fondo
   C2(:,:,1)=mask1.*B(:, :, 1);
   C2(:,:,2)=mask1.*B(:, :, 2);
   C2(:,:,3)=mask1.*B(:, :, 3);
   %Final
   C=C1+C2;
endfunction