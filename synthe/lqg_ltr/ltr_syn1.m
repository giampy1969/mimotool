function ltr_syn1;
%LTR_SYN1 : calcolo dei controllori necessari 
%           nella fase di sintesi di un controllo LQG\LTR
%
% In base alla posizione dell'incertezza (ingresso o uscita)
% la sintesi è LQ o KFB ; a seconda dei due casi vengono 
% calcolate,graficate e salvate in stack.temp le seguenti
% variabili :
% sintesi LQ 
%    --> Kc,Klq=Kc*inv(si-A)*C,Krol=(1/sqrt(ro))*H*inv(sI-A)*C
% sintesi KFB 
%    --> Kf,Kkf=C*inv(si-A)*Kf,Kfol=(1/sqrt(mu))*C*inv(sI-A)*W
%
%
% Massimo Davini 20/10/99

global stack;

watchon;
set(findobj('tag','BNext'),'enable','off');
set(findobj('tag','inf1'),'visible','off');

%---------------------------------------------------
%settaggio del minimo e del massimo per la barra
%se sono stati modificati i campi edit relativi
mi=str2num(get(findobj('tag','rangemin'),'string'));
ma=str2num(get(findobj('tag','rangemax'),'string'));

if isempty(mi) | isempty(ma) | ~isreal(mi) | ~isreal(ma) | mi >= ma
   set(findobj('tag','rangemin'),'string',num2str(-3));
   set(findobj('tag','rangemax'),'string',num2str(0));  
   set(findobj('tag','edit_romu'),'string',num2str(1));
   drawnow;
   set(findobj('tag','barra_syn'),'min',-3,'max',0,'value',0);
elseif mi~=get(findobj('tag','barra_syn'),'min') |...
       ma~=get(findobj('tag','barra_syn'),'max')
   set(findobj('tag','barra_syn'),'value',ma);
   set(findobj('tag','barra_syn'),'min',mi,'max',ma);
   set(findobj('tag','edit_romu'),'string',num2str(10^ma));
end;   

drawnow;
val=10^(get(findobj('tag','barra_syn'),'value'));
%---------------------------------------------------

w=stack.temp.w;
[A,B,C,D]=unpck(stack.temp.plant);  %sistema aumentato

if strcmp(stack.temp.incer,'in') tipo=1;else tipo=2;end;
if strcmp(get(gcbo,'tag'),'barra_syn')
      val=10^(get(gco,'value'));
      set(findobj('tag','edit_romu'),'String',num2str(val));      
else  val=10^(get(findobj('tag','barra_syn'),'value'));
end;

switch tipo
case 1
   H=stack.temp.H;
   RO=val;
   
   %valori singolari max e min di Trol=(1/sqrt(ro))*H*inv(sI-A)*B;
   Trol=(1/sqrt(RO))*sigma(A,B,H,zeros(size(H,1),size(B,2)),w);
   s=size(Trol,1);
   if s > 1 sv_Trol=[20*log10(Trol(1,:));20*log10(Trol(s,:))];
   else sv_Trol=20*log10(Trol(1,:));end;

   %valori singolari max e min di Tlq=Kc*inv(sI-A)*B:
   %(è possibile che non si riesca a trovare Kc)
   try, Kc=lqr(A,B,H'*H,RO*eye(size(B,2)));vai=1;
   catch, vai=0;
   end;
   if vai   
     Tlq=sigma(A,B,Kc,zeros(size(Kc,1),size(B,2)),w);
     s=size(Tlq,1);
     if s > 1 sv_Tlq=[20*log10(Tlq(1,:));20*log10(Tlq(s,:))];
     else sv_Tlq=20*log10(Tlq(1,:));end;
   else sv_Tlq=nan;Kc=[];
     set(findobj('tag','BNext'),'enable','off');
     set(findobj('tag','inf1'),'visible','on');
   end;

   stack.temp.sv_Tlq=sv_Tlq;
   stack.temp.sv_Trol=sv_Trol;
   stack.temp.Kc=Kc;

   %grafico
   delete(findobj('tag','plot_Trol'));
   delete(findobj('tag','plot_Tlq'));

   set(gca,'drawmode','fast','nextplot','add');
   semilogx(w,sv_Trol,'b','tag','plot_Trol');
   if get(findobj('tag','ck_TlqTkf'),'value')
     semilogx(w,sv_Tlq,'r','tag','plot_Tlq');
   end;
   set(gca,'nextplot','replace');
   drawnow;
   if ~isempty(Kc) set(findobj('tag','BNext'),'enable','on');end;

case 2
   MU=val;   
   W=stack.temp.W;
   
   %valori singolari max e min di Tfol=(1/sqrt(mu))*C*inv(sI-A)*W;
   Tfol=(1/sqrt(MU))*sigma(A,W,C,zeros(size(C,1),size(W,2)),w);
   s=size(Tfol,1);
   if s > 1 sv_Tfol=[20*log10(Tfol(1,:));20*log10(Tfol(s,:))];
   else sv_Tfol=20*log10(Tfol(1,:));end;
   
   %valori singolari max e min di Tfb=C*inv(sI-A)*Kf:
   %(è possibile che non si riesca a trovare Kf)
   try, Kf=lqr(A',C',W*W',MU*eye(size(W,2)));vai=1;
   catch, vai=0;
   end;
   if vai   
     Kf=Kf';
     Tkf=sigma(A,Kf,C,zeros(size(C,1),size(Kf,2)),w);
     s=size(Tkf,1);
     if s > 1 sv_Tkf=[20*log10(Tkf(1,:));20*log10(Tkf(s,:))];
     else sv_Tkf=20*log10(Tkf(1,:));end;
   else sv_Tkf=nan;Kf=[];
     set(findobj('tag','BNext'),'enable','off');
     set(findobj('tag','inf1'),'visible','on');
   end;

   stack.temp.sv_Tkf=sv_Tkf;
   stack.temp.sv_Tfol=sv_Tfol;
   stack.temp.Kf=Kf;
   
   %grafico
   delete(findobj('tag','plot_Tfol'));
   delete(findobj('tag','plot_Tkf'));

   set(gca,'drawmode','fast','nextplot','add');
   semilogx(w,sv_Tfol,'b','tag','plot_Tfol');
   if get(findobj('tag','ck_TlqTkf'),'value')
     semilogx(w,sv_Tkf,'r','tag','plot_Tkf');
   end;
   set(gca,'nextplot','replace');
   drawnow;
   if ~isempty(Kf) set(findobj('tag','BNext'),'enable','on');end;
end;

watchoff;
