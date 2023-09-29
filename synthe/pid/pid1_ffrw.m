function pid1_ffrw(direzione);
%Massimo Davini 08/11/99

global stack;
watchon;

switch direzione
case 'ff' ,stack.temp.canale=stack.temp.canale+1;
case 'rw' ,stack.temp.canale=stack.temp.canale-1;
end;

canale=stack.temp.canale;
canali=stack.temp.canali;
pid_type=stack.temp.pid_type(canale);

if canale==canali set(findobj('tag','pid1>>'),'enable','off');
else set(findobj('tag','pid1>>'),'enable','on');end;

if canale==1 set(findobj('tag','pid1<<'),'enable','off');
else set(findobj('tag','pid1<<'),'enable','on');end;

if stack.temp.stabili(canale) str='STABLE';else str='UNSTABLE';end;
set(findobj('tag','tx1'),...
   'string',sprintf('CHANNEL %u-%u : %s ( open loop )',canale,canale,str));

set(findobj('tag','ed1'),'string','');
set(findobj('tag','ed2'),'string','');
set(findobj('tag','ed3'),'string','');
set(findobj('tag','ed4'),'string','');

delete(findobj('tag','plotol'));
delete(findobj('tag','plotcl'));
drawnow;

sys=tf(stack.temp.Num(canale,:),stack.temp.Den);
[y,t]=step(sys);
set(gca,'drawmode','fast');
plot(t,y,'tag','plotol','visible','off');
set(gca,'tag','grafico','NextPlot','replace',...
   'userdata',[min(y) max(y) max(t)],...
   'Ylim',[min(y)-0.2*abs(min(y)) max(y)+0.2*abs(max(y))],...
   'Xlim',[0,max(t)]); 
drawnow;

stack.temp.time{canale}=t;
pid1_opt(pid_type);

watchoff;
