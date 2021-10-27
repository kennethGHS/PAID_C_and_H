 function pt2
   
   W = [0.151,0.554,0.989];
  [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image("elena.jpg", 45,W);
  m = escale((CompressedReal),255)
   Image = (abs((reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,256,256,45))));
   imwrite(uint8(floor(Image)),"Result45.jpg");
   W = [0.151,0.554,0.989];
  [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image("elena.jpg", 35,W);
   Image = (abs((reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,256,256,35))));
   imwrite(uint8(floor(Image)),"Result35.jpg");
   W = [0.151,0.554,0.989];
  [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image("elena.jpg", 40,W);
   Image = (abs((reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,256,256,40))));
   imwrite(uint8(floor(Image)),"Result40.jpg");
   W = [0.151,0.554,0.989];
  [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image("elena.jpg", 60,W);
   Image = (abs((reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,256,256,60))));
   imwrite(uint8(floor(Image)),"Result60.jpg");
   W = [0.151,0.554,0.989];
  [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image("elena.jpg", 70,W);
   Image = (abs((reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,256,256,70))));
   imwrite(uint8(floor(Image)),"Result70.jpg");
   
  endfunction

function [Image] = reverse_compression(ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag,W,m,n,T)
    %Reverse the compression of an image, it return a matrix with the imaginary values
    %ZerosCD ZerosImag and ZerosReal are the Zero matrix of each one of the real, imaginary and CD values
    %The CompressedCD CompressedImaginary and CompressedReal are the minimzed values of the image
    %The possibleValuesImag and PossibleValuesReal are the possible values the real and imaginary matrixes can take after deminimizing
    %W are the weight values, m and n are the sizes of the image and T is the cuantization value
    nonZeroCD = combine_zeros_matrix(CompressedCD,ZerosCD)
    cosa = size(nonZeroCD);
    nonZeroImag = combine_zeros_matrix(CompressedImaginary,ZerosImag);
    cosa2 = size(nonZeroImag);
    nonZeroReal = combine_zeros_matrix(CompressedReal,ZerosReal);
    image = zeros(m,n);
    mat = turn_to_mat(image);
    imaginary = deconde_into_mat(mat,nonZeroImag,PossibleValuesImag,W) ;
    reals = deconde_into_mat(mat,nonZeroReal,PossibleValuesReal,W);
    cdValues = special_resize(mat,nonZeroCD);
    
    reals = cell2mat(reals);
    imaginary = cell2mat(imaginary)*1i;
    reals = reals + cdValues;
    imaginary_real = imaginary + reals;
    complete_mat = turn_to_mat(imaginary_real*T);
    [m,n] = size(complete_mat);
   
    for quadrant_i = 1:m
      for quadrant_j = 1:n
        element = complete_mat(quadrant_i,quadrant_j);
        element = cell2mat(element);
        element = ifft2(element);
        mat(quadrant_i,quadrant_j) = mat2cell(element,[4],[4]);
      endfor
    endfor
    Image = cell2mat(mat);
    
endfunction

function [M] =  special_resize(mat,value)
  [m,n] = size(mat);
  sizes = 1;
  for quadrant_i = 1:m
      for quadrant_j = 1:n
        sizes_2 = sizes +16;
        index = 1;
        zeros_mat = zeros(4,4);
        while sizes != sizes_2
          zeros_mat(index) = value(sizes);
          sizes = sizes +1;
          index = index +1;
        endwhile
        mat(quadrant_i,quadrant_j) = mat2cell(zeros_mat,[4],[4]);
      endfor
  endfor
  M = cell2mat(mat);
endfunction

function [decoded] =  deconde_into_mat(mat,array,possibleValues,W)
  [m,n] = size(mat);
  i =1;
  decoded = mat;
  for quadrant_i = 1:m
    for quadrant_j = 1:n
      cell_norm = de_minimize_matrix([array(i) array(i+1) array(i+2) array(i+3) array(i+4) array(i+5)],W,possibleValues);
      
      i = i+6;
      cell_norm = reshape(cell_norm,4,4)';
      decoded(quadrant_i,quadrant_j) = mat2cell(cell_norm,[4],[4]);
    endfor
  endfor
endfunction

function [R,I] = get_real_imag(M)
  
  [m,n] = size(M);
  x = fft2(M);
  I = imag(x);
  R = real(x);
  
endfunction



function [R] = getUniques(M)
  [m,n] = size(M);
  R = [];
  for i = 1:m*n
    if(~isempty(R))
     if any(R ==M(i))
        continue;
      else
        R = [R M(i)];
      endif
    else
       R = [R M(i)];
    endif
    
  endfor
endfunction

