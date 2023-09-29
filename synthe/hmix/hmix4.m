function hmix4
%HMIX4 : calcolo del controllore H-MIX
%
%
% Massimo Davini 02/06/99


watchon;
global stack;
delete(findobj('tag','inf'));
drawnow;
set(findobj('tag','BEVAL'),'enable','off');
set(findobj('tag','BSIMU'),'enable','off');
stack.evaluation=[];stack.simulation=[];
stack.general.K_flag=0;

sizetext=.08;
inf=uicontrol('style','text','units','normalized','position',[0.57 0.3 0.38 0.5],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
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
if stack.temp.type==1 lettera2='t';end;
if stack.temp.type==2 lettera2='m';end;
lettera3='r';

pstr=sprintf('%s%s%s',lettera1,lettera2,lettera3);
%-----------------------------
if get(findobj('tag','deriva1'),'value')==1 lettera='e';end;
if get(findobj('tag','deriva2'),'value')==1 lettera='a';end;

wstr=sprintf('a%s',lettera);
%-------------------------------
kstr='hmx';
%-------------------------------
% NOTE it should be, and it was :
% lmr=stack.temp.region;
% however it never worked with hinfmix, so the region is reset to empty:
lmr=[];
% this is why the message 5 lines below says that the region constraint 
% was not enforced
%-------------------------------
cost=stack.temp.pesi;
%-------------------------------

try,K=[];[f,g,K,X,F]=kmaker(x,G,str,pstr,wstr,kstr,cost,lmr);
catch, K=[];watchoff; end;

if ~isempty(K)
   set(inf,'string',strvcat('The controller has been COMPUTED : see Matlab Command Window for details.',...
                            'Note however that the region constraint was NOT enforced due to a problem with hinfmix.',...
                            'This will hopefully be solved in later releases.'));
  set(findobj('tag','simu_2'),'enable','on');
  set(findobj('tag','eval_31'),'enable','on');
 
  [Ak,Bk,Ck,Dk]=unpck(K);
 
  stack.general.K_flag=1;
  
  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='hmix';             %tipo del regolatore 
  stack.evaluation.K=K;                     %regolatore
  stack.evaluation.plant=stack.temp.plant;  %plant
  stack.evaluation.pstr=pstr;
  stack.evaluation.wstr=wstr;
  stack.evaluation.X1X2=stack.temp.X1X2;
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='hmix';  %tipo del regolatore 
  stack.simulation.Ak=Ak;        %regolatore
  stack.simulation.Bk=Bk;        %regolatore
  stack.simulation.Ck=Ck;        %regolatore
  stack.simulation.Dk=Dk;        %regolatore
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

