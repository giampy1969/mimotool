function setparam1(indice)
%SET PARAMETERS 1: callback dei bottini SET
%
%
%Massimo Davini 01/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

watchon;

delgraf;
set(gca,'position',[.39 .24 .37 .34],'visible','off')

cb0=sprintf('setparam(%u);',indice);
cb1=['set(gcbo,''value'',1);',cb0];

switch indice
case 1
   %-----------half plane---------------
   oldpar1=stack.temp.new_param.p1{1,1};
   oldpar2=stack.temp.new_param.p1{2,1};
   
   par1=str2num(get(findobj('tag','Edit1'),'string'));
   par2=str2num(get(findobj('tag','Edit2'),'string'));
   if isempty(par1)|~((par1==-1)|(par1==1))
      set(findobj('tag','Edit1'),'string',oldpar1);par1=oldpar1;
   end;
   if isempty(par2)|(~isreal(par2))
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   drawnow;   
   if (~isempty(par1))&(~isempty(par2))
       set(findobj('tag','ck1'),'callback',cb1);
       %-----calcolo della regione-----------
       e=par1;u=[];v=[];
       u=mdiag(u,-2*e*par2+j);v=mdiag(v,e);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p1{1,1}=par1;
       stack.temp.new_param.p1{2,1}=par2;
       stack.temp.new_param.p1{4,1}=region;
       %--------------grafico----------------
       if abs(par2)>0
            if par1==-1 vx=[par2 -5*abs(par2) -5*abs(par2) par2]';
            elseif par1==1 vx=[par2 +5*abs(par2) +5*abs(par2) par2]';
            end;
       elseif par2==0
            if par1==-1 vx=[0 -5 -5 0]';
            elseif par1==1 vx=[0 5 5 0]';
            end;
       end;  
       vy=[10 10 -10 -10]';
       fill(vx,vy,'b');grid;
       if par2==0   axis([-5,5,-5,5]);
       else         axis([-5*abs(par2),5*abs(par2),-10,10]);
       end;
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
    end;
    
 case 2
   %--------------disk------------------
   oldpar1=stack.temp.new_param.p2{1,1};
   oldpar2=stack.temp.new_param.p2{2,1};

   par1=str2num(get(findobj('tag','Edit1'),'string'));
   par2=str2num(get(findobj('tag','Edit2'),'string'));
   
   if isempty(par1)|(~isreal(par1))
      set(findobj('tag','Edit1'),'string',oldpar1);par1=oldpar1;
   end;
   if isempty(par2)|(~isreal(par2))|(par2 <= 0)
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   drawnow;
   if (~isempty(par1))&(~isempty(par2))
       set(findobj('tag','ck2'),'callback',cb1);
       %-----calcolo della regione-----------
       u=[];v=[];q=par1;r=par2;
       u=mdiag(u,[-r+2*j -q;-q -r]);v=mdiag(v,[0 0;1 0]);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p2{1,1}=par1;
       stack.temp.new_param.p2{2,1}=par2;
       stack.temp.new_param.p2{4,1}=region;
       %--------------grafico----------------
       x=(q-r):2*r/500:(q+r);
       for i=1:length(x)
         y1(i)=sqrt(r^2-(x(i)-q)^2);
         y2(i)=-sqrt(r^2-(x(i)-q)^2);
       end;
       for i=1:length(x) line([x(i) x(i)]',[y1(i) y2(i)]');end;
       
       axis([-(abs(q)+r*1.5) (abs(q)+r*1.5) -(abs(q)+r*1.5) (abs(q)+r*1.5) ]);grid;
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
   end;       
   
case 3
   %-----------conic sector-------------
   oldpar1=stack.temp.new_param.p3{1,1};
   oldpar2=stack.temp.new_param.p3{2,1};

   par1=str2num(get(findobj('tag','Edit1'),'string'));
   par2=str2num(get(findobj('tag','Edit2'),'string'));
   
   if isempty(par1)|(~isreal(par1))
      set(findobj('tag','Edit1'),'string',oldpar1);par1=oldpar1;
   end;
   if isempty(par2)|(~isreal(par2))|(par2 <= 0)
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   drawnow;
   if (~isempty(par1))&(~isempty(par2))
       set(findobj('tag','ck3'),'callback',cb1);
       %-----calcolo della regione-----------
       u=[];v=[];x0=par1;t=par2;
       t=t*pi/180;         %conversione in radianti
       t=t/2;s=sin(t);c=cos(t);
       u=mdiag(u,2*[-s*x0+j 0;0 -s*x0]);v=mdiag(v,[s -c;c s]);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p3{1,1}=par1;
       stack.temp.new_param.p3{2,1}=par2;
       stack.temp.new_param.p3{4,1}=region;
       %--------------grafico----------------
       if x0==0 ax=2;else ax=3*abs(x0);end;
       ay=ax;
       if t<pi/2
         fill([x0,-ax,-ax]',tan(t)*[0 (ax+x0) -(ax+x0)]','b');grid;
       elseif t==pi/2
         fill([x0 x0 -ax,-ax]',[-ay ay ay -ay]','b');grid;
       elseif t>pi/2
          fill([x0 x0 -ax,-ax]',[-ay ay ay -ay]','b');
          hold on
          fill([x0 ax ax x0]',[0 -tan(t)*(ax-x0) ay ay]','b');
          fill([x0 ax ax x0]',[0 tan(t)*(ax-x0) -ay -ay]','b');
          grid;
          hold off
       end;
       axis([-ax ax -ay ay]);
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
   end;   
   
