
function optimlqg0(integratori,pesi)
%OPTIMLQG0 : finestra di ottimozzazione per l'LQG
%
%    optimlqg0(integratori,pesi)
%
%  integratori = intero che indica il numero di blocchi di
%                integratori da aggiungere al sistema
%  pesi        = vettore di 4 elementi che rappresentano
%                i pesi della funzione di costo da minimizzare
%
%
% Massimo Davini 15/05/99 --- revised 02/06/99

global stack;
set(stack.temp.handles,'visible','off');
G=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D)

stack.temp.integratori=integratori;
stack.temp.pesi=pesi;
stack.temp.X1=[];     %per il grafico finale
stack.temp.X2=[];     %per il grafico finale
stack.temp.Fx=[];     %per il grafico finale
stack.temp.plant=G;

%----------------------------------------------

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz*0.8+.6;

opt(1)=uicontrol('style','Frame','units','normalized','position',[0.05 0.37 0.29 0.58],...
   'backgroundcolor',[1 1 1],'tag','optlqg','visible','off');

opt(2)=uicontrol('style','text','units','normalized','position',[0.07 0.85 0.25 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'HorizontalAlignment','left','string','Matrices :','tag','optlqg');

opt(3)=uicontrol('style','text','units','normalized','position',[0.07 0.78 0.08 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'string','R = I','tag','optlqg');

opt(4)=uicontrol('style','text','units','normalized','position',[0.16 0.78 0.16 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','right',...
   'string','Q = X1 * I','tag','optlqg');

opt(5)=uicontrol('style','text','units','normalized','position',[0.07 0.71 0.08 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'string','V = I','tag','optlqg');

opt(6)=uicontrol('style','text','units','normalized','position',[0.16 0.71 0.16 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','right',...
   'string','W = X2 * I','tag','optlqg');

opt(7)=uicontrol('style','text','units','normalized','position',[0.07 0.58 0.25 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'HorizontalAlignment','left','string','Initial values :','tag','optlqg');

opt(8)=uicontrol('style','text','units','normalized','position',[0.07 0.51 0.1 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'string','X1  =','tag','optlqg');

opt(9)=uicontrol('style','edit','units','normalized','position',[0.22 0.51 0.1 0.06],...
   'fontunits','normalized','fontsize',jsz+0.5,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'string',num2str(0),'tag','editlqg1');

opt(10)=uicontrol('style','text','units','normalized','position',[0.07 0.43 0.1 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'string','X2  =','tag','optlqg');

opt(11)=uicontrol('style','edit','units','normalized','position',[0.22 0.43 0.1 0.06],...
   'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'string',num2str(0),'tag','editlqg2');

set(opt,'visible','on');
drawnow;

opt(12)=uicontrol('style','push','unit','normalized','position',[0.05 0.22 0.29 0.1],...
   'fontunits','normalized','fontsize',.4,'fontweight','bold',...
   'Horizontalalignment','center','tag','BREG',...
   'TooltipString','Start the LQG Optimization',...
   'string','START','callback','optimlqg1;');

campi='''integratori'',''pesi'',''X1'',''X2'',''Fx'',''plant''';
opt(13)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','BottBC',...
   'TooltipString','Back to the previous window','userdata',sprintf('feval(''back_syn'',''integratori'',%u,%s)',length(stack.temp.handles),campi),...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''back'');else back_syn(''integratori'',%u,%s);end;',length(stack.temp.handles),campi));
   
opt(14)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center','userdata',sprintf('feval(''back_syn'',''syn0'',0,%s)',campi),...
   'TooltipString','Back to the main SYNTHESIS window','tag','BottBC',...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''close'');else back_syn(''syn0'',0,%s);end;',campi));
   
opt(15)=uicontrol('style','push','unit','normalized','position',[0.39 0.05 0.275 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Evaluate the computed Controller',...
   'Horizontalalignment','center','string','EVALUATION',...
   'callback','valuta;','tag','BEVAL','enable','off');

opt(16)=uicontrol('style','push','unit','normalized','position',[0.675 0.05 0.275 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Open the SIMULINK Closed-Loop-System',...
   'Horizontalalignment','center','string','SIMULATION',...
   'callback','simula;','tag','BSIMU','enable','off');

drawnow;

stack.temp.handles=[stack.temp.handles,opt];

