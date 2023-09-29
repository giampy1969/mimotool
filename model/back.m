function back(lunprec,fin)
% callback bottone BACK nella sezione di Modeling
% (chiude la finestra corrente e visualizza quella precedente)
%
%                         back(lunprec,fin)
%
% lunprec = intero che indica la lunghezza che il vettore 
%           stack.temp.handles (contenente gli identificatori o handles
%           degli oggetti creati all'interno della sezione corrente)
%           deve raggiungere in seguito alla esecuzione di questa
%           funzione;
%           lunprec indica quindi il numero totale di oggetti temporanei
%           che sono stati creati prima dell'apertura della finestra
%           corrente;
%
% fin     = stringa che indica la finestra da cui la funzione è stata
%           chiamata
%
% Massimo Davini 15/05/99 --- revised 23/03/00 

global stack;
delete(findobj('tag','matrice'));

x=length(stack.temp.handles);
delete(stack.temp.handles(lunprec+1:x));
stack.temp.handles(lunprec+1:x)=[];

switch fin
case {'new0','balred'}
   stack.temp=[];  
   set(findobj('tag','bottA'),'visible','on');
   set(findobj('tag','bottB'),'visible','on');
   set(findobj('tag','bottC'),'visible','on');
   set(findobj('tag','bottD'),'visible','on');
   set(findobj('tag','bottNew'),'visible','on');
   set(findobj('tag','bottLoad'),'visible','on');
   set(findobj('tag','BottAna'),'visible','on');
   set(findobj('tag','BottSyn'),'visible','on');
   set(findobj('tag','file_2'),'enable','on');  %file-new
   set(findobj('tag','file_3'),'enable','on');  %file-load
   set(findobj('tag','file_7'),'enable','off'); %file-print matrix
      
   if strcmp(stack.general.model,'')  str=' ';
      set(get(findobj('tag','tools_1'),'children'),'enable','off');
      set(get(findobj('tag','tools_2'),'children'),'enable','off');
      set(get(findobj('tag','tools_6'),'children'),'enable','off');
   elseif strcmp(upper(stack.general.model),'UNTITLED.MAT') 
      str='Untitled.mat';
      set(findobj('tag','file_4'),'enable','on');
      set(get(findobj('tag','tools_1'),'children'),'enable','on');
      set(get(findobj('tag','tools_2'),'children'),'enable','on');
      set(get(findobj('tag','tools_6'),'children'),'enable','on');
      
      C=stack.general.C;D=stack.general.D;
      if C==eye(size(C))
        if D==zeros(size(D))
          set(findobj('tag','tools_10'),'enable','off');
        end;
      else set(findobj('tag','tools_10'),'enable','on');
      end;

      stack.general.M_flag=1;
   else
      set(findobj('tag','file_4'),'enable','on');
      set(findobj('tag','file_5'),'enable','on');
      set(get(findobj('tag','tools_1'),'children'),'enable','on');
      set(get(findobj('tag','tools_2'),'children'),'enable','on');
      set(get(findobj('tag','tools_6'),'children'),'enable','on');
      if ~isempty(stack.evaluation) 
         set(findobj('tag','eval_31'),'enable','on');
         set(findobj('tag','file_6'),'enable','on');
      end;
      if ~isempty(stack.simulation)
         set(findobj('tag','simu_2'),'enable','on');
      end;
      str=stack.general.model;
      
      C=stack.general.C;D=stack.general.D;
      if C==eye(size(C))
        if D==zeros(size(D))
          set(findobj('tag','tools_10'),'enable','off');
        end;
      else set(findobj('tag','tools_10'),'enable','on');
      end;
   end;
      
   set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s',str));
   
case 'new1'
   [stack.temp.A,stack.temp.B,stack.temp.C,stack.temp.D]=deal([]);
   [stack.temp.flagA,stack.temp.flagB]=deal([]);
   [stack.temp.flagC,stack.temp.flagD]=deal([]);
   [stack.temp.matrice]=deal([]);
   
   set(findobj('tag','file_7'),'enable','off');
   set(findobj('tag','new0'),'visible','on');
   set(findobj('tag','NI'),'visible','on');
   set(findobj('tag','NO'),'visible','on');
   set(findobj('tag','NS'),'visible','on');
   drawnow;
end;
