function ltr1;
%LTR1 : 2° finestra di sintesi LQG\LTR
%
% Vengono prelevati i vari parametri dai campi edit 
% presenti nella prima finestra di questa sezione e,
% se sono consistenti,viene richiamata la funzione
% ltr_syn;
%
% Vengono aggiunti gli eventuali integratori richiesti
% e viene ricavata una realizzazione minima del sistema;
% il sistema modificato viene poi inserito nel campo
% stack.temp.plant,mentre il sistema originale viene
% inserito in stack.temp.sys.
%
%
% Massimo Davini 12/10/99


global stack;
hedit=stack.temp.edit;

%------------------------------------------------
%prelievo parametri dai campi edit della finestra
%------------------------------------------------
%bandwidth upper limit
ok_bul=0;
bul=str2num(get(hedit(1),'string'));
if ~isempty(bul)&(isreal(bul))&(bul>0) ok_bul=1;
else set(hedit(1),'string',num2str(10));bul=10; 
end

%static gain and/or freq
ok_sg=0;
if  get(findobj('tag','ck_sg'),'value')==1, h_sg=hedit(2); else h_sg=hedit(3); end

sg=str2num(get(h_sg,'string'));
if ~isempty(sg)&(isreal(sg))&(sg>0) ok_sg=1;
else set(h_sg,'string',num2str(60));sg=60; end;
   
ok_freq=0;
if get(findobj('tag','ck_ib'),'value')==0,
    ok_freq=1;freq=nan;
else
   freq=str2num(get(hedit(4),'string'));
   if ~isempty(freq)&(isreal(freq))&(freq>0) ok_freq=1;
   else set(hedit(4),'string',num2str(0.01));freq=0.01;
   end
end;

%uncertainty crossover-frequency
ok_cf=0;
cf=str2num(get(hedit(5),'string'));
if ~isempty(cf)&(isreal(cf))&(cf>0) ok_cf=1;
else set(hedit(5),'string',num2str(10));cf=10;end;
   
%uncertainty rolloff at crossover-frequency
ok_ro=0;
ro=str2num(get(hedit(6),'string'));
if ~isempty(ro)&(isreal(ro))&(ro>0) ok_ro=1;
else set(hedit(6),'string',num2str(40));ro=40;end;

%------------------------------------------------------------
%se tutti i parametri sono consistenti,si richiama la funzione
%ltr_s_lq (per la sintesi LQ) o la funzione ltr_s_kfb (per la 
%sintesi KFB) se l'incertezza è rispettivamente in ingresso o
%in uscita
%------------------------------------------------------------

if ok_bul & ok_sg & ok_freq & ok_cf & ok_ro
   
   if get(findobj('tag','opt_i'),'value')==1 pos='in';
   else pos='out';end;

   stack.temp.incer=pos;
   stack.temp.param=[bul sg freq cf ro];
   
   %-------------------------------------------------
   %aggiunta degli eventuali integratori al sistema :
   %incertezza in ingresso ---> integratori in uscita
   %incertezza in uscita ---> integratori in ingresso
   
   n_integr=stack.temp.integratori;    %integratori
   if n_integr > 0
       plant=stack.temp.sys;
       [ty,no,ni,ns]=minfo(plant);
       switch pos
       case 'in'
         Ai=zeros(no);Bi=eye(no);Ci=eye(no);Di=zeros(no);
         P=pck(Ai,Bi,Ci,Di);
         for i=1:n_integr,  plant=mmult(P,plant);end;
       case 'out'
         Ai=zeros(ni);Bi=eye(ni);Ci=eye(ni);Di=zeros(ni);
         P=pck(Ai,Bi,Ci,Di);
         for i=1:n_integr,  plant=mmult(plant,P);end;
       end;
       stack.temp.plant=plant;
    end;
   %riduzione di ordine 
   [Aaug,Baug,Caug,Daug]=unpck(stack.temp.plant);
   sys=ss(Aaug,Baug,Caug,Daug);
   msys=minreal(sys);
   [A,B,C,D]=ssdata(msys);
   stack.temp.plant=pck(A,B,C,D);
   
   ltr_syn;
end;

