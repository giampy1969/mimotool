function ana_syn(indice)
% Creazione della finestra principale di ANALYSIS e SYNTHESIS
% (callback dei relativi bottoni)
%  
%                      ana_syn(indice)
%
% indice = 1   visualizza la main analysis window
% indice = 2   visualizza la main synthesis window
%
% Massimo Davini 07/05/99 --- revised 23/03/00

global stack;


%chiusura della,eventuale,finestra si simulazione
if ~isempty(find_system('name','Closed_Loop_System'))
   close_system('Closed_Loop_System',0);
end;

%eliminazione dei campi text relativi ai coefficienti di una matrice
delete(findobj('tag','matrice'));drawnow;

%devisualizzazione bottoni delle matrici e relative frames
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
drawnow;

%aggiornamento menus file, tools, evaluation e simulation
set(findobj('tag','file_2'),'enable','off');
set(findobj('tag','file_3'),'enable','off');
set(findobj('tag','file_5'),'enable','off');
set(findobj('tag','file_6'),'enable','off');
set(findobj('tag','file_7'),'enable','off');
set(get(findobj('tag','tools_1'),'children'),'enable','off');
set(get(findobj('tag','tools_2'),'children'),'enable','off');
set(get(findobj('tag','tools_6'),'children'),'enable','off');
set(get(findobj('tag','eval_1'),'children'),'enable','off');
set(findobj('tag','simu_2'),'enable','off');

stack.evaluation=[];   stack.simulation=[];   
A=stack.general.A;     B=stack.general.B;
C=stack.general.C;     D=stack.general.D;
[ns ns]=size(A);[no ni]=size(D);

Num=[];
for i=1:ni ,[num,Den]=ss2tf(A,B,C,D,i);Num=[Num;num]; end;

stack.general.tfNUM=Num;
stack.general.tfDEN=Den;

%creazione comandi del menu Analisis che dipendono
%dal numero dei canali del sistema
crea_cascade(ni,no,'anal_12','responses','Rlocus');
crea_cascade(ni,no,'anal_13','responses','Step');
crea_cascade(ni,no,'anal_14','responses','Impulse');
crea_cascade(ni,no,'anal_15','responses','Bode');
crea_cascade(ni,no,'anal_16','responses','Nyquist');

sys=pck(A,B,C,D);
[ss0,su0]=sdecomp(sys,-1e-12);
[tyu,nou,niu,nsu]=minfo(su0);
[P,Z]=pzmap(A,B,C,D);epz=length(P)-length(Z);
rangoc=rank(ctrb(A,B));rangoo=rank(obsv(A,C));
r=ns;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz+0.6;sizeris=.6;

a(1)=uicontrol('style','frame',...
   'unit','normalized','position',[0.05 0.32 0.9 0.53],...
   'backgroundcolor',[1 1 1],'tag','ana0','visible','off');

