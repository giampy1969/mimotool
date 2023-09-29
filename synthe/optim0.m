
function optim0(tipo)
% Callback dei comandi del menu Optimization:
% crea la prima finestra (comune) di ottimizzazione 
%
%                 optim0(tipo)
%
% tipo = stringa che rappresenta il tipo di ottimizzazione 
%        richiesta ( 'H-I','H-2','H-MIX','MU' o 'LQG').
%
% Massimo Davini 08/05/99 --- revised 09/12/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

if stack.general.K_flag 
    messag(gcf,'kns_m',[],tipo,2);
    return;
end;

%se c'è un modello simulink aperto,viene chiuso 
if ~isempty(find_system('name','Closed_Loop_System'))
  close_system('Closed_Loop_System',0);
end;

delete(findobj('tag','inf'));
delete(findobj('tag','eva'));
delgraf;

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
set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> %s',stack.general.model,upper(tipo)));

%-------------------------------------------------

str0='The purpose of this section is to find an optimal controller that minimizes a LINEAR COST FUNCTION versus two parameters X1 and X2 .';
str1='The optimization involves nearly 60 iterations of the function that computes the controller.';
str2=sprintf('\nAs a result, using the optimization with the function "hinflmi" of the H-Infinity synthesis or with Mu synthesis or H-Mix synthesis, could lead to a VERY LONG COMPUTATION TIME.');

opti(1)=uicontrol('style','frame','units','normalized','position',[0.1 0.22 0.8 0.73],...
    'backgroundcolor',[1 1 1],'visible','off','tag','opti0');

opti(2)=uicontrol('style','text','units','normalized','position',[0.13 0.7 0.74 0.2],...
    'fontunits','normalized','fontsize',.2,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
    'string',str0,'tag','opti0');

opti(3)=uicontrol('style','text','units','normalized','position',[0.13 0.63 0.74 0.06],...
    'fontunits','normalized','fontsize',.8,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'visible','off',...
    'foregroundcolor','red','HorizontalAlignment','left',...
    'string','WARNING :','tag','opti0');

opti(4)=uicontrol('style','text','units','normalized','position',[0.13 0.23 0.74 0.4],...
    'fontunits','normalized','fontsize',.1,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
    'string',[str1,str2],'tag','opti0');
opti(5)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
    'fontunits','normalized','fontsize',.35,'fontweight','bold',...
    'string','BACK','Horizontalalignment','center','tag','opti0',...
    'TooltipString','Back to the main SYNTHESIS window',...
    'callback','back_syn(''syn0'',0);');
opti(6)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
    'fontunits','normalized','fontsize',.35,'fontweight','bold',...
    'Horizontalalignment','center','string','NEXT','tag','opti0',...
    'TooltipString','Go to the next window',...
    'callback',sprintf('optim1(''%s'')',tipo));

set(opti,'visible','on');
stack.temp.handles=opti;