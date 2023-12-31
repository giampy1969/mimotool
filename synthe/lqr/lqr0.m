function lqr0
%LQR0 : funzione di creazione della finestra del controllo LQR
%
%
% Massimo Davini 25/05/99 --- revised 31/05/99

global stack;
set(findobj('tag','sfnota'),'visible','off');

%-----------aggiornamento variabili temporanee---------------
[no,ni]=size(stack.general.D);
Q=eye(size(stack.general.A));
R=eye(ni);

stack.temp.Q=Q;
stack.temp.R=R;
stack.temp.flagQ=0;   %flag di memorizzazione di Q
stack.temp.flagR=0;   %flag di memorizzazione di R
%-------------------------------------------------

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz/10+.3;sizetext1=jsz/10+.229;sizefor=jsz/5+.55;

lq(1)=uicontrol('style','frame','units','normalized',...
   'position',[0.035 0.835 0.11 0.11],'backgroundcolor',[1 1 1],...
   'Visible','off','tag','FQ');

lq(2)=uicontrol('style','frame','units','normalized',...
   'position',[0.165 0.835 0.11 0.11],'backgroundcolor',[1 1 1],...
   'Visible','off','tag','FR');

ist0='set(findobj(''tag'',''nota''),''visible'',''off'');';
ist01='delete(findobj(''tag'',''inf''));';
ist1='set(findobj(''tag'',''FQ''),''visible'',''off'');';
ist2='set(findobj(''tag'',''FR''),''visible'',''off'');';
ist3='set(findobj(''tag'',''FQ''),''visible'',''on'');';
ist4='set(findobj(''tag'',''FR''),''visible'',''on'');';
ist5='set(findobj(''tag'',''BREG''),''visible'',''off'');';
ist6='set(findobj(''tag'',''BSAVE''),''visible'',''on'',''enable'',''on'');';

lq(3)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','Q',...
   'position',[0.05 0.85 0.08 0.08],...
   'callback',[ist0,ist01,ist2,ist3,'setmatrix(stack.temp.Q,''Q'');',ist5,ist6],'tag','BQ');
    
lq(4)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','R',...
   'position',[0.18 0.85 0.08 0.08],...
   'callback',[ist0,ist01,ist1,ist4,'setmatrix(stack.temp.R,''R'');',ist5,ist6],'tag','BR');

lq(5)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','COMPUTE LQR',...
   'position',[0.5 0.85 0.45 0.08],...
   'callback','lqr1;','tag','BREG');

lq(6)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.5,'fontweight','bold',...
   'Horizontalalignment','center','string','SAVE MATRIX',...
   'position',[0.5 0.85 0.45 0.08],'enable','off',...
   'callback','salvalqr;','tag','BSAVE');

lq(7)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','BottBC',...
   'TooltipString','Back to the previous window','userdata',sprintf('feval(''back_syn'',''sfnota'',%u,''Q'',''R'',''flagQ'',''flagR'')',length(stack.temp.handles)),...
   'callback',sprintf('if stack.general.K_flag messag(gcf,''kns'',''back'');else back_syn(''sfnota'',%u,''Q'',''R'',''flagQ'',''flagR'');end;',length(stack.temp.handles)));

lq(8)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center','userdata','back_syn(''syn0'',0,''Q'',''R'',''flagQ'',''flagR'');',...
   'TooltipString','Back to the main SYNTHESIS window','tag','BottBC',...
   'callback','if stack.general.K_flag messag(gcf,''kns'',''close'');else back_syn(''syn0'',0,''Q'',''R'',''flagQ'',''flagR'');end;');

lq(9)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Evaluate the computed Controller',...
   'Horizontalalignment','center','string','EVALUATION',...
   'position',[0.39 0.05 0.275 0.12],...
   'callback','valuta;','tag','BEVAL','enable','off');

lq(10)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'TooltipString','Open the SIMULINK Closed-Loop-System',...
   'Horizontalalignment','center','string','SIMULATION',...
   'position',[0.675 0.05 0.275 0.12],...
   'callback','simula;','tag','BSIMU','enable','off');

drawnow;

lq(11)=uicontrol('style','frame','units','normalized',...
   'backgroundcolor',[1 1 1],'position',[0.15 0.27 0.7 0.48],'tag','nota');

lq(12)=uicontrol('style','text','units','normalized','position',[.18 .57 .64 0.13],...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','left','tag','nota',...
   'string','Insert the matrices Q and R of the cost function J that will be minimized:');

lq(13)=uicontrol('style','text','units','normalized','position',[.17 .48 .66 0.07],...
   'fontunits','normalized','fontsize',sizefor,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','center','tag','nota',...
   'string','J = Integral {  X'' Q X + U'' R U  } dt');

lq(14)=uicontrol('style','text','units','normalized','position',[.18 .29 .64 0.17],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'foregroundcolor','white',...
   'HorizontalAlignment','left','tag','nota',...
   'string','where X and U are respectively the STATE vector and the CONTROL vector of the current model.');

set(lq(12),'foreground','black');
set(lq(13),'foreground','red');
set(lq(14),'foreground','black');

%aggiornamento handles temporanei
stack.temp.handles=[stack.temp.handles,lq];