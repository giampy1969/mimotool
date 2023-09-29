function g=gramcr(A,B,C)

% G=gramcr(A,B,C) cross-coupled gramian for square systems:
% Goc = integral{ exp(tA)BCexp(tA) }dt = lyap(A,A,B*C).
% 
% An extension of Åström-Jury-Agniel algorithm is used.
% This technique is more robust than the existing techniques
% and is computationally efficient when the number of inputs
% (and/or outputs) is low compared to the system order.
% 
% See also gram, gram2, gram3, dgram, ctrb and obsv.

% G. Campa 17-12-93, revised 25/11/96.

[T,E]=eig(B*C);
a=inv(T)*A*T;

s=min(size(a));					% initialization
d=zeros(s,s+2);
n=zeros(s*s,s+1);
m=zeros(s+1,s*s);
al=zeros(s,1);					% alpha
be=zeros(s,s);					% beta
ga=zeros(s,s);					% gamma
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

for b=sqrt(E),
c=b.';

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

end						 % n(k,:) vectors   

be(:,k+1)=n(1+s*k:s*(k+1),1)/d(k+1,2); 		 % beta(k+1)
end


m(1,1:s)=c;
for i=2:s
m(i,1:s)=m(i-1,1:s)*a+d(1,i)*c;			% m1,..,mn vectors
end

ga(1,:)=m(1,1:s)/d(1,2);				% gamma(1)

for k=1:s-1
for i=1:s+1-k

 if rem(i,2)==0 m(i,1+s*k:s*(k+1))=m(i+1,1+s*(k-1):s*k)-d(k,i+2)*ga(k,:);
 else m(i,1+s*k:s*(k+1))=m(i+1,1+s*(k-1):s*k);
 end

end						 % m(:,k) vectors   

ga(k+1,:)=m(1,1+s*k:s*(k+1))/d(k+1,2); 		 % gamma(k+1)
end

for k=1:s
y=y+be(:,k)*ga(k,:)/2/al(k,1);			 % y(k)
end

end
g=T*y*inv(T);