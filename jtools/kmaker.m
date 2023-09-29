function [f,g,K,X,F]=kmaker(x,G,str,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F)

% [f,g,K,X,F]=kmaker(x,G,str,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
% G is the simple plant to be controlled, with no augmentation or 
% weighting, for the meaning of all the arguments involved see khelps.

% G. Campa 24-2-96.

if nargin<14,F=inf;end
if nargin<13,X=zeros(2,4);end

[ty,no,ni,ns]=minfo(G);K=[];

if nargin<12,bTi=[ni ni]; elseif isempty(bTi), bTi=[ni ni]; end
if nargin<11,bTo=[no no]; elseif isempty(bTo), bTo=[no no]; end
if nargin<10,bMi=[ni no]; elseif isempty(bMi), bMi=[ni no]; end
if nargin<9,bMo=[no ni]; elseif isempty(bMo), bMo=[no ni]; end

if nargin<8, lrg=[]; end

if nargin<7, cost=[1 1e-2 100 1];
elseif any(size(cost)~=[1 4]), cost=[1 1e-2 100 1];
end

if nargin<6,kstr='hi3'; elseif isempty(kstr), kstr='hi3'; end
if nargin<5,wstr='ae'; elseif isempty(wstr), wstr='ae'; end
if nargin<4,pstr='0tr'; elseif isempty(pstr), pstr='0tr'; end
if nargin<3,str='p'; elseif isempty(str), str='p'; end

% frequency vector and response
w=logspace(-6,6,100);
fr=20*log10(vunpck(norm3(frsp(G,w))));
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
  if wstr(1)=='e',
     [SoW,SoD]=fotf(-inf,x(2)+bd/20,3,no);
     [SiW,SiD]=fotf(-inf,x(2)+bd/20,3,ni);
  elseif wstr(1)=='c',
     SoW=10^(3/20)*eye(no);SoD=10^(3/20)*eye(no);
     SiW=10^(3/20)*eye(ni);SiD=10^(3/20)*eye(ni);
  else
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2)+bd/20,3,no);
     [SiW,SiD]=fotf(max(-6,x(2)-3),x(2)+bd/20,3,ni);
  end
  plant=mmult(daug(SiD,eye(no),eye(ni),SoD,eye(no)),plant);

  % control sensitivity weighting
  if wstr(2)=='e' & ~any(any(d(ni+[1:no+ni],:))),
     MoW=fotf(inf,x(2),x(1),ni);
     MiW=fotf(inf,x(2),x(1),no);
     plant=sderiv(pck(a,b,c,d),ni+[1:no],10^(-x(1)/20)*[10^(-x(2)) 1]);
     plant=sderiv(plant,ni+no+[1:ni],10^(-x(1)/20)*[10^(-x(2)) 1]);
  elseif wstr(2)=='c',
     MoW=10^(x(1)/20)*eye(ni);MoD=10^(-x(1)/20)*eye(ni);
     MiW=10^(x(1)/20)*eye(no);MiD=10^(-x(1)/20)*eye(no);
     plant=mmult(daug(eye(ni),MiD,MoD,eye(no),eye(no)),plant);
  else
     [MoW,MoD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     [MiW,MiD]=fotf(min(6,x(2)+3),x(2),x(1),no);
     plant=mmult(daug(eye(ni),MiD,MoD,eye(no),eye(no)),plant);
  end

  ToW=[];TiW=[];
  ToD=[];TiD=[];
  blk=[ni ni;bMi;bMo;no no];

elseif pstr(2)=='m', 

  % sensitivity weighting
  if wstr(1)=='e',
     [SoW,SoD]=fotf(-inf,x(2)+bd/20,3,no);
  elseif wstr(1)=='c', 
     SoW=10^(3/20)*eye(no);SoD=10^(-3/20)*eye(no);
  else
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2)+bd/20,3,no);
  end
  plant=mmult(daug(eye(ni),SoD,eye(no)),plant);

  % control sensitivity weighting
  if wstr(2)=='e' & ~any(any(d(1:ni,:))),
     MoW=fotf(inf,x(2),x(1),ni);
     plant=sderiv(plant,1:ni,10^(-x(1)/20)*[10^(-x(2)) 1]);
  elseif wstr(2)=='c',
     MoW=10^(x(1)/20)*eye(ni);MoD=10^(-x(1)/20)*eye(ni);
     plant=mmult(daug(MoD,eye(no),eye(no)),plant);
  else
     [MoW,MoD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     plant=mmult(daug(MoD,eye(no),eye(no)),plant);
  end

  SiW=[];MiW=[];ToW=[];TiW=[];
  SiD=[];MiD=[];ToD=[];TiD=[];
  if pstr(3)=='s',blk=[bMo;no no]; else blk=[no no+ni]; end

elseif pstr([2 3])=='tf',

  % sensitivity weighting
  if wstr(1)=='e',
     [SoW,SoD]=fotf(-inf,x(2),x(1),no);
     [SiW,SiD]=fotf(-inf,x(2),x(1),ni);
  elseif wstr(1)=='c',
     SoW=10^(x(1)/20)*eye(no);SoD=10^(-x(1)/20)*eye(no);
     SiW=10^(x(1)/20)*eye(ni);SiD=10^(-x(1)/20)*eye(ni);
  else
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2),x(1),no);
     [SiW,SiD]=fotf(max(-6,x(2)-3),x(2),x(1),ni);
  end
  plant=mmult(daug(SiD,eye(ni),eye(no),SoD,eye(no)),plant);

  % complementary sensitivity weighting
  if wstr(2)=='e' & ~any(any(d(2*ni+[1:no],:))),
     [ToW,ToD]=fotf(-inf,x(2),x(1),no);
     [TiW,TiD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     plant=sderiv(plant,2*ni+[1:no],10^(-x(1)/20)*[10^(-x(2)) 1]);
     plant=mmult(daug(eye(ni),TiD,eye(no),eye(no),eye(no)),plant);
  elseif wstr(2)=='c',
     ToW=10^(x(1)/20)*eye(no);ToD=10^(-x(1)/20)*eye(no);
     TiW=10^(x(1)/20)*eye(ni);TiD=10^(-x(1)/20)*eye(ni);
     plant=mmult(daug(eye(ni),TiD,ToD,eye(no),eye(no)),plant);
  else
     [ToW,ToD]=fotf(min(6,x(2)+3),x(2),x(1),no);
     [TiW,TiD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     plant=mmult(daug(eye(ni),TiD,ToD,eye(no),eye(no)),plant);
  end

  MoW=[];MiW=[];
  MoD=[];MiD=[];
  blk=[ni ni;bTi;bTo;no no];

elseif pstr(2)=='t',

  % sensitivity weighting
  if wstr(1)=='e',
     [SoW,SoD]=fotf(-inf,x(2),x(1),no);
  elseif wstr(1)=='c',
     SoW=10^(x(1)/20)*eye(no);SoD=10^(-x(1)/20)*eye(no);
  else
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2),x(1),no);
  end
  plant=mmult(daug(eye(no),SoD,eye(no)),plant);

  % complementary sensitivity weighting
  if wstr(2)=='e' & ~any(any(d(1:no,:))),
     ToW=fotf(inf,x(2),x(1),no);
     plant=sderiv(plant,1:no,10^(-x(1)/20)*[10^(-x(2)) 1]);
  elseif wstr(2)=='c',
     ToW=10^(x(1)/20)*eye(no);ToD=10^(-x(1)/20)*eye(no);
     plant=mmult(daug(ToD,eye(no),eye(no)),plant);
  else
     [ToW,ToD]=fotf(min(6,x(2)+3),x(2),x(1),no);
     plant=mmult(daug(ToD,eye(no),eye(no)),plant);
  end

  SiW=[];MoW=[];MiW=[];TiW=[];
  SiD=[];MoD=[];MiD=[];TiD=[];
  if pstr(3)=='s',blk=[bTo;no no]; else blk=[no 2*no]; end

