function pid1_opt(index);
%Massimo Davini 08/11/99

global stack;
if nargin <1 index=stack.temp.pid_type(stack.temp.canale);end;

if nargin==1
  opt(1)=findobj('tag','pidopt1');
  opt(2)=findobj('tag','pidopt2');
  opt(3)=findobj('tag','pidopt3');
  opt(4)=findobj('tag','pidopt4');
  opt(5)=findobj('tag','pidopt5');
  f(1)=findobj('tag','f1');
  f(2)=findobj('tag','f2');
  f(3)=findobj('tag','f3');
  
  set(opt,'value',0,'foregroundcolor','k');
  set(opt(index),'value',1,'foregroundcolor','r');
  switch index
  case 1
    str1=[''];
    str2=[' P = Kp '];
    str3=[''];
  case 2
    str1=['       Kp  '];
    str2=[' I  = ---- '];
    str3=['       sTi '];
  case 3
    str1=['                    1   '];
    str2=['PI = Kp( 1 + ---- )'];
    str3=['                   sTi  '];
  case 4
    str1=['                       sTd'];
    str2=sprintf('PD = Kp( 1 + ---------- )');
    str3=sprintf('                    1+s/pd');
  case 5
    str1=['                       1       sTd'];
    str2=sprintf('PID = Kp( 1 + ---- + ---------- )');
    str3=sprintf('                      sTi   1+s/pd');
  end;

  set(f,'visible','off');
  set(f(1),'string',str1);
  set(f(2),'string',str2);
  set(f(3),'string',str3);
  set(f,'visible','on');

  stack.temp.pid_type(stack.temp.canale)=index;
end;

canale=stack.temp.canale;

if length(find(isnan(stack.temp.parametri{canale}(index,:))==1))==4
     par=NaN*ones(1,4);
else par=stack.temp.parametri{canale}(index,:);
end;

ed(1)=findobj('tag','ed1');
ed(2)=findobj('tag','ed2');
ed(3)=findobj('tag','ed3');
ed(4)=findobj('tag','ed4');

set(ed(1),'string',num2str(par(1)));
set(ed(2),'string',num2str(par(2)));
set(ed(3),'string',num2str(par(3)));
set(ed(4),'string',num2str(par(4)));

switch index
case 1  
   set(ed(1),'enable','on','backgroundcolor','y');
   set(ed(2:4),'enable','inactive','backgroundcolor',[.8 .8 .8]);
case {2,3} 
   set(ed(1:2),'enable','on','backgroundcolor','y');
   set(ed(3:4),'enable','inactive','backgroundcolor',[.8 .8 .8]);
case 4
   set(ed(1),'enable','on','backgroundcolor','y');
   set(ed(2),'enable','inactive','backgroundcolor',[.8 .8 .8]);
   set(ed(3:4),'enable','on','backgroundcolor','y');
case 5
   set(ed(1:4),'enable','on','backgroundcolor','y');
end;

drawnow;

pid1_cl;

