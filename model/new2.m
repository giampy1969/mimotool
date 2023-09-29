function new2
%NEW2 : callback del bottone "SAVE MATRIX" 
% Salvataggio nuova matrice
% 
% Massimo Davini   28/05/99 revised 19/03/00

global stack;

go=1;
matrice=findobj('tag','matrice');

for i=1:length(matrice)
   if isempty(str2num(get(matrice(length(matrice)+1-i),'string')))
      go=0;
   else
      coeff(i)=str2num(get(matrice(length(matrice)+1-i),'string'));
   end;
end;

if go==1  
%-----parametri consistenti
 ind=stack.temp.matrice;       %indice della matrice visualizzata   
 switch ind
 case 1, label='A';
 case 2, label='B';
 case 3, label='C';
 case 4, label='D';
 end;

 eval(sprintf('[row,col]=size(stack.temp.%s);',label));
 matrix=zeros(row,col);
 for i=1:row , for j=1:col
       matrix(i,j)=coeff(j+(i-1)*col);
 end; end;
 eval(sprintf('stack.temp.%s=matrix;',label));
 eval(sprintf('stack.temp.flag%s=1;',label));
   
 set(stack.temp.handles(13+ind),'string',sprintf('[ %s ]',label));
   
 if (stack.temp.flagA)&(stack.temp.flagB)&...
             (stack.temp.flagC)&(stack.temp.flagD)
   stack.general.model='Untitled.mat';
   stack.general.A=stack.temp.A;  stack.general.B=stack.temp.B; 
   stack.general.C=stack.temp.C;  stack.general.D=stack.temp.D;
   stack.general.M_flag=1;          %flag di nuovo sistema
      
   stack.evaluation=[];  stack.simulation=[];
      
   %ind è l'indice dell'ultima matrice salvata (e visualizzata)
      
   delete(stack.temp.handles);drawnow;
   stack.temp=[];
      
   titolo=get(gcf,'Name');
   titolo=titolo(1:length(titolo)-8);
   set(gcf,'name',titolo);
 
   set(findobj('tag','bottA'),'enable','on',...
      'visible','on','string','[ A ]');
   set(findobj('tag','bottB'),'enable','on',...
      'visible','on','string','[ B ]');
   set(findobj('tag','bottC'),'enable','on',...
      'visible','on','string','[ C ]');
   set(findobj('tag','bottD'),'enable','on',...
      'visible','on','string','[ D ]');
      
   set(findobj('tag',sprintf('Frame%s',label)),'visible','on');
      
   set(findobj('tag','bottNew'),'visible','on');
   set(findobj('tag','bottLoad'),'visible','on');
   set(findobj('tag','BottAna'),'visible','on','enable','on');
   set(findobj('tag','BottSyn'),'visible','on','enable','on');

   set(findobj('tag','file_2'),'enable','on');
   set(findobj('tag','file_3'),'enable','on');
   set(findobj('tag','file_4'),'enable','on');
   set(get(findobj('tag','tools_1'),'children'),'enable','on');
   set(get(findobj('tag','tools_2'),'children'),'enable','on');
   set(get(findobj('tag','tools_6'),'children'),'enable','on');
   
   C=stack.general.C;D=stack.general.D;
   if C==eye(size(C))
     if D==zeros(size(D))
      set(findobj('tag','tools_10'),'enable','off');
     end;
    else set(findobj('tag','tools_10'),'enable','on');
    end;

   set(findobj('tag','file_7'),'enable','on'); 
   set(matrice,'style','text');
   
   switch ind
   case 1, set(gcf,'userdata',[{'A'},{'sy'},{stack.general.A}]);
   case 2, set(gcf,'userdata',[{'B'},{'sy'},{stack.general.B}]);
   case 3, set(gcf,'userdata',[{'C'},{'sy'},{stack.general.C}]);
   case 4, set(gcf,'userdata',[{'D'},{'sy'},{stack.general.D}]);
   end;
   
 end;
 
else
%----parametri inconsistenti   
   messag(gcf,'pi');
end;