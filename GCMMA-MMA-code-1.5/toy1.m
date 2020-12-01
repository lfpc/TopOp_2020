%-------------------------------------------------------------
%
%    Copyright (C) 2009 Krister Svanberg
%
%    This file, toy1.m, is part of GCMMA-MMA-code.
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
%
%  This file calculates function values (but no gradients)
%  for the following "toy problem":
%
%    minimize x(1)^2 + x(2)^2 + x(3)^2
%  subject to (x(1)-5)^2 + (x(2)-2)^2 + (x(3)-1)^2 =< 9
%             (x(1)-3)^2 + (x(2)-4)^2 + (x(3)-3)^2 =< 9
%              0 =< x(j) =< 5, for j=1,2,3.
%
function [f0val,fval] = toy1(x,model,index_p,len_U,constraint)


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

f_constraint = [mean(mpheval(model,'sens2.iobj2','dataonly','on','dataset','dset2'))];

fval = [f_constraint(1)-constraint(1)];
end
%
%---------------------------------------------------------------------
