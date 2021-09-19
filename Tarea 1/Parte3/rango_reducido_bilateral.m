function[Ar] = rango_reducido_bilateral(A,r,p)
  %Paso 1
  %A es una matriz de mxn, extraemos el segundo valor
  
  n= size(A,2); %columnas
  Y2 = randn(n,r);
  
  %Paso 2
  for k=1:p
    Y1 = A*Y2;
    Y2 = A'*Y1;
  endfor
  
  %Paso 3 
  [Q,~]=qr(Y2);%Y2=QR, Q es ortogonal y R es triangular superior
  
  %Paso 4
  Qr=Q(:,1:r);
  
  %Paso 5
  B= A*Qr;
  C= Qr';
  Ar=B*C;
  
endfunction