function replace
%REPLACE : callback del bottone "REPLACE MODEL" 
%
% Rimpiazza il modello in memoria con il sistema equivalente calcolato
% da un qualunque comando del menu Tools 
%
% Massimo Davini 28/06/99 revised 31/05/00

global stack;
creato=stack.general.M_flag; % new (unsaved) model flag

if creato==0
  stack.general.model='Untitled.mat';
  stack.general.A=infnan2x(stack.temp.newA);
  stack.general.B=infnan2x(stack.temp.newB);
  stack.general.C=infnan2x(stack.temp.newC);
  stack.general.D=infnan2x(stack.temp.newD);
  stack.general.M_flag=1; 
      
  delete(findobj('tag','matrice'));
  delete(stack.temp.handles);
  drawnow;
      
  stack.evaluation=[];
  stack.simulation=[];
  stack.temp=[];
  
  nome=stack.general.model;
  set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s ',nome));

  set(findobj('tag','bottA'),'enable','on','visible','on',...
     'string','[ A ]');
  set(findobj('tag','bottB'),'enable','on','visible','on',...
     'string','[ B ]');
  set(findobj('tag','bottC'),'enable','on','visible','on',...
     'string','[ C ]');
  set(findobj('tag','bottD'),'enable','on','visible','on',...
     'string','[ D ]');
      
  set(findobj('tag','bottNew'),'visible','on');
  set(findobj('tag','bottLoad'),'visible','on');
  set(findobj('tag','BottAna'),'visible','on','enable','on');
  set(findobj('tag','BottSyn'),'visible','on','enable','on');

  set(findobj('tag','file_2'),'enable','on');
  set(findobj('tag','file_3'),'enable','on');
  set(findobj('tag','file_4'),'enable','on');
  set(findobj('tag','file_7'),'enable','off');
  
  C=stack.general.C;
  D=stack.general.D;
  if C==eye(size(C))
    if D==zeros(size(D))
      set(findobj('tag','tools_10'),'enable','off');
    end;
  else set(findobj('tag','tools_10'),'enable','on');
  end;
 

elseif creato==1
    messag(gcf,'rpl');
end;