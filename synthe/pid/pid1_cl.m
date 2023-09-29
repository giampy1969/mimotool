function pid1_cl;
%Massimo Davini 08/11/99

global stack;
watchon;

delete(findobj('tag','plotcl'));
set(findobj('tag','plotol'),'visible','off');
drawnow;

ed(1)=findobj('tag','ed1');
ed(2)=findobj('tag','ed2');
ed(3)=findobj('tag','ed3');
ed(4)=findobj('tag','ed4');

pid_type=stack.temp.pid_type(stack.temp.canale);
canale=stack.temp.canale;

stack.temp.stabilicl(canale)=0;
stack.temp.controllo{canale}=[];
stack.temp.flag(canale)=0;

stack.temp.grafico{1}=[];
stack.temp.grafico{2}=[];
stack.temp.grafico{3}=[];

Num=stack.temp.Num(canale,:);
Den=stack.temp.Den;
sys=tf(Num,Den);
ok=0;

if isnan(str2num(get(ed(1),'string')))&...
   isnan(str2num(get(ed(2),'string')))&...
   isnan(str2num(get(ed(3),'string')))&...
   isnan(str2num(get(ed(4),'string')))

 set(findobj('tag','plotol'),'visible','on');
 set(findobj('tag','pidnext'),'enable','off');
 set(findobj('tag','pidnota'),'string','Closed loop step response');
 
 range=get(gca,'userdata');
 range(1)=range(1)-0.2*abs(range(1));
 range(2)=range(2)+0.2*abs(range(2));
 set(gca,'Ylim',range(1:2),'Xlim',[0 range(3)]);
 set(findobj('tag','plotol'),'visible','on');
 
 watchoff;
 return;
end;

switch pid_type
case 1  %controllore P
   Kp=str2num(get(ed(1),'string'));
   if isreal(Kp)&~isnan(Kp)&(Kp~=0)
        num=[Kp];den=[1];ok=1;
        Ti=NaN;Td=NaN;pd=NaN;
   else watchoff;messag(gcf,'pi');end;
   
case 2  %controllore I
   Kp=str2num(get(ed(1),'string'));
   Ti=str2num(get(ed(2),'string'));
   if isreal(Kp)&isreal(Ti)&~isnan(Kp*Ti)&(Kp*Ti~=0)
        num=[Kp];den=[Ti 0];ok=1;
        Td=NaN;pd=NaN;
   else watchoff;messag(gcf,'pi');end;
   
case 3  %controllore PI
   Kp=str2num(get(ed(1),'string'));
   Ti=str2num(get(ed(2),'string'));
   if isreal(Kp)&isreal(Ti)&...
         ~isnan(Kp*Ti)&(Kp*Ti~=0)
        num=Kp*[Ti 1];den=[Ti 0];ok=1;
        Td=NaN;pd=NaN;
   else watchoff;messag(gcf,'pi');end;
   
case 4  %controllore PD
   Kp=str2num(get(ed(1),'string'));
   Td=str2num(get(ed(3),'string'));
   pd=str2num(get(ed(4),'string'));
   if isreal(Kp)&isreal(Td)&isreal(pd)&...
         ~isnan(Kp*Td*pd)&(Kp*Td~=0)&(pd>0)
        num=Kp*[1+Td*pd pd];den=[1 pd];ok=1;
        Ti=NaN;
   else watchoff;messag(gcf,'pi');end;
   
case 5  %controllore PID
   Kp=str2num(get(ed(1),'string'));
   Ti=str2num(get(ed(2),'string'));
   Td=str2num(get(ed(3),'string'));
   pd=str2num(get(ed(4),'string'));
   if isreal(Kp)&isreal(Ti)&isreal(Td)&isreal(pd)&...
         ~isnan(Kp*Ti*Td*pd)&(Kp*Ti*Td~=0)&(pd>0)
        num=Kp*[(Ti+Ti*Td*pd) (Ti*pd+1) pd];den=[Ti Ti*pd 0];ok=1;
   else watchoff;messag(gcf,'pi');end;
   
end;

if ok
     
  syspid=tf(num,den);            %controllore del canale
  sysol=series(syspid,sys);
  [numol,denol]=tfdata(sysol,'v');
  numcl=numol;dencl=denol+numol;
  syscl=tf(numcl,dencl);
  [y,t]=step(syscl,stack.temp.time{canale});

  [ac,bc,cc,dc]=tf2ss(num,den);  %matrici del controllore del canale
  [sysclmin]=minreal(syscl);
  p=pole(sysclmin);
  if isempty(find(real(p)>0)) & length(find(p==0))<=1
       stack.temp.stabilicl(canale)=1;
  else stack.temp.stabilicl(canale)=0;
  end;
    
  stack.temp.controllo{canale}=pck(ac,bc,cc,dc);
  stack.temp.flag(canale)=1;
  stack.temp.parametri{canale}(pid_type,:)=[Kp,Ti,Td,pd];
  
  if stack.temp.dfl(pid_type,canale)        %parametri di default
       set(findobj('tag','pidnota'),'string','Closed loop step response from Z/N');
  else set(findobj('tag','pidnota'),'string','Closed loop step response');
  end;
  
  yol=get(findobj('tag','plotol'),'Ydata');
  
  set(gca,'nextplot','add');
  plot(t,y,'r','tag','plotcl');
  ymin=min(min(y),min(yol))-0.2*abs(min(min(y),min(yol)));
  ymax=max(max(y),max(yol))+0.2*abs(max(max(y),max(yol)));
  set(gca,'nextplot','replace','tag','grafico',...
     'Ylim',[ymin,ymax]);
  %[min(y)-abs(min(y))*0.1,max(y)+abs(max(y))*0.1] 
  
  stack.temp.grafico{1}=t;
  stack.temp.grafico{2}=yol; %y openloop
  stack.temp.grafico{3}=y;   %y closedloop

end;

set(findobj('tag','plotol'),'visible','on');

if ~isempty(find(stack.temp.flag==0)) 
     set(findobj('tag','pidnext'),'enable','off');
else set(findobj('tag','pidnext'),'enable','on');
end;

watchoff;