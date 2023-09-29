function mfc_2(tipo);
%MFC2 : creazione della 2° finestra del controllo EMFC o IMFC
%
%
%Massimo Davini 26/05/99 --- revised 31/05/99

global stack;

set(stack.temp.handles,'visible','off');
drawnow;

sizetext=.3;sizetext1=.2167;sizefor=.6;

mfc(1)=uicontrol('style','frame','units','normalized',...
   'position',[0.035 0.835 0.11 0.11],'backgroundcolor',[1 1 1],...
   'Visible','off','tag','FQ');

mfc(2)=uicontrol('style','frame','units','normalized',...
   'position',[0.165 0.835 0.11 0.11],'backgroundcolor',[1 1 1],...
   'Visible','off','tag','FR');

ist0='set(findobj(''tag'',''nota''),''visible'',''off'');';
ist1='set(findobj(''tag'',''FQ''),''visible'',''off'');';
ist2='set(findobj(''tag'',''FR''),''visible'',''off'');';
ist3='set(findobj(''tag'',''FQ''),''visible'',''on'');';
ist4='set(findobj(''tag'',''FR''),''visible'',''on'');';
ist5='set(findobj(''tag'',''BREG''),''visible'',''off'');';
ist6='set(findobj(''tag'',''BSAVE''),''visible'',''on'',''enable'',''on'');';

mfc(3)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','Q',...
   'position',[0.05 0.85 0.08 0.08],...
   'callback',[ist0,ist2,ist3,'setmatrix(stack.temp.Q,''Q'');',ist5,ist6],'tag','BQ');
    
mfc(4)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','R',...
   'position',[0.18 0.85 0.08 0.08],...
   'callback',[ist0,ist1,ist4,'setmatrix(stack.temp.R,''R'');',ist5,ist6],'tag','BR');

mfc(5)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string',sprintf('COMPUTE %s',tipo),...
   'position',[0.5 0.85 0.45 0.08],...
   'callback',sprintf('mfc3(''%s'');',tipo),'tag','BREG');

mfc(6)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','SAVE MATRIX',...
   'position',[0.5 0.85 0.45 0.08],'enable','off',...
   'callback','salvamfc;','tag','BSAVE');

mfc(7)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','BottBC',...
   'TooltipString','Back to the previous window','userdata',sprintf('feval(''back_syn'',''mfc1'',%u,''Q'',''R'',''flagQ'',''flagR'',''modello'')',length(stack.temp.handles)),...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''back'');else back_syn(''mfc1'',%u,''Q'',''R'',''flagQ'',''flagR'',''modello'');end;',length(stack.temp.handles)));
  
mfc(8)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center','userdata','feval(''back_syn'',''syn0'',0,''Q'',''R'',''flagQ'',''flagR'',''modello'');',...
   'TooltipString','Back to the main SYNTHESIS window','tag','BottBC',...
   'callback','if stack.general.K_flag messag(gcf,''kns'',''close'');else back_syn(''syn0'',0,''Q'',''R'',''flagQ'',''flagR'',''modello'');end;');
      
mfc(9)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Evaluate the computed Controller',...
   'Horizontalalignment','center','string','EVALUATION',...
   'position',[0.39 0.05 0.275 0.12],...
   'callback','valuta;','tag','BEVAL','enable','off');

mfc(10)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Open the SIMULINK Closed-Loop-System',...
   'Horizontalalignment','center','string','SIMULATION',...
   'position',[0.675 0.05 0.275 0.12],...
   'callback','simula;','tag','BSIMU','enable','off');

drawnow;

mfc(11)=uicontrol('style','frame',...
   'units','normalized','position',[0.15 0.27 0.7 0.48],...
   'backgroundcolor',[1 1 1],'tag','nota');

mfc(12)=uicontrol('style','text',...
   'units','normalized','position',[.17 .58 .66 0.13],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','left','tag','nota',...
   'string','Insert the matrices Q and R of the cost function that will be minimized:');

mfc(13)=uicontrol('style','text',...
   'units','normalized','position',[.17 .49 .66 0.07],...
   'fontunits','normalized','fontsize',sizefor,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','center','tag','nota');

mfc(14)=uicontrol('style','text',...
   'units','normalized','position',[.17 .28 .66 0.18],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','left','tag','nota');

if strcmp(tipo,'EMFC')
  set(mfc(13),'string','integral{ ((Y -Ym )''Q(Y - Ym) + u''Ru)dt }');
  str=['where Y is the system output vector, Ym is the model',...
        ' output vector and U is the system control vector.'];
  set(mfc(14),'string',str);
elseif strcmp(tipo,'IMFC')
  set(mfc(13),'string','integral{ ((Y° - Ym°)''Q(Y° - Ym°)+u''Ru)dt }');
  str=['where Y° and Ym° are respectively the time derivatives of the system',...
        ' and model output vectors, while U is the system control vector.'];
  set(mfc(14),'string',str);
end;


set(mfc(12),'foreground','black');
set(mfc(13),'foreground','red');
set(mfc(14),'foreground','black');

%aggiornamento handles temporanei
stack.temp.handles=[stack.temp.handles,mfc];


