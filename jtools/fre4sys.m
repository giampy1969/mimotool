function sys=fre4sys(fr,T,ord,wt)

% sys=fre4sys(fr,T,ord,wt) fits a stable, minimum phase MIMO system to
% the magnitude of the frequency response in the varying matrix fr.
% If T=0 (default) then sys is a continuous time system, otherwise,
% it is a discrete time system obtained by bilins2z(sys,T).
% The system is constructed with the function magfit, then balanced 
% and if necessary truncated to reduce the states to ord (otpional).
% The (optional) varying matrix wt is a supplied frequency domain 
% weighting function.
% 
% Example:
% [a,b,c,d]=unpck(bilins2z(sysrand(4,2,3,1),1));
% fr=frsp(pck(a,b,c,d),logspace(-2,0,50),1);
% s1=fre4sys(fr,1);[a1,b1,c1,d1]=unpck(s1);
% subplot(2,1,1),dsigma(a,b,c,d,1);
% subplot(2,1,2),dsigma(a1,b1,c1,d1,1)

% This is the jtools version (with ord).
% It requires the files sys2sys,sysbal3 and infnan2x. 

% G. Campa 22/12/96

if nargin<4,wt=frsp(1,getiv(fr));end
if nargin<3,ord=1e3;end
if nargin<2,T=0;end

sys=[];
fr=sortiv(fr);
[ty1,no1,ni1,np1]=minfo(fr);

if fr(1,ni1+1)<=0,
[wmn,idx]=max((1:np1).*(fr(1:np1,ni1+1)'<=0));
fr=xtracti(fr,idx:np1);
end

for i=1:no1,
rs=[];

for j=1:ni1,
sij=magfit(vabs(sel(fr,i,j)),[.1 .1 1 3],wt);
rs=sbs(rs,sij);
end

sys=abv(sys,rs);
end

sys=sys2sys(sys,'r',ord);

if T,
sys=bilins2z(sys,T);
end
