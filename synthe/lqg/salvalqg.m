function salvalqg
%SALVA le MATRICI per LQG
%Ricava i parametri per la chiamata della funzione savematrix in base 
%alla matrice visualizzata. 
%
%
% Massimo Davini 25/05/99 revised 31/05/99

global stack
delete(findobj('tag','inf'));

if strcmp(get(findobj('tag','FQ'),'visible'),'on')
   Q=stack.temp.Q;
   funzione=sprintf('savematrix(%u,%u,''Q'',''flagQ'',''flagR'',''flagW'',''flagV'')',size(Q,1),size(Q,2));
elseif strcmp(get(findobj('tag','FR'),'visible'),'on')
   R=stack.temp.R;
   funzione=sprintf('savematrix(%u,%u,''R'',''flagQ'',''flagR'',''flagW'',''flagV'')',size(R,1),size(R,2));
elseif strcmp(get(findobj('tag','FW'),'visible'),'on')
   W=stack.temp.W;
   funzione=sprintf('savematrix(%u,%u,''W'',''flagQ'',''flagR'',''flagW'',''flagV'')',size(W,1),size(W,2));
elseif strcmp(get(findobj('tag','FV'),'visible'),'on')
   V=stack.temp.V;
   funzione=sprintf('savematrix(%u,%u,''V'',''flagQ'',''flagR'',''flagW'',''flagV'')',size(V,1),size(V,2));
end;

eval(funzione);
