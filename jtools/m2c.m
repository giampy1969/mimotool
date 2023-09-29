function csys=m2c(msys)

% csys=m2c(msys) converts LTI system structure 
% from mutools to control toolbox representations.

[a,b,c,d]=unpck(msys);
csys=ss(a,b,c,d);
