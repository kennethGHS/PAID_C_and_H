clc;
clear;
close all;

function  [M,n_message,m_message]= p1(filename,message,key,T)
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
    randn("seed",key)
    quadrant_j = 1;
    already_coded = [];
    FM = C;
    finalized_coding = 0
    for quadrant_i = 1:m_new
        while quadrant_j ~= (n_new + 1)
          if finalized_coding ~=1
            i=int8 (abs(randn(1)*i_max));
            j=int8 (abs(randn(1)*j_max));
            temp = [i,j];
            if ismember(temp,already_coded,'rows') || i ==0 || j ==0 || i >i_max || j > j_max
                if length(already_coded) == (i_max*j_max)
                   finalized_coding = 1
                endif
                continue;
            endif
            already_coded = [already_coded ; temp];
            value = bin2dec(W(i,j));
            B = cell2mat (C(quadrant_i,quadrant_j));
            [U,S,V] = svd(B);
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
    W = []
    l = length(str);
    len = l
    for i = 1:l
        num = abs(str(i) - '0');
        W = [W;dec2bin(num,8)];
    endfor
    [n,m] = size(W);
end 

function [M]= build_binary(m_messages)
   M = []
   for i = 1:m_messages
     M = [M;dec2bin(0,8)];
   endfor
  
end

function [M] = decode_array(WB,key,T,n_message,m_message)
    num_matrices = floor(n_message * m_message/4);
    [WBN,WBM] = size(WB);
    fours = 4*ones(WBM/4,1);
    already_coded = [];
    C = mat2cell(WB,fours ,fours);
    M = build_binary(m_message);
    randn("seed",key)
    i_max = n_message;
    j_max = m_message;
    [m_new,n_new] = size(C);
    finalized_coding = 0;
    quadrant_j = 1;
    for quadrant_i = 1:m_new
        while quadrant_j ~= (n_new + 1)
            i=int8 (abs(randn(1)*i_max));
            j=int8 (abs(randn(1)*j_max));
            temp = [i,j];
            if finalized_coding ~=1
                if ismember(temp,already_coded,'rows') || i ==0 || j ==0 || i >i_max || j > j_max
                    if length(already_coded) == (i_max*j_max)
                        finalized_coding = 1;
                    endif
                    continue;
                endif
                already_coded = [already_coded ; temp];
                B = cell2mat (C(quadrant_i,quadrant_j));
                [U,S,V] = svd(B);
                if (S(6) - S(11)) > T/2
                    M(i,j) = dec2bin(1);
                else
                    M(i,j) = dec2bin(0);
                end
                quadrant_j = quadrant_j + 1;
            else
                quadrant_j = quadrant_j + 1;
            end
        endwhile
        quadrant_j = 1;
    endfor
end

function R = calculate_error(M,W)
  [n1,n2] = size(W);
  count = 0;
  for i = 1:n1
    for j = 1:n2
      v1 = hex2dec (M(i,j));
      v2 = hex2dec (W(i,j));
      count = (not(xor(v1,v2))) + count;
    endfor
  endfor
  R = count*100/(n1*n2)  ;
endfunction

function MSE = calculate_error_image(M,W)
    [n,m] = size(M)
    M = double(M);
    W = double(W);
    sum = 0.0
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

function [random_str] = generate_random_str(sLength,key)
  s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  numRands = length(s);
  randn("seed",key)
  random_str = "";
  for i = 1:sLength
    random_str= strcat  (random_str,s(floor(mod(abs(randn(1,sLength)*numRands),numRands )) + 1));
  endfor
endfunction

function [T,ErrorMessage,ErrorPicture] = generateDiagramsError()
  T = [5,7.5,10,12.5,15,17.5,20,22.5,25,27.5,30,32.5,35,37.5,40];
  n2 = length(T);
  message = generate_random_str(10,1);
  [k,message_bin] = str_to_array(message);
  ErrorMessage = [];
  ErrorPicture = [];
  for i = 1:n2
    [M,n2,m] = p1("elena.jpg",message,1,T(i));
     F = decode_array(M,1,T(i),n2,m);
     c=calculate_error(message_bin,F);
     I = imread("elena.jpg");
     MSE = calculate_error_image(I,M);
     ErrorMessage= [ErrorMessage c];
     ErrorPicture = [ErrorPicture MSE];
  endfor
  plot(T,ErrorMessage,"*",T,ErrorPicture,"-");
  xlabel("Threshold");
  ylabel("Errors");
  legend("Error of decoding", "MSE of pictures");
  title("Errors of decoding and encoding")
endfunction
  
generateDiagramsError()
