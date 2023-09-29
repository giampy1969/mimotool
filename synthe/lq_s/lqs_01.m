function lqs_01(index,tipo);
%callback dei bottoni check relativi alle uscite e alle relative
%azioni integrative nella prima finestra della sintesi LQ-SERVO
%
%    lqs_01(index,tipo)
%
% index = intero che indica l'indice del bottone check che ha
%         richiamato questa funzione (ogni bottone corrisponde
%         ad una uscita del sistema il cui numero massimo è 18)
%
%  tipo = intero che indica il tipo di bottone check che richiama
%         la funzione:
%         tipo=0 --> bottone relativo ad una uscita
%         tipo=1 --> bottone relativo ad una azione integrativa
%
%
%Massimo Davini 19/04/2000

global stack;

switch tipo
case 0
   if get(gcbo,'value') 
     set(findobj('tag',sprintf('cki_%u',index)),'enable','on');
     set(findobj('tag','lqs0_next'),'enable','on');
     stack.temp.outs(index)=1;
   else
      set(findobj('tag',sprintf('cki_%u',index)),...
         'enable','off','value',0);
      stack.temp.outs(index)=0;
      stack.temp.outsi(index)=0;
      if isempty(find(stack.temp.outs ~= 0))
         set(findobj('tag','lqs0_next'),'enable','off');
         
      end;
    end;

case 1
    stack.temp.outsi(index)=get(gcbo,'value');
    
end;
 