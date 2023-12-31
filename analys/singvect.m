function singvect
%SINGULAR VECTOR's windows
%Callback del bottone "S.VECTORS" della finestra dei 
%SINGULAR VALUES
%
%
%Massimo Davini 07/05/99 --- revised 28/09/99

global stack;
delete(gca);
set(findobj('tag','singval'),'visible','off');
drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz*0.8+0.7;
set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Singular Vectors',stack.general.model)); 

sva(1)=uicontrol('style','text','units','normalized','position',[0.05 0.9 0.18 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'Horizontalalignment','left',...
   'string',' Frequency :','tag','singvett');

sva(2)=uicontrol('style','edit','units','normalized','position',[0.24 0.895 0.1 0.06],...
   'fontunits','normalized','fontsize',sizetext-0.1,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'Horizontalalignment','left',...
   'string',num2str(0.001),'tag','frequenza');

sva(3)=uicontrol('style','push','unit','normalized','position',[0.05 0.73 0.07 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'Horizontalalignment','center',...
   'string','<<','enable','off',...
   'callback','stack.temp.ind_grafico=stack.temp.ind_grafico-1;singvect1;','tag','BI');

sva(4)=uicontrol('style','push','unit','normalized','position',[0.13 0.73 0.13 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'Horizontalalignment','center',...
   'string','SAME','callback','singvect1;','tag','BS');

sva(5)=uicontrol('style','push','unit','normalized','position',[0.27 0.73 0.07 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'Horizontalalignment','center',...
   'string','>>','callback','stack.temp.ind_grafico=stack.temp.ind_grafico+1;singvect1;','tag','BA');

drawnow;

sva(6)=uicontrol('style','text','units','normalized','position',[0.05 0.63 0.29 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'Horizontalalignment','left','tag','num_vett');

sva(7)=uicontrol('style','text','units','normalized','position',[0.05 0.55 0.29 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'Horizontalalignment','left','tag','valore');

sva(8)=uicontrol('style','frame','units','normalized','position',[0.05 0.22 0.29 0.29],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'tag','singvett');

sva(9)=uicontrol('style','text','units','normalized','position',[0.06 0.44 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left','tag','testo1');

sva(10)=uicontrol('style','text','units','normalized','position',[0.06 0.38 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
   'string',' Trasfer matrix rank ','tag','singvett');

sva(11)=uicontrol('style','text','units','normalized','position',[0.06 0.34 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'Horizontalalignment','center',...
    'tag','testo2');

sva(12)=uicontrol('style','text','units','normalized','position',[0.06 0.28 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
    'string',' Condition number','tag','singvett');

sva(13)=uicontrol('style','text','units','normalized','position',[0.06 0.24 0.27 0.05],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'Horizontalalignment','center',...
   'tag','testo3');

sva(14)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','singvett',...
   'TooltipString','Back to the previous window');
callb=sprintf('back_ana(''singval'',%u,''ind_grafico'');',length(stack.temp.handles));
set(sva(14),'callback',callb);

sva(15)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main MODELING window',...
   'callback','back_ana(''ana0'',[],''ind_grafico'');','tag','singvett');

drawnow;

stack.temp.handles=[stack.temp.handles,sva];
stack.temp.ind_grafico=1;

singvect1;