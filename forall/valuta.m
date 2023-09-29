function valuta
%VALUTA : finestra di valutazione per ogni controllore
%
%(tutti i parametri necessari alla valutazione vengono
% prelevati o inseriti da o in stack.evaluation)
%
%
%Massimo Davini 17/02/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
delete(findobj('tag','matrice'));
delgraf;
delete(findobj('tag','inf'));

for i=1:33 set(findobj('tag',sprintf('eval_%u',i)),'enable','on');end;
set(findobj('tag','eval_31'),'visible','off');

%se i poli del sistema sono maggiori di 20 ,il comando del menu
%evaluation relativo alla loro visualizzazione è disabilitato
if size(stack.general.A,1)>20 
   set(findobj('tag','eval_33'),'enable','off');
end;

if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
  % =>la directory di lavoro è dentro synthe
  set(stack.temp.handles,'visible','off');
  dir_back=stack.evaluation.kind;
  if strcmp(get(findobj('tag','BREG'),'string'),'START OPTIMIZATION')|...
        strcmp(get(findobj('tag','BREG'),'string'),'START')
     dir_back=[dir_back,'_opt'];
  end;
else
   % =>la directory di lavoro è model
   set(findobj('tag','FrameA'),'visible','off');
   set(findobj('tag','FrameB'),'visible','off');
   set(findobj('tag','FrameC'),'visible','off');
   set(findobj('tag','FrameD'),'visible','off');
   set(findobj('tag','bottA'),'visible','off');
   set(findobj('tag','bottB'),'visible','off');
   set(findobj('tag','bottC'),'visible','off');
   set(findobj('tag','bottD'),'visible','off');
   set(findobj('tag','bottNew'),'visible','off');
   set(findobj('tag','bottLoad'),'visible','off');
   set(findobj('tag','BottAna'),'visible','off');
   set(findobj('tag','BottSyn'),'visible','off');
   set(findobj('tag','file_2'),'enable','off');
   set(findobj('tag','file_3'),'enable','off');
   set(findobj('tag','file_5'),'enable','off');
   set(findobj('tag','file_6'),'enable','off');
   set(findobj('tag','file_7'),'enable','off');
   set(findobj('tag','tools_1'),'enable','off');
%   for i=2:10 set(findobj('tag',sprintf('tools_%u',i)),'enable','off');end;
   
   dir_back='model';
end;
drawnow;

titolo=upper(stack.evaluation.kind);
if     strcmp(titolo,'HI') titolo='H - INFINITY';
elseif strcmp(titolo,'H2') titolo='H - 2';
elseif strcmp(titolo,'HMIX') titolo='H - MIX';
elseif strcmp(titolo,'LQS') titolo='LQ - SERVO';
end;
set(gcf,'Name',sprintf(' MIMO Tool : EVALUATION %s --> %s',stack.general.model,titolo));

sizetext=.8;

eva(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
    'fontunits','normalized','fontsize',.35,'fontweight','bold',...
    'string','BACK','Horizontalalignment','center','tag','eva',...
    'TooltipString','Back to the previous SYNTHESIS window',...
    'callback',sprintf('back_eval(''%s'',''back'');',dir_back)); 
 
eva(2)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
    'fontunits','normalized','fontsize',.35,'fontweight','bold',...
    'string','CLOSE','Horizontalalignment','center','tag','eva',...
    'TooltipString','Back to the main SYNTHESIS window','userdata',sprintf('eval(''back_eval(''''%s'''',''''close'''');'')',dir_back),...
    'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''close'');else back_eval(''%s'',''close'');end;',dir_back));
if strcmp(dir_back,'model') set(eva(2),'enable','off');end;

eva(3)=uicontrol('style','Frame','units','normalized','position',[0.39 0.05 0.56 0.12],...
   'backgroundcolor',[1 1 1],'tag','eva','visible','off');

eva(4)=uicontrol('style','text','units','normalized','position',[0.46 0.115 0.48 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0],...
   'HorizontalAlignment','center','string','Po = To = inv( I+GK )*GK',...
   'tag','eva','visible','off');

eva(5)=uicontrol('style','text','units','normalized','position',[0.46 0.055 0.48 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0],...
   'HorizontalAlignment','center','string','Pi = Mi =  G*inv( I+KG )',...
   'tag','eva','visible','off');

