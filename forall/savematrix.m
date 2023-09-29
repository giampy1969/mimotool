function savematrix(row,column,label,varargin)
%SAVE MATRIX (general function) 
%
%  savematrix(row,column,label,pos_matrix,pos_flag,pos_flags)
%
% row         = # righe dela matrice
% column      = # colonne della matrice
% label       = char che indica il nome della matrice per poter 
%               fare i controlli necessari (vedi il codice)
% varargin    = numero variabile di stringhe rappresentanti i campi
%               della struttura stack.temp relativi ai flag di 
%               memorizzazione delle matrici
%
% Massimo Davini 25/05/99 --- revised 31/05/99


global stack;
matrice=findobj('tag','matrice');

set(findobj('tag','BEVAL'),'enable','off');
set(findobj('tag','BSIMU'),'enable','off');

if (row < 11)&(column < 11)
  %verifica la consistenza dei coefficienti inseriti 
  coeff=zeros(1,row*column);
  for i=1:length(matrice)
    if isempty(str2num(get(matrice(length(matrice)+1-i),'string')))
         messag(gcf,'pi');return;
    elseif ~isreal(str2num(get(matrice(length(matrice)+1-i),'string')))
         messag(gcf,'pi');return;
    else coeff(i)=str2num(get(matrice(length(matrice)+1-i),'string'));
    end;
  end;

  matrix=zeros(row,column);
  for i=1:row , for j=1:column
         matrix(i,j)=coeff(j+(i-1)*column);
  end , end;
  
  switch label
   case 'Q'
      if (norm(matrix'-matrix,1)>100*eps*norm(matrix,1))|(min(real(eig(matrix)))<0)
         %se la matrice Q non è simmetrica o semidefinita positiva
         messag(gcf,'nsesd','Q');
         stack.temp.flagQ=0;
         set(findobj('tag','BQ'),'string','Q');
         set(findobj('tag','BEVAL'),'enable','off');
         set(findobj('tag','BSIMU'),'enable','off');
         set(findobj('tag','eval_31'),'enable','off');
         set(findobj('tag','simu_2'),'enable','off');
         return;
      else
         stack.temp.flagQ=1;
         set(findobj('tag','BQ'),'string','[ Q ]');
         stack.temp.Q=matrix;
      end;
   case 'R'
      if (norm(matrix'-matrix,1)>100*eps*norm(matrix,1))|(min(real(eig(matrix)))<=0)
         %se la matrice R non è simmetrica o definita positiva
         messag(gcf,'nsed','R');
         stack.temp.flagR=0;
         set(findobj('tag','BR'),'string','R');
         set(findobj('tag','BEVAL'),'enable','off');
         set(findobj('tag','BSIMU'),'enable','off');
         set(findobj('tag','eval_31'),'enable','off');
         set(findobj('tag','simu_2'),'enable','off');
         return;
      else
         stack.temp.flagR=1;
         set(findobj('tag','BR'),'string','[ R ]');
         stack.temp.R=matrix;
      end;
   case 'W'
      if (norm(matrix'-matrix,1)>100*eps*norm(matrix,1))|(min(real(eig(matrix)))<0)
         %se la matrice W non è simmetrica o semidefinita positiva
         messag(gcf,'nsesd','W');
         stack.temp.flagW=0;
         set(findobj('tag','BW'),'string','W');
         set(findobj('tag','BEVAL'),'enable','off');
         set(findobj('tag','BSIMU'),'enable','off');
         set(findobj('tag','eval_31'),'enable','off');
         set(findobj('tag','simu_2'),'enable','off');
         return;
      else
         stack.temp.flagW=1;
         set(findobj('tag','BW'),'string','[ W ]');
         stack.temp.W=matrix;
      end;
   case 'V'
        if (norm(matrix'-matrix,1)>100*eps*norm(matrix,1))|(min(real(eig(matrix)))<=0)
         %se la matrice V non è simmetrica o definita positiva
         messag(gcf,'nsed','V');
         stack.temp.flagV=0;
         set(findobj('tag','BV'),'string','V');
         set(findobj('tag','BEVAL'),'enable','off');
         set(findobj('tag','BSIMU'),'enable','off');
         set(findobj('tag','eval_31'),'enable','off');
         set(findobj('tag','simu_2'),'enable','off');
         return;
      else
         stack.temp.flagV=1;
         set(findobj('tag','BV'),'string','[ V ]');
         stack.temp.V=matrix;
      end;
   end;
   
elseif (row > 10)|(column > 10)
   %in questo caso è presente un messaggio all'interno di cui
   %è possibile inserire (campo edit) il valore sulla diagonale.
   %il campo edit è il primo degli oggetti con tag='matrice'
   
   T=str2num(get(matrice(1),'string'));
   if isempty(T)|(~isreal(T)) messag(gcf,'pi');return; end;
   if T<=0 T=1;set(matrice(1),'string',num2str(1));end;

   switch label
      case 'Q'
         stack.temp.Q=T*eye(row,column);
         stack.temp.flagQ=1;
         set(findobj('tag','BQ'),'string','[ Q ]');
      case 'R'
         stack.temp.R=T*eye(row,column);
         stack.temp.flagR=1;
         set(findobj('tag','BR'),'string','[ R ]');
      case 'W'
         stack.temp.W=T*eye(row,column);
         stack.temp.flagW=1;
         set(findobj('tag','BW'),'string','[ W ]');
      case 'V'
         stack.temp.V=T*eye(row,column);
         stack.temp.flagV=1;
         set(findobj('tag','BV'),'string','[ V ]');
      end;
      set(matrice(3),'string',sprintf('The actual matrix %s is %u*eye(%u,%u) .\nYou can choose T such that the new value will be T*eye(%u,%u) .',label,T,row,column,row,column));
 
end;   
   
   
   
go=1;
for i=1:length(varargin)
   str=sprintf('stack.temp.%s==0',varargin{i});
   if eval(str) go=0;end;
end;

if go==1
   set(findobj('tag','FQ'),'visible','off');
   set(findobj('tag','FR'),'visible','off');
   set(findobj('tag','FW'),'visible','off');
   set(findobj('tag','FV'),'visible','off');
   delete(findobj('tag','matrice'));
   drawnow;
   set(gcbo,'visible','off');
   set(findobj('tag','BREG'),'visible','on');
end;
