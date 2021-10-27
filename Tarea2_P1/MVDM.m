function result = MVDM(P)
  pixels = sort(P); 
  P1=pixels(1);
  P2=pixels(2);
  
  P3=pixels(3);
  if (P2 == 255)
    result=P1;
  elseif (P2 == 0)
    result=P3;
  else
    result=P2;
  endif

endfunction

