function hmix2
%HMIX2 : 3° finestra di sintesi e di ottimizzazione  H-MIX
%
%
% Massimo Davini 02/06/99

global stack;
set(stack.temp.handles,'visible','off');
drawnow;

if get(findobj('tag','opt1'),'value')==1 ;type=1;end;  %minimizz. di [T,S]'
if get(findobj('tag','opt2'),'value')==1 ;type=2;end;  %minimizz. di [M,S]'

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=.6;sizenota=.15;sizenota1=jsz/3+.2;

mix2(1)=uicontrol('style','text','units','normalized','position',[0.05 0.89 0.19 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.6,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'HorizontalAlignment','left',...
   'string','X1 (dB)    =','tag','mix2');

mix2(2)=uicontrol('style','edit','units','normalized','position',[0.25 0.89 0.09 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.6,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center','tag','EditX1');

mix2(3)=uicontrol('style','text','units','normalized','position',[0.05 0.79 0.19 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.6,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'HorizontalAlignment','left',...
   'string','X2 (-8..8) =','tag','mix2');
 
mix2(4)=uicontrol('style','edit','units','normalized','position',[0.25 0.79 0.09 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.6,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'HorizontalAlignment','center','tag','EditX2');
 
mix2(5)=uicontrol('style','push','unit','normalized','position',[0.05 0.67 0.29 0.08],...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','PLOT','tag','mix2',...
   'callback','stack.temp.X1X2=plotlimiti(''EditX1'',''EditX2'',stack.temp.type,stack.temp.plant);');
 
mix2(6)=uicontrol('style','Frame','units','normalized','position',[0.05 0.21 0.29 0.42],...
    'backgroundcolor',[1 1 1],'tag','mix2');

mix2(7)=uicontrol('style','text','units','normalized','position',[0.06 0.38 0.27 0.24],...
   'fontunits','normalized','fontsize',sizenota,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left','tag','mix2',...
   'position',[0.06 0.36 0.27 0.26]);

if type==1
   set(mix2(7),'string','For both functions X1 is the gain in dB and 10^X2 is the cutoff frequency');
elseif type==2
   set(mix2(7),'string','X1 is the gain in dB of M while 10^X2 is the crossover fr. for M and the cutoff fr. for S');
end;

mix2(8)=uicontrol('style','text','units','normalized','position',[0.06 0.22 0.27 0.15],...
   'fontunits','normalized','fontsize',sizenota1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left','foregroundcolor',[1 0 0],...
   'string','Default values are recommended !','tag','mix2');
 
campi0=['''X1'',''X2'',''Fx'''];
mix2(9)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','mix2',...
   'TooltipString','Back to the previous window',...
   'callback',sprintf('back_syn(''mix1'',%u,%s);',length(stack.temp.handles),campi0)); 
 
campi=['''integratori'',''pesi'',''dfl_region'',''region'',''new_param'',''type'',''X1X2'',''plant'',''x2'',''X1'',''X2'',''Fx'''];
mix2(10)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main SYNTHESIS window',...
   'callback',sprintf('back_syn(''syn0'',0,%s);',campi),'tag','mix2');
 
mix2(11)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','mix2',...
   'TooltipString','Go to the next window','callback','hmix3;');
 
 
drawnow;
stack.temp.handles=[stack.temp.handles,mix2];


G=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);

stack.temp.type=type;
stack.temp.plant=G;
stack.temp.X1X2=plotlimiti('EditX1','EditX2',stack.temp.type,stack.temp.plant);
stack.temp.X1=[];  %serve in caso di ottimizzazione
stack.temp.X2=[];  %serve in caso di ottimizzazione
stack.temp.Fx=[];  %serve in caso di ottimizzazione