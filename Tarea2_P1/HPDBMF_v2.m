function I = HPDBMF_v2(I)
  %Funcion que se encarga de realizar el High-Performance Modified Decision Based Median Filterutilizando
  % una mascara de 3x3
  %Entrada: Imagen a filtrar.
  %Salida: Imagen filtrada.

  [x_pos,y_pos] = find((I==0)|(I==255)); %Posiciones de los pixeles sucios
  
  lastCleanPixel = 0; %Ultimo pixel limpio
  
  dirtyPositionsSize =  size(x_pos)(1); %Largo de las posiciones
  
  x_pos .+= 2;
  y_pos .+= 2;
  
 
  I_p = padarray(I, [2, 2], 0, 'both'); %Aumentamos el marco de la imagen
  
  for i = 1: dirtyPositionsSize 
        x = x_pos(i);
        y = y_pos(i);
        window = I_p(x - 1: x + 1, y - 1 :y + 1);
        M1 = MVDM([window(1,1) window(1,2) window(1,3)]); % Col11, Col12, Col13
        M2 = MVDM([window(2,1) window(2,2) window(2,3)]); % Col21, Col22, Co213
        M3 = MVDM([window(3,1) window(3,2) window(3,3)]); % Col31, Col32, Col33
        medianValue = MVDM([M1 M2 M3]); % Calculamos el valor medio de las tres columnas
        if (medianValue > 0 && medianValue < 255) %Si el valor de la mediana es limpio
          I(x-2,y-2) = medianValue; %Guardamos el valor del pixel como el de la mediana
          lastCleanPixel = medianValue; %Reasignamos el valor del ultimo pixel limpio
        else
          window2 = I_p(x-2:x+2, y-2:y+2); %5x5 window
          for i2 = 1: 4; %Recorremos la ventana de 5x5
            for j2 = 1 :4;
              if (i2 == 5 && j2 == 5) %Si no se encontró un pixel limpio
                I(x-2,y-2) =  lastCleanPixel; %Asignamos al ultimo pixel limpio
              elseif( window2(i2,j2) != 255 && window2(i2,j2) != 0) %Si el pixel esta limpio
                I(x-2,y-2) =  window2(i2,j2); %Lo asignamos a la imagen final
              endif
            endfor
          endfor
        endif
  endfor
endfunction

