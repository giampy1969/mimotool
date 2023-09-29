function [Po,Pi,mv] = ...
  keval2(G2,K2,str,w,FoW,FiW,SoW,SiW,MoW,MiW,ToW,TiW,bMo,bMi,bTo,bTi)

% [Po,Pi,mv]=keval2(G,K,str,w); linear control evaluation.
% Performs analysis on the closed loop obtained by connecting the
% controller K as a negative state to input feedback on G (u=-Kx).
% Returns also :
% Po: Closed loop system from control input to plant output.
% Pi: Closed loop system from plant input to plant output.
% If str contains 'd' data and plots will be shown.
% If str contains 'p' Po and Pi will be analysed.
% If str contains 'm' performance robustness will be analysed by mean
% of mu{blk} values of several sensitivity matrices (it may be long).
% Default blk is full size.
% Default w is a 120 log spaced points vector from 1e-6 to 1e6 rad/sec.
% Default str is 'dp', type keval2 for more info.
% See also keval and keval3.

% 
% G.Campa 20/05/98

if nargin<16,bTi=[];end
if nargin<15,bTo=[];end
if nargin<14,bMi=[];end
if nargin<13,bMo=[];end

if nargin<12,TiW=[];end
if nargin<11,ToW=[];end
if nargin<10,MiW=[];end
if nargin<9,MoW=[];end
if nargin<8,SiW=[];end
if nargin<7,SoW=[];end
if nargin<6,FiW=[];end
if nargin<5,FoW=[];end
if nargin<4,w=[];end

if nargin<3,str='dp';end
if nargin<2,error('Please read keval2 help');end

[ty2,no2,ni2,ns2]=minfo(G2);
[tyk,nok,nik,nsk]=minfo(K2);

if ns2~=nik | ni2~=nok,
error('G and K have incompatible sizes')
end

[A,B,C,D]=unpck(G2);
ni=size(B,2);no=size(B,2)+size(B,1);
G=abv(eye(ni),pck(A,B,eye(size(A)),zeros(size(B))));
K=sbs(zeros(ni),K2);

if isempty(bTi),bTi=[ni ni];end
if isempty(bTo),bTo=[no no];end
if isempty(bMi),bMi=[ni no];end
if isempty(bMo),bMo=[no ni];end

if isempty(w),w=logspace(-6,6,120);end

if ~isempty(FoW), sFoW=vunpck(norm3(frsp(FoW,w))); else sFoW=w'*NaN; end
if ~isempty(FiW), sFiW=vunpck(norm3(frsp(FiW,w))); else sFiW=w'*NaN; end
if ~isempty(SoW), sSoW=vunpck(norm3(frsp(SoW,w))); else sSoW=w'*NaN; end
if ~isempty(SiW), sSiW=vunpck(norm3(frsp(SiW,w))); else sSiW=w'*NaN; end
if ~isempty(MoW), sMoW=vunpck(norm3(frsp(MoW,w))); else sMoW=w'*NaN; end
if ~isempty(MiW), sMiW=vunpck(norm3(frsp(MiW,w))); else sMiW=w'*NaN; end
if ~isempty(ToW), sToW=vunpck(norm3(frsp(ToW,w))); else sToW=w'*NaN; end
if ~isempty(TiW), sTiW=vunpck(norm3(frsp(TiW,w))); else sTiW=w'*NaN; end

%------------------------------------------------------------------------%
% Input ant output open loop responses

Fo=mmult(G,K);Fi=mmult(K,G);

% frequency responses
sFo=vunpck(norm3(frsp(Fo,w)));mFo=max(sFo);
sFi=vunpck(norm3(frsp(Fi,w)));mFi=max(sFi);

ww=sort([w 1e-2:.01:10]);
dIFo=vunpck(vdet(frsp(madd(eye(no),Fo),ww)));mdo=min(abs(dIFo));

rWFo=infnan2x(20*log10(min(sFoW./sFo)));
rWFi=infnan2x(20*log10(min(sFiW./sFi)));

