
function polesana
%POLES's ANALYSIS window
%
%
% Massimo Davini 15/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

delgraf;
set(stack.temp.handles,'visible','off');
drawnow;

set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Poles',stack.general.model));

pa(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','singval',...
   'TooltipString','Back to the Poles and Zeros window',...
   'callback',sprintf('back_ana(''pzmaps'',%u);',length(stack.temp.handles)));

pa(2)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback','back_ana(''ana0'',[]);');

pa(3)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'position',[0.39 0.05 0.22 0.12],'tag','gramiani',...
   'string','CTRB-OBSV','Horizontalalignment','center',...
   'TooltipString','View the value of CTRB and OBSV gramian');

pa(4)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'position',[0.81 0.05 0.14 0.12],'tag','avanti',...
   'TooltipString','Next plot',...
   'string','>>','Horizontalalignment','center');

pa(5)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'position',[0.66 0.05 0.14 0.12],'tag','indietro',...
   'TooltipString','previous plot',...
   'string','<<','Horizontalalignment','center');

stack.temp.handles=[stack.temp.handles,pa];

drawnow;

polesplot(1,0);