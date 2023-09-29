function goto_syn
%GO TO THE SYNTHESIS WINDOW FROM ANALYSIS ONE
%
%
% Massimo Davini 24/05/99 --- revised 30/09/99

global stack;

set(findobj('tag','ana0'),'visible','off');
drawnow;

set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s',stack.general.model));


for i=2:54 set(findobj('tag',sprintf('view_%u',i)),'enable','off');end;
for i=2:16 set(findobj('tag',sprintf('anal_%u',i)),'enable','off');end;
for i=1:13 set(findobj('tag',sprintf('synt_%u',i)),'enable','on'); end;

%se non è presente il toolbox di Optimization non viene abilitato
%il menu relativo
if ~isempty(ver('optim'))
    for i=1:6,set(findobj('tag',sprintf('opti_%u',i)),'enable','on');end;
end;

synthe;
