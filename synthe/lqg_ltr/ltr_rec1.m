function ltr_rec1;
% LTR_REC1 : calcolo dei controllori necessari 
%            nella fase di recupero di un controllo LQG\LTR
%
% In base alla posizione dell'incertezza (ingresso o uscita)
% il recupero è KFB o LQ ; a seconda dei due casi vengono 
% calcolate,graficate e salvate in stack.temp le seguenti
% variabili :
% sintesi LQ e recupero KFB   --> Kf,K(s)G(s)   
% sintesi KFB e recupero LQ   --> Kc,G(s)K(s)
%
% con G(s) sistema originale e K(s) compensatore dinamico
%
% Massimo Davini 20/10/99
global stack;

watchon;
set(findobj('tag','inf2'),'visible','off');
set(findobj('tag','BNext12'),'enable','off');
drawnow;

%---------------------------------------------------
%settaggio del minimo e del massimo per la barra
%se sono stati modificati i campi edit relativi
mi=str2num(get(findobj('tag','rangemink'),'string'));
ma=str2num(get(findobj('tag','rangemaxk'),'string'));

if isempty(mi) | isempty(ma) | ~isreal(mi) | ~isreal(ma) | mi >= ma
   set(findobj('tag','rangemink'),'string',num2str(0));
   set(findobj('tag','rangemaxk'),'string',num2str(3));  
   set(findobj('tag','editq'),'string',num2str(1));
   drawnow;
   set(findobj('tag','barra_rec'),'min',0,'max',3,'value',1);
elseif mi~=get(findobj('tag','barra_rec'),'min') |...
       ma~=get(findobj('tag','barra_rec'),'max')
   set(findobj('tag','barra_rec'),'value',mi);
   set(findobj('tag','barra_rec'),'min',mi,'max',ma);
   set(findobj('tag','editq'),'string',num2str(10^mi));
end;   

drawnow;
q=10^(get(findobj('tag','barra_rec'),'value'));
set(findobj('tag','editq'),'string',num2str(q));
 
%---------------------------------------------------
r=str2num(get(findobj('tag','editr'),'string'));
if isempty(r) | ~isreal(r) | r<=0
   set(findobj('tag','editr'),'string',num2str(1));r=1;
end;
drawnow;
%---------------------------------------------------
w=stack.temp.w;
[A,B,C,D]=unpck(stack.temp.plant);
ap=stack.general.A;
bp=stack.general.B;
cp=stack.general.C;

if strcmp(stack.temp.incer,'in') tipo=1;else tipo=2;end;
switch tipo
case 1
   
   Kc=stack.temp.Kc;
   if stack.temp.integratori>0
        qo=[bp;zeros(size(A,1)-size(ap,1),size(bp,2))];
        Q0=qo*qo';
   else Q0=B*B';
   end;
   Q1=B*B';

   try, Kf=lqr(A',C',Q0+q*q*Q1,r*eye(size(C',2)));vai=1;
   catch,vai=0;
   end;
   if vai
      Kf=Kf';
      K=pck(A-B*Kc-Kf*C,Kf,Kc,zeros(size(Kc,1),size(Kf,2)));

      %se il sistema è stato aumentato è necessario riconsiderare
      %il sistema iniziale e aggiungere gli integratori al K(s) :
      %in questo caso li devo aggiungere in ingresso al K
      n=stack.temp.integratori;
      if n > 0
        [ty,no,ni,ns]=minfo(stack.temp.sys);
        Ai=zeros(ni);Bi=eye(ni);Ci=eye(ni);Di=zeros(ni);
        P=pck(Ai,Bi,Ci,Di);
        for i=1:n K=mmult(P,K);end;
      end;
   
      GK_KG=mmult(stack.temp.sys,K);
      [akg,bkg,ckg,dkg]=unpck(GK_KG);
      KG=sigma(akg,bkg,ckg,dkg,w);
      s=size(KG,1);
      if s > 1 sv_GKKG=[20*log10(KG(1,:));20*log10(KG(2,:))];
      else sv_GKKG=20*log10(KG(1,:));end;
   else
      sv_GKKG=nan;Kf=[];K=[];GK_KG=nan;
      set(findobj('tag','BNext12'),'enable','off');
      set(findobj('tag','inf2'),'visible','on');
   end;

   stack.temp.Kf=Kf;   
   if ~isempty(Kf) set(findobj('tag','BNext12'),'enable','on');end;
   
case 2
   
   Kf=stack.temp.Kf;
   if stack.temp.integratori>0
        qo=[cp zeros(size(cp,1),size(A,1)-size(ap,1))];
        Q0=qo'*qo;
   else Q0=C'*C;
   end;
   Q1=C'*C;
   try, Kc=lqr(A,B,Q0+q*q*Q1,r*eye(size(B,2)));vai=1;
   catch,vai=0;
   end;
   if vai
      K=pck(A-B*Kc-Kf*C,Kf,Kc,zeros(size(Kc,1),size(Kf,2)));

      %se il sistema è stato aumentato è necessario riconsiderare
      %il sistema iniziale e aggiungere gli integratori al K(s) :
      %in questo caso li devo aggiungere in ingresso al K
      n=stack.temp.integratori;
      if n > 0
        [ty,no,ni,ns]=minfo(stack.temp.sys);
        Ai=zeros(no);Bi=eye(no);Ci=eye(no);Di=zeros(no);
        P=pck(Ai,Bi,Ci,Di);
        for i=1:n,  K=mmult(K,P);end;
      end;
   
      GK_KG=mmult(K,stack.temp.sys);
      [akg,bkg,ckg,dkg]=unpck(GK_KG);
      GK=sigma(akg,bkg,ckg,dkg,w);
      s=size(GK,1);
      if s > 1 sv_GKKG=[20*log10(GK(1,:));20*log10(GK(2,:))];
      else sv_GKKG=20*log10(GK(1,:));end;
   else
      sv_GKKG=nan;Kc=[];K=[];GK_KG=nan;
      set(findobj('tag','BNext12'),'enable','off');
      set(findobj('tag','inf2'),'visible','on');
   end;

   stack.temp.Kc=Kc;   
   if ~isempty(Kf) set(findobj('tag','BNext12'),'enable','on');end;
   
end;

stack.temp.K=K; 
stack.temp.GK_KG=GK_KG;
stack.temp.sv_GKKG=sv_GKKG;

%grafico
delete(findobj('tag','plot_GKKG'));
set(gca,'drawmode','fast','nextplot','add');
semilogx(w,sv_GKKG,'b','tag','plot_GKKG');
set(gca,'nextplot','replace');
drawnow;

watchoff;