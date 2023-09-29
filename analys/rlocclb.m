function rlocclb
%RLOCUS CALLBACK for buttons "P" "Z" and "K" 
%of the root locus's window
%
%
% Massimo Davini 21/05/99 --- revised 30/05/99

poli1=findobj('tag','poli1');
poli2=findobj('tag','poli2');
zeri1=findobj('tag','zeri1');
zeri2=findobj('tag','zeri2');
gain=findobj('tag','gain');


switch get(gcbo,'string')
   
   case 'P'
   
      set(zeri1,'visible','off');
      set(zeri2,'visible','off');
      set(gain,'visible','off');
      set(findobj('tag','FZ'),'visible','off');
      set(findobj('tag','FK'),'visible','off');
      drawnow;
      set(findobj('tag','FP'),'visible','on');
      set(poli1,'visible','on');
   
   case 'P...'
   
      set(findobj('tag','FZ'),'visible','off');
      set(findobj('tag','FK'),'visible','off');
      set(findobj('tag','FP'),'visible','on');

     if strcmp(get(poli1(1),'visible'),'off')&strcmp(get(poli2(1),'visible'),'off')
         set(zeri1,'visible','off');
         set(zeri2,'visible','off');
         set(gain,'visible','off');
         drawnow;
         set(poli1,'visible','on');
         return;
     elseif strcmp(get(poli1(1),'visible'),'on')
         set(poli1,'visible','off');
         set(poli2,'visible','on');
         return;
     elseif strcmp(get(poli2(1),'visible'),'on')
         set(poli2,'visible','off');
         set(poli1,'visible','on');
         return;
      end;
      
   case 'Z'
      
         set(poli1,'visible','off');
         set(poli2,'visible','off');
         set(gain,'visible','off');
         set(findobj('tag','FP'),'visible','off');
         set(findobj('tag','FK'),'visible','off');
         drawnow;
         set(findobj('tag','FZ'),'visible','on');
         set(findobj('tag','zeri1'),'visible','on');
         
   case 'Z...'
         
         set(findobj('tag','FP'),'visible','off');
         set(findobj('tag','FK'),'visible','off');
         set(findobj('tag','FZ'),'visible','on');

     if strcmp(get(zeri1(1),'visible'),'off')&strcmp(get(zeri2(1),'visible'),'off')
         set(poli1,'visible','off');
         set(poli2,'visible','off');
         set(gain,'visible','off');
         drawnow;
         set(zeri1,'visible','on');
         return;
     elseif strcmp(get(zeri1(1),'visible'),'on')
         set(zeri1,'visible','off');
         set(zeri2,'visible','on');
         return;
     elseif strcmp(get(zeri2(1),'visible'),'on')
         set(zeri2,'visible','off');
         set(zeri1,'visible','on');
         return;
      end;

   case 'K'
      
         set(poli1,'visible','off');
         set(poli2,'visible','off');
         set(zeri1,'visible','off');
         set(zeri2,'visible','off');
         set(findobj('tag','FP'),'visible','off');
         set(findobj('tag','FZ'),'visible','off');
         drawnow;
         set(findobj('tag','FK'),'visible','on');
         set(gain,'visible','on');
         
end;
      
   
   
   
   
