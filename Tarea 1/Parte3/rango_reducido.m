function[Ur,Sr,Vr] = rango_reducido(A,r)
  [U,S,V]=svd(A);
  
  Ur=U(:,1:r);
  Vr=V(:,1:r);
  Sr=S(1:r,1:r);
  
  B=Ur*Sr;
  C=Vr';
  Ar=B*C;
endfunction