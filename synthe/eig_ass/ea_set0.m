function ea_set0;
%EA_SET0 : callback del bottone SET del controllo EIG\ASSIGN
%
% Preleva dalla finestra il valore dell'autovalore e dello
% autovettore corrispondente desiderati;
% se tali parametri sono consistenti richiama la funzione 
% successiva :
%
% se l'utovalore è reale       -->  richiama ea_set1(1) 
%
% se l'utovalore è complesso   
% ed è il primo tra i due 
% complessi coniugati          -->  richiama ea_ffrw('ff')    
% (prima dobbiamo inserire entrambi gli autovettori e poi
% viene fatto il calcolo)
%
% se l'utovalore è complesso   
% ed è il secondo tra i due 
% complessi coniugati          -->  richiama ea_set1(2)    
%
%
% Massimo Davini 12/10/99 --- revised 21/10/99

global stack;
[ns ns]=size(stack.general.A);
a=[];

%autovalore corrente
num=str2num(get(findobj('tag','ea1_edit'),'string'));
%indice autovalore corrente sul totale richiesti
corrente=stack.temp.cont_autov;  
%autovettore desiderato
for i=1:ns
  a=[a;str2num(get(findobj('tag',sprintf('ea1_vet_%u',i)),'string'))];
end

x=strcmp(get(findobj('tag','ea1_edit'),'enable'),'on');

if isempty(num)|isstr(num)|isnan(num)|isempty(find(isnan(a)==0))|...
    (~isreal(num)&(stack.temp.cont_autov==stack.temp.num_autov)& x)
   set(findobj('tag','ea1_edit'),'string','NaN');
   for i=1:ns
     set(findobj('tag',sprintf('ea1_vet_%u',i)),'string','NaN');
     set(findobj('tag',sprintf('ea1_ach_%u',i)),'string','');
   end;
   stack.temp.flag(corrente)=0;   
   set(findobj('tag','ea1_next'),'enable','off');
   return;
end;

%----------------------------------------------------

if isreal(num) , 
   eval('ea_set(1);');
elseif ~isreal(num) & ~x ,
   eval('ea_set(2);');
elseif ~isreal(num) & x , 
   stack.temp.a_val(corrente)=num;
   stack.temp.a_val(corrente+1)=conj(num);
   
   stack.temp.flag(corrente)=1;      
   stack.temp.flag(corrente+1)=1;
   
   stack.temp.a_vet(:,corrente)=a;
   stack.temp.a_vet(:,corrente+1)=real(a)*nan;
   
   stack.temp.ach_vet(:,corrente+1)=real(a)*nan;
   stack.temp.ach_vet(:,corrente)=real(a)*nan;
   
   eval('ea_ffrw(''ff'');');
end;