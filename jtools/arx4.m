function th=arx4(y,u,mxs)

% th=arx4(y,u,mxs) MIMO model obtained joining all the MISO arx models 
% between inputs and each output.
% Each arx model is chosen with the structure that achieve the smallest AIC,
% according to a simple search algorithm, in which the first half of data
% is used for estimation, the second for cross validation.
% Each column of y,(u) contains the story of the related output,(input).
% The stable part of the whole system is balanced and truncated in order
% to reduce the states to mxs if possible (mxs=inf=default skips reduction).
%
% Example:
% [a,b,c,d]=unpck(bilins2z(sysrand(4,2,3,1),1));
% th0=ms2th(modstruc(a,b,c,d,zeros(size(c'))),'d');
% e=rand(200,2);u=rand(200,3);y=idsim([u e],th0);
% th4=arx4(y,u);
% vid=ver('ident'); if vid.Version(1)=='4', [a4,b4,c4,d4,k4,x04]=th2ss(th4); 
% else [a4,b4,c4,d4,k4,x04]=ssdata(th2ido(th4)); end
% subplot(2,1,1),dsigma(a,b,c,d,1);
% subplot(2,1,2),dsigma(a4,b4,c4,d4,1);

% This is the jtools version (with mxs).
% It requires the files sys2sys,sysbal4 and infnan2x. 

% Giampiero Campa 12-12-95


if nargin<2, th=[]; disp('  usage: th=arx4(y,u,mxs)'); return, end
if nargin<3, mxs=inf; end

% initialization
no=size(y,2);
ni=size(u,2);

f=size(y,1);
l=floor(f/2);

% outer cycle (constructs matrices row by row)
A=[];B=[];C=[];D=[];K=[];X0=[];
for i=1:no,

% computes optimal structure
n0=struc(1:3,1:3,0:3);
n0=[n0(:,1) n0(:,2)*ones(1,ni) n0(:,3)*ones(1,ni)];
n1=sls4(arxstruc([y(1:l,i) u(1:l,:)],[y(l+1:f,i) u(l+1:f,:)],n0),'AIC');
vtx=(n1==3);
c=0;

while any(vtx)&(c<9),
n0=struc(n1(1)-vtx(1):n1(1)+vtx(1),n1(2)-vtx(2):n1(2)+vtx(2),n1(2+ni)-vtx(2+ni):n1(2+ni)+vtx(2+ni));
n0=[n0(:,1) n0(:,2)*ones(1,ni) n0(:,3)*ones(1,ni)];
n2=sls4(arxstruc([y(1:l,i) u(1:l,:)],[y(l+1:f,i) u(l+1:f,:)],n0),'AIC');
vtx=(n2==(n1+1));
n1=n2;c=c+1;
end

th=arx([y(:,i) u],n1);
[a,b,c,d,k,x0]=th2ss(th);

% state space matrices construction
A=[A zeros(size(A,1),size(a,2)); zeros(size(a,1),size(A,2)) a];
B=[B;b];
C=[C zeros(size(C,1),size(c,2)); zeros(size(c,1),size(C,2)) c];
D=[D;d];
K=[K zeros(size(K,1),size(k,2)); zeros(size(k,1),size(K,2)) k];
X0=[X0; x0];

% outer cycle
end

% balance and truncation if required
if ~isinf(mxs),

  % system in continuous time domain
  s0=bilinz2s(pck(A,[B K X0(1:size(A,1))],C,[D eye(size(K,2)) zeros(size(D,1),1)]),1);

  % balance and truncation
  s2=sys2sys(s0,'r',mxs);
  [ty2,no2,ni2,ns2]=minfo(s2);
  
  % final discrete time system
  s3=bilins2z(s2,1);

  A=s3(1:ns2,1:ns2);
  B=s3(1:ns2,ns2+[1:ni]);
  C=s3(ns2+[1:no],1:ns2);
  D=s3(ns2+[1:no],ns2+[1:ni]);
  K=s3(1:ns2,ns2+ni+[1:no]);
  X0=s3(1:ns2,ns2+ni+no+1);

% end if
end 

% final theta format
th=ss4th(A,B,C,D,K,X0);

%bodeplot([th2ff(th) spa([y u],30*ones(1,no))]);

% subfunctions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theta=ss4th(a,b,c,d,k,x0,cd,parval,lambda,T)

% THETA = ss4th(A,B,C,D,K,X0,CD,PARVAL,LAMBDA,T)
% Pack standard ss parameterizations into THETA format

if nargin<10, T=[];end
if nargin<9, lambda=[];end
if nargin<8, parval=[];end 
if nargin<7, cd=[];end

if isempty(T),T=1;end

if nargin<5,error('All of the matrices A, B, C, D, K, must be specified!'),end
[nx,nd]=size(a);
if nx ~= nd, error('The A-matrix must be square!'),end
if nargin<6, x0=zeros(nx,1);end,if isempty(x0),x0=zeros(nx,1);end
[nd,nu]=size(b);
if nx ~= nd & nu~=0, error('A and B must have the same number of rows!'),
end
[ny,nd]=size(c);
if nx ~= nd, error('A and C must have the same number of columns!'),
end
[nd1,nd2]=size(d);
if nd1 ~= ny & nu~=0, error('D and C must have the same number of rows!'),end
if nd2 ~= nu, error('D and B must have the same number of columns!'),
end
[nd1,nd2]=size(k);
if nd1 ~= nx, error('K and A must have the same numb er of rows!'),
end
if nd2 ~= ny, error('The number of columns in K must equal the number of coulumns in C!'),end
[nd1,nd2]=size(x0);
if nd1~=nx, error('X0 and A must have the same number of rows!'),end
if nd2 ~= 1, error('X0 must be a coulmn vector!'),end
ms(1:nx,1:nx)=a;
if nu>0, ms(1:nx,nx+1:nx+nu)=b;end
ms(1:nx,nx+nu+1:nx+nu+ny)=c';
if nu>0, ms(1:ny,nx+nu+ny+1:nx+2*nu+ny)=d;end
nn=nx+2*(nu+ny);
ms(1:nx,nx+2*nu+ny+1:nn)=k;
ms(1:nx,nn+1:nn+1)=x0;
ms(1,nn+2)=ny;ms(2,nn+2)=nx;

d1=sum(sum(isnan(ms))');

if isempty(parval),parval=zeros(1,d1);end
if isempty(cd), cd='d';end, cd=cd(1);
if cd~='c' & cd~='d', 
  error('CD must be one of ''c''(ontinuous) or ''d''(iscrete)')
end
[nx,nn]=size(ms);nyy=ms(1,nn);
if nyy<0,arx=1;else arx=0;end
d=length(parval);
if d~=d1 & ~arx, 
  error('Incorrect number of parameter values  have been specified; must be equal to the number of ''NaN'':s in the model structure!')
end

if T<0,
  error('The sampling interval T must be a positive number. Use ''c'' in the second argument to indicate continuous time model!')
end

[rarg,carg]=size(ms);
if cd=='c',theta(1,2)=-abs(T);else theta(1,2)=abs(T);end
if cd=='d',Tmod=-1;else Tmod=abs(T);end
theta(1,6:7)=[rarg,carg];

[a,b,c,Dd,k,x0]=ssmodx4(parval,Tmod,ms);

if ms(1,carg)>0,
   if max(abs(eig(a-k*c)))>1,disp('WARNING: Predictor unstable!'),end
end
[ny,nx]=size(c);[nx,nu]=size(b);
if isempty(lambda),lambda=eye(ny);end
theta(1,1)=det(lambda);
ti=fix(clock);
ti(1)=ti(1)/100;
theta(1,3:5)=[nu ny d];theta(2,1)=theta(1,1);
theta(2,2:6)=ti(1:5);
theta(2,7)=21;
if cd=='c', theta(2,8)=1;else theta(2,8)=2;end
if d>0,
	theta(3,1:d)=parval;
end
theta(4+d:3+d+rarg,1:carg)=ms;
theta(4+d+rarg:3+ny+d+rarg,1:ny)=lambda;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [nn,Vmod]=sls4(V,c)

%
% nn = sls4(V,c)    or   [nn,Vm] = sls(V,c)
% copy of selstruc.m with graphic mode disabled,
% meant to be used as a subroutine of arx4 and rarx4
%

nn=[];
if nargin<2,c='a';,end
if c<0,c='a';end
if c<0,c='a';end
[nl1,nm1]=size(V);
nu=floor((nl1-2)/2);
Nc=V(1,nm1);
if c(1)=='a' | c(1)=='A',alpha=2;end
if c(1)=='m' | c(1)=='M', alpha=log(Nc);end

for kj=1:nm1-1
Vmod(1,kj)=V(1,kj)*(1+(alpha/Nc)*sum(V(2:nu+2,kj)));
end
Vmod(2:nl1,1:nm1-1)=V(2:nl1,1:nm1-1);

Vmod(1,1:nm1-1)=log(Vmod(1,1:nm1-1));
if length(nn)==0,[vm,sel]=min(Vmod(1,1:nm1-1));
nn=V(2:2+2*nu,sel)';end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,B,C,D,K,X0]=ssmodx4(th,T,mod)

%	[A,B,C,D,K,X0] = ssmodx4(PARVAL,T,MS)
%
% copy of ssmodx9.m with a few changes,
% meant to be used as a subroutine of arx4 and rarx4
%
	
[dum,nn]=size(mod);nyy=mod(1,nn);nx=mod(2,nn);
ny=abs(nyy);nu=(nn-nx-2*ny-2)/2;
s=1;
if nyy<0,arx=1;else arx=0;end
na=0;
if arx,
as1=mod(1:nx,1:nx);
sumas=sum4vms(as1');
nr=find(sumas==0&~isnan(sumas));
if isempty(nr),na=nx/ny;else na=(nr(1)-1)/ny;end
end
A=mod(1:nx,1:nx);
for kr=1:nx
	for kc=1:nx
	if isnan(A(kr,kc)), A(kr,kc)=th(s);s=s+1;end
	end
end
B=mod(1:nx,nx+1:nx+nu);
for kr=1:nx
	for kc=1:nu
	if isnan(B(kr,kc)),B(kr,kc)=th(s);s=s+1;end
	end
end
if na==0
C=mod(1:nx,nx+nu+1:nx+nu+ny)';
for kr=1:ny
	for kc=1:nx
	if isnan(C(kr,kc)),C(kr,kc)=th(s);s=s+1;end
	end
end
if nu==0, D=[];else D=mod(1:ny,nx+nu+ny+1:nx+2*nu+ny);end
for kr=1:ny
	for kc=1:nu
	if isnan(D(kr,kc)),D(kr,kc)=th(s);s=s+1;end
	end
end
else
C=A(1:ny,1:nx);
if nu>0,D=B(1:ny,:);else D=[];end
end
K=mod(1:nx,nx+2*nu+ny+1:nx+2*nu+2*ny);
for kr=1:nx
	for kc=1:ny
	if isnan(K(kr,kc)),K(kr,kc)=th(s);s=s+1;end
	end
end

X0=mod(1:nx,nx+2*nu+2*ny+1);
for kr=1:nx
	if isnan(X0(kr)),X0(kr)=th(s);s=s+1;end
end
if T>0 % We shall in this case sample the model with sampling interval T
s = expm([[A [B K]]*T; zeros(nu+ny,nx+nu+ny)]);
A = s(1:nx,1:nx);
B = s(1:nx,nx+1:nx+nu);
K = s(1:nx,nx+nu+1:nx+nu+ny);
end
