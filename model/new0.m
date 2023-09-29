function new0
%NEW0: finestra di scelta delle dimensioni del sistema 
%
% Callback associata al comando New model del menu file e al
% bottone NEW della finestra di MODELING
%
% Massimo Davini 13/05/99 --- revised 16/03/00

global stack;
creato=stack.general.M_flag;  %new (unsaved) model flag

if creato==0
  if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
  end;

  delete(findobj('tag','matrice'));drawnow;
   
%-----------aggiornamento menu
  set(findobj('tag','file_2'),'enable','off');
  set(findobj('tag','file_3'),'enable','off');
  set(findobj('tag','file_4'),'enable','off');
  set(findobj('tag','file_5'),'enable','off');
  set(findobj('tag','file_6'),'enable','off');
  set(findobj('tag','file_7'),'enable','off');
   
  set(get(findobj('tag','tools_1'),'children'),'enable','off');

  set(get(findobj('tag','eval_1'),'children'),'enable','off');
  set(findobj('tag','simu_2'),'enable','off');
   
  set(findobj('tag','FrameA'),'visible','off');
  set(findobj('tag','bottA'),'visible','off');
  set(findobj('tag','FrameB'),'visible','off');
  set(findobj('tag','bottB'),'visible','off');
  set(findobj('tag','FrameC'),'visible','off');
  set(findobj('tag','bottC'),'visible','off');
  set(findobj('tag','FrameD'),'visible','off');
  set(findobj('tag','bottD'),'visible','off');
  set(findobj('tag','bottNew'),'visible','off');
  set(findobj('tag','bottLoad'),'visible','off');
  set(findobj('tag','BottAna'),'visible','off');
  set(findobj('tag','BottSyn'),'visible','off');
  drawnow;

  % enlarge text if java machine is running
jsz=stack.general.javasize;
  
%-----------creazione finestra
 set(gcf,'Name',' MIMO Tool : MODELING Untitled.mat --> NEW');

  n(1)=uicontrol('style','push','tag','new0',...
      'unit','normalized','position',[0.05 0.05 0.12 0.12],...
      'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
      'string','BACK','Horizontalalignment','center',...
      'TooltipString','Back to the main MODELING window',...
      'callback','back(0,''new0'');');
   
  n(2)=uicontrol('style','text','tag','new0',...
      'unit','normalized','position',[0.68 0.8 0.14 0.05],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor',[.6 .7 .9],'Horizontalalignment','center',...
      'string','(max 10)');

  n(3)=uicontrol('style','text','tag','new0',...
      'unit','normalized','position',[0.2 0.7 0.35 0.05],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor',[.6 .7 .9],'Horizontalalignment','left',...
      'string','NUMBER OF INPUTS');

  n(4)=uicontrol('style','edit','tag','NI',...
      'unit','normalized','position',[0.7 0.695 0.1 0.06],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor','y','string',num2str(1));
   
  n(5)=uicontrol('style','text','tag','new0',...
      'unit','normalized','position',[0.2 0.6 0.35 0.05],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor',[.6 .7 .9],'Horizontalalignment','left',...
      'string','NUMBER OF OUTPUTS');
   
  n(6)=uicontrol('style','edit','tag','NO',...
      'unit','normalized','position',[0.7 0.595 0.1 0.06],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor','y','string',num2str(1));

  n(7)=uicontrol('style','text','tag','new0',...
      'unit','normalized','position',[0.2 0.5 0.35 0.05],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor',[.6 .7 .9],'Horizontalalignment','left',...
      'string','NUMBER OF STATES');
   
  n(8)=uicontrol('style','edit','tag','NS',...
      'unit','normalized','position',[0.7 0.495 0.1 0.06],...
      'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
      'BackgroundColor','y','string',num2str(1));
   
  n(9)=uicontrol('style','push','tag','new0',...
      'unit','normalized','position',[0.2 0.35 0.6 0.1],...
      'fontunits','normalized','fontsize',jsz/4+0.42,'fontweight','bold',...
      'Horizontalalignment','center','string','INSERT THE MATRICES',...
      'callback','new1;');

%-----------aggiornamento variabili temporanee
   stack.temp.handles=n;
   stack.temp.A=[];      stack.temp.B=[];
   stack.temp.C=[];      stack.temp.D=[];
   stack.temp.flagA=[];  stack.temp.flagB=[];
   stack.temp.flagC=[];  stack.temp.flagD=[];
   stack.temp.matrice=[];
   
elseif creato==1
    messag(gcf,'n');
end;