drawnow;

stack.evaluation.grafici=[];

%inizializzazione di alcuni parametri aggiuntivi
SoW=[];SiW=[];MoW=[];MiW=[];ToW=[];TiW=[];
bMo=[];bMi=[];bTo=[];bTi=[];
FoW=[];FiW=[];



switch stack.evaluation.kind
   
  case {'hi','h2','hmix'}
     G=stack.evaluation.plant;
     K=stack.evaluation.K;
     pstr=stack.evaluation.pstr;
     x=stack.evaluation.X1X2;
     wstr=stack.evaluation.wstr;

  case 'mu'
     G=stack.evaluation.plant;
     K=stack.evaluation.K;
     pstr=stack.evaluation.pstr;
     x=stack.evaluation.X1X2;
     wstr=stack.evaluation.wstr;
     bTo=stack.evaluation.bTo;
     bMo=stack.evaluation.bMo;
     bTi=stack.evaluation.bTi;
     bMi=stack.evaluation.bMi;

 otherwise
     G=stack.evaluation.plant;
     K=stack.evaluation.K;

end;


%---------------------------------------------------------
%---------------------------------------------------------
%IL CODICE SEGUENTE E' STATO COPIATO DAL FILE KEVAL.M DEL
%JTOOLS PER POTER GRAFICARE I RISULTATI DELLA VALUTAZIONE,
%SULL'INTERFACCIA GRAFICA,SEPARATAMENTE L'UNO DALL'ALTRO .
%---------------------------------------------------------
%---------------------------------------------------------

w=logspace(-6,6,120);
[ty,no,ni,ns]=minfo(G);

%---------------------------------------------------------
kind=stack.evaluation.kind;
if strcmp(kind,'h2')|strcmp(kind,'hi')|strcmp(kind,'hmix')

   % frequency vector and response
   fr=20*log10(vunpck(norm3(frsp(G,w)))); 
   k0=mean(fr(1:10));
   bd=log10(max(w'.*((k0-fr)<3)));

   %---------------------------------------------
   % weighted plant and uncertainity construction

   %basic plant construction
   plant=pmaker(G,pstr);[a b c d]=unpck(plant);

   if pstr(2)=='m', 

     % sensitivity weighting
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2)+bd/20,3,no);

     % control sensitivity weighting
     if wstr(2)=='e' & ~any(any(d(1:ni,:))),
       MoW=fotf(inf,x(2),x(1),ni);
     else
       [MoW,MoD]=fotf(min(6,x(2)+3),x(2),x(1),ni);
     end;

     ToW=[];ToD=[];TiW=[];TiD=[];

   elseif pstr(2)=='t',

     % sensitivity weighting
     [SoW,SoD]=fotf(max(-6,x(2)-3),x(2),x(1),no);

     % complementary sensitivity weighting
     if wstr(2)=='e' & ~any(any(d(1:no,:))),
        ToW=fotf(inf,x(2),x(1),no);
     else
        [ToW,ToD]=fotf(min(6,x(2)+3),x(2),x(1),no);
     end;

     MoW=[];MoD=[];MiW=[];MiD=[];
   end;

end;
%---------------------------------------------------------

if isempty(bTi),bTi=[ni ni];end
if isempty(bTo),bTo=[no no];end
if isempty(bMi),bMi=[ni no];end
if isempty(bMo),bMo=[no ni];end

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
%------------------------------------------------------------------------%
% Input ant output sensitivity.
So=starp(mmult(G,K),mmult([eye(no);eye(no)],[-eye(no),eye(no)]),no,no);
Si=starp(mmult(K,G),mmult([eye(ni);eye(ni)],[-eye(ni),eye(ni)]),ni,ni);

% frequency responses
sSo=vunpck(norm3(frsp(So,w)));mSo=max(sSo);
sSi=vunpck(norm3(frsp(Si,w)));mSi=max(sSi);
%------------------------------------------------------------------------%
% Input and output control sensitivity.

% step responses calculation of hloop2.
Mo=starp(G,mmult([eye(ni);eye(ni)],K,[-eye(no) eye(no)]),no,ni);
Mi=starp(K,mmult([eye(no);eye(no)],G,[-eye(ni) eye(ni)]),ni,no);

