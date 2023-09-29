function zerosana
%TRANSMISSION ZEROS's window
%
%
% Massimo Davini 15/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

delgraf;
set(stack.temp.handles,'visible','off');
drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz+0.7;
set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Zeros',stack.general.model));

za(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.85 0.14 0.1],...
   'fontunits','normalized','fontsize',0.35+jsz/4,'fontweight','bold',...
   'Horizontalalignment','center','string','<<','enable','off',...
   'TooltipString','previous plot','tag','indietro');

za(2)=uicontrol('style','push','unit','normalized','position',[0.2 0.85 0.14 0.1],...
   'fontunits','normalized','fontsize',0.35+jsz/4,'fontweight','bold',...
   'string','>>','Horizontalalignment','center',...
   'TooltipString','Next plot','tag','avanti');

za(3)=uicontrol('style','text','units','normalized','position',[0.05 0.75 0.29 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'Horizontalalignment','left','tag','numzero');

za(4)=uicontrol('style','frame','units','normalized','position',[0.05 0.25 0.29 0.45],...
  'backgroundcolor',[1 1 1]);

za(5)=uicontrol('style','text','units','normalized','position',[0.06 0.62 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
   'string',' Value of the Zero:');

za(6)=uicontrol('style','text','units','normalized','position',[0.06 0.56 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'Horizontalalignment','center','tag','zero');

za(7)=uicontrol('style','text','units','normalized','position',[0.06 0.49 0.275 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
   'string',' Transfer matrix rank:');

za(8)=uicontrol('style','text','units','normalized','position',[0.06 0.43 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'Horizontalalignment','center','tag','rank');

za(9)=uicontrol('style','text','units','normalized','position',[0.06 0.36 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
   'string',' Norm(x0) :');

za(10)=uicontrol('style','text','units','normalized','position',[0.06 0.3 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'Horizontalalignment','center','tag','norm');

za(11)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','singval',...
   'TooltipString','Back to the Poles and Zeros window',...
   'callback',sprintf('back_ana(''pzmaps'',%u);',length(stack.temp.handles)));

za(12)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback','back_ana(''ana0'',[]);');

drawnow;

stack.temp.handles=[stack.temp.handles,za];

zerosplot(1);