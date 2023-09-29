function [K,P,mf]=musyne(plant,no,ni,blk,mrt)

% [K,P,mf]=musyne(plant,no,ni,blk,mrt) mu synthesys using
% hinfsyne and muftbtch, K is the resulting controller,
% P the closed loop plant, and mf its mu maximum value.
% The D-K loop is stopped when the ratio between the old mu response
% and the new one is below mrt decibels, (default 3db).
% As in hinfsyne, plant is the generalized plant, no the 
% number of its measured outputs, and ni the number of its 
% control inputs, while blk is the uncertainity structure.
%
% See also hinfsyne, mu, muftbtch.

% G.Campa 14/01/97

K=[];P=[];mf=inf;
if nargin<5,mrt=3;end

%------------------------------------------------------------------------%
% first iteration

[gf,K]=hinflmi(plant,[no ni]);
P=starp(plant,K,no,ni);

[bds,dvec,sens]=mu(frsp(P,logspace(-3,3,30)),blk,'s');
[s_Dl,s_Dr]=muftbtch('first',dvec,sens,blk,no,ni,[.26*mrt/3,.1*mrt/3,0,3]);

%------------------------------------------------------------------------%
% more iterations

while 1,

plant=mmult(s_Dl,plant,minv(s_Dr));

[gf2,K2]=hinflmi(plant,[no ni]);
P2=starp(plant,K2,no,ni);

[bds2,dvec,sens]=mu(frsp(P2,logspace(-3,3,30)),blk,'s');
[s_Dl,s_Dr]=muftbtch(s_Dl,dvec,sens,blk,no,ni,[.26*mrt/3,.1*mrt/3,0,3]);

bdrt=20*log10(max(vunpck(sel(bds,1,1))./vunpck(sel(bds2,1,1))));

if bdrt<mrt,break,end
bds=bds2;K=K2;P=P2;

end
mf=max(vunpck(sel(bds,1,1)));
