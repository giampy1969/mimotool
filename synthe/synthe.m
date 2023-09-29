function synthe
% Callback del bottone SYNTHESIS 
% apre la finestra principale di Sintesi.
%
%
% Massimo Davini 09/05/99 --- revised 07/12/99
global stack;

%-----------------------------------------------------------
%abilitazione e disabilitazione comandi della barra dei menù
set(findobj('tag','tools_1'),'enable','off');
set(findobj('tag','view_1'),'enable','off');
set(findobj('tag','anal_1'),'enable','off');
set(findobj('tag','synt_1'),'enable','on');
set(findobj('tag','opti_1'),'enable','on');
set(findobj('tag','eval_1'),'enable','on');
set(findobj('tag','simu_1'),'enable','on');

%----------- OUTPUT FEEDBACK-------------
%----------------------------------------

for j=1:3,for i=1:3       %3 righe x 3 bottoni
    BottOF(i+3*(j-1))=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
   'visible','off','tag','syn0',...
   'position',[.05+.31*(i-1) .78-.11*(j-1) .28 .08]);
end;end; 
%i due bottoni seguenti possono essere usati per altri tipi di controllo
delete(BottOF(8));delete(BottOF(9));

set(BottOF(1),'string','H - INFINITY','callback','o_feed0(''H - INFINITY'');',...
   'TooltipString',sprintf('Start H-INFINITY regulator synthesis for %s',stack.general.model));
set(BottOF(2),'string','H - 2','callback','o_feed0(''H - 2'');',...
   'TooltipString',sprintf('Start H-2 regulator synthesis for %s',stack.general.model));
set(BottOF(3),'string','H - MIX','callback','o_feed0(''H - MIX'');',...
   'TooltipString',sprintf('Start H-MIX regulator synthesis for %s',stack.general.model));
set(BottOF(4),'string','MU','callback','o_feed0(''MU'');',...
   'TooltipString',sprintf('Start MU regulator synthesis for %s',stack.general.model));
set(BottOF(5),'string','LQG','callback','o_feed0(''LQG'');',...
   'TooltipString',sprintf('Start LQG regulator synthesis for %s',stack.general.model));
set(BottOF(6),'string','LQG \ LTR',...
   'TooltipString',sprintf('Start LQG-LTR regulator synthesis for %s',stack.general.model));
set(BottOF(7),'string','PID','callback','o_feed0(''PID'');',...
   'TooltipString',sprintf('Start PID regulator synthesis for %s',stack.general.model));

%----------- STATE FEEDBACK -------------
%----------------------------------------

for j=4:5,for i=1:3       %2 righe x 3 bottoni
    BottSF(i+3*(j-4))=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
   'visible','off','tag','syn0',...
   'position',[.05+.31*(i-1) .78-.11*(j-1) .28 .08]);
end;end; 
%il bottone seguente può essere usato per altri tipi di controllo
delete(BottSF(6));

set(BottSF(1),'string','LQR','callback','s_feed0(''LQR'');',...
   'TooltipString',sprintf('Start LQR regulator synthesis for %s',stack.general.model));
%----------------------------------------
%in IMFC e EMFC : A invertibile e D nulla
A=stack.general.A;B=stack.general.B;
C=stack.general.C;D=stack.general.D;
if ~isempty(find(D~=0))|(rank(A)<size(A,1))
     set(findobj('tag','synt_10'),'enable','off');
     set(findobj('tag','synt_11'),'enable','off');
     if (rank(A)<size(A,1))     cb1='messag(gcf,''nmra'');';cb2=cb1;
     elseif ~isempty(find(D~=0)) cb1='messag(gcf,''nnd'');';cb2=cb1;
     end;
else cb1='s_feed0(''IMFC'');';cb2='s_feed0(''EMFC'');';
end; 
set(BottSF(2),'string','IMFC','callback',cb1,...
   'TooltipString',sprintf('Start IMFC regulator synthesis for %s',stack.general.model));
set(BottSF(3),'string','EMFC','callback',cb2,...
   'TooltipString',sprintf('Start EMFC regulator synthesis for %s',stack.general.model));
%------------------------------------------------------------
%EIG\ASSIGN (a causa delle dimensioni della finestra) non può 
%essere attivato se ha un numero di autovalori maggiori di 18
if size(A,1)>18
     cbeigass='messag(gcf,''too'');';
     set(findobj('tag','synt_12'),'enable','off');