if any(str=='d'),
figure;
plot(real(dIFo),imag(dIFo),'r',0,0,'w');add_disk;
axis([-3 3 -3 3]);title('det(I+GK)=det(I+KG)');
figure;
subplot(2,1,1);
semilogx(w,20*log10(sFi),'r',w,20*log10(sFo),'b',...
         w,20*log10(sFiW),'m',w,20*log10(sFoW),'c');
title('blue: F=GK, red: F=KG, (cyan,mag=weight)');
end

%------------------------------------------------------------------------%
% Input ant output sensitivity.

So=starp(mmult(G,K),mmult([eye(no);eye(no)],[-eye(no),eye(no)]),no,no);
Si=starp(mmult(K,G),mmult([eye(ni);eye(ni)],[-eye(ni),eye(ni)]),ni,ni);

% frequency responses
sSo=vunpck(norm3(frsp(So,w)));mSo=max(sSo);
sSi=vunpck(norm3(frsp(Si,w)));mSi=max(sSi);

rWSo=infnan2x(20*log10(min(sSoW./sSo)));
rWSi=infnan2x(20*log10(min(sSiW./sSi)));

if any(str=='d'),
subplot(2,1,2);
semilogx(w,20*log10(sSi),'r',w,20*log10(sSo),'b',...
         w,20*log10(sSiW),'m',w,20*log10(sSoW),'c');
title('blue: S=(I+GK)^-1, red: S=(I+KG)^-1, (cyan,mag=weight)');
end

%------------------------------------------------------------------------%
% Input and output control sensitivity.

% step responses calculation of hloop2.
Mo=starp(G,mmult([eye(ni);eye(ni)],K,[-eye(no) eye(no)]),no,ni);
Mi=starp(K,mmult([eye(no);eye(no)],G,[-eye(ni) eye(ni)]),ni,no);

% frequency responses
sMo=vunpck(norm3(frsp(Mo,w)));mMo=max(sMo);
sMi=vunpck(norm3(frsp(Mi,w)));mMi=max(sMi);

rWMo=infnan2x(20*log10(min(sMoW./sMo)));
rWMi=infnan2x(20*log10(min(sMiW./sMi)));

if any(str=='d'),
figure;
subplot(2,1,1);
semilogx(w,20*log10(sMi),'r',w,20*log10(sMo),'b',...
         w,20*log10(sMiW),'m',w,20*log10(sMoW),'c');
title('blue: M=K(I+GK)^-1, red: M=G(I+KG)^-1, (cyan,mag=weight)');
end

%------------------------------------------------------------------------%
% Input and output complementary sensitivity 

To=starp(mmult([eye(no);eye(no)],G,K),[-eye(no) eye(no)],no,no);
Ti=starp(mmult([eye(ni);eye(ni)],K,G),[-eye(ni) eye(ni)],ni,ni);

% frequency responses
sTo=vunpck(norm3(frsp(To,w)));mTo=max(sTo);
sTi=vunpck(norm3(frsp(Ti,w)));mTi=max(sTi);

rWTo=infnan2x(20*log10(min(sToW./sTo)));
rWTi=infnan2x(20*log10(min(sTiW./sTi)));

if any(str=='d'),
subplot(2,1,2);
semilogx(w,20*log10(sTi),'r',w,20*log10(sTo),'b',...
         w,20*log10(sTiW),'m',w,20*log10(sToW),'c');
title('blue: T=GK(I+GK)^-1, red: T=KG(I+KG)^-1, (cyan,mag=weight)');
end

%------------------------------------------------------------------------%
% gain and phase margins:

gmho=max(1+1/mTo,mSo/(mSo-1));
gmlo=min(1-1/mTo,mSo/(mSo+1));
pho=180/pi*2*max(asin(1/2/mTo),asin(1/2/mSo));

gmhi=max(1+1/mTi,mSi/(mSi-1));
gmli=min(1-1/mTi,mSo/(mSi+1));
phi=180/pi*2*max(asin(1/2/mTi),asin(1/2/mSi));

