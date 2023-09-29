function g = gram3(A,B)

% G=gram3(A,B) returns the controllability gramian:
% Gc = integral{ exp(tA)BB'exp(tA') }dt = lyap(A,A',B*B').
% G=gram3(A',C') returns the observability gramian:
% Go = integral{ exp(tA')C'Cexp(tA) }dt = lyap(A',A,C'*C).
% 
% An ad hoc pseudo-inverse extension of lyap algorithm is used.
% This gives a result when solution is not unique (finds the one 
% with minimum magnitude) or does not exists (finds a solution
% getting as close as possible to the required B*B').
%
% See also gram, gram2, gramcr, dgram, ctrb and obsv.

% G. Campa 25-09-97, based on J.N. Little 3-6-86 (lyap function).

[u,s,v]=svd(B);
a=u'*A*u;
n=size(a,1);

real_flg=1;
if any(any(imag(a))) | any(any(imag(s*s'))), real_flg=0; end

% perform schur decomposition on a and a'
[u1,t1]=schur(a);
[u1,t1]=rsf2csf(u1,t1);
[u2,t2]=schur(a');
[u2,t2]=rsf2csf(u2,t2);

% transform b
tb=-u1'*s*s'*u2;

% solve for first column of transformed solution
y=zeros(n,n);
y(:,1)=pinv(t1+eye(n)*t2(1,1))*tb(:,1);

% solve for remaining columns of transformed solution
for k=2:n
	km1=1:(k-1);
	y(:,k)=pinv(t1+eye(n)*t2(k,k))*(tb(:,k)-y(:,km1)*t2(km1,k));
end

% find untransformed solution 
x=u1*y*u2';

% ignore complex part if real inputs (better be small)
if real_flg,	x=real(x); end

% result
g=u*x*u';
