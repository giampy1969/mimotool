function ltr3(index);
%LTR3 : valutazione delle condizioni nel controllo LQG|LTR
%       ( è la callback dei bottoni presenti nell'ultima 
%        finestra della sezione LQG\LTR )
%
%              ltr3(index)
%
% index = 1 --> condizioni di performance
% index = 2 --> condizioni di crossover
% index = 3 --> condizioni di robustness
%
% Massimo Davini 20/10/99

global stack;
watchon;
delgraf;

a(1)=findobj('tag','cframe');
a(2)=findobj('tag','ctitle');
a(3)=findobj('tag','ctitle1');
a(4)=findobj('tag','co1');
a(5)=findobj('tag','co2');

set(a,'visible','off');
drawnow;

if strcmp(stack.temp.incer,'in') tipo=1;else tipo=2;end;

switch index
case 1
   set(a(2),'string','PERFORMANCE :');
   if tipo==1
           set(a(3),'string','( Tlq = Kc*inv(sI-A)*B )');
           set(a(4),'string','sv_min( Tlq ) >> 1');
           set(a(5),'string','sv( Tlq ) --> sv( Trol )');
   else    set(a(3),'string','( Tkf = C*inv(sI-A)*Kf )');
           set(a(4),'string','sv_min( Tkf ) >> 1');
           set(a(5),'string','sv( Tkf ) --> sv( Tfol )');
   end;
case 2
   set(a(2),'string','CROSSOVER :');
   if tipo==1
           set(a(3),'string','( Tlq = Kc*inv(sI-A)*B )');
           set(a(4),'string','sv( I+Tlq ) >= 1');
           set(a(5),'string','sv( I+inv(Tlq) ) >= .5');
   else    set(a(3),'string','( Tkf = C*inv(sI-A)*Kf )');
           set(a(4),'string','sv( I+Tkf ) >= 1');
           set(a(5),'string','sv( I+inv(Tkf) ) >= .5');
   end;
case 3
   set(a(2),'string','ROBUSTNESS :');
   if tipo==1
           set(a(3),'string','( L > sv_max(unc.) )');
           set(a(4),'string','L < sv_min(I+inv(Tlq))');
           set(a(5),'string','');
   else    set(a(3),'string','( L > sv_max(uncert.) )');
           set(a(4),'string','L < sv_min(I+inv(Tkf))');
           set(a(5),'string','');
   end;
end;

set(a,'visible','on');
drawnow;

w=stack.temp.w;
%-------------------
%-----grafici-------
if index==1
   
   j=length(find(w<=stack.temp.param(1)*10));
   axes('Position',[0.39 0.33 0.56 0.57]);
   set(gca,'drawmode','fast');
   semilogx(w(1:j),nan);
   set(gca,'NextPlot','add');
   if tipo==1
        semilogx(w(1:j),stack.temp.sv_Tlq(:,1:j),'r');
        semilogx(w(1:j),stack.temp.sv_Trol(:,1:j),'b');
        titolo='SV of Tlq (red) and Trol (blue)';
   else semilogx(w(1:j),stack.temp.sv_Tkf(:,1:j),'r');
        semilogx(w(1:j),stack.temp.sv_Tfol(:,1:j),'b');
        titolo='SV of Tkf (red) and Tfol (blue)';
   end;
   semilogx(w(1:j),zeros(1,j),':k');
   semilogx(w(1),1,'k');semilogx(w(1),-1,'k');
   semilogx(stack.temp.param(1),0,'*r');

   set(gca,'Xlim',[w(1),stack.temp.param(1)*10],...
     'tag','grafico','NextPlot','replace'); 
   title(titolo,'color','k','fontsize',9);
  
elseif index==2 
   
   [A,B,C,D]=unpck(stack.temp.plant);
   if tipo==1
        sys=ss(A,B,stack.temp.Kc,zeros(size(stack.temp.Kc,1),size(B,2)));
        titolo='SV of I+Tlq (blue) and I+inv(Tlq) (red)';
   else sys=ss(A,stack.temp.Kf,C,zeros(size(C,1),size(stack.temp.Kf,2)));
        titolo='SV of I+Tkf (blue) and I+inv(Tkf) (red)';
   end;
   sv=sigma(sys,w,2);
   svinv=sigma(sys,w,3);
   
   axes('Position',[0.39 0.33 0.56 0.57]);
   set(gca,'drawmode','fast');
   semilogx(w,nan);
   set(gca,'NextPlot','add');
   semilogx(w,20*log10(sv),'b');
   semilogx(w,zeros(size(w)),':b');
   semilogx(w,20*log10(svinv),'r');
   semilogx(w,-6*ones(size(w)),':r');
   semilogx(w(1),1,'k');semilogx(w(1),-1,'k');
   semilogx(stack.temp.param(1),0,'*r');
   set(gca,'NextPlot','replace','tag','grafico');
   
   set(gca,'tag','grafico','NextPlot','replace'); 
   title(titolo,'color','k','fontsize',9);

elseif index==3
   
   gates=stack.temp.gates;
   x(1,1)=gates(1,5);y(1,1)=gates(2,5);
   x(1,2)=gates(1,6);y(1,2)=-gates(2,6);
   x(1,3)=gates(1,7);y(1,3)=gates(2,7);
   
   [A,B,C,D]=unpck(stack.temp.plant);
   if tipo==1
        sys=ss(A,B,stack.temp.Kc,zeros(size(stack.temp.Kc,1),size(B,2)));
        titolo='SV-min of I+inv(Tlq) (blue) and inv(I+KG) (red)';
   else sys=ss(A,stack.temp.Kf,C,zeros(size(C,1),size(stack.temp.Kf,2)));
        titolo='SV-min of I+inv(Tkf) (blue) and inv(I+GK) (red)';
   end;
   k=find(w>=stack.temp.param(1)/100);
   svinv=sigma(sys,w(k),3);
   svinvmin=svinv(size(svinv,1),:);
   
   [Akg,Bkg,Ckg,Dkg]=unpck(stack.temp.GK_KG);
   sysol1=ss(Akg,Bkg,Ckg,Dkg);no=size(Ckg,1);
   sysol2=ss(zeros(no,no),zeros(no,no),zeros(no,no),eye(no));
   %syscl è il sistema a ciclo chiuso con il controllore
   syscl=feedback(sysol1,sysol2);
   
   try,svconK=sigma(syscl,w(k),1);svconKmin=svconK(size(svconK,1),:);
   catch,svconKmin=nan;
   end;
   
   axes('Position',[0.39 0.33 0.56 0.57]);
   set(gca,'drawmode','fast');
   semilogx(w(k),nan);
   set(gca,'NextPlot','add');
   fill(x,y,'y');
   semilogx(w(k),20*log10(svinvmin),'b');
   semilogx(w(k),20*log10(svconKmin),'r');
   semilogx(w(k(1)),1,'k');semilogx(w(k(1)),-1,'k');
   semilogx(w(k),zeros(size(w(k))),':k');
   semilogx(stack.temp.param(1),0,'*r');
   set(gca,'NextPlot','replace','tag','grafico');
   
   set(gca,'tag','grafico','NextPlot','replace',...
      'Xlim',[stack.temp.param(1)/100,w(length(w))]); 
   title(titolo,'color','k','fontsize',9);
   
end;

xlabel('dB -- rad/sec','fontsize',8);
crea_pop(1,'crea');

watchoff;

