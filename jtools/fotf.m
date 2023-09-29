function [sout,sinv]=fotf(z,p,k,size)

% [sout,sinv]=fotf(z,p,k,size); first order transfer function
% with 10^z, 10^p =zero & pole positions,
% if z <= p then k=20*log10(G(s=inf)) otherwise k=20*log10(G(s=0)).
% The final result is a square diagonal system with output and input
% as specified in size, and with the selected transfer function
% in each channel.
% sinv is the realization of the inverse of sout.

% by Giampiero Campa 13/aug/95

p=10^p;
z=10^z;
k=10^(k/20);

if z==inf,  ki=k*p;
elseif p<z, ki=k*p/z;
else        ki=k;
end

sout=[];[A,B,C,D]=zp2ss(-z,-p,ki);
for n=1:size,sout=daug(sout,pck(A,B,C,D));end

sinv=[];
if nargout>1 & z<inf
  [a,b,c,d]=zp2ss(-p,-z,1/ki);
  for n=1:size,sinv=daug(sinv,pck(a,b,c,d));end
end
