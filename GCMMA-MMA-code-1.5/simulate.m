model.physics('sens').feature('cvar1').set('initialValue', 1);
%model.physics('sens').feature('cvar2').set('initialValue', 1);
%model.physics('sens').feature('cvar3').set('initialValue', 1);
model.physics('sens2').feature('cvar1').set('initialValue', 0);
%model.physics('sens2').feature('cvar2').set('initialValue', 0);
%model.physics('sens2').feature('cvar3').set('initialValue', 0);
model.sol('sol1').run();
index_p = find(model.sol('sol1').getU());
len_U = length(model.sol('sol1').getU());
len_p = length(index_p);
model.physics('sens2').feature('cvar1').set('initialValue', 'p');
%model.physics('sens2').feature('cvar2').set('initialValue', 'p_Br_aux');
%model.physics('sens2').feature('cvar3').set('initialValue', 'theta_Br_aux');

gctoyinit;

model.param.set('psimp',p_simp);
%model.param.set('r_filter_ur',r_filter_ur);
%model.param.set('r_filter_Br',r_filter_Br);
model.param.set('beta',beta);

live_plot = 1;

constraint = [0.15 0.016272 0.043463];
beta_jump = 100;

gctoymain;

B = 0.0064289/(f0val)

for i=1:len_p
if xval(i) > 0.5
xval(i) = 1;
else
xval(i) = 0;
end
end
p_simp = p_simp+1;
model.param.set('psimp',p_simp);
gctoymain;


for r=1:2
   p_simp=p_simp+2;
   model.param.set('psimp',p_simp);
   

   beta = 2*beta;
   
   gctoymain;
   B = 0.0064289/(f0val);
   kkttol = kkttol*0.75;
end
