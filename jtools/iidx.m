function [f,g]=iidx(c,x,y,k)

% [f,g]=iidx(c,x,y,k);
% returns the square error between y and p(c,x)
% where  p(x) = c(1)*x.^n + c(2)*x.^(n-1) + ... + c(n+1)*x.^(0)
% this function should be used like this with the "constr" function. 

% G. Campa 24-2-96.

p=zeros(size(x));
n=length(c)-1;

for i=1:n+1;
p=p+c(i)*x.^(n+1-i+k);
end

f=sum((y-p).^2);
g=-1;
