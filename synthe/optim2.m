function optim2(tipo)
% In base al tipo di regolatore considerato, richiama
% la funzione o_feed0 con i parametri necessari (se i pesi
% inseriti dall'utente non sono corretti, non è possibile 
% andare aventi)
%
%                 optim2(tipo)
%
% tipo = stringa che rappresenta il tipo di ottimizzazione 
%        richiesta ( 'H-I','H-2','H-MIX','MU' o 'LQG').
%
% Massimo Davini 08/05/99 --- revised 09/12/99
global stack;

C1=str2num(get(findobj('tag','edit1'),'string'));
C2=str2num(get(findobj('tag','edit2'),'string'));
C3=str2num(get(findobj('tag','edit3'),'string'));
C4=str2num(get(findobj('tag','edit4'),'string'));

if isempty(C1)|isempty(C2)|isempty(C3)|isempty(C4)|...
      (~isreal(C1))|(~isreal(C2))|(~isreal(C3))|(~isreal(C4))
   messag(gcf,'pi');return;
end;

%---- procede se i parametri sono numeri reali ----
set(stack.temp.handles,'visible','off');drawnow;

o_feed0(tipo,[C1,C2,C3,C4]);