function ea_set(tipo);
%EA_SET : funzione per il settaggio in EIG\ASSIGN 
%         delle coppie autovalore\autovettore desiderati
%         e per il calcolo degli autovettori ottenibili
%
%                     ea_set(tipo)
%
% tipo = 1 --> l'autovalore corrente è reale
% tipo = 2 --> l'autovalore corrente è il secondo di due
%              complessi coniugati (l'altro è quello
%              precedente visualizzabile con il bottone <<)
%
% Massimo Davini 12/10/99 --- revised 21/10/99

global stack;

A=stack.general.A;B=stack.general.B;
C=stack.general.C;D=stack.general.D;

[ns ns]=size(A);[nb,mb]=size(B);
a=[];prec=[];succ=[];
tol=0.01;

%autovalore corrente
num=str2num(get(findobj('tag','ea1_edit'),'string'));
%indice autovalore corrente
corrente=stack.temp.cont_autov;

%-----------------------------
   
if (corrente<stack.temp.num_autov)&...
     (stack.temp.flag(corrente+1))&(stack.temp.flag(corrente))
  prec=stack.temp.a_val(corrente);
  succ=stack.temp.a_val(corrente+1);
end;
   
for i=1:ns
   h=findobj('tag',sprintf('ea1_vet_%u',i));
   x=str2num(get(h,'string'));
   if isempty(x)                 
      %i-esima entrata vuota
      set(h,'string','NaN');
      x=nan;
   elseif ~isempty(x)&(tipo==1)&(imag(x)~=0)  
      %i-esima entrata complessa con autovalore reale   
      x=real(x); set(h,'string',num2str(x));
   end;
   stack.temp.a_vet(i,corrente)=x;
end;

autovettore=stack.temp.a_vet(:,corrente);
stack.temp.flag(corrente)=1;      
stack.temp.a_val(corrente)=num;
   
switch tipo
case 1      %autovalore reale
    %  (1) Define  Basis matrix: s
    s=inv(A-num*eye(ns))*B;
    if (~isempty(prec))&(~isempty(succ))&(prec==conj(succ))
       stack.temp.flag(corrente+1)=0;
       set(findobj('tag','ea1_next'),'enable','off');
    end;
   
    k=isnan(autovettore);
    j=isfinite(autovettore);
      
    l = autovettore(j); L = s(j,:);
    try,z = pinv(L,tol)*l; va=s(1:ns,:)*z;
    catch, 
       messag(gcf,'anp');
       watchoff;
       for i=1:ns
         set(findobj('tag',sprintf('ea1_ach_%u',i)),'string','');
       end;
       stack.temp.flag(corrente)=0;   
       set(findobj('tag','ea1_next'),'enable','off');
       return;
    end;
      
    %Forzatura di un NaN per avere un autovettore raggiungibile
    %diverso da zero
    if nnz(va==0)&(~isempty(k))
      stack.temp.a_vet(k(1),corrente)=1;
      %for i=1:ns
      %   x=stack.temp.a_vet(i,corrente);
      %   if isnan(x) set(findobj('tag',sprintf('ea1_vet_%u',i)),'string','NaN');
      %   else        set(findobj('tag',sprintf('ea1_vet_%u',i)),'string',num2str(x));
      %   end;
      %end;
    end;
     
    stack.temp.ach_vet(:,corrente)=va;
    for i=1:ns
       set(findobj('tag',sprintf('ea1_ach_%u',i)),'string',num2str(stack.temp.ach_vet(i,corrente)),...
          'TooltipString',sprintf('Va(%u) = %u',i,stack.temp.ach_vet(i,corrente)));
    end;
    
 case 2     %autovalore complesso
    stack.temp.flag(corrente-1)=1;
    %l'autovettore precedente è già stato assegnato
    autovettoreprec=stack.temp.a_vet(:,corrente-1);   
   
    %  (1) Define  Basis matrix: s
    % faccio i calcoli sull'autovalore precedente
    % complesso coniugato di quello attuale
    s=inv(A-conj(num)*eye(ns))*B;
    
    %  (2) Reordering desired eigenvectors : 
    %      se l'autovalore è complesso --> s è complessa
    s=[real(s) -imag(s);imag(s) real(s)];
    evt=[autovettoreprec;autovettore];
    
    k=isnan(evt); j=isfinite(evt);
    l=evt(j); L=s(j,:);
    [nl,ml]=size(L); 
    mb2=mb*2;

    %  (3) Find z value corresponding to the projection of v
    z=pinv(L,tol)*l;
    zv(:,1)=z(1:mb,:)+sqrt(-1)*z(mb+1:2*mb,:);
    zv(:,2)=conj(zv(:,1));
       
    %  (4) Find an achievable eigenvector  : va
    var=s(1:ns,:)*z;
    vai=s(ns+1:2*ns,:)*z;  
    va(:,1)=var+vai*sqrt(-1);
    va(:,2)=conj(va(:,1));
      
    %   (5) If va is a complex matrix, modify v which consists with
    %       the separated real parts and imaginary parts of eigenvectors
    iva=imag(va);j=find(iva~=0);
    if all(j)~=0 va=modv(va);end;
    
    %Forzatura di un NaN per avere un autovettore raggiungibile
    %diverso da zero
    if (nnz(va(:,1))==0)&(~isempty(k))
       stack.temp.a_vet(k(1),corrente)=1;
       stack.temp.a_vet(k(1),corrente-1)=1;
       %for i=1:ns
       %  x=stack.temp.a_vet(i,corrente);
       %  if isnan(x) set(findobj('tag',sprintf('ea1_vet_%u',i)),'string','nan');
       %  else        set(findobj('tag',sprintf('ea1_vet_%u',i)),'string',num2str(x));
       %  end;
       %end;
    end;
     
    stack.temp.ach_vet(:,corrente-1)=va(:,1);
    stack.temp.ach_vet(:,corrente)=va(:,2);
    for i=1:ns
       set(findobj('tag',sprintf('ea1_ach_%u',i)),'string',num2str(stack.temp.ach_vet(i,corrente)),...
          'TooltipString',sprintf('Va(%u) = %u',i,stack.temp.ach_vet(i,corrente)));
    end;
  
end;
   
%-------------------------------------------------------  
flag=stack.temp.flag;
if nnz(flag)==stack.temp.num_autov
      set(findobj('tag','ea1_next'),'enable','on');
else set(findobj('tag','ea1_next'),'enable','off');  
end;


%----------------------------------------------------------
%----------------------------------------------------------
function[v]=modv(v)
%  ------------------------------------------------------------- %
%   This function produces the desired complex eigenvectors
%   to be modified with real terms and imaginary terms
%
%   Input   :    v  -- achived eigenvectors
%
%   Output  :    v  -- replaced desired eigenvectors
%  ------------------------------------------------------------- %
%
i = sqrt(-1);
[nv,mv]=size(v);
%
iv=imag(v);
%  checking the matrix v --- complex matrix ?  .If yes, modify !
mod=[0.5  -0.5*i
     0.5   0.5*i];
j = 1;
while j <= mv
   if all(iv(:,j)==0),    % matrix with real elements
       vrp(:,j)= v(:,j)*1; 
       j = j + 1 ;
   else                   % complex terms -- modify to matrix with
       vc = v(:,j:j+1);   %      separated real and imaginary term.!!
       vrp(:,j:j+1)= vc*mod; 
       j = j + 2;
   end
end
v=vrp;
% --- end  for modv.m
