function g=gram2(A,B)

% G=gram2(A,B) returns the controllability gramian:
% Gc = integral{ exp(tA)BB'exp(tA') }dt = lyap(A,A',B*B').
% G=gram2(A',C') returns the observability gramian:
% Go = integral{ exp(tA')C'Cexp(tA) }dt = lyap(A',A,C'*C).
% 
% An extension of Åström-Jury-Agniel algorithm is used.
% This technique is more robust than the existing techniques
% and is computationally efficient when the number of inputs
% (and/or outputs) is low compared to the system order.
% 
% See also gram, gram3, gramcr, dgram, ctrb and obsv.

% G. Campa 17-12-93, revised 25/11/96.

[U,S,V]=svd(B);
a=U'*A*U;

s=min(size(a));					% initialization
d=zeros(s,s+2);
n=zeros(s*s,s+1);
al=zeros(s,1);					% alpha
be=zeros(s,s);					% beta
y=zeros(s,s);

d(1,:)=[poly(a) 0];				% first d row      
al(1,1)=d(1,1)/d(1,2);				% alpha(1) 

for k=1:s-1
for i=1:s+1-k

 if rem(i,2)==0 d(k+1,i)=d(k,i+1)-al(k)*d(k,i+2);
 else d(k+1,i)=d(k,i+1);
 end 						% d row number k+1 

end 

al(k+1,1)=d(k+1,1)/d(k+1,2);			% alpha(k+1)   
end


for b=U'*B,

n(1:s,1)=b;
for i=2:s
n(1:s,i)=a*n(1:s,i-1)+b*d(1,i);			% n1,..,nn vectors
end

be(:,1)=n(1:s,1)/d(1,2);			% beta(1)
  
for k=1:s-1
for i=1:s+1-k

 if rem(i,2)==0 n(1+s*k:s*(k+1),i)=n(1+s*(k-1):s*k,i+1)-be(:,k)*d(k,i+2);
 else n(1+s*k:s*(k+1),i)=n(1+s*(k-1):s*k,i+1);
 end

end						% n(k,:) vectors   

be(:,k+1)=n(1+s*k:s*(k+1),1)/d(k+1,2); 		% beta(k+1)
end

for k=1:s
y=y+be(:,k)*be(:,k)'/2/al(k,1);			% y(k)
end

end
g=U*y*U';