% frequency responses
sMo=vunpck(norm3(frsp(Mo,w)));mMo=max(sMo);
sMi=vunpck(norm3(frsp(Mi,w)));mMi=max(sMi);
%------------------------------------------------------------------------%
% Input and output complementary sensitivity 

To=starp(mmult([eye(no);eye(no)],G,K),[-eye(no) eye(no)],no,no);
Ti=starp(mmult([eye(ni);eye(ni)],K,G),[-eye(ni) eye(ni)],ni,ni);

% frequency responses
sTo=vunpck(norm3(frsp(To,w)));mTo=max(sTo);
sTi=vunpck(norm3(frsp(Ti,w)));mTi=max(sTi);
%------------------------------------------------------------------------%
% gain and phase margins:

gmho=max(1+1/mTo,mSo/(mSo-1));
gmlo=min(1-1/mTo,mSo/(mSo+1));
pho=180/pi*2*max(asin(1/2/mTo),asin(1/2/mSo));

gmhi=max(1+1/mTi,mSi/(mSi-1));
gmli=min(1-1/mTi,mSo/(mSi+1));
phi=180/pi*2*max(asin(1/2/mTi),asin(1/2/mSi));

%------------------------------------------------------------------------%
% PZmaps

[AFo,BFo,CFo,DFo]=unpck(Fo);
[ASo,BSo,CSo,DSo]=unpck(So);
[AMo,BMo,CMo,DMo]=unpck(Mo);
[ATo,BTo,CTo,DTo]=unpck(To);

[AFi,BFi,CFi,DFi]=unpck(Fi);
[ASi,BSi,CSi,DSi]=unpck(Si);
[AMi,BMi,CMi,DMi]=unpck(Mi);
[ATi,BTi,CTi,DTi]=unpck(Ti);

%------------------------------------------------------------------------%
% poles drifting:
% open loop system
[Aol,Bol,Col,Dol]=unpck(starp(mmult([eye(no);eye(no)],G,K),...
                  [-0*eye(no) eye(no)],no,no));

avm=[];
for q=0:.02:1,
    [Aq,Bq,Cq,Dq]=unpck(starp(mmult([eye(no);eye(no)],G,K),...
                  [-q*eye(no) eye(no)],no,no));
    avm=[avm eig(Aq)];	
end
l=size(avm,2);


%---------------------------------------
%inserimenti in stack.evaluation.grafici
%---------------------------------------

stack.evaluation.grafici.w=w;    

%per il grafico con indice 1
stack.evaluation.grafici.dIFo=dIFo;    

%per il grafico con indice 2
stack.evaluation.grafici.sFi=sFi;    
stack.evaluation.grafici.sFo=sFo;    
stack.evaluation.grafici.sFiW=sFiW;    
stack.evaluation.grafici.sFoW=sFoW;    

%per il grafico con indice 3
stack.evaluation.grafici.sSi=sSi;    
stack.evaluation.grafici.sSo=sSo;    
stack.evaluation.grafici.sSiW=sSiW;    
stack.evaluation.grafici.sSoW=sSoW;    

%per il grafico con indice 4
stack.evaluation.grafici.sMi=sMi;    
stack.evaluation.grafici.sMo=sMo;    
stack.evaluation.grafici.sMiW=sMiW;    
stack.evaluation.grafici.sMoW=sMoW;    

%per il grafico con indice 5
stack.evaluation.grafici.sTi=sTi;    
stack.evaluation.grafici.sTo=sTo;    
stack.evaluation.grafici.sTiW=sTiW;    
stack.evaluation.grafici.sToW=sToW;    

%per il grafico con indice 6
stack.evaluation.grafici.mdo=mdo;    
stack.evaluation.grafici.pho=pho;    
stack.evaluation.grafici.gmho=gmho;    
stack.evaluation.grafici.gmlo=gmlo;    
stack.evaluation.grafici.phi=phi;    
stack.evaluation.grafici.gmhi=gmhi;    
stack.evaluation.grafici.gmli=gmli;    

