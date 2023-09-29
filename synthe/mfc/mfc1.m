function mfc1(tipo)
%MFC1 : permette il passaggio alla 2° finestra di EMFC o IMFC
%
%Questa funzione è la callback associata al bottone NEXT della 
%prima finestra relativa ai controlli di tipo IMFC o EMFC.
%Preleva dai campi di edit presenti nella finestra i valori inseriti
%dall'utente e,se sono significativi e corretti,crea la finestra 
%successiva;altrimenti setta soltanto i campi edit al loro valore 
%di default.
%
%
%
%Massimo Davini 26/05/99 --- revised 31/05/99

global stack;

ordine=0;
if strcmp(tipo,'EMFC')
   if get(findobj('tag','option1'),'value') ordine=1;
   else ordine=2;end;
end;

%--------------------------------------------------------
ok_gain=0;ok_over=0;ok_sett=0;

if strcmp(tipo,'IMFC')|(ordine==1) ok_over=1; end;

gain=str2num(get(findobj('tag','EditGain'),'string'));
if ~isempty(gain)&isreal(gain) ok_gain=1;end;

if strcmp(tipo,'EMFC')&(ordine==2)
    over=str2num(get(findobj('tag','EditOver'),'string'));
    if ~isempty(over)&isreal(over)&(over>=0)&(over<=100) ok_over=1;end;
end;

sett=str2num(get(findobj('tag','EditSett'),'string'));
if ~isempty(sett)&isreal(sett)&(sett>0) ok_sett=1;end;
%--------------------------------------------------------

if (ok_gain)&(ok_over)&(ok_sett) prosegui=1;
else 
      prosegui=0;
      if ~(ok_gain)         set(findobj('tag','EditGain'),'string',num2str(1));  end;
      if ~(ok_over)         set(findobj('tag','EditOver'),'string',num2str(5));  end;
      if ~(ok_sett)         set(findobj('tag','EditSett'),'string',num2str(10)); end;
end;

%----------------------------------------------------------------------------
%------Se i parametri sono corretti si passa alla finestra successiva--------

if prosegui==1

   if strcmp(tipo,'EMFC')&(ordine==2)

     %costruzione del modello con sistemi del 2° ordine
     if over>0        %poli complessi
         delta=sqrt(log(over/100)*log(over/100)/(log(over/100)*log(over/100)+pi*pi));
         omegan=3/(sett*delta);
     elseif over==0    %poli reali
         delta=1;     %poli reali coincidenti
         omegan=5/sett;
     end;

     num=[0 0 gain*omegan*omegan];
     den=[1 2*delta*omegan omegan*omegan];

     [a b c d]=tf2ss(num,den);

   elseif strcmp(tipo,'EMFC')&(ordine==1)
     %costruzione del modello con sistemi del 1° ordine
     polo=-log(0.05)/sett;   %y(sett)=0.95*gain
     k=gain*polo;

     num=[0 k];
     den=[1 polo];

     [a b c d]=tf2ss(num,den);
      
   elseif strcmp(tipo,'IMFC')

     %costruzione del modello con sistemi del 1° ordine
     polo=-log(0.05)/sett;   %y(sett)=0.95*gain
     k=gain*polo;
     
     num=[0 k];
     den=[1 polo];

     [a b c d]=tf2ss(num,den);

     %la matrice C del modello deve essere la matrice Identità
     coeff=c(1,1);
     c=c/coeff;
     b=b*coeff;
   end;

   plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   [ty,no,ni,ns]=minfo(plant);
     
   canale=pck(a,b,c,d);modello=[];
   for k=1:no modello=daug(modello,canale);end;

   %l'indice di costo da minimizzare in EMFC è dato da :
   %       J=integral( (y-ym)'Q(y-ym) +u'Ru )dt
   %con y uscite del sistema con gli integratori e ym uscite del modello.
   %Dalle equazioni di uscita otteniamo ( I SISTEMI DEVONO ESSERE PROPRI , CON D=0 ) :
   %       J=integral( x'[Caug - Cm]'Q [Caug - Cm] x +u'Ru )dt
   %con x =[ x stati del sistema,xm stati delmodello]'.
   
   %l'indice di costo da minimizzare in IMFC è dato da :
   %       J=integral( (dy/dt-Am*y)'Q(dy/dt-Am*y) +u'Ru )dt
   %con y uscite del sistema con gli integratori e ym=xm=y uscite del modello.
   %Il modello deve avere Cm=I , quindi le ym=xm=y.
     
   Q=eye(no);
   R=eye(ni);
   
   stack.temp.Q=Q;
   stack.temp.R=R;
   stack.temp.flagQ=0;          %flag di memorizzazione di Q
   stack.temp.flagR=0;          %flag di memorizzazione di R
   stack.temp.modello=modello;

   mfc2(tipo);
   
end;