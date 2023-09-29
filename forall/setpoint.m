function [sp,ome12,ome22,S11,S12,S21,S22,A12,A21,C1,B2,T,x1,n_x2]=setpoint(plant)

%  [sp,ome12,ome22,S11,S12,S21,S22,A12,A21,C1,B2,T,x1,n_x2]=setpoint(plant);
%
%
%  plant  =   matrice del sistema in forma packed
%             (se è stato richiesto di aumentare il sistema con dei blocchi
%              di integratori , plant rappresenta il sistema aumentato)
%  sp     =   intero che indica se il set point è statico o quasi statico
%             (dipende dalla singolarità o meno della matrice [A B;C D])
%             sp=0 => set point statico
%             sp=1 => set point quasi statico   
%  ome12  =   se sp=0 è la matrice per cui x*=ome12 y* ; se sp=1 ome12=[];
%  ome22  =   se sp=0 è la matrice per cui u*=ome22 y* ; se sp=1 ome22=[];
%
%  nel caso di set point quasi-statico sono presenti inoltre le seguenti
%  variabili di uscita 
%
%  S11,S12,S21,S22,A12,A22,C1,B2,T,x1,n_x2
%
%  con T matrice di trasformazione per portare il sistema nella forma
%  necessaria per il calcolo di questi tipo di set-point,x1 gli stati
%  per cui possiamo,ma non è detto che lo sia,imporre il set point
%  costante e n_x2 il numero degli stati che variano nel tempo.
%  (vedi teoria per il significato delle altre variabili)
%
%  -------------------------------------------------------------------
%  Si presuppone che la matrice dinamica A del sistema si invertibile
%  e che la matrice D sia nulla (in caso contrario non sarebbe possibile
%  accedere alla sintesi dei controllori IMFC e EMFC che utilizzano
%  questo file
%  -------------------------------------------------------------------
%
%
%Massimo Davini 04/05/99

sp=[];
ome12=[];ome22=[];
S11=[];S12=[];S21=[];S22=[];A12=[];A21=[];C1=[];B2=[];T=[];x1=[];n_x2=[];

[ty,no,ni,ns]=minfo(plant);
[A,B,C,D]=unpck(plant);
Sigma=[A,B;C,D];

if (rank(A)==ns)&sum(any(~isnan(C*inv(-A)*B+D))~=0)&(rank(C*inv(-A)*B+D)==min(ni,no))
  %caso 1: set point STATICO
  %Sigma=[A,B;C,D] quadrata e non singolare
  %=> A è invertibile e G0=C*inv(-A)*B+D è invertibile
  
  %caso 2: set point STATICO
  %Sigma=[A,B;C,D] rettangolare e non singolare
  %=> A è invertibile e G0=C*inv(-A)*B+D è a rango pieno

  [row_S column_S]=size(Sigma);
  
  %caso1:
  if (row_S==column_S)  
         ome22=inv(-C*inv(A)*B+D);
         ome21=-ome22*C*inv(A);
         ome12=-inv(A)*B*ome22;
         ome11=inv(A)*(-B*ome21+eye(size(A,1)));
         sp=0;       
  %caso2:
  else
         Omega=pinv(Sigma);
         ome12=Omega(1:ns,ns+1:ns+no);
         ome22=Omega(ns+1:ns+ni,ns+1:ns+no);
         sp=0;       
  end;

elseif (rank(A)==ns)&(rank(C*inv(-A)*B+D) < min(ni,no))|(rank(Sigma) < min(size(Sigma)))
   %caso3: set point QUASI-STATICO
   %Sigma SINGOLARE => G0=C*inv(-A)*B+D non è a rango pieno
   %                   oppure Sigma non è a rango pieno
   %                   (supponiamo che A sia invertibile)

   %in questo caso possiamo partizionare lo stato in [x1,x2]' con
   %x2=integral(f(x1,u));
   %gli x2 saranno sicuramente tempovarianti mentre gli x1 potrebbero
   %essere costanti a seconda che dipendano o meno dagli x2.

   %     n=size(A,1);
   x10=[];x20=[];
   Aapp=A;
   
   for i=1:ns ,for j=1:ns
       if A(i,j)~=0 , Aapp(i,j)=1; end;
       if (i==j)&(A(i,j)==0) , x20=[x20;i]; end;
   end; end;
   %App ha 1 in ogni posizione in cui A ha un numero diverso da 0;
   %x20 contiene gli indici di tutti gli stati le cui derivate non 
   %dipendono da loro stessi
   
   A2app=[];
   for i=1:length(x20) , A2app=[A2app;Aapp(x20(i),:)]; end;
   %A2app è costituita dalle righe di App relative agli stati in x20
   
   [r,c]=size(A2app);
   A2x=zeros(r,c);
   for i=1:r , for j=1:c
       if A2app(i,j)~=0 A2x(i,j)=j; end;
   end; end;
   %A2x ha,al posto di ogni 1 in A2app,l'indice dello stato corrispondente
   
   app=[x20,A2x];
   %alla matrice A2x viene aggiunta come prima colonna il vettore x20;
   %in questo modo la matrice app ha per ogni riga gli indici degli stati
   %che sono legati al primo elemento della riga stessa:
   %ad esempio se una riga è [4 0 0 3 0 5 6] , significa che 
   %dx4/dt = k1*x3+k2*x5+k3*x6 (con k1,k2,k3 coefficenti corrispondenti
   %nella matrice A)
   
   appfine=[];x2=[];
   %appfine è la matrice finale relativa agli stati della partizione x2
   %i cui coefficenti hanno lo stesso significato della matrice app,ma sono
   %(x20 e app sono relative ad una prima partizione iniziale che deve 
   %essere eventualmente corretta : ogni stato in x2 deve dipendere SOLO
   %dagli stati in x1 e da u)
   
   while length(x20)>0
      index_min=1;
      elimina=0;
      %cerca in A2app la riga col minor numero di 1;
      for i=1:length(x20)
         if sum(A2app(i,:))<sum(A2app(index_min,:)) index_min=i; end;
      end;
      
      if (~isempty(x20))&(~isempty(appfine))& sum(any(appfine==x20(index_min)))>0  
         %verifica se lo stato x20(index_min) è già presente come
         %coefficiente all'interno della matrice appfine;
         %se già presente deve essere eliminato
         elimina=1;
      else
         for i=2:c+1
            if (~isempty(x20))&(~isempty(appfine))&(app(index_min,i)~=0)&(sum(any(appfine==app(index_min,i)))>0) 
               %verifica se gli stati da cui x20(index_min) dipende
               %(elementi diversi da 0 nella riga di app escluso il primo)
               %sono presenti all'interno della matrice appfine;
               %se già presente deve essere eliminato
               elimina=1;
            end;
         end;
      end;
      
      if elimina==1
            %x20(index_min) non può fare parte della partizione x2
            %e viene eliminato da x20 senza modificare appfine
            x20(index_min)=[];
            app(index_min,:)=[];
            A2app(index_min,:)=[];
         else  
            %x20(index_min) fa parte della partizione x2
            %e viene eliminato da x20 modificando appfine
            x2=[x2;x20(index_min)];
            appfine=[appfine;app(index_min,:)];
            x20(index_min)=[];
            app(index_min,:)=[];
            A2app(index_min,:)=[];
      end;
   %termina quando x20 è vuoto   
   end;              
   
   
%partizione x1
x1=[];
for i=1:ns , if ~any(x2==i) x1=[x1;i]; end; end;

%nuovo vettore di stato
x=[x1;x2];

%matrice di trasformazione per portare il sistema (plant)
%nella forma in cui x è il nuovo vettore di stato
T=[];T0=eye(ns);
for i=1:length(x) T=[T;T0(x(i),:)];end;

[no,ni]=size(D);

Anew=T*A*inv(T);
Bnew=T*B;
Cnew=C*inv(T);
Dnew=D;

A11=Anew(1:length(x1),1:length(x1));
A12=Anew(1:length(x1),length(x1)+1:length(x));
A21=Anew(length(x1)+1:length(x),1:length(x1));
A22=Anew(length(x1)+1:length(x),length(x1)+1:length(x));

B1=Bnew(1:length(x1),:);
B2=Bnew(length(x1)+1:length(x),:);

C1=Cnew(:,1:length(x1));
C2=Cnew(:,length(x1)+1:length(x));

invS=[A11 B1;C1 Dnew];
S=pinv(invS);

S11=S(1:length(x1),1:length(x1));
S12=S(1:length(x1),length(x1)+1:length(x1)+no);
S21=S(length(x1)+1:length(x1)+ni,1:length(x1));
S22=S(length(x1)+1:length(x1)+ni,length(x1)+1:length(x1)+no);

sp=1;
n_x2=length(x2);
end;

