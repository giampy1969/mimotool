function valuta2(decina);


global stack;
avm=stack.evaluation.grafici.avm;
l=stack.evaluation.grafici.l;

hand=findobj('tag','textgrafico');
text_open=hand(11:20);
text_closed=hand(1:10);

bott_ff=hand(21);
set(bott_ff,'callback',sprintf('valuta2(%u);',decina+1));
bott_rw=hand(22);
set(bott_rw,'callback',sprintf('valuta2(%u);',decina-1));

if decina==1 set(bott_rw,'enable','off');
else set(bott_rw,'enable','on');
end;
set(bott_ff,'enable','on');
   
set(text_open,'string','','visible','off');   
set(text_closed,'string','','visible','off');   
drawnow;
   
if size(avm,1)<=decina*10 
   limite=size(avm,1)-(decina-1)*10;
   set(bott_ff,'enable','off');
else
   limite=10;
end;
   
for i=1:limite
   set(text_open(11-i),'string',num2str(avm(i+10*(decina-1),1)),'visible','on');
   if real(avm(i+10*(decina-1),1))>0 set(text_open(11-i),'foregroundcolor','yellow');
   else set(text_open(11-i),'foregroundcolor',[0 0 0]);
   end;
   set(text_closed(11-i),'string',num2str(avm(i+10*(decina-1),l)),'visible','on');
   if real(avm(i+10*(decina-1),l))>0 set(text_closed(11-i),'foregroundcolor','yellow');
   else set(text_closed(11-i),'foregroundcolor',[0 0 0]);
   end;
end;





