function hmix3
%HMIX3 : 4° finestra di sintesi e di ottimizzazione H-MIX
%
%
% Massimo Davini 02/05/99


global stack;
delete(findobj('tag','grafico'));
set(stack.temp.handles,'visible','off');
drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz/2+.65;pos1=[0.062 0.75 0.44 0.18];pos2=[0.062 0.51 0.44 0.12];

mix3(1)=uicontrol('style','Frame','units','normalized','position',[0.05 0.66 0.46 0.29],...
   'backgroundcolor',[1 1 1],'tag','h2');

mix3(2)=uicontrol('style','text','units','normalized','position',pos1,...
   'fontunits','normalized','fontsize',.22,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'HorizontalAlignment','left','tag','h2',...
   'string','Do you want to express the weights of T or M using a derivative action on the plant?');

mix3(3)=uicontrol('style','radiobutton','units','normalized','position',[0.15 0.68 0.12 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'value',1,'tag','deriva1',...
   'HorizontalAlignment','left','string','YES',...
   'callback','sldopt(1,''deriva1'',''deriva2'');');

mix3(4)=uicontrol('style','radiobutton','units','normalized','position',[0.3 0.68 0.12 0.06],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'value',0,'tag','deriva2',...
   'HorizontalAlignment','left',...
   'string','NO ','callback','sldopt(2,''deriva1'',''deriva2'');');

drawnow;

mix3(5)=uicontrol('style','Frame','units','normalized','position',[0.05 0.22 0.46 0.43],...
     'backgroundcolor',[1 1 1],'tag','h2');

mix3(6)=uicontrol('style','text','units','normalized','position',pos2,...
   'fontunits','normalized','fontsize',.33,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[.5 .5 .5],...
   'HorizontalAlignment','left','tag','h2',...
   'string','Choose the function used to compute the controller :');

mix3(7)=uicontrol('style','radiobutton','units','normalized','position',[0.07 0.43 0.42 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.6,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'value',1,'HorizontalAlignment','left',...
   'string','hinfmix    (LMI toolbox)','tag','funz1',...
   'enable','off');
  
mix3(8)=uicontrol('style','text','units','normalized','position',[0.06 0.25 0.44 0.1],...
   'fontunits','normalized','fontsize',sizetext/1.8,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
   'HorizontalAlignment','left','tag','h2',...
   'string','The computation time could be long');
  
drawnow;

mix3(9)=uicontrol('style','push','unit','normalized','position',[0.57 0.85 0.38 0.1],...
   'fontunits','normalized','fontsize',jsz/3+.35,'fontweight','bold',...
   'Horizontalalignment','center','tag','BREG');

mix3(10)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','BottBC',...
   'TooltipString','Back to the previous window','userdata',sprintf('feval(''back_syn'',''mix2'',%u)',length(stack.temp.handles)),...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''back'');else back_syn(''mix2'',%u);end;',length(stack.temp.handles)));
   
campi=['''integratori'',''pesi'',''dfl_region'',''region'',''new_param'',''type'',''X1X2'',''plant'',''x2'',''X1'',''X2'',''Fx'''];
mix3(11)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center','userdata',sprintf('feval(''back_syn'',''syn0'',0,%s)',campi),...
   'TooltipString','Back to the main SYNTHESIS window','tag','BottBC',...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''close'');else back_syn(''syn0'',0,%s);end;',campi));
   
mix3(12)=uicontrol('style','push','unit','normalized','position',[0.39 0.05 0.275 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Evaluate the computed Controller',...
   'Horizontalalignment','center','string','EVALUATION',...
   'callback','valuta;','tag','BEVAL','enable','off');

mix3(13)=uicontrol('style','push','unit','normalized','position',[0.675 0.05 0.275 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Open the SIMULINK Closed-Loop-System',...
   'Horizontalalignment','center','string','SIMULATION',...
   'callback','simula;','tag','BSIMU','enable','off');

drawnow;

if isempty(stack.temp.pesi)
  set(mix3(9),'string','COMPUTE H - MIX','callback','hmix4;');
else
  set(mix3(9),'string','START OPTIMIZATION','callback','hmix4opt;');
end;

stack.temp.handles=[stack.temp.handles,mix3];