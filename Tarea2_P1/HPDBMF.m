clc; %limpiar consola
clear;%limpiamos variables
close all; %Cierra todas las figuras


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


function I_f = HPDBMF_V2(I)
  % Función para realizar la aproximación del filtro rapido de promedio con el 
  % fin de quitar el ruido sal y pimienta de una imagen
  % Entradas - I: imagen con ruido sal y pimienta
  % Salidas - I_f: imagen filtrada por FMFA
  I = padarray(I, [2, 2], 0, 'both');
  [H W k] = size(I); % Obtenemos las dimensiones de la imagen
  I_f = uint8(zeros(H - 2,W - 2)); % Creamos la imagen final
  lastCleanPixel = 127;
  for i=3: (H - 2) % Recorremos las filas de la imagen Z = padarray(Z, [2, 2], 0, 'both');
    for j=3: (W - 2)  %  Recorremos las columnas de la imagen
        window = I(i-1:i+1, j-1:j+1);
        if (I(i,j) > 0 && I(i,j) < 255)
            I_f(i-2,j-2) = I(i,j);
        else
          M1 = MVDM([window(1,1) window(1,2) window(1,3)]); % Col11, Col12, Col13
          M2 = MVDM([window(2,1) window(2,2) window(2,3)]); % Col21, Col22, Co213
          M3 = MVDM([window(3,1) window(3,2) window(3,3)]); % Col31, Col32, Col33
          medianValue = MVDM([M1 M2 M3], 3); % Calculamos el valor medio de las tres columnas
          if (medianValue > 0 || medianValue < 255)
            I_f(i-2,j-2) = medianValue;
            lastCleanPixel = medianValue;
          else
            window2 = I(i-2:i+2, j-2:j+2); %5x5 window
            for i2 = 0: 4;
              for j2 = 0:4;
                if (i == 5 && j == 5)
                  I_f(i-2,j-2) =  lastCleanPixel;
                elseif( window2(i,j) != 255 && window2(i,j) != 0)
                  I_f(i-2,j-2) =  window2(i,j);
                endif
              endfor
            endfor
          endif
          
          I_f(i,j) =  medianValue;
         endif
      endfor
    endfor  
endfunction



%I =  imread('./Images/SP_barbara.jpg');

%I_c = HPDBMF_V2(I);

%imwrite (I_c, './Images/HPDBMF_filterd_SP_barbara.jpg');

