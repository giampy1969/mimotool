function [Tr,Ts,Os]=laguerre(Al,N,epz,time);

% [Tr,Ts,Os]=laguerre(Al,N,epz,time);
% computes rise time, settling time, overshoot of the 
% laguerre transfer function versus alpha and N.

[ni,nj]=size(Al);
Tr=zeros(ni,nj);Ts=zeros(ni,nj);Os=zeros(ni,nj);

if nargin<3, epz=1; end

for i=1:ni,
for j=1:nj,
a=Al(i,j);n=N(i,j);

if a==0, [A,B,C,D]=zp2ss([],-ones(1,n+epz),1);
else [A,B,C,D]=zp2ss(-ones(1,n)/a,-ones(1,n+epz),a^n);
end

if nargin>3 ,[y,x,t]=step(A,B,C,D,1,time);
else [y,x,t]=step(A,B,C,D);
end

g0=1;  %D-C*inv(A)*B

Ts(i,j)=max(t'.*(abs(y-g0)>.05*abs(g0)));
Os(i,j)=max(y-g0)/g0;

[t9,i9]=max(t'.*(abs(y/g0)<.9));
[t5,i5]=max(t'.*(abs(y/g0)<.5));
[t1,i1]=max(t'.*(abs(y/g0)<.1));

t=[t t(1,size(t,2))];
t90=(t(i9+1)+t(i9))/2;
t50=(t(i5+1)+t(i5))/2;
t10=(t(i1+1)+t(i1))/2;
Tr(i,j)=(t90-t10)/t50;

end
end
