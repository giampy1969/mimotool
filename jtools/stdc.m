function [K,Kf,P,ro,Tx]=stdc(G,plt)

% [K,Kf,P,ro,Tx]=stdc(G,plt) inversion based static decoupling control.
% Given a plant G (mutools format), this function provides a control
% law which moves a pole on every zero, and moves in zero the 
% other poles of G.
% K and Kf are the feedback and feedforward matrices, such that
% the closed loop system is P(s)=(C-D*K)*(s*I-A+B*K)*B*Kf+D*Kf
% Every output y(i) of P(s) is the ro(i) derivative of ist input v(i),
% where ro(i) is the relative degree of y(i).
% Tx is the transformation matrix which brings the system in normal
% form : An=Tx*A*inv(Tx), Cn=C*inv(Tx), Bn=Tx*B; Dn=D; see statecc.
% 
% If plt=1 (default) the function produces plots and displays data.
% Default w is a 100 log spaced points vector from 1e-6 to 1e6 rad/sec.
% 
% Example :
% A=rand(3);B=rand(3,2);C=rand(2,3);D=rand(2,2);
% G=[[A B;C D] [3;zeros(4,1)] ; [zeros(1,5) -inf]];
% [K,Kf,P,ro,Tx]=stdc(G);
% 

% G.Campa 22/1/98

if nargin<2,plt=1;end

% general info
[ty,no,ni,n]=minfo(G);
if ty=='cons', G=[G,zeros(size(G,1),1);zeros(1,size(G,2)),-inf]; end
[A,B,C,D]=unpck(G);

Tx=[];
ro=zeros(no,1);
Ex=zeros(no,n);
Dx=zeros(no,ni);

% relative degree
for i=1:no,
   for k=0:n-1,
      if k==0,Dx(i,:)=D(i,:); else Dx(i,:)=C(i,:)*A^(k-1)*B;end
      if any(Dx(i,:)~=zeros(1,ni)),
         ro(i)=k;
         Ex(i,:)=C(i,:)*A^k;
         break,
      else
         Tx=[Tx;C(i,:)*A^k];
      end
   end
end

Tx=[Tx;null(Tx)'];
Kf=pinv(Dx);
K=Kf*Ex;

P=pck(A-B*K,B*Kf,C-D*K,D*Kf);

%------------------------------------------------------------------------%
% poles drifting:

if plt,

figure;
pzmap(A-B*K*0,B*Kf,C-D*K*0,D*Kf);
hold on
title('closed loop poles drifting')

avm=[];
for q=0:.02:1,avm=[avm eig(A-B*K*q)];end

l=size(avm,2);

for j=1:size(avm,1),
    plot(real(avm(j,1:l-1)),imag(avm(j,1:l-1)),'r.')
    plot(real(avm(j,l)),imag(avm(j,l)),'bx')
end

end
