function sldopt(selected_index,varargin)
%SLDOPT selected option
%
%   sldopt(selected_index,varargin)
%
%Callback per il settaggio del 'value' di un numero variabile
%di bottoni option :
%
%selected_index = indice (intero) del bottone nella lista di variabili
%                 di ingresso successive.
%varargin       = lista di 'tag' (separata da virgole) dei bottoni 
%                 option 
%
%Massimo Davini 12/05/99

if nargin<2 
   disp(' ');
   disp('Numero di ingressi insufficienti !');return;
end;
if selected_index>length(varargin)
   disp('non esistono bottoni option con l''indice selezionato');return;
end;
for i=1:length(varargin)
   if ~ischar(varargin{i})
      disp('Varargin deve essere una lista di stringhe');return;
   end;
end;

for i=1:length(varargin)
   set(findobj('tag',varargin{i}),'value',0);
end;
set(findobj('tag',varargin{selected_index}),'value',1);


