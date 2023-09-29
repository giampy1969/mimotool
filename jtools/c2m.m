function msys=c2m(csys)

% msys=c2m(csys) converts LTI system structure
% from control toolbox to mutools representations.

[a,b,c,d]=ssdata(csys);
msys=pck(a,b,c,d);
