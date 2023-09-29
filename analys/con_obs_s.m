function con_obs_s(tipo)
%CONTROLLABILITY or OBSERVABILITY of states window
%
% con_obs_s(tipo)
%
% tipo : 'ctrbs' o 'obsvs' a seconda che voglia esaminare la
%        controllabilità o l'osservabilità dei poli
%
% Massimo Davini 18/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack
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
stack.temp.handles=[];
%---------------------------------------------------------------

if strcmp(tipo,'ctrbs') str='CTRB';
elseif strcmp(tipo,'obsvs') str='OBSV';
else return;
end;

set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> %s of States',stack.general.model,str));

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

sys=pck(A,B,C,D);
[ty,no,ni,ns]=minfo(sys);

co_s(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback',sprintf('back_ana(''ana0'',%u);',length(stack.temp.handles)));

co_s(2)=uicontrol('style','frame','units','normalized',...
   'position',[0.39 0.05 0.56 0.12],'backgroundcolor',[1 1 1],...
   'visible','off');

co_s(3)=uicontrol('style','text','units','normalized',...
   'fontunits','normalized','fontsize',.7,'fontweight','bold',...
   'position',[0.4 0.08 0.54 0.06],'backgroundcolor',[1 1 1],...
   'foregroundcolor','blue','visible','off');

if strcmp(tipo,'ctrbs')      
   G=gram3(A,B);    %ctrb gramian
   set(co_s(3),'string',sprintf(' RANK OF CTRB ( A,B )  =  %u',rank(ctrb(A,B))))
elseif strcmp(tipo,'obsvs')  
   G=gram3(A',C');  %obsv gramian
   set(co_s(3),'string',sprintf(' RANK OF OBSV ( A,C )  =  %u',rank(obsv(A,C))))
end;

set(co_s,'visible','on');
drawnow;

[U,S,V]=svd(G);
c0_o0=1./abs(sqrt(diag(pinv(U*S*U'))));

stack.temp.handles=co_s;

set(gca,'position',[0.1 0.3 0.8 0.6]);
semilogy(c0_o0,'r'); xlabel('States','fontsize',9);ylabel('');

set(gca,'tag','grafico');
title(sprintf('%s GRAMIAN',str),'color','y',...
   'fontsize',9,'fontweight','demi');
crea_pop(0,'crea');