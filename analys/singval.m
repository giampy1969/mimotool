function singval
%SINGULAR VALUES's window
%
%
% Massimo Davini 15/05/99 --- revised 28/09/99 

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
stack.temp=[];
drawnow;
%---------------------------------------------------------------

stack.temp.handles=[];


set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Singular Values',stack.general.model));

Bott(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','singval',...
   'TooltipString','Back to the main ANALYSIS window');

callb=sprintf('back_ana(''ana0'',%u,'''');',length(stack.temp.handles));
set(Bott(1),'callback',callb);

Bott(2)=uicontrol('style','push','unit','normalized','position',[0.5 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'Horizontalalignment','center','string','S.VECTORS',...
   'callback','singvect;','tag','singval');

Bott(3)=uicontrol('style','push','unit','normalized','position',[0.73 0.05 0.22 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NORM( G(Jw) )',...
   'callback','normgjw;','tag','singval');


stack.temp.handles=Bott; %oggetti creati 

%--------------------------grafico------------------------------
sys=ss(stack.general.A,stack.general.B,stack.general.C,stack.general.D);

axes('Position',[0.12 0.33 0.78 0.57]);
[sv w]=sigma(sys);semilogx(w,20*log(sv));

ylabel('dB','fontsize',9);xlabel('frequency (rad/sec)','fontsize',9);
title('SINGULAR VALUES','color','y',... 
   'fontsize',9,'fontweight','demi');

set(gca,'tag','grafico');
crea_pop(1,'crea');