case 4
   %-----------ellipsoid---------------
   oldpar1=stack.temp.new_param.p4{1,1};
   oldpar2=stack.temp.new_param.p4{2,1};
   oldpar3=stack.temp.new_param.p4{3,1};

   par1=str2num(get(findobj('tag','Edit1'),'string'));
   par2=str2num(get(findobj('tag','Edit2'),'string'));
   par3=str2num(get(findobj('tag','Edit3'),'string'));
   
   if isempty(par1)|(~isreal(par1))
      set(findobj('tag','Edit1'),'string',oldpar1);par1=oldpar1;
   end;
   if isempty(par2)|(~isreal(par2))|(par2 <= 0)
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   if isempty(par3)|(~isreal(par3))|(par3 <= 0)
      set(findobj('tag','Edit3'),'string',oldpar3);par3=oldpar3;
   end;
   drawnow;
   if (~isempty(par1))&(~isempty(par2))&(~isempty(par3))
       set(findobj('tag','ck4'),'callback',cb1);
       %-----calcolo della regione-----------
       q=par1;a=par2;b=par3;u=[];v=[];
       aa=1/abs(a);bb=1/abs(b);
       u=mdiag(u,[-1+2*j -q*aa;-q*aa -1]);
       v=mdiag(v,[0 (aa-bb)/2;(aa+bb)/2 0]);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p4{1,1}=par1;
       stack.temp.new_param.p4{2,1}=par2;
       stack.temp.new_param.p4{3,1}=par3;
       stack.temp.new_param.p4{4,1}=region;
       %--------------grafico----------------
       ax=1.5*max(a+abs(q),b);
       x=q-a:2*a/500:q+a;
       for i=1:length(x)
            y1(i)=b*sqrt(1-((x(i)-q)/a)^2);
            y2(i)=-b*sqrt(1-((x(i)-q)/a)^2);
       end;
       for i=1:length(x)
         line([x(i) x(i)]',[y1(i) y2(i)]');
       end;
       axis([-ax ax -ax ax]);grid;
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
    end;
    
case 5
   %-----------parabola-----------------
   oldpar2=stack.temp.new_param.p5{2,1};
   oldpar3=stack.temp.new_param.p5{3,1};

   par2=str2num(get(findobj('tag','Edit2'),'string'));
   par3=str2num(get(findobj('tag','Edit3'),'string'));
   
   if isempty(par2)|(~isreal(par2))
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   if isempty(par3)|(~isreal(par3))|(par3==0)
      set(findobj('tag','Edit3'),'string',oldpar3);par3=oldpar3;
   end;
   drawnow;
   if (~isempty(par2))&(~isempty(par3))
       set(findobj('tag','ck5'),'callback',cb1);
       %-----calcolo della regione-----------
       x0=par2;p=par3;u=[];v=[];
       q=-p*x0;
       u=mdiag(u,2*[q-1+j q+1;q+1 q-1]);v=mdiag(v,[p p-2;p+2 p]);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p5{2,1}=par2;
       stack.temp.new_param.p5{3,1}=par3;
       stack.temp.new_param.p5{4,1}=region;
       %----------grafico-----------------
       if x0==0 ax=2;else ax=3*abs(x0);end;
       if p>0 x=-ax:(x0+ax)/500:x0;ay=abs(sqrt(-p*(-ax-x0)));
       elseif p<0 x=x0:(ax-x0)/500:ax;ay=abs(sqrt(-p*(ax-x0)));
       end;
       for i=1:length(x)
            y1(i)=sqrt(-p*(x(i)-x0));
            y2(i)=-sqrt(-p*(x(i)-x0));
       end;
       for i=1:length(x)
         line([x(i) x(i)]',[y1(i) y2(i)]');
       end;
       axis([-ax ax -ay ay]);grid;
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
    end;
    
case 6
   %--------horizontal strip------------
   oldpar2=stack.temp.new_param.p5{2,1};

   par2=str2num(get(findobj('tag','Edit2'),'string'));
   
   if isempty(par2)|(~isreal(par2))|(par2 <= 0)
      set(findobj('tag','Edit2'),'string',oldpar2);par2=oldpar2;
   end;
   drawnow;
   if ~isempty(par2)
       set(findobj('tag','ck6'),'callback',cb1);
       %-----calcolo della regione-----------
       r=par2;u=[];v=[];
       u=mdiag(u,[-r+2*j 0;0 -r]);v=mdiag(v,[0 -1;1 0]);
       region=[u,v];
       %--------aggiornamento parametri------
       stack.temp.new_param.p6{2,1}=par2;
       stack.temp.new_param.p6{4,1}=region;
       %----------grafico-----------------
       fill([-5 -5 5 5]',[-r r r -r]','b');
       if r<=10 axis([-5 5 -10 10]);
       else axis([-5 5 -2*r 2*r]);
       end;grid;
       set(gca,'visible','on','tag','grafico');crea_pop(0,'crea');
    end;
    
end;

handles=stack.temp.handles;
x=length(handles);
if ~isempty(findobj('tag','grafico'))
      set(handles(x-1),'enable','on');set(handles(x),'enable','off');
else  set(handles(x-1),'enable','off');set(handles(x),'enable','on');
end;

region1=stack.temp.new_param.p1{4,1};
region2=stack.temp.new_param.p2{4,1};
region3=stack.temp.new_param.p3{4,1};
region4=stack.temp.new_param.p4{4,1};
region5=stack.temp.new_param.p5{4,1};
region6=stack.temp.new_param.p6{4,1};

new_region=lmireg(region1,region2,region3,region4,region5,region6);
stack.temp.region=new_region;

watchoff;