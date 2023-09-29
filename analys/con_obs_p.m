function con_obs_p(tipo)
%CONTROLLABILITY or OBSERVABILITY of poles window
%
% con_obs_p(tipo)
%
% tipo : 'ctrbp' o 'obsvp' a seconda che voglia esaminare la
%        controllabilità o l'osservabilità dei poli
%
% Massimo Davini 15/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack

if strcmp(tipo,'ctrbp') str='CTRB';
elseif strcmp(tipo,'obsvp') str='OBSV';
else return;
end;

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

set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> %s of Poles',stack.general.model,str));

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

co(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','con_obs',...
   'TooltipString','Back to the main ANALYSIS window',...
   'callback',sprintf('back_ana(''ana0'',%u,''gramians'');',length(stack.temp.handles)));

co(2)=uicontrol('style','push','units','normalized','position',[0.55 0.05 0.4 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'TooltipString','Go to the next window','tag','con_obs');

[ns ni]=size(B);
[no ni]=size(D);
if strcmp(tipo,'ctrbp')
   set(co(2),'string','CTRB with INPUT ...','callback','con_obs_p1(''ctrbp'');');
   if (ni>10)|(ns>20) set(co(2),'enable','off');end; 
   
   Gc=gram3(A,B);        %gramiano di controllabilità
   [U,S,V]=svd(Gc);
   
elseif strcmp(tipo,'obsvp')
   set(co(2),'string','OBSV from OUTPUT...','callback','con_obs_p1(''obsvp'');');
   if (no>10)|(ns>20) set(co(2),'enable','off');end; 
   
   Go=gram3(A',C');      %gramiano di osservabilità
   [U,S,V]=svd(Go);

end;


[E,L]=eig(A);
cv_ov=1./abs(sqrt(diag(pinv(E'*U*S*U'*E))));
l=diag(L);

stack.temp.handles=co;      %handles oggetti creati in questa finestra
stack.temp.gramians=cv_ov;  %variabile cv_ov

set(gca,'Position',[0.08 0.3 0.85 0.6]);    
plot3(real(l),imag(l),log10(cv_ov),'r*','MarkerSize',5);
xlabel('real axis','fontsize',9);ylabel('imag axis','fontsize',9);
grid;
set(gca,'tag','grafico');

title(sprintf('%s OF POLES',str),'color','y','fontsize',9,...
     'fontweight','demi');

crea_pop(0,'crea');
