function new1
%NEW1 : callback del bottone "INSERT THE MATRICES" nella finestra di
%       inserimento delle dimensioni delle matrici del nuovo modello
%
% Massimo Davini 07/05/99 --- revised 16/03/00

global stack;

ni=str2num(get(findobj('tag','NI'),'String'));
no=str2num(get(findobj('tag','NO'),'String'));
ns=str2num(get(findobj('tag','NS'),'String'));

ok_ni=0;ok_no=0;ok_ns=0;

if ~isempty(ni)&(ni>0)&(ni<11) ok_ni=1;end; 
if ~isempty(no)&(no>0)&(no<11) ok_no=1;end; 
if ~isempty(ns)&(ns>0)&(ns<11) ok_ns=1;end; 

if (~ok_ni)|(~ok_no)|(~ok_ns) 
   messag(gcf,'pi');
   if ~ok_ni set(findobj('tag','NI'),'String',num2str(1));end;
   if ~ok_no set(findobj('tag','NO'),'String',num2str(1));end;
   if ~ok_ns set(findobj('tag','NS'),'String',num2str(1));end;
else
  set(findobj('tag','new0'),'visible','off');
  set(findobj('tag','NI'),'visible','off');
  set(findobj('tag','NO'),'visible','off');
  set(findobj('tag','NS'),'visible','off');
  drawnow;
  
  stack.temp.A=zeros(ns,ns);
  stack.temp.B=zeros(ns,ni);
  stack.temp.C=zeros(no,ns);
  stack.temp.D=zeros(no,ni);
  
  stack.temp.flagA=0;  %flag si salvataggio di A
  stack.temp.flagB=0;  %flag si salvataggio di B
  stack.temp.flagC=0;  %flag si salvataggio di C
  stack.temp.flagD=0;  %flag si salvataggio di D

  handleprec=length(stack.temp.handles);
  x=handleprec;
    
  n(1)=uicontrol('style','frame','tag','new1',...
     'units','normalized','position',[.037 .833 .106 .11],...
     'backgroundcolor',[1 1 1],'Visible','off');
   
  n(2)=uicontrol('style','frame','tag','new1',...
     'units','normalized','position',[0.167 0.833 0.106 0.11],...
     'backgroundcolor',[1 1 1],'Visible','off');
  
  n(3)=uicontrol('style','frame','tag','new1',...
     'units','normalized','position',[0.297 0.833 0.106 0.11],...
     'Visible','off','backgroundcolor',[1 1 1]);
  
  n(4)=uicontrol('style','frame','tag','new1',...
     'units','normalized','position',[0.427 0.833 0.106 0.11],...
     'Visible','off','backgroundcolor',[1 1 1]);
   
  ABCDoff=sprintf('set(stack.temp.handles(%u+1:%u+4),''visible'',''off'');',x,x);
  istend=['set(findobj(''tag'',''file_7''),''enable'',''off'');']; 
  
  n(5)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.05 0.85 0.08 0.08],...
     'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
     'string','A','Horizontalalignment','center',...
     'TooltipString','Visualize system matrix A',...
     'callback',[ABCDoff,sprintf('set(stack.temp.handles(%u+1),''visible'',''on'');visual(stack.temp.A,''A'',''edit'');stack.temp.matrice=1;',x),istend]);

  n(6)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.18 0.85 0.08 0.08],...
     'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
     'string','B','Horizontalalignment','center',...
     'TooltipString','Visualize system matrix B',...
     'callback',[ABCDoff,sprintf('set(stack.temp.handles(%u+2),''visible'',''on'');visual(stack.temp.B,''B'',''edit'');stack.temp.matrice=2;',x),istend]);  

  n(7)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.31 0.85 0.08 0.08],... 
     'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
     'string','C','Horizontalalignment','center',...
     'TooltipString','Visualize system matrix C',...
     'callback',[ABCDoff,sprintf('set(stack.temp.handles(%u+3),''visible'',''on'');visual(stack.temp.C,''C'',''edit'');stack.temp.matrice=3;',x),istend]);

  n(8)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.44 0.85 0.08 0.08],... 
     'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
     'string','D','Horizontalalignment','center',...
     'TooltipString','Visualize system matrix D',...
     'callback',[ABCDoff,sprintf('set(stack.temp.handles(%u+4),''visible'',''on'');visual(stack.temp.D,''D'',''edit'');stack.temp.matrice=4;',x),istend]);

  n(9)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.57 0.85 0.38 0.08],...
     'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
     'string','SAVE MATRIX','Horizontalalignment','center',...
     'TooltipString','Save the matrix visualized',...
     'callback','new2;');
   
  callb_back=['delete(findobj(''tag'',''matrice''));pause(0.05);',sprintf('back(%u,''new1'');',handleprec)];
  callb_clos=['delete(findobj(''tag'',''matrice''));pause(0.05);back(0,''new0'');'];
  
  n(10)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.05 0.05 0.12 0.12],...
     'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
     'string','BACK','Horizontalalignment','center',...
     'TooltipString','Back to the previous window',...
     'callback',callb_back);

  n(11)=uicontrol('style','push','tag','new1',...
     'unit','normalized','position',[0.22 0.05 0.12 0.12],...
     'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
     'string','CLOSE','Horizontalalignment','center',...
     'TooltipString','Back to the main MODELING window',...
     'callback',callb_clos);
   
  %aggiornamento oggetti temporanei
  stack.temp.handles=[stack.temp.handles,n]; 
   
  drawnow;
  set(n(1),'visible','on');
  visual(stack.temp.A,'A','edit');   
  stack.temp.matrice=1;           %indica la matrice da salvare
  set(findobj('tag','file_7'),'enable','off'); 
end;