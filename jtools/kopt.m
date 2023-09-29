function [K,x]=kopt(G,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi)

% [K,x]=kopt(G,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi); optimized controller
% G is the system to be controlled, bMo, bMi, bTo, bTi 
% are the uncertainity structures of Mo, Mi, To, Ti.
% The file khelps.m contains details on the arguments meaning.
% 
% If necessary adjust the cost function in kcost, or the max
% number of steps and the starting point here in kopt.
% K is the controller to be connected in negative feedback.
% press several times ^C to stop the program.

% G. Campa 24-2-96.

[ty,no,ni,ns]=minfo(G);

if nargin<10,bTi=[ni ni]; elseif isempty(bTi), bTi=[ni ni]; end
if nargin<9,bTo=[no no]; elseif isempty(bTo), bTo=[no no]; end
if nargin<8,bMi=[ni no]; elseif isempty(bMi), bMi=[ni no]; end
if nargin<7,bMo=[no ni]; elseif isempty(bMo), bMo=[no ni]; end

if nargin<6,lrg=[];end

if nargin<5, cost=[1 1e-2 100 1]; end

if nargin<4,kstr='hi3';end
if nargin<3,wstr='ae';end
if nargin<2,pstr='0tr';end

ct=0;
F=inf;
X=zeros(2,4);
%G=sys2sys(G);

options=[];
options(1)=1;                         % displays some results
options(2)=1e-1;                      % term tolerance for x
options(3)=1e-1;                      % term tolerance for f
options(14)=60;                       % # max iterazioni

% SYSTEM PASSBAND AND GAIN
w=logspace(-6,6,100);
fr=20*log10(vunpck(norm3(frsp(G,w))));
cn=20*log10(vunpck(vcond(frsp(G,w))));
k0=mean(fr(1:10));
bd=log10(max(w'.*((k0-fr)<3)));
k1=mean(cn(1:10)-fr(1:10));


% STARTING POINT :

% default

if any(pstr=='m') | any(pstr=='a'),
 x=[(k1+k0)/2 min(max(-2,bd),2)]';
elseif  any(pstr=='t'),
 x=[min(max(0,k0),10) min(max(-2,bd),2)]';
else
 x=[0 0]';
end
if kstr([1 2])=='lq' | kstr([1 2])=='pl', x=[0 0]'; end

% Lower and Upper BOUNDS :

if any(pstr=='m') | any(pstr=='a'),
  vlb=[min(k1,x(1)-20) -4]';vub=[max(k0,x(1)+20)  4]';
elseif  any(pstr=='t'),
  vlb=[0 -4]';vub=[x(1)+10 4]';
else
  vlb=x-[4 4]';vub=x+[4 4]';
end
if kstr=='lqg' | kstr=='plc', vlb=x-[4 4]';vub=x+[4 4]'; end

%---------------------------------------------------------------------------%
% THIS IS FOR THE STARTING POINT,
% CAN BE SKIPPED IF YOU ALREADY KNOW A GOOD ONE.
% (or if there are problems near the edges). 

% central point
eval('[f,g,K,X,F]=kmaker(x,G,''p'',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);','');
% each hypercube vertex (4 points)
stp1=(vub(1)-vlb(1))/5;
for i1=[vlb(1)+stp1 vub(1)-stp1],
  stp2=(vub(2)-vlb(2))/5;
  for i2=[vlb(2)+stp2 vub(2)-stp2],
	x=[i1 i2];
	eval('[f,g,K,X,F]=kmaker(x,G,''p'',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);',...
             'f=Inf;g=Inf;');
        ct=ct+1,
  end
end

%---------------------------------------------------------------------------%

%---------------------------------------------------------------------------%
% Pre minimization: (30 steps)
% 
 exestr=[ '[f,g,K,X,F]=kmaker([X1(i,j);X2(i,j)],' ... 
          'G,''p'',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);' ];
 [X1,X2]=meshgrid(linspace(vlb(1),vub(1),5),linspace(vlb(2),vub(2),6));
 Fx=zeros(size(X1));
 for i=1:size(X1,1);
   for j=1:size(X1,2);
       eval(exestr,'f=Inf;g=Inf;');
       if any(g>0), Fx(i,j)=NaN; else Fx(i,j)=f; end
       ct=ct+1,
   end
 end
 figure;surf(X1,X2,Fx);grid;xlabel('Magnitude');ylabel('Frequency');
%---------------------------------------------------------------------------%

%---------------------------------------------------------------------------%
% random jumping around best point (100 steps)
% x=X(:,1);
% exestr='[f,g,K,X,F]=kmaker(x,G,''p'',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);';
% while ct < 154,
% eval(exestr,'x=X(:,1)+rand(size(X(:,1)));');
% ct=ct+1,
% end
%---------------------------------------------------------------------------%


%---------------------------------------------------------------------------%
% MINIMIZATION :
x=X(:,1);
x=constr('kmaker',x,options,vlb,vub,[],G,'p',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
%---------------------------------------------------------------------------%

[f,g,K]=kmaker(x,G,'dpm',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi);
