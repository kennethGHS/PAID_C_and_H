clc;
clear;
close all;

function [random_str] = generate_random_str(sLength,key)
  %Generates a random message to be encoded into a picture
  s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  numRands = length(s);
  randn("seed",key)
  random_str = "";
  for i = 1:sLength
    random_str= strcat  (random_str,s(floor(mod(abs(randn(1,sLength)*numRands),numRands )) + 1));
  endfor
endfunction

function [len,W] = str_to_array(str)
  %Transforms a message of string into a binary message
    W = [];
    l = length(str);
    len = l;
    for i = 1:l
        num = abs(str(i) - '0');
        W = [W;dec2bin(num,8)];
    endfor
    [n,m] = size(W);
end 

function [M]= build_binary(m_messages)
  %Build a matrix for the binary message 
   M = [];
   for i = 1:m_messages
     M = [M;dec2bin(0,8)];
   endfor
  
end


function R = calculate_error(M,W)
  %Calculates the difference between the M and W messages in binary
  [n1,n2] = size(W);
  count = 0;
  for i = 1:n1
    for j = 1:n2
      v1 = hex2dec (M(i,j));
      v2 = hex2dec (W(i,j));
      count = (not(xor(v1,v2))) + count;
    endfor
  endfor
  R = 100 - count*100/(n1*n2)  ;
endfunction


function [M] = decode_array(WB,key,T,n_message,m_message)
  %Decodes the message from a picture
  %Arguments
  %WB is the picture array with the message
  %key is the key for the random generator
  %n_message and m_message is the size of the message
    num_matrices = floor(n_message * m_message/4);
    [WBN,WBM] = size(WB);
    fours = 4*ones(WBM/4,1);
    already_coded = [];
    C = mat2cell(WB,fours ,fours);
    %Build an ampty message to fill it up with the decoded one
    M = build_binary(n_message);
    randn("seed",key)
    i_max = n_message;
    j_max = m_message;
    [m_new,n_new] = size(C);
    finalized_coding = 0;
    quadrant_j = 1;
    #Generates a list of random coordinates
    coords = generate_random_coordinates(n_message,m_message);
    for quadrant_i = 1:m_new
        while quadrant_j ~= (n_new + 1)
           if finalized_coding ~=1
            [i_max,j_max] = size(coords);
            if i_max == 0 || j_max == 0
               finalized_coding = 1;
               continue;
            endif
            %Selects a random index for the coordinates
            index = uint8(mod(abs(randn(1)*i_max),i_max));
            if index == 0
              continue
            endif
            i = coords(index,:);
            coords(index,:) = [];
            %Decodes the picture 
                B = cell2mat (C(quadrant_i,quadrant_j));
                [U,S,V] = svd(B);
                if (S(6) - S(11)) > T/2
                    M(i(1),i(2)) = dec2bin(1);
                else
                    M(i(1),i(2)) = dec2bin(0);
                end
                quadrant_j = quadrant_j + 1;
            else
                quadrant_j = quadrant_j + 1;
            end
        endwhile
        quadrant_j = 1;
    endfor
end

function [coord] = generate_random_coordinates(n,m)
  %Generates a array of coordinates
  coord = [];
   for i = 1:n
      for j = 1:m
          coord = [coord ;[i j]];
      endfor
   endfor
endfunction

function MSE = calculate_error_image(M,W)
  %Calculates the MSE between two pictures M and W
    [n,m] = size(M);
    M = double(M);
    W = double(W);
    sum = 0.0;
    for i = 1:n
      for j = 1:m
        sum = sum + abs((M(i,j)-W(i,j)))^2;
        if (M(i,j)-W(i,j)) != 0
          l = abs((M(i,j)-W(i,j)))^2;
        endif
      endfor
    endfor
    MSE = sum/(n*m);
endfunction


message = generate_random_str(90,3);
[lenght_binary, binary_message] = str_to_array(message);
[n,m] = size(binary_message);
load ("barbara_encriptada.mat");
load ("barbara_original.mat");
F = decode_array(A_Stego*255,3,0.05*255,n,m);
Image_error = calculate_error_image(A_Stego*255,Ar*255)
Error_Message = 100 - calculate_error(binary_message,F)

