function gohome
%GO HOME : Callback associata al comando Home del menu file
%
%Torna alla finestra HOME di mimotool
%reinizializzando la variabile globale stack.
%
%
%Massimo Davini 13/05/99 --- revised 17/02/00 

global stack;
creato=stack.general.M_flag;
jsz=stack.general.javasize;

if creato==0
     
   if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
   end;
   
   delete(findobj('tag','matrice'));drawnow;
   delete(get(gcf,'children'));drawnow;
   clf;drawnow;
  
   global stack;
   stack=struct('general',[],'evaluation',[],'simulation',[],'temp',[]);
   stack.general.javasize=jsz;
   
   set(gcf,'Name',' MIMOTool for MIMO LTI Continuous Time dynamical Systems'); 
   
   avvio_1;
elseif creato==1 
   messag(gcf,'h');
end;

