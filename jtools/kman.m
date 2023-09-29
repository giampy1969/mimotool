function [f,g,K,X,F]=kman(G,str,pstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F)

% [f,g,K,X,F]=kman(G,str,pstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
% G is the simple plant to be controlled, with no augmentation or 
% weighting, for the meaning of all the arguments involved see khelps.

% G. Campa 24-2-96.

if nargin<12,F=inf;end
if nargin<11,X=zeros(2,4);end

[ty,no,ni,ns]=minfo(G);
x=X(:,1);K=[];

if nargin<10,bTi=[ni ni]; elseif isempty(bTi), bTi=[ni ni]; end
if nargin<9,bTo=[no no]; elseif isempty(bTo), bTo=[no no]; end
if nargin<8,bMi=[ni no]; elseif isempty(bMi), bMi=[ni no]; end
if nargin<7,bMo=[no ni]; elseif isempty(bMo), bMo=[no ni]; end

% frequency vector and response
w=logspace(-6,6,100);
fr=20*log10(vunpck(norm3(frsp(G,w))));
k0=mean(fr(1:10));
bd=log10(max(w'.*((k0-fr)<3)));
x2=min(max(-2,bd),2);

if nargin<6,
   lrg=[10^x2+sqrt(-1) 0 0 1 0 0;
        0 2*sqrt(-1) 0 0 sin(1) -cos(1);
        0 0 0 0 cos(1) sin(1)];
elseif isempty(lrg),
   lrg=[10^x2+sqrt(-1) 0 0 1 0 0;
        0 2*sqrt(-1) 0 0 sin(1) -cos(1);
        0 0 0 0 cos(1) sin(1)];
end

if nargin<5, cost=[1 1e-2 100 1];
elseif any(size(cost)~=[1 4]), cost=[1 1e-2 100 1];
end

if nargin<4,kstr='hi3'; elseif isempty(kstr), kstr='hi3'; end
if nargin<3,pstr='0tr'; elseif isempty(pstr), pstr='0tr'; end
if nargin<2,str='p'; elseif isempty(str), str='p'; end

% frequency vector and response
w=logspace(-6,6,100);
Gs=norm3(frsp(G,w));

% weighting function initialization
ToWs=[];MoWs=[];SoWs=[];
TiWs=[];MiWs=[];SiWs=[];
AbWs=[];aBWs=[];

% main cycle
while 1,

nwfg=figure;
fr=20*log10(vunpck(Gs));
k0=mean(fr(1:10));
bd=log10(max(w'.*((k0-fr)<3)));

% --------------------------------------------------------------------------------- %
% weighted plant and uncertainity construction

% basic plant construction
plant=pmaker(G,pstr);[a,b,c,d]=unpck(plant);

if (size(pstr,2)~=3 & size(pstr,2)~=1) | (size(pstr,2)==1 & isempty(str2num(pstr))),
  error('second argument unknown, please read khelps.m');

elseif size(pstr,2)==1 & ~isempty(str2num(pstr)),

  % ok, just initialise and skip the other choices
  blk=[];
  SoW=[];SiW=[];MoW=[];MiW=[];ToW=[];TiW=[];
  SoD=[];SiD=[];MoD=[];MiD=[];ToD=[];TiD=[];

elseif pstr([2 3])=='mf',

  % sensitivity weighting
  [SoW,SoD]=tfdraw(daug(Gs,abv(SoWs,MoWs)),no,'Yellow: G(s). Design So Upper Limit');
  [SiW,SiD]=tfdraw(daug(Gs,abv(SiWs,MiWs)),ni,'Yellow: G(s). Design Si Upper Limit');
  SoWs=norm3(frsp(SoW,w));SiWs=norm3(frsp(SiW,w));
  plant=mmult(daug(SiD,eye(no),eye(ni),SoD,eye(no)),plant);

  % control sensitivity weighting
  [MoW,MoD]=tfdraw(daug(Gs,abv(MoWs,SoWs)),ni,'Yellow: G(s). Design Mo Upper Limit');
  [MiW,MiD]=tfdraw(daug(Gs,abv(MiWs,SiWs)),no,'Yellow: G(s). Design Mi Upper Limit');
  MoWs=norm3(frsp(MoW,w));MiWs=norm3(frsp(MiW,w));
  plant=mmult(daug(eye(ni),MiD,MoD,eye(no),eye(no)),plant);

  ToW=[];TiW=[];
  ToD=[];TiD=[];
  blk=[ni ni;bMi;bMo;no no];

elseif pstr(2)=='m', 

  % sensitivity weighting
  [SoW,SoD]=tfdraw(daug(Gs,abv(SoWs,MoWs)),no,'Yellow: G(s). Design So Upper Limit');
  SoWs=norm3(frsp(SoW,w));
  plant=mmult(daug(eye(ni),SoD,eye(no)),plant);

  % control sensitivity weighting
  [MoW,MoD]=tfdraw(daug(Gs,abv(MoWs,SoWs)),ni,'Yellow: G(s). Design Mo Upper Limit');
  MoWs=norm3(frsp(MoW,w));
  plant=mmult(daug(MoD,eye(no),eye(no)),plant);

  SiW=[];MiW=[];ToW=[];TiW=[];
  SiD=[];MiD=[];ToD=[];TiD=[];
  if pstr(3)=='s',blk=[bMo;no no]; else blk=[no no+ni]; end

elseif pstr([2 3])=='tf',

  % sensitivity weighting
  [SoW,SoD]=tfdraw(daug(Gs,abv(SoWs,ToWs)),no,'Yellow: G(s). Design So Upper Limit');
  SoWs=norm3(frsp(SoW,w));
  [SiW,SiD]=tfdraw(daug(Gs,abv(SiWs,TiWs)),ni,'Yellow: G(s). Design Si Upper Limit');
  SiWs=norm3(frsp(SiW,w));
  plant=mmult(daug(SiD,eye(ni),eye(no),SoD,eye(no)),plant);

  % complementary sensitivity weighting
  [ToW,ToD]=tfdraw(daug(Gs,abv(ToWs,SoWs)),no,'Yellow: G(s). Design To Upper Limit');
  ToWs=norm3(frsp(ToW,w));
  [TiW,TiD]=tfdraw(daug(Gs,abv(TiWs,SiWs)),ni,'Yellow: G(s). Design Ti Upper Limit');
  TiWs=norm3(frsp(TiW,w));
  plant=mmult(daug(eye(ni),TiD,ToD,eye(no),eye(no)),plant);

  MoW=[];MiW=[];
  MoD=[];MiD=[];
  blk=[ni ni;bTi;bTo;no no];

elseif pstr(2)=='t',

  % sensitivity weighting
  [SoW,SoD]=tfdraw(daug(Gs,abv(SoWs,ToWs)),no,'Yellow: G(s). Design So Upper Limit');
  SoWs=norm3(frsp(SoW,w));
  plant=mmult(daug(eye(no),SoD,eye(no)),plant);

  % complementary sensitivity weighting
  [ToW,ToD]=tfdraw(daug(Gs,abv(ToWs,SoWs)),no,'Yellow: G(s). Design To Upper Limit');
  ToWs=norm3(frsp(ToW,w));
  plant=mmult(daug(ToD,eye(no),eye(no)),plant);

  SiW=[];MoW=[];MiW=[];TiW=[];
  SiD=[];MoD=[];MiD=[];TiD=[];
  if pstr(3)=='s',blk=[bTo;no no]; else blk=[no 2*no]; end

elseif pstr([2 3])=='ab',

  [aBW,aBD]=tfdraw(daug(Gs,abv(aBWs,AbWs)),ni,'Yellow: G(s). Design Input Limit');
  aBWs=norm3(frsp(aBW,w));
  plant=mmult(daug(aBD,eye(ns),eye(no)),plant);

  [AbW,AbD]=tfdraw(daug(Gs,abv(AbWs,aBWs)),ns,'Yellow: G(s). Design State Limit');
  AbWs=norm3(frsp(AbW,w));
  plant=mmult(daug(eye(ni),AbD,eye(no)),plant);

  SoW=[];SiW=[];MoW=[];MiW=[];ToW=[];TiW=[];
  SoD=[];SiD=[];MoD=[];MiD=[];ToD=[];TiD=[];
  blk=[size(plant,2)-plant(1,size(plant,2))-ni-1 ni+ns];

else
  error('second argument unknown, please read khelps.m');
end
% --------------------------------------------------------------------------------- %


% --------------------------------------------------------------------------------- %
% controller 

if kstr=='mu2',
  [K,P,gf]=musyne(plant,no,ni,blk);

elseif kstr=='mu3',
  [gf,K]=musynl(plant,no,ni,blk);

elseif kstr=='hi1',
  gmax=1e3;
  [K,P,gf]=hinfsynr(plant,no,ni,0,gmax,.01);

elseif kstr=='hi2',
  gmax=1;
  [K,P,gf]=hinfsyne(plant,no,ni,0,gmax,.01,inf,1);
  while isempty(K) & gmax<1e8,
  gmax=10*gmax;
  [K,P,gf]=hinfsyne(plant,no,ni,0,gmax,.01,inf,1);
  end

elseif kstr=='hi3',
  [gf,K]=hinfric(plant,[no ni]);

elseif kstr=='hlm',
  [gf,K]=hinflmi(plant,[no ni]);

elseif kstr=='hmx',
  region=[10^x(2)+sqrt(-1) 0 0 1 0 0;
        0 2*sqrt(-1) 0 0 sin(1) -cos(1);
        0 0 0 0 cos(1) sin(1)];
  [gf,h2f,K,R,S]=hinfmix(plant,[0 no ni],[0 0 1 0],region,1e2,1e-1);

elseif kstr=='h21', 
  [K,P]=h2synr(plant,no,ni);gf=0;

elseif kstr=='h22',
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  plant=pck(A,[B1,B2],[C1;C2],[zeros(size(D11)),D12;D21,D22]);
  [K,P]=h2syn(plant,no,ni);gf=0;

elseif kstr=='h23',
  [gf,K]=hinfric(plant,[no ni],Inf,Inf);

elseif kstr=='lqr',
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  k=lqr(A,B2,10^x(1)*eye(size(A)),10^x(2)*eye(ni));
  K=pinv(eye(ni)+k*pinv(C2)*D22)*k*pinv(C2);gf=max(max(K));

elseif kstr=='lqg',
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  [Ak,Bk,Ck,Dk]=reg(A,B2,C2,D22,...
  lqr2(A,B2,10^x(1)*eye(size(A)),eye(ni)),...
  lqe2(A,eye(size(A)),C2,10^x(2)*eye(size(A,2)),eye(no)));
  K=pck(Ak,Bk,Ck,Dk);gf=max(max(Dk));

elseif kstr=='plc',
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  k=place(A,B2,-1e-6-...
  linspace(10^min(x(1),x(2)),10^max(x(1),x(2)+1),size(B2,1))');
  K=pinv(eye(ni)+k*pinv(C2)*D22)*k*pinv(C2);gf=max(max(K));

end
% --------------------------------------------------------------------------------- %

if size(K,1)*size(K,2)>0,

% input and output integrator blocks
n=str2num(pstr(1));nm=min(no,ni);
Ibs=pck(zeros(nm),eye(nm),eye(nm),zeros(nm));
if ni<no, Ibi=Ibs;Ibo=eye(no); else Ibi=eye(ni);Ibo=Ibs; end

% controller with integrators
for k=1:n,K=mmult(Ibi,K,Ibo);end

% controller evaluation
[Po,Pi,mv]=keval(G,K,str,w,[],[],SoW,SiW,MoW,MiW,ToW,TiW,bMo,bMi,bTo,bTi);

% cost function evaluation
[f,g]=kcost([0 0]',mv,gf,pstr,cost);

else f=inf;g=ones(3,1)*inf;
end

f_g=[f,g']

goon=input('Continue ? (0 to stop any other to go on)');
if goon==0, break, end

if min([ isfinite(f) isfinite(g') ])==0, f=1e7;g=ones(3,1)*1e7; end

% "saving" of current minimum for "non constr" optimization
fc=max(max(g),0)*1e5+f;
if nargin>7 & fc<F,F=fc,X=[reshape(x,2,1) X(:,1:3)],end

end
delete(nwfg);