function [gap,g,X,F]=sclgap(sclv,G,w,X,F)

% [gap,g,X,F]=sclgap(sclv,G,w,X,F); 
% performs scaling of G system according to the vector 10^sclv and
% returns gap in dB between max and min sv for w = 0.05 in scaled system.

% by Giampiero Campa 25-aug-95

[z1,z2]=size(G);
ns=G(1,z2);no=z1-ns-1;ni=z2-ns-1;

n=length(sclv);
sclv=(10.*ones(n,1)).^sclv;
ssc=sclio(G,sclv(1:no),sclv(no+1:n));

[A,B,C,D]=unpck(ssc);
Gs=C*inv(sqrt(-1)*w*eye(size(A))-A)*B+D;
[U,S,V]=svd(Gs);

gap=20*log10(max(diag(S))/min(diag(S)));
g=-max(diag(S));

% "saving" of current minimum in case of any errors occurrence.
fc=max(max(g),0)*1e5+gap;
if isfinite(fc) & fc < F,
F=fc;X=sclv;
end


