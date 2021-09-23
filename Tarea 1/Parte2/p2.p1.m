clc;
clear;
close all;

function  [M,n_message,m_message]= p1(filename,message,key,T)
  %Method that encodes a message into a picture
  %Arguments
  %Filename: name of the image
  %message: Message to be encoded
  %Key: key for the random generator
  %Threshold: Used for the codification of the bitand
  %Returns: Picture encoded and the size of the message in binary 
   [max_i,W] = str_to_array(message);
   A = imread(filename);
   [m,n] = size(A);
    num_matrices = floor((m)/4);
    fours = 4*ones(num_matrices,1);
    C = mat2cell(A,fours ,fours);
    [m_new,n_new] = size(C); 
    [n_message,m_message] =size(W); 
    i_max = max_i;
    j_max = 8;
    %generates random coordinates array
    coords = generate_random_coordinates(max_i,j_max);
    randn("seed",key)
    quadrant_j = 1;
    already_coded = [];
    FM = C;
    finalized_coding = 0;
    %Moves trought the binary message
    for quadrant_i = 1:m_new
        while quadrant_j ~= (n_new + 1)
          if finalized_coding ~=1
            [i_max,j_max] = size(coords);
            if i_max == 0 || j_max == 0
               finalized_coding = 1;
               continue;
            endif
            index = uint8(mod(abs(randn(1)*i_max),i_max));
            if index == 0
              continue
            endif
            i = coords(index,:);
            coords(index,:) = [];
            value = bin2dec(W(i(1),i(2)));
            B = cell2mat (C(quadrant_i,quadrant_j));
            [U,S,V] = svd(B);
            %Encodes the bit
            if (value == 1)
                if (S(11) > (S(6) - S(11)))
                    S(16) =  (S(6) - S(11));
                else
                    S(16) = 0;
                end
                S(6) = S(6) + T;
            endif
            if S(11) < S(16)
                S(11) = S(16);
            endif
            %Reconstructs fro the USV
            WB = U*S*V';
            FM(quadrant_i,quadrant_j) = WB;
            quadrant_j = quadrant_j + 1;
          else
            FM(quadrant_i,quadrant_j) = C(quadrant_i,quadrant_j);
            quadrant_j = quadrant_j + 1;
          end
        endwhile
        quadrant_j = 1;
    endfor
    FM = cell2mat(FM);
    M = FM;
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


function [coord] = generate_random_coordinates(n,m)
  %Generates a array of coordinates
  coord = [];
   for i = 1:n
      for j = 1:m
          coord = [coord ;[i j]];
      endfor
   endfor
endfunction

message = generate_random_str(30,1);
[M,n_message,m_message] = p1("elena.jpg",message,1,30);
image = imread("elena.jpg");
subplot(1,2,1), imshow(image);
subplot(1,2,2), imshow(uint8(M));