else cbeigass='ea_0;';                 
end;
set(BottSF(4),'string','EIG \ ASSIGN','callback',cbeigass,...
   'TooltipString',sprintf('Start EIG\ASSIGN regulator synthesis for %s',stack.general.model));
%------------------------------------------------------------
%LQ-SERVO: questo tipo di sintesi è applicabile solo a sistemi
%con matrici C=I e D=0
if isempty(find((size(C)-size(A))~=0 )) &...
      isempty(find((size(D)-[size(A,1),size(B,2)])~=0 )) &...
        isempty(find( (C-eye(size(C)))~=0)) &...
          isempty(find(D~=0))
       if size(A,1)>18 
            cblqs='messag(gcf,''too'');';
            set(findobj('tag','synt_13'),'enable','off');
       else cblqs='lqs_0;';
       end;
else  cblqs='messag(gcf,''lqs'');';
      set(findobj('tag','synt_13'),'enable','off');
end;

set(BottSF(5),'string','LQ - SERVO','callback',cblqs,...
   'TooltipString',sprintf('Start LQ-SERVO regulator synthesis for %s',stack.general.model));
%------------------------------------------------------------

sy(1)=uicontrol('style','push','unit','normalized','position',[0.46 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','MODELING','Horizontalalignment','center','visible','off',...
   'TooltipString','Go to the Modeling main Window','tag','syn0',...
   'callback','back_section(''synthesis'',''modeling'');','visible','off');

sy(2)=uicontrol('unit','normalized','style','push','position',[0.73 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','ANALYSIS','Horizontalalignment','center','visible','off',...
   'TooltipString','Go to the Analysis main Window','tag','syn0',...
   'callback','back_section(''synthesis'',''analysis'');','visible','off');

%---visualizzazione finestra---
set(BottOF(1:7),'visible','on');
set(BottSF(1:5),'visible','on');
set(sy(1:2),'visible','on');

[ns,ns]=size(A);

%---------------callback del bottone LQG\LTR-------------------
%--------------------------------------------------------------
%in LQG\LTR il sistema deve essere stabilizzabile e detectabile
%se :
%     ok_stab=1   ==> sys stabilizzabile
%     ok_dete=1   ==> sys detectabile
%     ok_minph=1  ==> sys nonminimum phase
%--------------------------------------------------------------
ok_minph=1;ok_stab=1;ok_dete=1; %valori iniziali
%--------------------------------------------------------------

%verifica di sistema a fase minima
tzeros=tzero(ss(A,B,C,D));
if ~isempty(find(real(tzeros)>0)) ok_minph=0;end;

%verifica di stabilizzabilità
ctrb_rank=rank(ctrb(A,B));
if ctrb_rank < ns            %sys non full.controllable
   [AA,BB,CC,T,K]=ctrbf(A,B,C);
   p=eig(AA);
   pnc=p(1:ns-ctrb_rank);    %poli non controllabili
   if ~isempty(find(real(pnc)>0)) ok_stab=0; 
   else
      pin0=find((real(pnc)==0)&(imag(pnc)==0));
      if length(pin0)>1 ok_stab=0;end;
   end;
end;

%verifica di detectabilità
obsv_rank=rank(obsv(A,C));
if obsv_rank < ns            %sys non full.observable
   [AA,BB,CC,T,K]=obsvf(A,B,C);
   p=eig(AA);
   pno=p(1:ns-obsv_rank);    %poli non osservabili
   if ~isempty(find(real(pno)>0)) ok_dete=0; 
   else
      pin0=find((real(pno)==0)&(imag(pno)==0));
      if length(pin0)>1 ok_dete=0;end;
   end;
end;

if (~ok_minph)               cb=['messag(gcf,''no_minph'');'];
elseif (~ok_stab)&(~ok_dete) cb=['messag(gcf,''no_stde'');']; 
elseif (~ok_stab)            cb=['messag(gcf,''no_st'');'];
elseif (~ok_dete)            cb=['messag(gcf,''no_de'');'];
else                         cb=['o_feed0(''LQG \ LTR'');'];
end;

if (~ok_stab)|(~ok_dete)|(~ok_minph) 
   set(findobj('tag','synt_7'),'enable','off');
end;
set(BottOF(6),'callback',cb);
%--------------------------------------------------------------
