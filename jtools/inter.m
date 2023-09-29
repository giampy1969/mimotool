% this is an m file for finding the interpolating polinomial coefficients
% of the curve y(x), n is the degree of the curve.  
% Es: x=1:10; y=x.^2; n=2; inter
% the function iidx is used.

% G. Campa 24-2-96.

if (~exist('y'))|(~exist('x'))|(~exist('n')),
error('You should put in y(x) the function and in n the degree');
end

% k is the exponent of the last term (default = 0)
% if is nonzero then the terms with exponent < k are considered 0
k=0;

c0=zeros(n+1,1);

options=[];
options(2)=1e-6;
options(3)=1e-6;
options(14)=200*length(c0);

c=constr('iidx',c0,options,[],[],[],x,y,k)

p=zeros(size(x));
for i=1:n+1;p=p+c(i)*x.^(n+1-i+k);end
figure;plot(x,y,'b',x,p,'r');grid

