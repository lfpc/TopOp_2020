%-------------------------------------------------------------
%
%    Copyright (C) 2009 Krister Svanberg
%
%    This file, toy2.m, is part of GCMMA-MMA-code.
%    
%    GCMMA-MMA-code is free software; you can redistribute it and/or
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation; either version 3 of 
%    the License, or (at your option) any later version.
%    
%    This code is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%    
%    You should have received a copy of the GNU General Public License
%    (file COPYING) along with this file.  If not, see 
%    <http://www.gnu.org/licenses/>.
%    
%    You should have received a file README along with this file,
%    containing contact information.  If not, see
%    <http://www.smoptit.se/> or e-mail mmainfo@smoptit.se or krille@math.kth.se.
%
%------
%
%  Version September 2009.
%  This file calculates function values and gradients
%  for the following "toy problem":
%
%    minimize x(1)^2 + x(2)^2 + x(3)^2
%  subject to (x(1)-5)^2 + (x(2)-2)^2 + (x(3)-1)^2 =< 9
%             (x(1)-3)^2 + (x(2)-4)^2 + (x(3)-3)^2 =< 9
%              0 =< x(j) =< 5, for j=1,2,3.
%
function [f0val,df0dx,fval,dfdx] = toy2(x,model,index_p,len_U,constraint)


%model.sol('sol2').run();
%
U_new = zeros(len_U,1);
for i=1:length(index_p)
    U_new(index_p(i))=x(i);
end
model.sol('sol1').setU(U_new);
model.sol('sol1').createSolution;
model.sol('sol2').run();
    
obj = (mpheval(model,'sens2.iobj1','dataonly','on','dataset','dset2'));

f0val = (obj(1));
%fval  = [0.025-(abs(x(1)-x(4)))
%         0.025-(abs(x(2)-x(5)))];
%

sens_f = mphgetu(model,'Type','Fsens','soltag','sol2');
df0dx = sens_f(~isnan(sens_f));

f_constraint = [mean(mpheval(model,'sens2.iobj2','dataonly','on','dataset','dset2'))];

fval = [f_constraint(1)-constraint(1)];

model.sol('sol3').run();
sens_c1 = mphgetu(model,'Type','Fsens','soltag','sol3');

%sens_c2 = mphgetu(model,'Type','Fsens','soltag','sol4');
dfdx =[sens_c1(~isnan(sens_c1))'];

%dfdx = zeros(length(df0dx),1)';

%dfdx  = [-(x(1)-x(4))/abs((x(1)-x(4))) 0 0 (x(1)-x(4))/abs((x(1)-x(4))) 0 0 
%    0 -(x(2)-x(5))/abs((x(2)-x(5))) 0 0 (x(2)-x(5))/abs((x(2)-x(5))) 0]; 

%for i=1:length(x)
    %x_aux = x;
    %x_aux(i) = x_aux(i)+0.00001;
    %[f0val_aux,fval_aux] = toy1(x_aux,model,U);
   % df0dx(i) = (f0val_aux - f0val)/0.00001;
    %for j=0:1
    %    dfdx(2*i-1+j) = (fval_aux(j+1) - fval(j+1))/0.00001;
    %end
%end

%df0dx = [2*x(1)
	 %2*x(2)
	 %2*x(3)];
%

%
%dfdx  = 2*[x(1)-5  x(2)-2  x(3)-1
	   %x(1)-3  x(2)-4  x(3)-3];
%---------------------------------------------------------------------
