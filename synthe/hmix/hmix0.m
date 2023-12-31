function hmix0(n,pesi)
%H-MIX0 : 1° finestra di sintesi e di ottimizzazione  H-MIX
%
%                     hmix0(n,pesi)
%
%  n         = intero che indica il numero di blocchi di integratori
%              da aggiungere al sistema
%              (presente sia in caso di sintesi che di ottimizzazione)
%
%  pesi      = vettore riga di 4 elementi rappresentanti i pesi
%              della funzione di costo da minimizzare : vedi il manuale
%              per maggiori informazioni
%              (presente solo in caso di ottimizzazione)
%
%
% Massimo Davini 31/05/99 --- revised 01/06/99

if nargin<2 pesi=[];end;
   
global stack;

set(findobj('tag','integratori'),'visible','off');
set(findobj('tag','EditIntegr'),'visible','off');
drawnow;

G=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);


stack.temp.integratori=n;
stack.temp.pesi=pesi;
stack.temp.dfl_region=[];           %regione di default
stack.temp.region=[];               %eventuale nuova regione
stack.temp.new_param.p1=cell(4,1);  %parametri del 1° tipo di regione
stack.temp.new_param.p2=cell(4,1);  %parametri del 2° tipo di regione 
stack.temp.new_param.p3=cell(4,1);  %parametri del 3° tipo di regione 
stack.temp.new_param.p4=cell(4,1);  %parametri del 4° tipo di regione 
stack.temp.new_param.p5=cell(4,1);  %parametri del 5° tipo di regione 
stack.temp.new_param.p6=cell(4,1);  %parametri del 6° tipo di regione 
stack.temp.type=[];
stack.temp.X1X2=[];
stack.temp.plant=G;

%---------------- regione di default-------------------

w=logspace(-10,10,100);
fr=20*log10(vunpck(norm3(frsp(G,w))));
k0=mean(fr(1:10));
bd=log10(max(w'.*((k0-fr)<3)));
x2=min(max(-2,bd),2);

stack.temp.x2=x2;

region_default=[10^x2+sqrt(-1) 0 0 1 0 0;
                0 2*sqrt(-1) 0 0 sin(1) -cos(1);
                0 0 0 0 cos(1) sin(1)];

stack.temp.dfl_region=region_default;
stack.temp.region=region_default;

%------------nomi dei campi inseriti,necessari per la callback di BACK e CLOSE---------------
campi=['''integratori'',''pesi'',''dfl_region'',''region'',''new_param'',''type'',''X1X2'',''plant'',''x2'''];

%-----------------------------finestra------------------------------------

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=.3;sizetext1=.7;pos=[0.36 0.03 0.43 0.14];

mix(1)=uicontrol('style','frame','units','normalized',...
      'position',[0.05 0.24 0.29 0.72],'backgroundcolor',[1 1 1],...
      'tag','mix0','visible','off');

mix(2)=uicontrol('style','text','units','normalized','position',[0.07 0.88 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
     'foregroundcolor','red','string','Kind of region :',...
     'visible','off','tag','mix0');

mix(3)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.81 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
     'string','Half plane','value',1,'tag','ck1','visible','off',...
     'callback','setparam(1);','foregroundcolor',[0 0 1],...
     'enable','inactive');

mix(4)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.75 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'value',0,'HorizontalAlignment','left',...
     'string','Disk','tag','ck2','visible','off',...
     'callback','setparam(2);',...
     'enable','off');

mix(5)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.69 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'value',1,'HorizontalAlignment','left',...
     'string','Conic sector','tag','ck3','visible','off',...
     'callback','setparam(3);','foregroundcolor',[0 0 1],...
     'enable','inactive');

mix(6)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.63 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'value',0,'HorizontalAlignment','left',...
     'string','Ellipsoid','tag','ck4','visible','off',...
     'callback','setparam(4);',...
     'enable','off');

mix(7)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.57 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'value',0,'HorizontalAlignment','left',...
     'string','Parabola','tag','ck5','visible','off',...
     'callback','setparam(5);',...
     'enable','off');

mix(8)=uicontrol('style','checkbox','units','normalized','position',[0.07 0.51 0.26 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'value',0,'HorizontalAlignment','left',...
     'string','Horizontal strip','tag','ck6','visible','off',...
     'callback','setparam(6);',...
     'enable','off');
   
mix(9)=uicontrol('style','push','unit','normalized','position',[0.07 0.44 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'string','DEFAULT','Horizontalalignment','center',...
     'enable','off','tag','BDFL','visible','off',...
     'TooltipString','Reload the default settings',...
     'callback','default;');
   
mix(10)=uicontrol('style','push','unit','normalized','position',[0.07 0.37 0.25 0.06],...
     'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
     'string','NEW','Horizontalalignment','center',...
     'enable','on','tag','BNEW','visible','off',...
     'TooltipString','Make a new region',...
     'callback','newregion;');

mix(11)=uicontrol('style','text','units','normalized','position',[0.07 0.27 0.26 0.09],...
     'fontunits','normalized','fontsize',jsz/1.2+sizetext,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
     'foregroundcolor',[1 0 0],'tag','mix0','visible','off',...
     'string','Default values are recommended !');
   
mix(12)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'string','BACK','Horizontalalignment','center','tag','mix0',...
     'TooltipString','Back to the previous window',...
     'callback',sprintf('back_syn(''integratori'',%u,%s);',length(stack.temp.handles),campi)); 

mix(13)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'string','CLOSE','Horizontalalignment','center',...
     'TooltipString','Back to the main SYNTHESIS window',...
     'callback',sprintf('back_syn(''syn0'',0,%s);',campi),'tag','mix0');
 
mix(14)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'Horizontalalignment','center','string','NEXT','tag','mix0',...
     'TooltipString','Go to the next window','callback','hmix1;');
 
mix(15)=uicontrol('style','text','units','normalized','position',pos,...
     'fontunits','normalized','fontsize',jsz+sizetext1/6,'fontweight','bold',...
     'backgroundcolor',[.6 .7 .9],'HorizontalAlignment','left',...
     'foregroundcolor',[0 0  0],'tag','testo','visible','off',...
     'string','The overall region will be the intersection of the selected regions.');

set(mix(1:14),'visible','on');

drawnow; 

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

%-------------aggiornamento handles temporanei------------------
stack.temp.handles=[stack.temp.handles,mix];