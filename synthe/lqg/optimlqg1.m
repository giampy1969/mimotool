function optimlqg1
%OPTIMLQG1 : calcolo del controllore ottimo LQG
%
%
% Massimo DAvini 27/02/99 --- revised 03/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

x1=str2num(get(findobj('tag','editlqg1'),'string'));
x2=str2num(get(findobj('tag','editlqg2'),'string'));

if isempty(x1)|(~isreal(x1))|(x1<0) messag(gcf,'pi');return;end;
if isempty(x2)|(~isreal(x2))|(x2<0) messag(gcf,'pi');return;end;


%---prosegue se i parametri inseriti sono validi------

watchon;

delgraf;
delete(findobj('tag','inf'));
drawnow;

set(findobj('tag','BEVAL'),'enable','off');
set(findobj('tag','BSIMU'),'enable','off');
stack.evaluation=[];stack.simulation=[];
stack.general.K_flag=0;

inf=uicontrol('style','text','units','normalized','position',[0.57 0.3 0.38 0.5],...
   'fontunits','normalized','fontsize',0.08,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
   'HorizontalAlignment','left','tag','inf','visible','off',...
   'string','It''s IMPOSSIBLE to find a controller : see Matlab Command Window for details .');

%----------------------
x=[x1;x2];
%----------------------
G=stack.temp.plant;
[ty no ni ns]=minfo(G);
%----------------------
lettera1=num2str(stack.temp.integratori);
pstr=sprintf('%str',lettera1);      
%----------------------
kstr='lqg';
%----------------------
wstr='ae';                  
%----------------------
cost=stack.temp.pesi;
%----------------------
bTi=[ni ni];
bTo=[no no];
bMi=[ni no];
bMo=[no ni];
%----------------------
lrg=[];
%----------------------


%----------INIZIO OTTIMIZZAZIONE-------------
%-----------------------------
%-----OPTIMIZATION------------
%-----------------------------
ct=0;
F=inf;
X=zeros(2,4);

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

vlb=x-[4 4]';vub=x+[4 4]';

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
%---------------------------------------------------------------------------%
set(gca,'position',[.41 .27 .52 .68]);
surf(X1,X2,Fx);xlabel('Magnitude','fontsize',8);ylabel('Frequency','fontsize',8);
set(gca,'tag','grafico');
crea_pop(0,'crea');
drawnow;

watchon;
stack.temp.X1=X1;
stack.temp.X2=X2;
stack.temp.Fx=Fx;

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
%x=X(:,1);
%x=constr('kmaker',x,options,vlb,vub,[],G,'p',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
%---------------------------------------------------------------------------%

%[f,g,K]=kmaker(x,G,'p',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi);

try,
  % MINIMIZATION :
  x=X(:,1);
  x=constr('kmaker',x,options,vlb,vub,[],G,'p',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
  %---------------------------------------------------------------------------%
  K=[];g=[];f=[];
  [f,g,K]=kmaker(x,G,'p',pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi);
catch, K=[];
   delgraf;
   drawnow;
   set(inf,'visible','on');
   watchoff;
   return;
end;

watchon;
if ~isempty(K)
  set(findobj('tag','simu_2'),'enable','on');
  set(findobj('tag','eval_31'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  stack.general.K_flag=1;
   
  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='lqg';      %tipo del regolatore 
  stack.evaluation.K=K;             %regolatore
  stack.evaluation.plant=G;         %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='lqg';  %tipo del regolatore 
  stack.simulation.Ak=Ak;       %regolatore
  stack.simulation.Bk=Bk;       %regolatore
  stack.simulation.Ck=Ck;       %regolatore
  stack.simulation.Dk=Dk;       %regolatore
  if rank(stack.general.A)==size(stack.general.A,1)
     G0=stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D;
     stack.simulation.pinvG0=pinv(G0);
  else 
     stack.simulation.pinvG0=zeros(size(stack.general.D'));
  end;

  set(findobj('tag','file_6'),'enable','on');
  set(findobj('tag','BEVAL'),'enable','on');
  set(findobj('tag','BSIMU'),'enable','on');
  drawnow;
  
else
   delgraf;
   drawnow;
   set(inf,'visible','on');
end;
watchoff;



