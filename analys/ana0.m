function ana0
%ANALYSIS main window
%
% mostra le proprietà generali del sistema
%(sono le stesse che vengono presentate all'apertura
% della sezione di analysis)
%
%Massimo Davini 15/05/99 --- revised 28/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

delete(findobj('tag','matrice'));
delgraf;
set(findobj('tag','file_7'),'enable','off');

if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
   delete(stack.temp.handles);
end;
stack.temp=[];
drawnow;

modello=stack.general.model;
set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s',modello));
set(findobj('tag','ana0'),'visible','on');
