function [f,g,K,Df,X,F]=dlidx(x,G,Ts,X,F,plt)

% [f,g,K,Df,X,F]=dlidx(x,G,Ts,X,F,plt); returns a quality index for x.
% x = real vector 2by1 (variables):
% Q = 10^x(1)*eye(size(A)) , R = eye(ni) ;
% W = 10^x(2)*eye(size(A)) , V = eye(no) ;
% f real 1by1 to be minimized with g<0.
% with G = plant to be controlled.
% plt = 0 during optimization, and 1 to show the final results.
% X(:,1) = current minimum point, F=max(0,1e5*g(X(:,1)))+f(X(:,1))

% G. Campa 24-2-96.

if nargin<6,plt=0;end
if nargin<5,F=inf;end
if nargin<4,X=zeros(2,4);end

[A,B,C,D]=unpck(G);
[no,ni]=size(D);

% frequency vector
w=logspace(-6,pi/Ts,100);

[Ak,Bk,Ck,Dk]=dreg(A,B,C,D,...
dlqr(A,B,10^x(1)*eye(size(A)),eye(size(B,2))),...
dlqe(A,eye(size(A)),C,10^x(2)*eye(size(A)),eye(size(C,1))));
K=pck(Ak,Bk,Ck,Dk);

if size(K,1)*size(K,2)>0
%------------------------------------------------------------------------%
% hloop1 : sensitivity.

% step responses calculation of hloop1.
s_l1=starp(mmult(G,K),mmult([eye(no);eye(no)],[-eye(no),eye(no)]),no,no);

% frequency response
sv1=vunpck(norm3(frsp(s_l1,w,Ts)));
ms1=max(sv1);

if plt,
f1=figure;
subplot(2,1,1);
semilogx(w,20*log10(sv1),'r');
title('sensitivity');
end

%------------------------------------------------------------------------%
% hloop2 : control sensitivity.

% step responses calculation of hloop2.
s_l2=starp(G,mmult([eye(ni);eye(ni)],K,[-eye(no) eye(no)]),no,ni);

% maximum control signal 
[ap2,bp2,cp2,dp2]=unpck(s_l2);
mxu=zeros(1,min(no,ni));
for n=1:min(no,ni);
[y,xsys,t]=dstep(ap2,bp2(:,n),cp2(n,:),dp2(n,n),1);
mxu(n)=max(y);
end
mxu=max(abs(mxu));

% frequency response
sv2=vunpck(norm3(frsp(s_l2,w,Ts)));
ms2=max(sv2);

if plt,
subplot(2,1,2);
semilogx(w,20*log10(sv2),'b');
title('control sensitivity');
end

%------------------------------------------------------------------------%
% hloop3 : both sensitivities

% step responses calculation of hloop3.
s_l3=starp(G,mmult(...
		   daug([eye(ni);eye(ni)],eye(no)),...
		   daug(K,eye(no)),...
		   [eye(no);eye(no)],...
		   [-eye(no) eye(no)]),no,ni);

% frequency response
sv3=vunpck(norm3(frsp(s_l3,w,Ts)));
ms3=max(sv3);

% generalized plant
GP=pck(A,[sqrt(10^x(2)*eye(size(A))),zeros(size(A,1),size(C,1)),B],...
         [sqrt(10^x(1)*eye(size(A)));zeros(size(B,2),size(A,2));C],...
         [zeros(size(A)),zeros(size(A,1),size(C,1)),zeros(size(B));...
          zeros(size(B,2),size(A,2)),zeros(size(D')),sqrt(eye(size(B,2)));...
          zeros(size(C)),sqrt(eye(size(C,1))),D]);

P=starp(GP,K,no,ni);
sp3=vunpck(norm3(frsp(P,w,Ts)));

if plt,
f2=figure;
subplot(2,1,1);
semilogx(w,20*log10(sv3),'g');
title('both sensitivities');
subplot(2,1,2);
semilogx(w,20*log10(sp3),'m');
title('generalized plant gain ');
end

%------------------------------------------------------------------------%
% hloop4 : closed loop 

s_l4=starp(mmult([eye(no);eye(no)],G,K),[-eye(no) eye(no)],no,no);
[A4,B4,C4,D4]=unpck(s_l4);

mp4=max(real(eig(A4)));
mf4=max(abs(eig(A4)));
g4=D4+C4*inv(eye(size(A4))-A4)*B4;

% feedforward matrix
Df=inv(g4);B4=B4*Df;D4=D4*Df;g4=eye(no);

% maximum settling time and overshoot 
for n=1:no;
[y,xsys,t]=dstep(A4,B4(:,n),C4(n,:),D4(n,n),1);
g0=g4(n,n);
ts4(n)=max(t'.*(abs(y-g0)>.05*abs(g0)));
os4(n)=abs(max(y-g0)/g0);
end
ts4=max(ts4);
os4=max(os4);

% frequency response
sv4=vunpck(norm3(frsp(s_l4,w,Ts)));
ms4=max(sv4);

if plt,
sysinfo(bilinz2s(s_l4,Ts),'s',1e-2);
end

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
% VARIABLES USED BELOW (TO BE CHANGED IF NEEDED).

% x(1) s.t. Q = 10^x(1)*eye(ns) , R = eye(nu) ;
% x(2) s.t. W = 10^x(2)*eye(ns) , V = eye(no) ;

% ms1     = max output sensitivity singular value
% ms2     = max control sensitivity singular value
% ms3     = max of both sensitivity singular values
% ms4     = max complementary sensitivity singular value

% mxu     = max control signal value.

% mp4     = max real part of closed loop poles in closed loop plant.
% mf4     = magnitude of higher frequency pole in closed loop plant.
% os4     = max overshoot of step responses closed loop plant.
% ts4     = max settling time of step responses closed loop plant.

% INDEX VECTOR :
q=[x(1);  x(2); ...
    ms1;   ms2;   ms3;   ms4; ...
                         mxu; ...
    mp4;   mf4;   os4;   ts4];

% COST FUNCTION TO BE MINIMIZED :
f=[   0,     0, ...
      0,     0,     0,     0, ...
                           0, ...
      0,  1e-2,    10,     1]*q;

% CONSTRAIN TO BE < 0 :
g=[1e-2-ts4;ts4-1e2;mxu-10;1e3*mp4];

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
else f=inf;g=inf*ones(4,1);
end

if min([ isfinite(f) isfinite(g') ])==0, f=1e7;g=ones(4,1)*1e7; end

% "saving" of current minimum for "non constr" optimization
fc=max(max(g),0)*1e5+f;
if nargin>2 & fc<F,F=fc,X=[reshape(x,2,1) X(:,1:3)],end
