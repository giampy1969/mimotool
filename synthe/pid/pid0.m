function pid0(n)
%PID0 : prima finestra controllo PID
%
%  pid0(n)
%
% n = intero che indica il numero di blocchi di integratori
%     richiesti nella finestra precedente
%
%Massimo Davini 08/11/99

global stack;

set(findobj('tag','integratori'),'visible','off');
set(findobj('tag','EditIntegr'),'visible','off');
drawnow;

G=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
[ty,no,ni,ns]=minfo(G);

nm=min(no,ni);P=G;
Ibs=pck(zeros(nm),eye(nm),eye(nm),zeros(nm));
if ni<no Ibi=Ibs;Ibo=eye(no); else Ibi=eye(ni);Ibo=Ibs; end;
for k=1:n P=mmult(Ibo,P,Ibi); end;

%in questo modo ho aggiunto gli n integratori richiesti in ingresso
%o in uscita a seconda di qual'è il lato (righe o colonne) a 
%dimensione  minima in G.

%--------------------------------------------------
%salvataggio delle funzioni di trasferimento dei
%canali sulla diagonale principale della matrice
%di trasferimento del sistema : numero di canali 
%da salvare =  min(ni,no) del sistema (ni e no non
%cambiano se si aggiungono gli integratori)

[a,b,c,d]=unpck(P); [ty,no,ni,ns]=minfo(P); 
Numcell=cell(no,ni);
for i=1:ni
   [num,Den]=ss2tf(a,b,c,d,i);
   for j=1:no Numcell{j,i}=num(j,:); end   
end
if size(Numcell,1)>1 & size(Numcell,2)>1,
    Numcell=diag(Numcell);
else
    Numcell=Numcell(1);
end
for k=1:length(Numcell), Numc(k,:)=Numcell{k}; end

%----------------------------------
%aggiornamento variabile stack.temp
stack.temp.integratori=n;   %blocchi di integratori aggiunti
stack.temp.plant=G;         %original plant
stack.temp.augmplant=P;     %augmented plant
stack.temp.canali=nm;       %canali sulla diagonale principale( = # di pid)
stack.temp.Num=Numc;        %numeratori fdt dei canali interessati
stack.temp.Den=Den;         %denominatori fdt dei canali interessati

str1='Every channel on the principal diagonal of the transfer matrix of the system will be controlled, singularly, with a PID standard regulator.';  
str2='Then the resulting Closed Loop System will have a better behaviour if the plant is diagonal dominant.'; 

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz/20+.12;str=sprintf('%s\n\n%s',str1,str2);pos=[.12 .5 .76 0.32];

pid(1)=uicontrol('style','frame','units','normalized','position',[0.1 0.47 0.8 0.38],...
   'backgroundcolor',[1 1 1],'visible','off','tag','pid0');
  
pid(2)=uicontrol('style','text','units','normalized','position',pos,...
   'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','tag','pid0',...
   'HorizontalAlignment','left','string',str); 
 
 campi=['''integratori'',''plant'',''augmplant'',''canali'',''Num'',''Den'''];
    pid(3)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','pid0',...
   'TooltipString','Back to the previous window',...
   'callback',sprintf('back_syn(''integratori'',%u,%s);',length(stack.temp.handles),campi));
   
pid(4)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center',...
   'TooltipString','Back to the main SYNTHESIS window','tag','pid0',...
   'callback',sprintf('back_syn(''syn0'',0,%s);',campi));

pid(5)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','pid0',...
   'TooltipString','Go to the next window','callback','pid1;');

set(pid,'visible','on');

stack.temp.handles=[stack.temp.handles,pid];