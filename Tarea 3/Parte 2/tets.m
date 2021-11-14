## Copyright (C) 2021 kenne
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} tets (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: kenne <kenne@DESKTOP-RJKQE7G>
## Created: 2021-11-13

function retval = tets (image)
image1=double(image);
N=size(image1, 1);
p = 1; s = 1; alpha = 1.03;
image_signal=f_pst(image1,N,p,s);
FT2D=fft2(image1);
FT1D=fft(image_signal);
FT1Dabs=abs(FT1D);
FT1D_rooting=FT1D.*power(FT1Dabs,alpha-1);
T_ps=cyclic_group (p, s, N)+1;
for k = 1 : N
FT2D(T_ps(k,1),T_ps(k,2))=FT1D_rooting(k);
endfor;
image2=real(ifft2(FT2D));
image2(find(image2<0))=0;
retval = image2;
endfunction


%-------------------------------------------------------
function image_signal=f_pst(image1,N,p,s)
image_signal=zeros(1,N);
ks = 0;
for m = 1 : N
t = ks;
for n = 1 : N
t1 = t + 1;
image_signal(t1)=image_signal(t1)+image1(m,n);
t = mod(t + p, N);
endfor;
ks = ks + s;
endfor;
endfunction
%-------------------------------------------------------
function T_ps=cyclic_group(p,s,N)
k = 0 : (N - 1);
T_ps=zeros(N,2);
T_ps(:, 1) = mod(k*p, N);
T_ps(:, 2) = mod(k*s, N);
endfunction