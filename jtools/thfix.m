function thout=thfix(thin,str,nst)

% thout=thfix(thin,str,nst) theta model fixing.
%
% If str contains 'b' (default) only a simple balancing on both 
% its stable and unstable parts is performed.
% If str contains 'r' and there are more than nst states, the whole system thin 
% (beginning from its stable part), is balanced and truncated in order 
% to reduce the states to nst.
% If str contains 'a' and there are less than nst states, dummy unobservable 
% and uncontrollable states will be added in zero to achieve an nst states system.

% G.Campa 26/2/96

if nargin<2,str='b';end
if nargin<1,error('Please read thfix help');end

if thin(1,2)>=0,thin=thd2thc(thin);end
[A,B,C,D,K,X0]=th2ss(thin);
[no,ni]=size(D);
s2=pck(A,[B K X0(1:size(A,1))],C,[D eye(no) zeros(no,1)]);

if nargin<3,nst=size(A,1);end
s3=sys2sys(s2,str,nst);

[ty3,no3,ni3,ns3]=minfo(s3);
A=s3(1:ns3,1:ns3);
B=s3(1:ns3,ns3+[1:ni]);
C=s3(ns3+[1:no],1:ns3);
D=s3(ns3+[1:no],ns3+[1:ni]);
K=s3(1:ns3,ns3+ni+[1:no]);
X0=s3(1:ns3,ns3+ni+no+1);

thout=ss3th(A,B,C,D,K,X0);

if thin(1,2)>=0,thout=thc2thd(thout);end
