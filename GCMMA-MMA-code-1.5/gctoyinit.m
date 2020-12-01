%-------------------------------------------------------------
%
%    Copyright (C) 2009 Krister Svanberg
%
%    This file, gctoyinit.m, is part of GCMMA-MMA-code.
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
%  Some parameters and the starting point are defined
%  for the "toy problem":
%    minimize x(1)^2 + x(2)^2 + x(3)^2
%  subject to (x(1)-5)^2 + (x(2)-2)^2 + (x(3)-1)^2 =< 9
%             (x(1)-3)^2 + (x(2)-4)^2 + (x(3)-3)^2 =< 9
%              0 =< x(j) =< 5, for j=1,2,3.
%
%
%      Minimize  f_0(x) + a_0*z + sum( c_i*y_i + 0.5*d_i*(y_i)^2 )
%    subject to  f_i(x) - a_i*z - y_i <= 0,  i = 1,...,m
%                xmin_j <= x_j <= xmax_j,    j = 1,...,n
%                z >= 0,   y_i >= 0,         i = 1,...,m
%*** INPUT:
%
%   m    = The number of general constraints.
%   n    = The number of variables x_j.
%  iter  = Current iteration number ( =1 the first time mmasub is called).
%  xval  = Column vector with the current values of the variables x_j.
%  xmin  = Column vector with the lower bounds for the variables x_j.
%  xmax  = Column vector with the upper bounds for the variables x_j.
%  xold1 = xval, one iteration ago (provided that iter>1).
%  xold2 = xval, two iterations ago (provided that iter>2).
%  f0val = The value of the objective function f_0 at xval.
%  df0dx = Column vector with the derivatives of the objective function
%          f_0 with respect to the variables x_j, calculated at xval.
%  fval  = Column vector with the values of the constraint functions f_i,
%          calculated at xval.
%  dfdx  = (m x n)-matrix with the derivatives of the constraint functions
%          f_i with respect to the variables x_j, calculated at xval.
%          dfdx(i,j) = the derivative of f_i with respect to x_j.
%  low   = Column vector with the lower asymptotes from the previous
%          iteration (provided that iter>1).
%  upp   = Column vector with the upper asymptotes from the previous
%          iteration (provided that iter>1).
%  a0    = The constants a_0 in the term a_0*z.
%  a     = Column vector with the constants a_i in the terms a_i*z.
%  c     = Column vector with the constants c_i in the terms c_i*y_i.
%  d     = Column vector with the constants d_i in the terms 0.5*d_i*(y_i)^2.
%     
%*** OUTPUT:
%
%  xmma  = Column vector with the optimal values of the variables x_j
%          in the current MMA subproblem.
%  ymma  = Column vector with the optimal values of the variables y_i
%          in the current MMA subproblem.
%  zmma  = Scalar with the optimal value of the variable z
%          in the current MMA subproblem.
%  lam   = Lagrange multipliers for the m general MMA constraints.
%  xsi   = Lagrange multipliers for the n constraints alfa_j - x_j <= 0.
%  eta   = Lagrange multipliers for the n constraints x_j - beta_j <= 0.
%   mu   = Lagrange multipliers for the m constraints -y_i <= 0.
%  zet   = Lagrange multiplier for the single constraint -z <= 0.
%   s    = Slack variables for the m general MMA constraints.
%  low   = Column vector with the lower asymptotes, calculated and used
%          in the current MMA subproblem.
%  upp   = Column vector with the upper asymptotes, calculated and used
%          in the current MMA subproblem.
%
%epsimin = sqrt(m+n)*10^(-9);

beta = 6; %projection constant
p_simp = 3; %density interpolation constant
r_filter_ur = 5E-3; %helmhotz filter radius (can get in function of h)
r_filter_Br = 0;

n_blocks = 0;
m = 1;
n = len_p + 3*n_blocks;
epsimin = 0.0000001;
xval    = (0.25)*ones(len_p,1);
xold1   = xval;
xold2   = xval;
xmin    =  zeros(len_p,1);%[(-0.2)  0.07  -pi/2 (-0.2) 0.07 -pi/2]';
xmax    =  ones(len_p,1);%[0.3  0.3  pi/2 0.3 0.3 pi/2]';
low     = xmin;
upp     = xmax;
c       = 1000*ones(m,1);%[1000  1000]';
d       = ones(m,1);%[1  1]';
a0      = 1;
a       = zeros(m,1);%[0  0]';
raa0    = 0.01;
raa     = 0.01*ones(m,1);%[1  1]';
raa0eps = 0.000001;
raaeps  = 0.000001*ones(m,1);%[1  1]';
outeriter = 0;
maxoutit  = 70;
minoutit = 20;
kkttol  = 1E-4;
%
%---------------------------------------------------------------------
