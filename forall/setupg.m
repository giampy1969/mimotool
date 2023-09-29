function setupg;
%SETUPG 
%funzione associata al menu di popup "Graphic Setup ..." relativo
%ad un grafico; tale funzione copia il grafico selezionato in una
%nuova finestra rendendone possibile la modifica e la successiva
%stampa
%
%
% Massimo Davini---16/01/00

pos=get(gcf,'position');
posnew=[pos(1)+pos(3)*.02,pos(2)+pos(4)*.025,pos(3)*.96,pos(4)*.85];
handle1=gca;

handle2=figure('menubar','figure','unit','normalized',...
    'NumberTitle','off','name','Graphic Setup ...',...
    'visible','off','position',posnew);
c=copyobj(handle1,handle2);

set(get(handle2,'currentaxes'),'position',[.15 .2 .7 .65]);
set(get(get(handle2,'currentaxes'),'title'),'color','r',...
    'fontsize',9,'fontweight','normal');

pause(.05);
set(handle2,'visible','on');