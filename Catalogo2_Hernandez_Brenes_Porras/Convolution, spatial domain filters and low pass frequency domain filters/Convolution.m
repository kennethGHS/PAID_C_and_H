function convolution = Convolution(x,y,type_convolution)
  [m1,n1]=size(x);
  [m2,n2]=size(y);

  %Convolution calculation
  if (type_convolution=='full')
    convolution=zeros(m1+m2-1,n1+n2-1);
    for j = 1:m1+m2-1
      for k = 1:n1+n2-1
        for p = max([1,j-m2+1]):min([j,m1])
          for q = max([1,k-n2+1]):min([k,n1])
            convolution(j,k)= convolution(j,k)+x(p,q)*y(j-p+1,k-q+1);
          endfor
        endfor
      endfor
    endfor
  else
    convolution=zeros(m1,n1);
    for j = 1:m1
      for k = 1:n1
        for p = max([1,j-m2+1]):min([j,m1])
          for q = max([1,k-n2+1]):min([k,n1])
            convolution(j,k)= convolution(j,k)+x(p,q)*y(j-p+1,k-q+1);
          endfor
        endfor
      endfor
    endfor
  endif
endfunction