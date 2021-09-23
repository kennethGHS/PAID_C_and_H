clc;
clear;
close all;

% Este archivo genera el "espacio de caras" utilizado para comparar

total_per = 43; % Total de personas
S = []; % Training set

tic
% Carga de las imagenes
for i = 1:total_per
  % Por cada persona se tienen nueve imagenes
  filename_i = ['Database\' num2str(i) '_'];
  for j = 1:9
      filename_j = [filename_i num2str(j) '.png'];
      f_i = im2double(imread(filename_j));
      S = [S f_i(:)]; % Se agrega la imagen en forma vectorialA
  endfor
endfor

% Se calcula la cara promedio del training set
total_im = size(S)(2); % Total de imagenes 
f = 0; # Variable para guardar la sumatoria de las imagenes
for i = 1:total_im
  f_i = S(:, i); # Se obtiene la imagen "i"
  f = f + f_i;
endfor
f = f/total_im; # Se obtiene el promedio

% Construccion de la matriz A, cada una de las columnas es una imagen
% a la que se le ha restado la cara promedio
A = zeros(size(S));
for i = 1:total_im
  f_i = S(:, i); # Se obtiene la imagen "i"
  A(:, i) = f_i - f; # Se realiza la resta de la cara promedio
endfor

% Descomposicion de la matriz A en valores singulares
r = rank(A);
[U, S_A, V] = rango_reducido(A,r);

% Se calcula un vector "x" para cada imagen, este vector representa la
% posicion de cada cara en el espacio de caras
x = zeros([r total_im]);
for i = 1:total_im
  x_i = U(:, 1:r)' * A(:, i);
  x(:, i) = x_i;
endfor

el = 10; % Maxima distancia en el espacio de caras
e0 = 3.8780; % Maxima distancia de cualquier cara conocida en el espacio

% Este archivo utiliza el espacio de caras generado por parte3.m para
% realizar una comparacion entre una cara ingresada con las almacenadas
% en el espacio de caras

% Lectura de la imagen
numero_imagen = 42;
imagen = imread(['Comparar\' num2str(numero_imagen) '_10.png']);

% Plot del rostro ingresado
subplot(1, 2, 1);
imshow(imagen)
title('Imagen ingresada');

% Vectorizacion de la imagen
imagen = im2double(imagen)(:);

x1 = U(:, 1:r)' * (imagen - f); % Se calcula el vector coordenado
fp = U(:, 1:r) * x1; % Se calcula el vector de proyeccion
ef = norm((imagen - f) - fp); % Se calcula la distancia al espacio de caras

% Si ef > el la imagen ingresada no es una cara
if ef > el
  Y = 0 % Y = 0 significa que no es una cara
  B = 0;
else % Si ef < el la imagenes es una cara  
  Y = 1 % Y = 1 significa que es una cara
  e = [];
  [m, n] = size(x);
  % Se realiza la comparacion con cada imagen del espacio de caras
  for i = 1:n 
    x_i = x(:, i); % Distancia al espacio de caras de la imagen "i" 
    e_i = norm(x1 - x_i); % Se utiliza la norma para comparar
    e = [e e_i]; % Se almacena el resultado de la comparacion
  endfor  
  % Se obtiene la imagen que tuvo la mayor similitud con la cara ingresada
  % Se busca el resultado que tenga la menor norma
  [val, pos] = min(e);
  B = reshape(S(:, pos), [112 92]); % Se restauran las dimensiones de la imagen
endif  

% Plot de la coincidencia obtenida
subplot(1, 2, 2);
imshow(B);
title('Coincidencia obtenida');

tiempo_total=toc