elseif pstr([2 3])=='ab',

  % input weighting
  if wstr(1)=='e' & ~any(any(d(1:ni,:))),
     aBW=fotf(inf,x(2),x(1),ni);
     plant=sderiv(plant,1:ni,10^(-x(1)/20)*[10^(-x(2)) 1]);
  elseif wstr(1)=='c',
     aBW=10^(x(1)/20)*eye(ni);aBD=10^(-x(1)/20)*eye(ni);
     plant=mmult(daug(aBD,eye(ns),eye(no)),plant);
  else
     [aBW,aBD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     plant=mmult(daug(aBD,eye(ns),eye(no)),plant);
  end

  % state weighting
  if wstr(2)=='e' & ~any(any(d(ni+[1:ns],:))),
     AbW=fotf(inf,x(2),x(1),ns);
     plant=sderiv(plant,ni+[1:ns],10^(-x(1)/20)*[10^(-x(2)) 1]);
  elseif wstr(2)=='c',
     AbW=10^(x(1)/20)*eye(ns);AbD=10^(-x(1)/20)*eye(ns);
     plant=mmult(daug(eye(ni),AbD,eye(no)),plant);
  else
     [AbW,AbD]=fotf(min(6,x(2)+3),x(2),x(1),ns);
     plant=mmult(daug(eye(ni),AbD,eye(no)),plant);
  end

  SoW=[];SiW=[];MoW=[];MiW=[];ToW=[];TiW=[];
  SoD=[];SiD=[];MoD=[];MiD=[];ToD=[];TiD=[];
  blk=[size(plant,2)-plant(1,size(plant,2))-ni-1 ni+ns];
  
else
  error('second argument unknown, please read khelps.m');
end
% --------------------------------------------------------------------------------- %


% --------------------------------------------------------------------------------- %
% controller 

if kstr=='mu2' & ~isempty(blk),
  [K,P,gf]=musyne(plant,no,ni,blk);

elseif kstr=='mu3' & ~isempty(blk),
  [K,P,gf]=musynl(plant,no,ni,blk);

elseif kstr=='hi1' & ~isempty(blk),
  gmax=1e3;
  [K,P,gf]=hinfsynr(plant,no,ni,0,gmax,.01);

elseif kstr=='hi2' & ~isempty(blk),
  gmax=1;
  [K,P,gf]=hinfsyne(plant,no,ni,0,gmax,.01,inf,1);
  while isempty(K) & gmax<1e8,
  gmax=10*gmax;
  [K,P,gf]=hinfsyne(plant,no,ni,0,gmax,.01,inf,1);
  end

elseif kstr=='hi3' & ~isempty(blk),
  [gf,K]=hinfric(plant,[no ni]);

elseif kstr=='hlm' & ~isempty(blk),
  [gf,K]=hinflmi(plant,[no ni]);

elseif kstr=='hmx' & ~isempty(blk),
  [gf,h2f,K,R,S]=hinfmix(plant,[0 no ni],[0 0 1 0],lrg,1e2,1e-1);

elseif kstr=='h21' & ~isempty(blk), 
  [K,P]=h2synr(plant,no,ni);gf=0;

elseif kstr=='h22' & ~isempty(blk),
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  plant=pck(A,[B1,B2],[C1;C2],[zeros(size(D11)),D12;D21,D22]);
  [K,P]=h2syn(plant,no,ni);gf=0;

elseif kstr=='h23' & ~isempty(blk),
  [gf,K]=hinfric(plant,[no ni],Inf,Inf);

elseif kstr=='lqr',
  [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(plant,[no ni]);
  k=lqr(A,B2,10^x(1)*eye(size(A)),10^x(2)*eye(ni));
  K=daug(k*pinv(C2-D22*k),-Inf);gf=max(max(K));

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
  K=daug(k*pinv(C2-D22*k),-Inf);gf=max(max(K));

else 
   warning('incorrect or inconsistent kstr string : no k returned');
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
[f,g]=kcost(x,mv,gf,pstr,cost);

else f=inf;g=ones(3,1)*inf;
end

if min([ isfinite(f) isfinite(g') ])==0, f=1e7;g=ones(3,1)*1e7; end

% "saving" of current minimum for "non constr" optimization
fc=max(max(g),0)*1e5+f;
if nargin>12 & fc<F,F=fc,X=[reshape(x,2,1) X(:,1:3)],end
