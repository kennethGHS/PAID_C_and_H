clc;
clear;
close all;

total_per = 40; % Cantidad de personas en la BD
S = []; % Esta matriz va a tener todas las imagenes de la BD

tic
% En este ciclo se almacenan las imagenes en el vector S 
for i = 1:total_per
  filename_i = ['Database\' num2str(i) '_'];
  for j = 1:9
      filename_j = [filename_i num2str(j) '.png'];
      f_i = im2double(imread(filename_j));
      S = [S f_i(:)]; % Se agrega la imagen en forma vectorialA
  endfor
endfor

%Se procede a calcular la cara promedio de las imágenes de la BD
total_im = size(S)(2); % Se extrae el valor 2 del size de S, es decir, 
                       % las columnas las cuales corresponden a las
                       % imágenes 
f = 0; # Variable para guardar la sumatoria de las imagenes
for i = 1:total_im
  f_i = S(:, i); # Se obtiene la imagen "i"
  f = f + f_i;
endfor
f = f/total_im; # Se calcula la cara promedio

% Construccion de la matriz A, esta tiene el resultado de restarle a 
% cada cara la cara promedio
A = zeros(size(S));
for i = 1:total_im
  f_i = S(:, i); # Se obtiene la imagen "i"
  A(:, i) = f_i - f; # Se realiza la resta de la cara promedio
endfor

% Se calcula un vector "x" para cada imagen, este vector representa la
% posicion de cada cara en el espacio de caras
r = rank(A);
p=2;%Se utiliza un valor de p=2 para el algoritmo de rango reducido bilateral
[Ar]=rango_reducido_bilateral(A,r,p);
[U,S_Ar,V]=svd(Ar);
A=Ar;
x = zeros([r total_im]);
for i = 1:total_im
  x_i = U(:, 1:r)' * A(:, i);
  x(:, i) = x_i;
endfor

el = 10; % Maxima distancia en el espacio de caras

% Se lee la imagen del rostro que se quiere reconocer
numero_imagen = 31;
imagen = imread(['Comparar\' num2str(numero_imagen) '_10.png']);

subplot(1, 2, 1);
imshow(imagen)
title('Persona a identificar');

% Vectorizacion de la imagen del rostro que se busca reconocer
imagen = im2double(imagen)(:);

x1 = U(:, 1:r)' * (imagen - f); % Se calcula el vector coordenado
fp = U(:, 1:r) * x1; % Se calcula el vector de proyeccion
ef = norm((imagen - f) - fp); % Se calcula la distancia al espacio de caras

if ef > el %Si se cumple significa que no es una cara
  B = 0;
else % Si ef < el la imagenes es una cara  
  e = [];
  [m, n] = size(x);
  % Se realiza la comparacion de la imagen ingresada con cada imagen del espacio de caras
  for i = 1:n 
    x_i = x(:, i); % Distancia al espacio de caras de la imagen "i" 
    e_i = norm(x1 - x_i); % Se utiliza la norma para comparar
    e = [e e_i]; % Se almacena el resultado de la comparacion
  endfor  
  % Se obtiene la imagen que tuvo la mayor similitud con la cara ingresada
  % Se busca el resultado que tenga la menor norma, es decir, la menor diferencia
  [val, pos] = min(e);
  B = reshape(S(:, pos), [112 92]); % Se restauran las dimensiones de la imagen
endif  

% Plot de la coincidencia obtenida
subplot(1, 2, 2);
imshow(B);
title('Persona identificada');

tiempo_total=toc