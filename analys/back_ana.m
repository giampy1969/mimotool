function back_ana(tag_to,ogg_prec,varargin)
%BACK ANALYSYS: calbk di ogni bottone BACK nella sezione di ANALYSIS
%
%        back_ana(tag_to,ogg_prec,varargin)
%
% tag_to     = stringa che rappresenta il campo tag degli oggetti
%              o della maggior parte degli oggetti (è possibile
%              infatti che alcuni di loro abbiano tag particolari
%              diversi) della finestra a cui vogliamo tornare
% ogg_prec   = intero che rappresenta la lunghezza che il vettore degli
%              handle degli oggetti temporanei creati all'interno
%              di una particolare sezione,memorizzato nel campo
%              stack.temp.handles,dovrà raggiungere alla fine 
%              dell'esecuzione di questa funzione.
%              Se ogg_rec=[] significa che devono essere eliminati
%              tutti gli oggetti del vettore;altrimenti se ogg_prec=x
%              significa che dobbiamo eliminare gli oggetti dal vettore
%              a partire dall'elemento di indice x+1 in poi.
% varargin   = questo parametro può essere presente o meno ed è
%              costituito da una serie di lunghezza variabile di stringhe
%              che rappresentano i nomi dei nuovi campi della struttura 
%              stack.temp creati all'interno della sezione corrente.
%              Se sono stati creati nuovi campi per memorizzare 
%              nuove variabili,i nomi di questi campi vengono passati
%              a questa funzione per eliminarli dalla struttura 
%              stack.temp
%               
%
% Massimo Davini 30/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

delgraf;
delete(findobj('tag','matrice'));
set(findobj('tag','file_7'),'enable','off');

if isempty(ogg_prec) ogg_prec=0;end;
x=length(stack.temp.handles);
delete(stack.temp.handles(ogg_prec+1:x));
stack.temp.handles(ogg_prec+1:x)=[];
if isempty(stack.temp.handles) stack.temp=rmfield(stack.temp,'handles');end;

if ~strcmp(varargin,'')
for i=1:length(varargin)
 eval(sprintf('stack.temp=rmfield(stack.temp,''%s'');',varargin{i}));
end;
end;

drawnow;

modello=stack.general.model;
A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

switch tag_to
case 'ana0'
   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s',modello));
   
case 'singval'
   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Singular Values',modello));
   
   sys=ss(A,B,C,D);
   axes('Position',[0.12 0.33 0.78 0.57]);
   [sv w]=sigma(sys);semilogx(w,20*log(sv));
   ylabel('dB','fontsize',9);xlabel('frequency (rad/sec)','fontsize',9);
   title('SINGULAR VALUES','color','y','fontsize',9,'fontweight','demi');
   set(gca,'tag','grafico');
   crea_pop(1,'crea');
   
case 'pzmaps'
   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Poles and Zeros',modello));
   set(gca,'Position',[0.1 0.45 0.49 0.45]);
   
   mypzmap(A,B,C,D);xlabel('');ylabel('');
   title('       PZMAP ( Open Loop System )','color','y',... 
     'fontsize',9,'fontweight','demi');
   set(gca,'tag','grafico');
   crea_pop(1,'crea');

   set(findobj('tag','TestoP'),'visible','on');
   set(findobj('tag','FP'),'visible','on');
   set(findobj('tag','poli1'),'visible','on');
   
case 'con_obs'   
   tipo=get(stack.temp.handles(2),'string');
   tipo=tipo(1:4);
   if strcmp(tipo,'CTRB') str='Ctrb';
   else str='Obsv';
   end;
   
   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> %s of Poles',modello,str));
   
   cv_ov=stack.temp.gramians;
   [E,L]=eig(A);l=diag(L);
   
   set(gca,'Position',[0.08 0.3 0.85 0.6]);    
   plot3(real(l),imag(l),log10(cv_ov),'r*','MarkerSize',5);
   xlabel('real axis','fontsize',9);ylabel('imag axis','fontsize',9);
   grid;
   set(gca,'tag','grafico');
   crea_pop(0,'crea');

   title(sprintf('%s OF POLES',tipo),'color','y','fontsize',9,...
      'fontweight','demi');
   
end;

  
set(findobj('tag',tag_to),'visible','on');
