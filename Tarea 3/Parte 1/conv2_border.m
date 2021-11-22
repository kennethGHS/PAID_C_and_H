function C=conv2_border(A,D,iter)
  %Transform the person border image to double
   D=im2double(D);
   %Get the width(n),height(m) amd channels(r) of the image 
   %of the person
   [m,n,r]=size(A);
   for i=1:iter
     %Get colors of the pixel of the image of the person
     Ar=im2double(A(:,:,1));
     Ag=im2double(A(:,:,2));
     Ab=im2double(A(:,:,3));
     k=7;
     M=(1/k^2)*ones(k);
     Cr=conv2(Ar,M); Cr=Cr(1+(k-1)/2:m+(k-1)/2,2:n+1); Cr=Cr.*D;
     Cg=conv2(Ag,M); Cg=Cg(1+(k-1)/2:m+(k-1)/2,2:n+1); Cg=Cg.*D;
     Cb=conv2(Ab,M); Cb=Cb(1+(k-1)/2:m+(k-1)/2,2:n+1); Cb=Cb.*D;
     Ar(D==1)=0;
     Ag(D==1)=0;
     Ab(D==1)=0;
     C=zeros(m,n,r);
     C(:,:,1)=Ar+Cr;
     C(:,:,2)=Ag+Cg;
     C(:,:,3)=Ab+Cb;
     A=im2uint8(C);
  endfor
 C=A;
endfunction
