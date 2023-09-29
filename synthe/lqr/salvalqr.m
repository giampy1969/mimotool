function salvalqr
%SALVA le MATRICI per LQR
%Ricava i parametri per la chiamata della funzione savematrix in base 
%alla matrice visualizzata. 
%
%
% Massimo Davini 25/05/99 revised 31/05/99

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
