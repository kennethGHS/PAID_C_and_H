function I = fast_median_filter_aprox_v2(I)
  I = ((I!=0) & (I!=255)).*I; 
  
  [x_pos,y_pos] = find((I==0)|(I==255));
  
  dirtyPositionsSize =  size(x_pos)(1);
  I_p = padarray(I, [2, 2], 0, 'both');
  
  x_pos .+= 2;
  y_pos .+= 2;
  
  for i = 1: dirtyPositionsSize
        x = x_pos(i);
        y = y_pos(i);
        window = I_p(x - 1: x + 1, y - 1 :y + 1);
        col1 = median([window(1,1) window(1,2) window(1,3)]); % Col11, Col12, Col13
        col2 = median([window(2,1) window(2,2) window(2,3)]); % Col21, Col22, Co213
        col3 = median([window(3,1) window(3,2) window(3,3)]); % Col31, Col32, Col33
        I(x-2,y-2) = median([col1 col2 col3]);
        col1 = col2; % Reasignamos el valor de la columna 1
        col2 = col3; % Reasignamos el valor de la columna 2
  endfor
endfunction

%I =  imread('./Images/SP_barbara.jpg');



%I_c = fast_median_filter_aprox_v2(I);

%imwrite (I_c, './Images/filterd_SP_barbara.jpg')