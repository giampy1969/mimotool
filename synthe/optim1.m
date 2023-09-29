function optim1(tipo)
% Creazione della seconda finestra (comune) di ottimizzazione 
%
%                 optim1(tipo)
%
% tipo = stringa che rappresenta il tipo di ottimizzazione 
%        richiesta ( 'H-I','H-2','H-MIX','MU' o 'LQG').
%
% Massimo Davini 08/05/99 --- revised 09/12/99
global stack;
set(stack.temp.handles,'visible','off');drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

st=.2;st1=jsz+.5;

opti(1)=uicontrol('style','frame','units','normalized','position',[0.1 0.22 0.8 0.73],...
   'backgroundcolor',[1 1 1],'visible','off','tag','opti1');
opti(2)=uicontrol('style','text','units','normalized','position',[0.13 0.87 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
   'string','The COST FUNCTION is the sum of :','tag','opti1');

TERM1='  C1 * ( 1/Min( Det ( I+GK ) )';
TERM2='  C2 * ( Max( Eig ( To ) ) )';
TERM3='  C3 * ( Max( To Overshoot ) )';
TERM4='  C4 * ( Max( To Settling Time ) )';
TERM5='  Max ( Eig ( To ) ) < 0';
TERM6='  10^-2 < To Settling Time < 10^3';

opti(3)=uicontrol('style','text','units','normalized','position',[0.13 0.8 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'visible','off',...
   'HorizontalAlignment','left','string',TERM1,'tag','opti1');
opti(4)=uicontrol('style','text','units','normalized','position',[0.13 0.74 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'visible','off',...
   'HorizontalAlignment','left','string',TERM2,'tag','opti1');
opti(5)=uicontrol('style','text','units','normalized','position',[0.13 0.68 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'HorizontalAlignment','left',...
   'visible','off','string',TERM3,'tag','opti1');
opti(6)=uicontrol('style','text','units','normalized','position',[0.13 0.62 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'HorizontalAlignment','left',...
   'visible','off','string',TERM4,'tag','opti1');
opti(7)=uicontrol('style','text','units','normalized','position',[0.13 0.41 0.74 0.2],...
   'fontunits','normalized','fontsize',st,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left','visible','off',...
   'string',strvcat('with To = Po = inv( I+GK )GK','and with the following constraints :'),...
   'tag','opti1');
opti(8)=uicontrol('style','text','units','normalized','position',[0.13 0.41 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'HorizontalAlignment','left',...
   'visible','off','string',TERM5,'tag','opti1');
opti(9)=uicontrol('style','text','units','normalized','position',[0.13 0.35 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],'HorizontalAlignment','left',...
   'visible','off','string',TERM6,'tag','opti1');
opti(10)=uicontrol('style','text','units','normalized','position',[0.13 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'visible','off','backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'string','C1 =','tag','opti1');
opti(11)=uicontrol('style','edit','units','normalized','position',[0.21 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'visible','off','string',num2str(1),'tag','edit1');
opti(12)=uicontrol('style','text','units','normalized','position',[0.29+.1/3 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'visible','off','string','C2 =','tag','opti1');
opti(13)=uicontrol('style','edit','units','normalized','position',[0.37+.1/3 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'visible','off','string',num2str(0.01),'tag','edit2');
opti(14)=uicontrol('style','text','units','normalized','position',[0.45+.2/3 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'visible','off','string','C3 =','tag','opti1');
opti(15)=uicontrol('style','edit','units','normalized','position',[0.53+.2/3 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'visible','off','string',num2str(100),'tag','edit3');
opti(16)=uicontrol('style','text','units','normalized','position',[0.71 0.25 0.08 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'visible','off','string','C4 =','tag','opti1');
opti(17)=uicontrol('style','edit','units','normalized','position',[0.79 0.25 0.08 0.06],...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center',...
   'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
   'visible','off','string',num2str(1),'tag','edit4');
opti(18)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','opti1',...
   'TooltipString','Back to the previous window',...
   'callback',sprintf('back_syn(''opti0'',%u);',length(stack.temp.handles))); 
opti(19)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main SYNTHESIS window',...
   'callback','back_syn(''syn0'',0);','tag','opti1');
opti(20)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','opti1',...
   'TooltipString','Go to the next window',...
   'callback',sprintf('optim2(''%s'');',tipo));

set(opti,'visible','on');
stack.temp.handles=[stack.temp.handles,opti];