function [A] = tranform_dimensions(M,m,n)
  A = [];
  j = 1;
  while ( j <= m)
    i = 1;
    row = [];
    while ( i <= n)
      row = [row M(i*j)];
      i = i+1;
    endwhile
    j = j+1;
    A = [A ; row];
  endwhile
  
endfunction
function [C,L] = minimize_matrix(M,W)
  
  L = getUniques(M);
  V = reshape(M.',1,[]);
  [s,len] = size(V);
  C = [];
  
  %its done in iterations of 3 items
  i = 1;
  
  while (i <= len)
    
    if (i + 1 > len)
      
      v = V(i)*W(1);
      C = [C v];
      break
      
    endif
 
    if (i + 2 > len)
      
      v = (V(i)*W(1) + V(i+1)*W(2));
      C = [C v];
      break
      
    endif
    
    v = V(i)*W(1) + V(i+1)*W(2) + V(i+2)*W(3);
    C = [C v];
    i = i+3;
   
  endwhile
  
endfunction

function [CD,N] = get_and_remove_cd_values(M,T)
  
  [m,n] = size(M);
  i = 1;
  CD = [];
  
  while (i<= m*n)
    
    if (M(i) > T/2)
      CD = [CD M(i)];
      M(i) = 0;
    else
      CD = [CD 0];
    endif
    
    i = i+1;
    
  endwhile
  
  N = M;
  
endfunction

function [A] = de_minimize_matrix(M,W,L)
  %M is the values to be decoded
  %W is the weights
  %L are the possible values of the pixels
  
  [n,m] = size(L);
  size_l = m*n;
  m = n*m;
  A = [];
  i = 1;
  [m,n] = size(M);
  size_values = m*n;
  while (i<=size_values)
    S1 = 1;
    S2 = 1;
    S3 = 1;
    Est = L(S1)*W(1) + L(S2)*W(2) + L(S3)*W(3);
    while ((M(i) - Est) != 0 ) 
      S3 = S3 + 1;
      
      if(S3 > size_l)
        S2 = S2+1;
        S3 = 1;
      endif
      
      if (S2> size_l)
        S1 = S1+1;
        S2 = 1;
      endif
      
      if(S1 > size_l )
        S1 = 1;
      endif
      
      Est = L(S1)*W(1) + L(S2)*W(2) + L(S3)*W(3);
    endwhile
    A = [A L(S1) L(S2) L(S3) ];
    i = i+1;
  endwhile
  [m,n] = size(A);
  A(m*n) = [];
  A(m*n -1) = [];
endfunction


function [ValueMatrix,ZeroMatrix] = separate_function(M)
  [m,n] = size(M);
  len = m*n;
  zero_count = 0;
  ZeroMatrix = [];
  ValueMatrix = [];
  for i = 1:len
    if M(i) != 0
      if zero_count == 0
          ValueMatrix = [ValueMatrix M(i)];
          ZeroMatrix = [ZeroMatrix 0];
      else
          ZeroMatrix = [ZeroMatrix zero_count 0];
          zero_count = 0;
          ValueMatrix = [ValueMatrix M(i)];
      endif
    else
      zero_count = zero_count +1;
    endif
  endfor
  if zero_count != 0
    ZeroMatrix = [ZeroMatrix zero_count];
  endif
endfunction

function [R] = combine_zeros_matrix(M,Z)
    [m,n] = size(Z);
    len = m*n;
    i = 1;
    j = 1;
    R = [];
    for i = 1:len
      if Z(i) == 0
        R = [R M(j)];
        j = j+1;
      else
        for n = 1:Z(i)
          R = [R 0];
        endfor
      endif
    endfor
endfunction

function [Mats] = turn_to_mat(M)
   [m,n] = size(M);
   num_matrices = floor((m)/4);
   fours = 4*ones(num_matrices,1);
   Mats = mat2cell(M,fours ,fours);
endfunction

function [CDMatrix,PossibleValues,HFCompressedValues]=process_and_reduce_real(M,W,T)
  [CDMatrix,M] = get_and_remove_cd_values(M,T);
  [HFCompressedValues,PossibleValues] = minimize_matrix(M,W);
endfunction

function [R] = add_to_possibles(M,A)
  [m,n] = size(A);
  R = M;
  for i = 1:(m*n)
    if any(R ==A(i))
      continue;
    else
      R = [R A(i)];
    endif
  endfor
  
endfunction

function [ZerosCD,ZerosImag,ZerosReal,CompressedImaginary,CompressedReal,CompressedCD,PossibleValuesReal,PossibleValuesImag] = compress_image(filename, T,W)
    %Compression of an image, all the necessary matrices to decode the image
    %ZerosCD ZerosImag and ZerosReal are the Zero matrix of each one of the real, imaginary and CD values
    %The CompressedCD CompressedImaginary and CompressedReal are the minimzed values of the image
    %The possibleValuesImag and PossibleValuesReal are the possible values the real and imaginary matrixes can take after deminimizing
    %W are the weight values,and T is the cuantization value
  imag = imread(filename);
  size(imag);
  Mats = turn_to_mat(imag);
  [m,n] = size(Mats);
  RealMatrix = [];
  ZerosCD = [];
  CompressedReal = [];
  ZerosReal = [];
  ZerosImag = [];
  CompressedImaginary = [];
  PossibleValuesReal = [];
  PossibleValuesImag = [];
  CompressedCD = [];
  for quadrant_i = 1:m
    for quadrant_j = 1:n
      B = cell2mat (Mats(quadrant_i,quadrant_j));
      [R,I] = get_real_imag(B);
      R = floor(R/T);
      I = floor(I/T);

      [CDMatrix,PossibleVals,HFCompressedValues] = process_and_reduce_real(R,W,T);
      %Removes zeros and creates the zeros matrix
      CompressedCD = [CompressedCD CDMatrix];
      CompressedReal = [CompressedReal HFCompressedValues ];
      PossibleValuesReal = add_to_possibles(PossibleValuesReal,PossibleVals);
      [HFCompressedValues,PossibleVals] = minimize_matrix(I,W);
      CompressedImaginary = [CompressedImaginary HFCompressedValues];
      PossibleValuesImag = add_to_possibles(PossibleValuesImag,PossibleVals);
    endfor
  endfor
  disp("NonZeroCompressedCD")
  [m,n] = size(CompressedCD)
  disp("NonZeroCompressedReal")
  [m,n] = size(CompressedReal)
  disp("NonZeroCompressedImaginary")
  [m,n] = size(CompressedImaginary)
  [CompressedCD,ZerosCD] = separate_function(CompressedCD);
  [CompressedReal,ZerosReal] = separate_function(CompressedReal);
  [CompressedImaginary,ZerosImag] = separate_function(CompressedImaginary);
endfunction


function tag=arithmetic_encode(message,problist)
  if nargin < 2
      error('Usage: arithmetic_encode(message,problist)');
  end

  Up=1;
  Lo=0;
  L_MSG=length(message);

  for itr=1:L_MSG
    Mi=message(itr);
    T1=Lo;
    T2=+(Up-Lo);
    T3=sum(problist(1:Mi)); 
    Lo=T1+T2*(T3-problist(Mi));
    Up=T1+T2*T3;
  end

  tag=0.5*(Up+Lo);
  return;
end

function message=arithmetic_decode(tag,problist,tolerance)
  if nargin < 2
    error("Usage: arithmetic_decode(tag,problist,tolerance=1e-8)");
  elseif nargin < 3
    tolerance=1e-8;
  end

  %start from the extreme extents & find the sweet-spot.
  Up=1.0;
  Lo=0.0;
  L_SYM=length(problist);

  mytag=0;
  message=[];


  while (mytag~=tag)
    % initial guess for the sweet-spot.

    %some loop-invariants.
    found=0;
    T1=Lo;
    T2=+(Up-Lo);
    
    for itr=1:L_SYM
      T3=sum(problist(1:itr));
      tL=T1+T2*(T3-problist(itr));
      tU=T1+T2*T3;

      %identify the correct spot.
      if((tL < tag) && (tag < tU))
	found=1;
	break;
      end
    end

    if(~found)
      warning("Cannot decode letter. Defaults to max symbol.\n");
    end

    Up=tU;
    Lo=tL;
    mytag=0.5*(tL+tU);
    message=[message itr]; 
    if(abs(tag-mytag)<tolerance)
      break;
    end
  end
  return;
end

function [possibility] = getPossibilityArray(M,U)
  [m,n] = size(U);
  size_u = m*n;
  [m,n] = size(M);
  size_m = m*n;
  possibility = zeros(255);
  for i = 1:size_u
    sum = 0;
    for j = 1:size_m
      if M(j) == U(i)
        sum = 1+sum;
      endif
    endfor
    possibility(U(i)) =(sum/size_m);
  endfor
endfunction
  
function [scaled] = escale(M,maxi)
  U = unique(M);
  [m,n] = size(U);
  if m == 0
    scaled = []
    return
  endif
  xmax = U(m*n)
  xmin = U(1);
  m = (maxi-1)/(xmax - xmin);
  c = maxi - xmax * m;
  scaled = floor(M*m + c);
  endfunction