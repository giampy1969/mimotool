function setmat(mat)
%SET uncertainty MATRIX for MU synthesis or optimization
%
%Questa funzione serve per il settaggio dei parametri delle 
%matrici bTi,bTo,bMi e bMo relative alla struttura delle incertezze 
%a blocchi (corrispondenti alle matrici Ti,To,Mi e Mo) nel caso
%di controllore Mu.
%Le matrici relative alle incertezze strutturate (b..) hanno
%inizialmente dimensioni pari alle dimensioni delle corrispondenti
%matrici Ti,To,Mi o Mo trasposte (quindi inizialmente sono 
%considerate costituite da un unico blocco) e possono essere
%suddivise in blocchi di varie dimensioni.
%I vari blocchi devono comunque essere tali da rispettare le
%dimensioni iniziali delle matrici . Ad esempio se inizialmente è
%bTo=[4,4] , possiamo dividerla in 4 blocchi di dimensioni unitaria
%--> bTo=[1 1;1 1;1 1;1 1] oppure in due blocchi --> bTo=[2 3;2 1]
%(la somma delle righe totali e la somma delle colonne totali 
%devono comunque essere uguali a quelle iniziali);
%
%NOTA:un blocco con dimensioni [3,0] corrisponde ad un blocco 
%diagonale di dimensioni [3,3].
%
%      setmat(mat)
%
%  mat = intero -> 1 o 2 (vedi sotto)
%
%La selezione del tipo di matrici è data dal parametro memorizzato
%in stack.temp.sceltamatrici e mat indica (nel caso in cui il
%precedente parametro sia uguele a 3 o 4) quale matrice considerare
%(negli altri casi la matrice è unica).
%Vedi manuali per maggiori informazioni.
%
%
%Massimo Davini 15/02/99 --- revised 02/06/99

global stack;
if nargin < 1 mat==1;end;

selezione=stack.temp.sceltamatrici;
[no,ni]=size(stack.general.D);

x=length(stack.temp.handles);

switch selezione 
   case 1
      
     if no<=10 lim1=no;else lim1=10;end;
     max_row=no;max_col=no;aggiungi=0;
     n_mat1=lim1*2;
     h_mat1=stack.temp.handles(x-n_mat1+1:x);     
     
  case 2
      
     lim1=min(ni,no);
     if lim1>10 lim1=10;end;
     max_row=no;max_col=ni;aggiungi=0;
     n_mat1=lim1*2;
     h_mat1=stack.temp.handles(x-n_mat1+1:x);     

  case 3
      
     if ni<=10 lim1=ni;else lim1=10;end;
     n_mat1=lim1*2;   
     
     if no<=10 lim2=no;else lim2=10;end;
     n_mat2=lim2*2;
     
     if mat==1       max_row=ni;max_col=ni;aggiungi=0;
     elseif mat==2   max_row=no;max_col=no;
        
%        if ni<=10 plus=ni;else plus=10;end;
%        aggiungi=2*plus+2;         %per tenere conto degli oggetti già creati
     end;
     h_mat1=stack.temp.handles(x-n_mat1-n_mat2+1:x-n_mat2);     
     h_mat2=stack.temp.handles(x-n_mat2+1:x);     
     
  case 4
     
     lim1=min(ni,no);
     if lim1>10 lim1=10;end;
     n_mat1=lim1*2;
     
     lim2=lim1;
     n_mat2=lim2*2;
     lim=min(ni,no);
     
     if mat==1      max_row=ni;max_col=no;aggiungi=0;
     elseif mat==2  max_row=no;max_col=ni;aggiungi=2*lim+2;
     end;
     
     h_mat1=stack.temp.handles(x-n_mat1-n_mat2+1:x-n_mat2);     
     h_mat2=stack.temp.handles(x-n_mat2+1:x);     
     
  end;
  
%------------------------------------------------------------------
%verifica se sono stati inseriti entrambi i valori per una qualunque
%riga della matrice,altrimenti setta i valori a quelli di default
%-------------------------------------------------------------------

%mat indica se la matrice da settare è mat1 (mat=1) o mat2 (mat=2)
if mat==1 handles=h_mat1;lim=lim1;
elseif mat==2 handles=h_mat2;lim=lim2;
end;


i=0;vai1=1;
while vai1&(i<=lim-1)
   
   i=i+1;
   num1=str2num(get(handles(1+(i-1)*2),'string'));
   if isreal(num1)&(num1>0) go_1=1;
   else go_1=0;set(handles(1+(i-1)*2),'string','');
   end; 

   num2=str2num(get(handles(2+(i-1)*2),'string'));
   if isreal(num2)&(num2>=0) go_2=1;
   else go_2=0;set(handles(2+(i-1)*2),'string','');
   end;

   if go_1&go_2, vai1=1;
   elseif (~go_1)&(~go_2) vai1=1;
   else vai1=0;
   end;          
   
end;

if ~vai1
   
   set(handles,'string','');
   set(handles(1),'string',num2str(max_row));
   set(handles(2),'string',num2str(max_col));
   rows=[max_row];columns=[max_col];
   
end;
  
%------------------------------------------------------
%------------verifica sulle dimensioni-----------------
%------------------------------------------------------

if vai1
     tot_righe=0;rows=[];i=0;
     while(i<=lim-1)
        num=str2num(get(handles(1+2*i),'string'));
        if isempty(num) num=0;end;
        tot_righe=tot_righe+num;
        num=str2num(get(handles(1+2*i),'string'));
        rows=[rows;num];
        i=i+1;
     end;
     if tot_righe~=max_row 
        set(handles,'string','');
        set(handles(1),'string',num2str(max_row));
        set(handles(2),'string',num2str(max_col));
        columns=[max_col];rows=[max_row];
     end;

     tot_col=0;columns=[];i=0;
     while(i<=lim-1)
        num=str2num(get(handles(2+i*2),'string'));
        if isempty(num) tot_col=tot_col;
        elseif num==0 tot_col=tot_col+str2num(get(handles(1+2*i),'string'));
        else tot_col=tot_col+num;
        end;
        columns=[columns;num];
        i=i+1;
     end;
     if (tot_col~=max_col)  
            set(handles,'string','');
            set(handles(1),'string',num2str(max_row));
            set(handles(2),'string',num2str(max_col));
            columns=[max_col];rows=[max_row];
     end;
end;


%---------------------------------------------------
%---aggiornamento stack.temp con le nuove matrici---
%---------------------------------------------------

matrice=[rows,columns];

switch selezione
case 1
   stack.temp.bTo=matrice;
   set(findobj('tag','BNEXT'),'enable','on');
   
case 2
   stack.temp.bMo=matrice;
   set(findobj('tag','BNEXT'),'enable','on');
   
case 3
   if mat==1
      stack.temp.bTi=matrice;
      stack.temp.flag.ok1=1;      
   elseif mat==2 
      stack.temp.bTo=matrice;
      stack.temp.flag.ok2=1;      
   end;
   if stack.temp.flag.ok1 & stack.temp.flag.ok2
      set(findobj('tag','BNEXT'),'enable','on');
   end;
   
case 4
   if mat==1
      stack.temp.bMi=matrice;
      stack.temp.flag.ok1=1;      
   elseif mat==2 
      stack.temp.bMo=matrice;
      stack.temp.flag.ok2=1;      
   end;
   if stack.temp.flag.ok1 & stack.temp.flag.ok2
      set(findobj('tag','BNEXT'),'enable','on');
   end;
   
end;