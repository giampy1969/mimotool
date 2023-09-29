function pzvalue(bottone)
%PZVALUE : mostra il valore dei poli edegli zeri di trasmissione
%nella finestra relativa alla pzmap del sistema
%
%
%E' la callback associata ai bottoni POLES (o POLES...) e
%ZEROS : vengono mostrati un massimo di 16 poli(cliccando due volte
%sullo stesso bottone) e un massimo di 8 zeri di trasmissione.
%
%Massimo Davini 15/05/99 --- revised 30/05/99


if strcmp(bottone,'poli1')
   
   set(findobj('tag','zeri'),'visible','off');
   set(findobj('tag','FZ'),'visible','off');
   set(findobj('tag','poli2'),'visible','off');
   drawnow;
    
   set(findobj('tag','TestoP'),'visible','on');
   set(findobj('tag','FP'),'visible','on');
   set(findobj('tag','poli1'),'visible','on');
   if ~isempty(findobj('tag','poli2'))
     set(gcbo,'callback','pzvalue(''poli2'');');
   end;
  
elseif strcmp(bottone,'poli2')
   
   set(findobj('tag','TestoP'),'visible','on');
   set(findobj('tag','zeri'),'visible','off');
   set(findobj('tag','FZ'),'visible','off');
   set(findobj('tag','poli1'),'visible','off');
   drawnow;
   
   set(findobj('tag','FP'),'visible','on');
   set(findobj('tag','poli2'),'visible','on');
   set(gcbo,'callback','pzvalue(''poli1'');');

elseif strcmp(bottone,'zeri')
    
   set(findobj('tag','TestoP'),'visible','off');
   set(findobj('tag','poli1'),'visible','off');
   set(findobj('tag','poli2'),'visible','off');
   set(findobj('tag','FP'),'visible','off');
   drawnow;
   
   set(findobj('tag','FZ'),'visible','on');
   set(findobj('tag','zeri'),'visible','on');
   
end;
