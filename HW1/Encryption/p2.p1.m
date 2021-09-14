
function  [M]= p1(filename,message,key,T)
   [max_i,W] = str_to_array(message);
   A = imread(filename);
   [m,n] = size(A)
    num_matrices = floor((m)/4);
    fours = 4*ones(num_matrices,1);
    C = mat2cell(A,fours ,fours);
    [m_new,n_new] = size(C); 
    i_max = max_i;
    j_max = 8;
    rand("seed",key)
    quadrant_j = 1
    already_coded = [];
    FM = C;
    finalized_coding = 0
    for quadrant_i = 1:m_new
        while quadrant_j ~= (n_new + 1)
          if finalized_coding ~=1
            i=int8 (rand(1)*i_max);
            j=int8 (rand(1)*j_max);
            temp = [i,j];
            if ismember(temp,already_coded,'rows') || i ==0 || j ==0
                if length(already_coded) == (i_max*j_max)
                   finalized_coding = 1
                   coded = quadrant_j+ n_new * quadrant_i
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
        quadrant_j = 1
    endfor
    FM = cell2mat(FM);
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