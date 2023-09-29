function default
%DEFAULT : riporta la regione e la finestra ai valori di default 
%
%
% Massimo Davini 01/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

delgraf;

handles=stack.temp.handles;
if ~isempty(findobj('tag','para'))
   x=length(handles);
   delete(stack.temp.handles(x-11:x));
   handles(x-11:x)=[];
   stack.temp.handles=handles;   
end;

set(findobj('tag','testo'),'visible','off');

set(findobj('tag','ck1'),'value',1,'enable','inactive','foregroundcolor',[0 0 1]);
set(findobj('tag','ck2'),'value',0,'enable','off');
set(findobj('tag','ck3'),'value',1,'enable','inactive','foregroundcolor',[0 0 1]);
set(findobj('tag','ck4'),'value',0,'enable','off');
set(findobj('tag','ck5'),'value',0,'enable','off');
set(findobj('tag','ck6'),'value',0,'enable','off');

set(gcbo,'enable','off');
set(findobj('tag','BNEW'),'enable','on');

drawnow;

x2=stack.temp.x2;
stack.temp.region=stack.temp.dfl_region;

%---grafico della regione di default----

x2=-10^x2;
x1=x2-5*abs(x2);
vx=[x2 x2 x1 x1]';vy=tan(1)*[x2 -x2 -x1 x1]';

h=fill(vx,vy,'b');grid;
set(h,'tag','grafico');
axis([x1,0,tan(1)*x1*1.3,-tan(1)*x1*1.3]);
set(gca,'position',[0.44 0.33 0.51 0.55],'tag','grafico');

title('     DEFAULT REGION (complex plane)','color','y',...
   'fontsize',9,'fontweight','demi');
xlabel(sprintf('max. absciss = %s , inner angle = 2 rad',num2str(x2)),'fontsize',8); 

crea_pop(0,'crea');
