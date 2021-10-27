function result = filtros(I,algorithm)
  %Función que se encarga de llamar respectivamente al algoritmo seleccionado.
  %Los algoritmos son FMFA y HPDBMF
  %Entradas: -La imagen a filtrarVideos
  %          -El algoritmo seleccionado
  %Salidas: El resultado del filtrado.
  if(algorithm == 1) 
    result = fast_median_filter_aprox_v2(I);
  elseif(algorithm == 2) 
    result = HPDBMF_v2(I);
  endif
endfunction




