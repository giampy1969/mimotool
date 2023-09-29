function newregion
%NEW REGION callback
%
%
%Massimo Davini 01/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack

delgraf;

handles=stack.temp.handles;
if ~isempty(findobj('tag','para'))
   x=length(handles);
   delete(stack.temp.handles(x-11:x));
   handles(x-11:x)=[];
   stack.temp.handles=handles;   
end;
drawnow;

%---inizializzazione dei parametri di tutti i tipi di regione-------
for i=1:6
   eval(sprintf('stack.temp.new_param.p%u{1,1}=[];',i));
   eval(sprintf('stack.temp.new_param.p%u{2,1}=[];',i));
   eval(sprintf('stack.temp.new_param.p%u{3,1}=[];',i));
   eval(sprintf('stack.temp.new_param.p%u{4,1}=[];',i));
   eval([sprintf('set(findobj(''tag'',''ck%u''),',i),...
         '''value'',0,''enable'',''on'',''foregroundcolor'',[0 0 0]);']);
end;
%---------------------------------------------------------------------

set(findobj('tag','BDFL'),'enable','on');
set(findobj('tag','testo'),'visible','on');

%------------------inizializzazione nuova regione---------------------
stack.temp.region=[];