a(2)=uicontrol('style','text',...
   'unit','normalized','position',[0.07 0.77 0.3 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
   'string','DIMENSIONS','visible','off','tag','ana0');

if no==1 str1='1 output'; else str1=sprintf('%u outputs',no);end;
if ni==1 str2='1 input';  else str2=sprintf('%u inputs',ni);end;
if ns==1 str3='1 state';  else str3=sprintf('%u states',ns);end;
str=sprintf('%s , %s , %s',str1,str2,str3);
a(3)=uicontrol('style','text',...
   'unit','normalized','position',[0.38 0.77  0.55 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right',...
   'string',str,'foregroundcolor','red','visible','off','tag','ana0');
%---
a(4)=uicontrol('style','text','unit','normalized','position',[0.07 0.735 0.86 0.03],...
   'fontunits','normalized','fontsize',sizeris,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0','visible','off',...  
   'string',char(45*ones(1,149+(jsz>0)*55)));
%---
a(5)=uicontrol('style','text','unit','normalized','position',[0.07 0.67 0.45 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0',...
   'string','CONTROLLABILITY','visible','off');

a(6)=uicontrol('style','text','unit','normalized','position',[0.53 0.67  0.4 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right','tag','ana0',...
   'foregroundcolor','red','visible','off');
if rangoc==ns set(a(6),'string','complete');
else set(a(6),'string',sprintf('rank(ctrb(A,B)) = %u',rangoc));
end; 
%---
a(7)=uicontrol('style','text','unit','normalized','position',[0.07 0.6 0.45 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0',...
   'string','OBSERVABILITY','visible','off');

a(8)=uicontrol('style','text','unit','normalized','position',[0.53 0.6 0.4 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right','tag','ana0',...
   'foregroundcolor','red','visible','off');
if rangoo==ns set(a(8),'string','complete');
else set(a(8),'string',sprintf('rank(obsv(A,C)) = %u',rangoo));
end; 
%---
a(9)=uicontrol('style','text','unit','normalized','position',[0.07 0.565 0.86 0.03],...
   'fontunits','normalized','fontsize',sizeris,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0','visible','off',...
   'string',char(45*ones(1,149+(jsz>0)*55)));
%---
a(10)=uicontrol('style','text','unit','normalized','position',[0.07 0.5 0.45 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0',...
   'string','UNSTABLE PART','visible','off');

if nsu==1 str='1 state';else str=sprintf('%u  states',nsu);end;
a(11)=uicontrol('style','text','unit','normalized','position',[0.53 0.5 0.4 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right','tag','ana0',...
   'string',str,'visible','off','foregroundcolor','red');
%---
a(12)=uicontrol('style','text','unit','normalized','position',[0.07 0.43 0.4 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0',...
   'string','n° POLES - n° ZEROS','visible','off');

a(13)=uicontrol('style','text','unit','normalized','position',[0.53 0.43 0.4 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right','tag','ana0',...
   'string',sprintf('%u',epz),'visible','off','foregroundcolor','red');
%---
a(14)=uicontrol('style','text','unit','normalized','position',[0.07 0.36 0.55 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','ana0',...
   'string','Max { Real ( EIGENVALUES ) }','visible','off');

a(15)=uicontrol('style','text','unit','normalized','position',[0.63 0.36 0.3 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','right','tag','ana0',...
   'string',sprintf('%u',max(real(spoles(sys)))),'visible','off','foregroundcolor','red');
%---
a(16)=uicontrol('style','push','unit','normalized','position',[0.46 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','MODELING','Horizontalalignment','center',...
   'TooltipString','Go to the Modeling main Window','tag','ana0',...
   'callback','back_section(''analysis'',''modeling'');','visible','off');

a(17)=uicontrol('unit','normalized','style','push','position',[0.73 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','SYNTHESIS','Horizontalalignment','center',...
   'TooltipString','Go to the Synthesis main Window','tag','ana0',...
   'callback','goto_syn;','visible','off');

switch indice
case 1 
   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s',stack.general.model));
   %-----------------------------------------------------------
   %abilitazione e disabilitazione comandi della barra dei menù
   set(findobj('tag','tools_1'),'enable','off');
   set(findobj('tag','view_1'),'enable','on');
   set(findobj('tag','anal_1'),'enable','on');
   set(findobj('tag','synt_1'),'enable','off');
   set(findobj('tag','opti_1'),'enable','off');
   set(findobj('tag','eval_1'),'enable','off');
   set(findobj('tag','simu_1'),'enable','off');
   %-----------------------------------------------------------
   set(findobj('tag','ana0'),'visible','on');
   
   for i=1:10,set(findobj('tag',sprintf('view_%u',i)),'enable','on');end;
   
   %la forma compagna esiste se è controllabile con il 1° ingresso
   if rank(ctrb(A,B(:,1)))<ns , set(findobj('tag','view_6'),'enable','off'); end;
   
   % calcolo la forma di jordan preventivamente per essere sicuro che vada
   s0=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   try
       [s1,Tj]=sys2sys(s0,'j');
       if size(Tj,1)<1 | size(Tj,2)<1 | size(Tj,1)~=size(Tj,2), 
           error('jordan failed');
       end
   catch
       set(findobj('tag','view_7'),'enable','off');
   end
   
   %------------------------------------------------------------
   %------C'E' UN ERORE NEL CALCOLO DELLA FORMA DI JORDAN:------
   %------ad esempio per i sistemi LIN_4x3.mat e LIN_4x4.mat----
   %------la matrice T che viene ricavata nel file sys2sys.m ---
   %------non è quadrata,mentre dovrebbe esserlo;per questo-----
   %------motivo lascio ancora disabilitato il comando ---------
   %------relativo alla forma di Jordan quando ns>8 .----------- 
   %------------------------------------------------------------
   
   %per la forma di Brunowsky Tx (vedi stdc.m) deve esistere quadrata
   G=pck(A,B,C,D); [K Kf P ro Tx]=stdc(G,0); [rig col]=size(Tx);
   if isempty(Tx) | rig~=col set(findobj('tag','view_10'),'enable','off');end;
   
   for i=1:54,set(findobj('tag',sprintf('anal_%u',i)),'enable','on');end;
   
   %per limitazioni grafiche,relative degree è disabilitato se ni>12
   if ni>12 set(findobj('tag','anal_11'),'enable','off');end;
   
case 2   

   set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s',stack.general.model));
   
   for i=1:13,set(findobj('tag',sprintf('synt_%u',i)),'enable','on');end;
   
   %se non è presente il toolbox di Optimization non viene abilitato
   %il menu relativo
   if ~isempty(ver('optim'))
      for i=1:6,set(findobj('tag',sprintf('opti_%u',i)),'enable','on');end;
   end;
   synthe;
end;   
   
%---------------------------
function crea_cascade(ninput,noutput,tag_padre,nome_funzione,tipo)

if nargin<5 tipo='';end;
if ninput<=3 lun_in=ninput;else lun_in=2;end;
if noutput<=4 lun_out=noutput;else lun_out=3;end;

tag='cascade';
padre=findobj('tag',tag_padre);
for i=1:lun_in
   label=sprintf('Input %u',i);
   ingresso(i)=uimenu(padre,'label',label,'tag',tag);
   for j=1:lun_out
     uscita(j+(i-1)*noutput)=uimenu(ingresso(i),...
       'label',sprintf('Output %u',j),'tag',tag,...
       'callback',sprintf('%s(%u,%u,''%s'');',nome_funzione,i,j,tipo));
   end;
end;
if ninput > 3
   ingresso(lun_in+1)=uimenu(padre,'label','Others','tag',tag,...
    'callback',sprintf('%s(3,1,''%s'');',nome_funzione,tipo));
end;
if noutput > 4 
  for i=1:lun_in
    other(i)=uimenu(ingresso(i),'label','Others','tag',tag,...
     'callback',sprintf('%s(%u,4,''%s'');',nome_funzione,i,tipo));
  end;
end;