%per il grafico con indice 7
stack.evaluation.grafici.AFo=AFo;
stack.evaluation.grafici.BFo=BFo;
stack.evaluation.grafici.CFo=CFo;
stack.evaluation.grafici.DFo=DFo;
stack.evaluation.grafici.ASo=ASo;
stack.evaluation.grafici.BSo=BSo;
stack.evaluation.grafici.CSo=CSo;
stack.evaluation.grafici.DSo=DSo;
stack.evaluation.grafici.AMo=AMo;
stack.evaluation.grafici.BMo=BMo;
stack.evaluation.grafici.CMo=CMo;
stack.evaluation.grafici.DMo=DMo;
stack.evaluation.grafici.ATo=ATo;
stack.evaluation.grafici.BTo=BTo;
stack.evaluation.grafici.CTo=CTo;
stack.evaluation.grafici.DTo=DTo;

%per il grafico con indice 8
stack.evaluation.grafici.AFi=AFi;
stack.evaluation.grafici.BFi=BFi;
stack.evaluation.grafici.CFi=CFi;
stack.evaluation.grafici.DFi=DFi;
stack.evaluation.grafici.ASi=ASi;
stack.evaluation.grafici.BSi=BSi;
stack.evaluation.grafici.CSi=CSi;
stack.evaluation.grafici.DSi=DSi;
stack.evaluation.grafici.AMi=AMi;
stack.evaluation.grafici.BMi=BMi;
stack.evaluation.grafici.CMi=CMi;
stack.evaluation.grafici.DMi=DMi;
stack.evaluation.grafici.ATi=ATi;
stack.evaluation.grafici.BTi=BTi;
stack.evaluation.grafici.CTi=CTi;
stack.evaluation.grafici.DTi=DTi;

%per il grafico con indice 9
stack.evaluation.grafici.Aol=Aol;
stack.evaluation.grafici.Bol=Bol;
stack.evaluation.grafici.Col=Col;
stack.evaluation.grafici.Dol=Dol;
stack.evaluation.grafici.avm=avm;
stack.evaluation.grafici.l=l;


%----------------------------------------------------------------------
%//////////////////////////////////////////////////////////////////////
%----------------------------------------------------------------------
if stack.general.adv_flag==0
   
   set(findobj('tag','eval_12'),'enable','off');
   set(findobj('tag','eval_13'),'enable','off');
   sTSi=[];sTSo=[];sTSiW=[];sTSoW=[];sMSiW=[];sMSoW=[];wm=[];
   sMSi=[];sMSo=[];sM=[];sMW=[];sT=[];sTW=[];
   
else   
   %-------------------------------------------------
   % Both sensitivities: robust performance condition
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
   %---------------------------------------------------------
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
end;
      
      
%----------------------------------------------------------------------
%//////////////////////////////////////////////////////////////////////
%----------------------------------------------------------------------

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

Po=To;
[tyo,noo,nio,nso]=minfo(Po);
%if noo*nio>12 set(evalu(17),'label',sprintf('Po (12 of %u)',noo*nio));end;

%------------------------------------------------------------------------%
% Input Closed loop: from plant input to plant output

Pi=Mi;
[tyi,noi,nii,nsi]=minfo(Pi);
%if noi*nii>12 set(evalu(18),'label',sprintf('Pi (12 of %u)',noi*nii));end;


%----------------------------------------------------------------
%inserimenti in stk_eval per i grafici richiamabili tramite menu

%per il grafico con indice 10 e 11
stack.evaluation.grafici.sTSi=sTSi;
stack.evaluation.grafici.sTSo=sTSo;
stack.evaluation.grafici.sTSiW=sTSiW;
stack.evaluation.grafici.sTSoW=sTSoW;
stack.evaluation.grafici.sMSiW=sMSiW;
stack.evaluation.grafici.sMSoW=sMSoW;
stack.evaluation.grafici.wm=wm;
stack.evaluation.grafici.sMSi=sMSi;
stack.evaluation.grafici.sMSo=sMSo;
stack.evaluation.grafici.sM=sM;
stack.evaluation.grafici.sMW=sMW;
stack.evaluation.grafici.sT=sT;
stack.evaluation.grafici.sTW=sTW;

%per i grafici con indice 12 --> 30
stack.evaluation.grafici.Po=Po;
stack.evaluation.grafici.Pi=Pi;

valuta1(1);


