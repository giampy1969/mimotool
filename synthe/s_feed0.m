function s_feed0(tipo)
% Crea la finestra (comune) di informazione relativa
% ai controllori di tipo (pseudo) state-feedback .
%
%                   s_feed0(tipo)
%  
% tipo = stringa che indica il tipo di controllo scelto
%        ('LQR','IMFC','EMFC' o 'EIG\ASSIGN')
%
% Massimo Davini 09/05/99 --- revised 07/12/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

if stack.general.K_flag 
    messag(gcf,'kns_m',[],tipo,3);
    return;
end;

%se c'è un modello simulink aperto,viene chiuso 
if ~isempty(find_system('name','Closed_Loop_System'))
   close_system('Closed_Loop_System',0);
end;

%---------------inizializzazione-----------------
delete(findobj('tag','inf'));
delete(findobj('tag','eva'));
delete(findobj('tag','textgrafico'));
set(findobj('tag','syn0'),'visible','off');
delgraf;
delete(findobj('tag','matrice'));
set(findobj('tag','file_6'),'enable','off');

if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
   delete(stack.temp.handles);
end;
drawnow;

stack.temp=[];stack.temp.handles=[];
stack.evaluation=[];stack.simulation=[];

set(findobj('tag','simu_2'),'enable','off');
set(get(findobj('tag','eval_1'),'children'),'enable','off','visible','on');
%------------------------------------------------

set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> %s',stack.general.model,upper(tipo)));

% enlarge text if java machine is running
jsz=stack.general.javasize;

st=jsz/3+.2;sf=jsz/3+.55;

Nota(1)=uicontrol('style','frame',...
   'units','normalized','position',[0.1 0.29 0.8 0.58],...
   'backgroundcolor',[1 1 1],'visible','off','tag','sfnota');

str=['The STATE FEEDBACK controller Ksf ',...
      'that you will design in this section will be remapped',...
      ' into an OUTPUT FEEDBACK controller Kof, according to the following law:'];
Nota(2)=uicontrol('style','text',...
   'units','normalized','position',[.13 .69 .74 0.15],...
   'fontunits','normalized','fontsize',st,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','string',str,...
   'HorizontalAlignment','left','tag','sfnota');

Nota(3)=uicontrol('style','text',...
   'units','normalized','position',[.13 .58 .74 0.07],...
   'fontunits','normalized','fontsize',sf,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'visible','off','HorizontalAlignment','center',...
   'tag','sfnota','string','Kof = Ksf * pinv( C - D*Ksf )');

Nota(4)=uicontrol('style','text',...
   'units','normalized','position',[.13 .46 .74 0.1],...
   'fontunits','normalized','fontsize',st+.15,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off',...
   'HorizontalAlignment','left','tag','sfnota',... 
   'string',sprintf('therefore a perfect STATE FEEDBACK behaviour will be obtained only when C = I and D = 0 .'));

Nota(5)=uicontrol('style','push',...
   'unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','sfnota',...
   'TooltipString','Back to the main SYNTHESIS window',...
   'callback','back_syn(''syn0'',0);');

Nota(6)=uicontrol('style','push',...
   'unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','sfnota');

switch upper(tipo)
case 'LQR',           callback='lqr0;';
case {'IMFC','EMFC'}, callback=sprintf('mfc0(''%s'');',upper(tipo));
case 'EIG \ ASSIGN',  callback='ea_0;';
end;
set(Nota(6),'callback',callback);

Nota(7)=uicontrol('style','text',...
   'units','normalized','position',[.13 .32 .74 0.1],...
   'fontunits','normalized','fontsize',st+.15,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','foregroundcolor',[0 0 1],...
   'HorizontalAlignment','left','tag','sfnota',... 
   'string','Note : in order to set the matrices C = I and D = 0 you can use the Tools menu in the Modeling section.');

set(Nota,'visible','on');
stack.temp.handles=Nota;