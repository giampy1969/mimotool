function h3(tipo)
%H3 : calcolo del controllore H-2 o H-INFINITY
%
%                     h3(tipo)
%
%  tipo  = stringa indicante il tipo di sintesi o di ottimizzazione
%          scelta : 'H - 2' o 'H - INFINITY'
%
%
% Massimo Davini 27/05/99 --- revised 31/05/99


watchon;
global stack;
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
   'string','');


%parametri per la chiamata della funzione kmaker del jtools
%-----------------------------
x=stack.temp.X1X2;
%-----------------------------
G=stack.temp.plant;
%-----------------------------
str='p';
%-----------------------------
n=stack.temp.integratori;

lettera1=num2str(n);
tipo_matrix=stack.temp.type;
if tipo_matrix==1 lettera2='t';end;
if tipo_matrix==2 lettera2='m';end;
lettera3='r';

pstr=sprintf('%s%s%s',lettera1,lettera2,lettera3);
%-----------------------------
if get(findobj('tag','deriva1'),'value')==1 lettera='e';end;
if get(findobj('tag','deriva2'),'value')==1 lettera='a';end;

wstr=sprintf('a%s',lettera);
%-----------------------------
switch tipo
   case 'H - INFINITY'
     if get(findobj('tag','funz1'),'value')==1 stringa='hi1';end;
     if get(findobj('tag','funz2'),'value')==1 stringa='hi2';end;
     if get(findobj('tag','funz3'),'value')==1 stringa='hi3';end;
     if get(findobj('tag','funz4'),'value')==1 stringa='hlm';end;
   case 'H - 2'
     if get(findobj('tag','funz1'),'value')==1 stringa='h21';end;
     if get(findobj('tag','funz2'),'value')==1 stringa='h22';end;
     if get(findobj('tag','funz3'),'value')==1 stringa='h23';end;
end;

kstr=stringa;
%-------------------------------
cost=stack.temp.pesi;
%-------------------------------
try,K=[];[f,g,K,X,F]=kmaker(x,G,str,pstr,wstr,kstr);
catch, K=[];watchoff; end;

if exist('K') & ~isempty(K)
  set(inf,'string','The controller has been correctly COMPUTED : see Matlab Command Window for details .');
  set(findobj('tag','simu_2'),'enable','on');
  set(findobj('tag','eval_31'),'enable','on');
 
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  if strcmp(tipo,'H - INFINITY') str='hi';
  elseif strcmp(tipo,'H - 2')    str='h2';
  end;
  
  stack.general.K_flag=1;
   
  %aggiornamento stack per la valutazione  
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind=str;                  %tipo del regolatore 
  stack.evaluation.K=K;                       %regolatore
  stack.evaluation.plant=stack.temp.plant;    %plant
  stack.evaluation.pstr=pstr;
  stack.evaluation.wstr=wstr;
  stack.evaluation.X1X2=stack.temp.X1X2;

  %aggiornamento stack per simulazione  
  stack.simulation.kind=str;  %tipo del regolatore 
  stack.simulation.Ak=Ak;      %regolatore
  stack.simulation.Bk=Bk;      %regolatore
  stack.simulation.Ck=Ck;      %regolatore
  stack.simulation.Dk=Dk;      %regolatore
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
   set(inf,'string','It''s IMPOSSIBLE to find a controller : see Matlab Command Window for details .');
end;

set(inf,'visible','on');
watchoff;

