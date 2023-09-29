function o_feed0(tipok,pesi)
% Crea la finestra (comune) per l'agiunta al sistema di
% blocchi di integratori nei controlli di tipo  output-feedback
% (i blocchi scelti vengono posizionati lungo la dimensione
% minima del sistema)
%
%          o_feed0(tipok,pesi)
%  
%  tipok = stringa che indica il tipo di controllo scelto
%          ('H-I','H-2','H-MIX','MU','LQG',...) sia in fase di
%          sintesi che di ottimizzazione
%
%  pesi  = vettore di 4 numeri reali che rappresentano i pesi
%          della funzione di costo ( è presente solo in caso
%          di ottimizzazione ).
%
% Massimo Davini 26/05/99 --- revised 09/12/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
if nargin < 2 pesi=[];end;

if isempty(pesi)
%---solo in caso di sintesi---   
   if stack.general.K_flag 
     messag(gcf,'kns_m',[],tipok,1);
     return;
   end;
   
   %se c'è un modello simulink aperto,viene chiuso 
   if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
   end;

   delete(findobj('tag','inf'));
   delete(findobj('tag','eva'));
   delgraf;
   delete(findobj('tag','matrice'));

   set(findobj('tag','syn0'),'visible','off');
   set(findobj('tag','file_6'),'enable','off');

   if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
     delete(stack.temp.handles);
   end;
   drawnow;

   stack.temp=[];stack.temp.handles=[];
   stack.evaluation=[];stack.simulation=[];
   
   set(findobj('tag','simu_2'),'enable','off');
   set(get(findobj('tag','eval_1'),'children'),'enable','off','visible','on');
   set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> %s',stack.general.model,upper(tipok)));

end;

%---sia in caso di sintesi che di ottimizzazione---    
st=.2;st1=.65;

in(1)=uicontrol('style','frame',...
   'units','normalized','position',[0.1 0.32 0.8 0.53],...
   'backgroundcolor',[1 1 1],'visible','off','tag','integratori');

in(2)=uicontrol('style','text',...
   'units','normalized','position',[.13 .58 .74 0.2],...
   'fontunits','normalized','fontsize',st,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','tag','integratori',...
   'HorizontalAlignment','left','foregroundcolor','black',...
   'string',sprintf('If you want , the INPUT or the OUTPUT of the plant can be augmented with some block of integrators (max 9).'));

in(3)=uicontrol('style','text',...
   'units','normalized','position',[0.13 0.4 0.74 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','tag','integratori',...
   'foregroundcolor','black','HorizontalAlignment','left',...
   'string','( The blocks will be added automatically )');

in(4)=uicontrol('style','text',...
   'units','normalized','position',[0.18 0.5 0.07 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','tag','integratori',....
   'HorizontalAlignment','left','string','Add',...
   'foregroundcolor','red');

in(5)=uicontrol('style','edit',...
   'units','normalized','position',[0.27 0.5 0.1 0.06],...
   'fontunits','normalized','fontsize',.65,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'visible','off',...
   'string',num2str(0),'tag','EditIntegr',...
   'HorizontalAlignment','center');

in(6)=uicontrol('style','text',...
   'units','normalized','position',[0.4 0.5 0.4 0.06],...
   'fontunits','normalized','fontsize',st1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','tag','integratori',...
   'HorizontalAlignment','left','string','blocks .',...
   'foregroundcolor','red');

in(7)=uicontrol('style','push',...
   'unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','integratori',...
   'TooltipString','Back to the main SYNTHESIS window',...
   'callback','back_syn(''syn0'',0);');
  
if ~isempty(pesi)
   in(8)=uicontrol('style','push',...
      'unit','normalized','position',[0.2 0.05 0.14 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'string','CLOSE','Horizontalalignment','center','tag','integratori',...
     'TooltipString','Back to the main SYNTHESIS window');
end;     

x=length(in);
in(x+1)=uicontrol('style','push',...
   'unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','integratori',...
   'TooltipString','Go to the next window');

set(in,'visible','on');

ist1='n=str2num(get(findobj(''tag'',''EditIntegr''),''string''));';
ist2='if isempty(n)|(~isreal(n))|(round(n)<0)|(round(n)>9) clear n;messag(gcf,''pi'');return;else ';
if ~isempty(pesi)
   ist3=sprintf('pesi=[%u,%u,%u,%u];',pesi(1),pesi(2),pesi(3),pesi(4));
else ist3='pesi=[];';
end;
ist4='set(findobj(''tag'',''EditIntegr''),''string'',num2str(round(n)));';

switch upper(tipok)
case 'H - INFINITY'
   callback=[ist1,ist2,ist3,ist4,'h0(''H - INFINITY'',round(n),pesi);clear n pesi;end;'];
case 'H - 2'
   callback=[ist1,ist2,ist3,ist4,'h0(''H - 2'',round(n),pesi);clear n pesi;end;'];
case 'H - MIX'
   callback=[ist1,ist2,ist3,ist4,'hmix0(round(n),pesi);clear n pesi;end;'];
case 'MU'
   callback=[ist1,ist2,ist3,ist4,'mu0(round(n),pesi);clear n pesi;end;'];
case 'LQG'
   if ~isempty(pesi)
      callback=[ist1,ist2,ist3,ist4,'optimlqg0(round(n),pesi);clear n pesi;end;'];     
   else   
      callback=[ist1,ist2,ist4,'lqg0(round(n));clear n;end;'];
   end;
case 'LQG \ LTR'
      callback=[ist1,ist2,ist4,'ltr0(round(n));clear n;end;'];
case 'PID'
      callback=[ist1,ist2,ist4,'pid0(round(n));clear n;end;'];
end;

set(in(x+1),'callback',callback);

if ~isempty(pesi)
   set(in(7),'callback',sprintf('back_syn(''opti1'',%u);',length(stack.temp.handles)),...
           'TooltipString','Back to the previous window');
   set(in(8),'callback','back_syn(''syn0'',0);');
   stack.temp.handles=[stack.temp.handles,in];
else
  stack.temp.handles=in;
end;
