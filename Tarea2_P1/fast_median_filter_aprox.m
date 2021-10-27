clc; %limpiar consola
clear;%limpiamos variables
close all; %Cierra todas las figuras




function I_f = fast_median_filter_aprox(I)
  % Función para realizar la aproximación del filtro rapido de promedio con el 
  % fin de quitar el ruido sal y pimienta de una imagen
  % Entradas - I: imagen con ruido sal y pimienta
  % Salidas - I_f: imagen filtrada por FMFA
  [H W k] = size(I); % Obtenemos las dimensiones de la imagen
  I_f = uint8(zeros(H,W, k)); % Creamos la imagen final
  for c=1:k % Recorremos los canales de la imagen
    for i=2: H-1 % Recorremos las filas de la imagen
      col1 = median([I(i-1, 1,c) I(i, 1,c) I(i+1, 1,c)]); % Extraemos el valor medio de la columna 1
      col2 = median([I(i-1, 2,c) I(i, 2,c) I(i+1, 2,c)]); % Extraemos el valor medio de la columna 2
      for j=3:W - 1  %  Recorremos las columnas de la imagen
        col3 = median([I(i-1,j,c) I(i,j,c) I(i+1, j,c)]); % Extraemos el valor medio de la columna 3
        I_f(i,j-1, c) = median([col1 col2 col3]); % Calculamos el valor medio de las tres columnas
        col1 = col2; % Reasignamos el valor de la columna 1
        col2 = col3; % Reasignamos el valor de la columna 2
      endfor
    endfor
  endfor
endfunction




I =  imread('./Images/SP_barbara.jpg');

I_c = fast_median_filter_aprox(I);

imwrite (I_c, './Images/filterd_SP_barbara.jpg')