if any(str=='d'),
disp(' ');
disp([ 'min(abs(det(I+GK)))    :  ' num2str(mdo) ]);
disp([ 'Output phase margin    :  ' num2str(pho) ]);
disp([ 'Output max gain margin :  ' num2str(gmho) ]);
disp([ 'Output min gain margin :  ' num2str(gmlo) ]);
disp([ 'Input phase margin     :  ' num2str(phi) ]);
disp([ 'Input max gain margin  :  ' num2str(gmhi) ]);
disp([ 'Input min gain margin  :  ' num2str(gmli) ]);
end

%------------------------------------------------------------------------%
% PZmaps

if any(str=='d'),

[AFo,BFo,CFo,DFo]=unpck(Fo);
[ASo,BSo,CSo,DSo]=unpck(So);
[AMo,BMo,CMo,DMo]=unpck(Mo);
[ATo,BTo,CTo,DTo]=unpck(To);

[AFi,BFi,CFi,DFi]=unpck(Fi);
[ASi,BSi,CSi,DSi]=unpck(Si);
[AMi,BMi,CMi,DMi]=unpck(Mi);
[ATi,BTi,CTi,DTi]=unpck(Ti);

figure;
subplot(2,2,1);pzmap(AFo,BFo,CFo,DFo);
title('GK');xlabel('');
subplot(2,2,2);pzmap(ASo,BSo,CSo,DSo);
title('(I+GK)^-1');ylabel('');xlabel('');
subplot(2,2,3);pzmap(AMo,BMo,CMo,DMo);
title('K(I+GK)^-1');
subplot(2,2,4);pzmap(ATo,BTo,CTo,DTo);
title('GK(I+GK)^-1');ylabel('');

figure;
subplot(2,2,1);pzmap(AFi,BFi,CFi,DFi);
title('KG');xlabel('');
subplot(2,2,2);pzmap(ASi,BSi,CSi,DSi);
title('(I+KG)^-1');xlabel('');ylabel('');
subplot(2,2,3);pzmap(AMi,BMi,CMi,DMi);
title('G(I+KG)^-1');
subplot(2,2,4);pzmap(ATi,BTi,CTi,DTi);
title('KG(I+KG)^-1');ylabel('');

end

%------------------------------------------------------------------------%
% poles drifting:

if any(str=='d'),

% open loop system
[Aol,Bol,Col,Dol]=unpck(starp(mmult([eye(no);eye(no)],G,K),...
                  [-0*eye(no) eye(no)],no,no));
figure;
pzmap(Aol,Bol,Col,Dol);hold on
title('closed loop poles drifting : from yellow to blue')

avm=[];
for q=0:.02:1,
    [Aq,Bq,Cq,Dq]=unpck(starp(mmult([eye(no);eye(no)],G,K),...
                  [-q*eye(no) eye(no)],no,no));
    avm=[avm eig(Aq)];	
end
l=size(avm,2);

for j=1:size(avm,1),
    plot(real(avm(j,1:l-1)),imag(avm(j,1:l-1)),'g.')
    plot(real(avm(j,l)),imag(avm(j,l)),'bx')
end

end

%------------------------------------------------------------------------%
% Both sensitivities: robust performance condition

if any(str=='m'),

% frequency responses
wm=logspace(-6,6,length(w)/2);

if ~isempty(SoW), sSoW=vunpck(norm3(frsp(SoW,wm))); else sSoW=wm'*NaN; end
if ~isempty(SiW), sSiW=vunpck(norm3(frsp(SiW,wm))); else sSiW=wm'*NaN; end
if ~isempty(MoW), sMoW=vunpck(norm3(frsp(MoW,wm))); else sMoW=wm'*NaN; end
if ~isempty(MiW), sMiW=vunpck(norm3(frsp(MiW,wm))); else sMiW=wm'*NaN; end
if ~isempty(ToW), sToW=vunpck(norm3(frsp(ToW,wm))); else sToW=wm'*NaN; end
if ~isempty(TiW), sTiW=vunpck(norm3(frsp(TiW,wm))); else sTiW=wm'*NaN; end

