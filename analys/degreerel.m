function degreerel
%RELATIVE DEGREE's window
%
%
% Massimo Davini 22/05/99 --- revised 30/05/99

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

% enlarge text if java machine is running
jsz=stack.general.javasize;

textsize=jsz/2+.7; %.6 .9 
set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Relative Degree',stack.general.model));

rd(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','con_obs',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback',sprintf('back_ana(''ana0'',%u);',length(stack.temp.handles)));

rd(2)= uicontrol('style','frame','unit','normalized','position',[0.05 0.45 0.29 0.5],...
    'backgroundcolor',[1 1 1]);

rd(3)= uicontrol('style','text','unit','normalized','position',[0.06 0.51 0.27 0.43],...
    'fontunits','normalized','fontsize',.08+jsz/12,'fontweight','bold',...
    'backgroundcolor',[1 1 1],'Horizontalalignment','left',...
    'string',sprintf('The Relative Degree represents the number of times we must derive a given output to make the input explicitly appear in that output derivative expression.'));

rd(4)= uicontrol('style','text','unit','normalized','position',[0.39 0.9 0.2 0.05],...
    'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
    'backgroundcolor',[1 1 0],'string','OUTPUTS :');

rd(5)= uicontrol('style','text','unit','normalized','position',[0.64 0.9 0.31 0.05],...
    'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
    'backgroundcolor',[1 1 0],'string','RELATIVE DEGREES :');

G=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
[K Kf P ro Tx]=stdc(G,0);

for i=1:length(ro)
   Text1(i)= uicontrol('style','text','unit','normalized',...
     'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'position',[0.39 0.8-0.07*(i-1) 0.2 0.06],...
     'string',sprintf('out %u',i));

   Text2(i)= uicontrol('style','text','unit','normalized',...
     'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
     'string',num2str(ro(i)),'position',[0.64 0.8-0.07*(i-1) 0.31 0.06],...
     'backgroundcolor',[1 1 1]);
end;
  
stack.temp.handles=[rd,Text1,Text2];