function salvalqs
%SALVA le MATRICI per LQ-SERVO
%Ricava i parametri per la chiamata della funzione savematrix in base 
%alla matrice visualizzata. 
%
%
% Massimo Davini 19/04/2000

global stack
delete(findobj('tag','inf'));

if strcmp(get(findobj('tag','FQ'),'visible'),'on')
   Q=stack.temp.Q;
   funzione=sprintf('savematrix(%u,%u,''Q'',''flagQ'',''flagR'')',size(Q,1),size(Q,2));
   eval(funzione);
end;
if strcmp(get(findobj('tag','FR'),'visible'),'on')
   R=stack.temp.R;
   funzione=sprintf('savematrix(%u,%u,''R'',''flagQ'',''flagR'')',size(R,1),size(R,2));
   eval(funzione);
end;
