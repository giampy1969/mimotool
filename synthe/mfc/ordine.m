function ordine(scelta)
%ORDINE del modello da inseguire
%
%Callback associata ai radiobuttons per la selezione 
%dell'ordine dei sottosistemi costituenti il modello 
%da inseguire nel caso di controllo EMFC
%
%
%
%---Massimo Davini---26/05/99

set(findobj('tag','BNext'),'enable','on');

if scelta==1 
   
   set(gcbo,'value',1);
   set(findobj('tag','option2'),'value',0);
   set(findobj('tag','EditGain'),'style','edit','background',[1 1 0],'string',num2str(1));
   set(findobj('tag','EditOver'),'style','text','background',[.8 .8 .8],'string','');
   set(findobj('tag','EditSett'),'style','edit','background',[1 1 0],'string',num2str(10));
   
elseif scelta==2
   
   set(findobj('tag','option1'),'value',0);
   set(gcbo,'value',1);
   set(findobj('tag','EditGain'),'style','edit','background',[1 1 0],'string',num2str(1));
   set(findobj('tag','EditOver'),'style','edit','background',[1 1 0],'string',num2str(5));
   set(findobj('tag','EditSett'),'style','edit','background',[1 1 0],'string',num2str(10));
   
end;