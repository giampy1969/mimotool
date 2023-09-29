function responses(in,out,tipo)
%STEP,IMPULSE,BODE,NYQUIST RESPONSES or RLOCUS window
%
% responses(tipo,in,out)
%
% tipo = stringa che indica il tipo di grafico richiesto
%        ('Step','Impulse','Bode','Nyquist','rlocus')
% in   = intero che indica il canale di ingresso
% out  = intero che indica il canale di uscita
%
%
% Massimo Davini 18/05/99 --- revised 20/10/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

%---------------------inizializzazione--------------------------
delgraf;
delete(findobj('tag','matrice'));
set(findobj('tag','ana0'),'visible','off');
set(findobj('tag','file_7'),'enable','off');

if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
   delete(stack.temp.handles);
end;
drawnow;

stack.temp=[];stack.temp.handles=[];
%---------------------------------------------------------------

if strcmp(tipo,'Bode')                             str0='Diagrams';
elseif strcmp(tipo,'Nyquist')                      str0='Diagram';
elseif strcmp(tipo,'Step')|strcmp(tipo,'Impulse')  str0='Response';
end;

if strcmp(tipo,'Rlocus')
  set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Root Locus',stack.general.model));
else
  set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> %s %s',stack.general.model,tipo,str0));
end;

D=stack.general.D;
[no,ni]=size(D);

st(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.13 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','back',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback','back_ana(''ana0'',[]);');

plus=0;
if ~strcmp(tipo,'Rlocus')
  %nel caso di rlocus non serve il bottone ALL 
   
  if strcmp(tipo,'Bode') posizione=[0.204 0.05 0.13 0.12];
  else posizione=[0.505 0.05 0.135 0.12];
  end;
  st(1+plus+1)=uicontrol('style','push','unit','normalized','position',posizione,...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','ALL','Horizontalalignment','center',...
   'TooltipString','View the responses all together','tag','all',...
   'callback',sprintf('makeplot(''%s'');',tipo));
  if (ni*no==1) set(st(1+plus+1),'enable','off');end;
  
  plus=1;
end;

if strcmp(tipo,'Bode') 
  st(1+plus+1)=uicontrol('style','push','unit','normalized','position',[0.358 0.05 0.13 0.12],...
     'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
     'string','GAIN','Horizontalalignment','center',...
     'TooltipString','View only the channel''s gain diagram','tag','gain',...
     'callback',sprintf('makeplot(''single'',%u,%u);',in,out));
      
  st(1+plus+2)=uicontrol('style','push','unit','normalized','position',[0.512 0.05 0.13 0.12],...
     'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
     'string','PHASE','Horizontalalignment','center',...
     'TooltipString','View only the channel''s phase diagram','tag','phase',...
     'callback',sprintf('makeplot(''single'',%u,%u);',in,out));
  plus=plus+2;
end;

if strcmp(tipo,'Rlocus')

st(1+plus+1)=uicontrol('backgroundcolor',[1 1 1],...
   'style','frame','Visible','on','tag','FP',...
   'units','normalized','position',[0.383 0.04 0.075 0.14]);

st(1+plus+2)=uicontrol('style','push','unit','normalized','position',[0.39 0.05 0.06 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','P','Horizontalalignment','center',...
   'TooltipString','View the channel''s poles','tag','P',...
   'callback','rlocclb;');

st(1+plus+3)=uicontrol('backgroundcolor',[1 1 1],...
   'style','frame','Visible','off','tag','FZ',...
   'units','normalized','position',[0.463 0.04 0.075 0.14]);

st(1+plus+4)=uicontrol('style','push','unit','normalized','position',[0.47 0.05 0.06 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','Z','Horizontalalignment','center',...
   'TooltipString','View the channel''s zeros','tag','Z',...
   'callback','rlocclb;');

st(1+plus+5)=uicontrol('backgroundcolor',[1 1 1],...
  'style','frame','Visible','off','tag','FK',...
  'units','normalized','position',[0.543 0.04 0.075 0.14]);

st(1+plus+6)=uicontrol('style','push','unit','normalized','position',[0.55 0.05 0.06 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','K','Horizontalalignment','center',...
   'TooltipString','View the channel''s gain','tag','K',...
   'callback','rlocclb;');

plus=plus+6;

end;

st(1+plus+1)=uicontrol('style','push','unit','normalized','position',[0.666 0.05 0.13 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','<<','Horizontalalignment','center',...
   'TooltipString','previous channel','tag','indietro');

st(1+plus+2)=uicontrol('style','push','unit','normalized','position',[0.82 0.05 0.13 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','>>','Horizontalalignment','center',...
   'TooltipString','Next channel','tag','avanti');

if (in==1)&(out==1)   set(findobj('tag','indietro'),'enable','off'); end;
if (in==ni)&(out==no) set(findobj('tag','avanti'),'enable','off'); end;

stack.temp.handles=st;

drawnow;

if strcmp(tipo,'Rlocus') str=sprintf('rlocmake(%u,%u,[]);',in,out);
else                     str=sprintf('makeplot(''%s'',%u,%u);',tipo,in,out);
end;

eval(str);