TSo=starp(mmult([eye(no);eye(no)],G),mmult(daug(K,eye(no)),...
          [eye(no);eye(no)],[-eye(no) eye(no) eye(no)]),no,ni);
TSi=starp(mmult([eye(ni);eye(ni)],K),mmult(daug(G,eye(ni)),...
          [eye(ni);eye(ni)],[-eye(ni) eye(ni) eye(ni)]),ni,no);

MSo=starp(G,mmult(daug([eye(ni);eye(ni)],eye(no)),daug(K,eye(no)),...
    [eye(no);eye(no)],[-eye(no) eye(no) eye(no)]),no,ni);
MSi=starp(K,mmult(daug([eye(no);eye(no)],eye(ni)),daug(G,eye(ni)),...
    [eye(ni);eye(ni)],[-eye(ni) eye(ni) eye(ni)]),ni,no);

sTSo=max(vunpck(mu(frsp(TSo,wm),[bTo;no no],'sU'))')';mTSo=max(sTSo);
sTSi=max(vunpck(mu(frsp(TSi,wm),[bTi;ni ni],'sU'))')';mTSi=max(sTSi);

sMSo=max(vunpck(mu(frsp(MSo,wm),[bMo;no no],'sU'))')';mMSo=max(sMSo);
sMSi=max(vunpck(mu(frsp(MSi,wm),[bMi;ni ni],'sU'))')';mMSi=max(sMSi);

sTSoW=max([sToW sSoW]')';sTSiW=max([sTiW sSiW]')';
rWTSo=infnan2x(20*log10(min(sTSoW./sTSo)));
rWTSi=infnan2x(20*log10(min(sTSiW./sTSi)));
   
sMSoW=max([sMoW sSoW]')';sMSiW=max([sMiW sSiW]')';
rWMSo=infnan2x(20*log10(min(sMSoW./sMSo)));
rWMSi=infnan2x(20*log10(min(sMSiW./sMSi)));

if any(str=='d'),
figure;
subplot(2,1,1);
semilogx(wm,20*log10(sTSi),'r',wm,20*log10(sTSo),'b',...
         wm,20*log10(sTSiW),'m',wm,20*log10(sTSoW),'c');
title('max(mu([T T; S S])); blue: output, red: input, (cyan,mag=weight)');
subplot(2,1,2);
semilogx(wm,20*log10(sMSi),'r',wm,20*log10(sMSo),'b',...
         wm,20*log10(sMSiW),'m',wm,20*log10(sMSoW),'c');
title('max(mu([M M; S S])); blue: output, red: input, (cyan,mag=weight)');
end

%------------------------------------------------------------------------%
% All sensitivities: ultimate robust performance condition

% frequency responses

M=starp(mmult(daug(eye(ni),[eye(no);-eye(no)]),daug(eye(ni),G),...
                      [eye(ni);eye(ni)],[eye(ni) eye(ni) eye(ni)]),...
        mmult(daug(eye(no),[eye(ni);+eye(ni)]),daug(eye(no),K),...
                      [eye(no);eye(no)],[eye(no) eye(no) eye(no)]),no,ni);
T=mmult(daug(eye(ni),...
        [zeros(ni,no) eye(ni); eye(no) zeros(no,ni)],eye(no)),M);

sM=max(vunpck(mu(frsp(M,wm),[ni ni;bMi;bMo;no no],'sU'))')';mM=max(sM);
sT=max(vunpck(mu(frsp(T,wm),[ni ni;bTi;bTo;no no],'sU'))')';mT=max(sT);

sMW=max([sMoW sSoW sMiW sSiW]')';
rWM=infnan2x(20*log10(min(sMW./sM)));

sTW=max([sSoW sToW sTiW sSiW]')';
rWT=infnan2x(20*log10(min(sTW./sT)));

if any(str=='d'),
figure;
subplot(2,1,1);
semilogx(wm,20*log10(sM),'y',wm,20*log10(sMW),'w');
title('max(mu(diag(Si Mi Mo So))) (white=weight)');
subplot(2,1,2);
semilogx(wm,20*log10(sT),'g',wm,20*log10(sTW),'w');
title('max(mu(diag(Si Ti To So))) (white=weight)');
end

else mMSo=0;mMSi=0;mTSo=0;mTSi=0;mM=0;mT=0;...
     rWMSo=0;rWMSi=0;rWTSo=0;rWTSi=0;rWM=0;rWT=0;
end

%------------------------------------------------------------------------%
% Maximum control signal: loop input = control input

[AMo,BMo,CMo,DMo]=unpck(Mo);mxuo=zeros(1,min(no,ni));
for n=1:min(no,ni);
[y,xs,t]=step(AMo,BMo(:,n),CMo(n,:),DMo(n,n));mxuo(n)=max(y);
end
mxuo=max(abs(mxuo));

%------------------------------------------------------------------------%
% Maximum control signal: loop input = plant input

[ATi,BTi,CTi,DTi]=unpck(Ti);mxui=zeros(1,ni);
for n=1:ni;
[y,xs,t]=step(ATi,BTi(:,n),CTi(n,:),DTi(n,n));mxui(n)=max(y);
end
mxui=max(abs(mxui));

%------------------------------------------------------------------------%
% Output Closed loop: from control input to plant output

Po=mmult([D C],To,[zeros(size(B)) eye(size(A))]');

%------------------------------------------------------------------------%
% Input Closed loop: from plant input to plant output

Pi=mmult([D C],Mi);

%------------------------------------------------------------------------%
% Displays main results on Po and Pi for w0=1e-2

if any(str=='p'),

w0=1e-2;
for ois=[ 'o' 'i' ],

eval([ 'sys=P' ois ';' ]);
[Ap,Bp,Cp,Dp]=unpck(sys);
[ty,no,ni,ns]=minfo(sys);
mrp=max(real(spoles(sys)));
mfp=max(abs(spoles(sys)));

if any(str=='d'),
  disp(' ');
  minfo(sys)
  disp(' ');
  disp([ 'Rank(ctrb(A,B)) : ' num2str(rank(ctrb(Ap,Bp),eps^2)) ]);
  disp([ 'Rank(obsv(A,C)) : ' num2str(rank(obsv(Ap,Cp),eps^2)) ]);
  
  Gc=gram3(Ap,Bp);
  Go=gram3(Ap',Cp');
  [Uc,Sc,Vc]=svd(Gc);
  [Uo,So,Vo]=svd(Go);
  cp=1./abs(sqrt(diag(pinv(Uc*Sc*Uc'))));
  op=1./abs(sqrt(diag(pinv(Uo*So*Uo'))));

  [ss,su] = sdecomp(sys,-1e-12);
  [tyu,nou,niu,nsu]=minfo(su);
    
  disp(' ');
  disp([ 'max eig : ' num2str(mrp) ]);
  disp([ 'unstable part : ' num2str(nsu) ' states.' ]);

  gsp=zeros(no,ni);
  for j=1:ni,
  for i=1:no,
    [a,b,c,d]=unpck(sel(ss,i,j));
    if size(a,1)==0, Gs=d;
    else Gs=c*inv(sqrt(-1)*w0*eye(size(a))-a)*b+d;
    end
    gsp(i,j)=abs(Gs);
  end
  end

  figure;

  subplot(2,2,1);
  pzmap(Ap,Bp,Cp,Dp);xlabel('');
  title([ 'P' ois ' poles & zeros' ]);

  subplot(2,2,2);
  sigma(Ap,Bp,Cp,Dp);xlabel('');
  title([ 'P' ois ' singular values' ]);

  subplot(2,2,3);
  semilogy(cp,'r');
  hold on
  semilogy(op,'b');
  xlabel('state');
  ylabel('ctrb (red), obsv (blue)');
  title([ 'P' ois ' ctrb & obsv gram. sv' ]);
  hold off

  subplot(2,2,4);
  if min(size(gsp))>1,contour(1:ni,-1:-1:-no,log10(gsp));end
  xlabel('input');ylabel('output');
  title([ 'max(svd(P' ois '(jw,i,j)))' ]);grid;
end

% settling time and overshoot for each channel
gp=Dp-Cp*inv(Ap)*Bp;

ts=zeros(no,ni);os=zeros(no,ni);ct=0;
if any(str=='d') & no<6 & ni<6, figure; end

for n1=1:no
for n2=1:ni

   ct=ct+1;
   [y,xs,t]=step(Ap,Bp(:,n2),Cp(n1,:),Dp(n1,n2));
   g0=gp(n1,n2);if g0<1e-1, g0=1; end

   ts(n1,n2)=max(t'.*(abs(y-g0)>.05*abs(g0)));
   os(n1,n2)=max(y-g0)/g0;
   
   if any(str=='d') & no<6 & ni<6,
     subplot(no,ni,ct);
     plot(t,y);
     if ct<=ni, title([ 'P' ois ' step' ]); end
   end

end
end

eval([ 'if min(size(ts))==1,ts' ois '=ts(1,1);else ts'...
        ois '=diag(ts); end' ]);
eval([ 'if min(size(os))==1,os' ois '=os(1,1);else os'...
        ois '=diag(os); end' ]);
eval([ 'mp' ois '=mrp;' ]);
eval([ 'mf' ois '=mfp;' ]);

end

if any(str=='d'),
disp(' ');
disp([ 'Maximum Po diagonal settling time : ' num2str(max(tso)) ]);
disp([ 'Maximum Po diagonal overshoot     : ' num2str(max(oso)) ]);
disp([ 'Maximum Pi diagonal settling time : ' num2str(max(tsi)) ]);
disp([ 'Maximum Pi diagonal overshoot     : ' num2str(max(osi)) ]);
end

else tso=0;tsi=0;oso=0;osi=0;mpo=0;mpi=0;mfo=0;mfi=0; end

%------------------------------------------------------------------------%
% M=[Si Si Mo Mo; Mi Mi To To; Ti Ti Mo Mo; Mi Mi So So];
% T=[Si Si Mo Mo; Ti Ti Mo Mo; Mi Mi To To; Mi Mi So So];
% results:

mv=[mFo mFi;		% max value of Fo and Fi over w
    mSo mSi;		% max value of So and Si over w
    mMo mMi;		% max value of Mo and Mi over w
    mTo mTi;		% max value of To and Ti over w

    rWFo rWFi;		% min ratio FoW/Fo and FiW/Fi over w
    rWSo rWSi;		% min ratio SoW/So and SiW/Si over w
    rWMo rWMi;		% min ratio MoW/Mo and MiW/Mi over w
    rWTo rWTi;		% min ratio ToW/To and TiW/Ti over w

    mTSo mTSi;		% max mu{diag(D,D)} of [To To;So So] (i) over w
    mMSo mMSi;		% max mu{diag(D,D)} of [Mo Mo;So So] (i) over w
    mM mT;		% max mu{diag(D,D,D,D)} of M and T over w
    rWTSo rWTSi;	% min ratio diag(ToW,SoW)/mu[To To;So So](i) over w
    rWMSo rWMSi;	% min ratio diag(MoW,SoW)/mu[Mo Mo;So So](i) over w
    rWM rWT;		% min ratio diag(SiW,MiW,MoW,SoW)/mu(M) over w
			% and min ratio diag(SiW,TiW,ToW,SoW)/mu(T) over w

    gmho gmhi;		% max output and input gain margin
    gmlo gmli;		% min output and input gain margin
    pho phi;		% output and input phase margin
    mdo mdo;		% min value of det(I+GK)=det(I+KG) over w

    mpo mpi;		% max realpart pole of Po,Pi
    mfo mfi;		% max magnitude pole of Po,Pi
    mxuo mxui;		% max control signal on a step in Po,Pi
    max(tso) max(tsi);	% max settling time on a step in Po,Pi
    max(oso) max(osi)];	% max overshoot on a step in Po,Pi
