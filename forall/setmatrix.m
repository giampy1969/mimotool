function setmatrix(matrix,label)
%SET MATRIX : visualizzazione matrici nella fase di sintesi
%
%      setmatrix(matrix,label)
%
% matrix = matrice che deve essere visualizzata
%          (l'utilizzo di questa funzione è relativo alle
%           matrici di peso all'interno delle sintesi di
%           controllori LQR,LQG,IMFC e EMFC)
% label  = (char) indica il nome della matrice
%
% (se la dimensione della matrice è superiore alle dimensioni 
% limite per la sua visualizzazione all'interno della finestra
% viene data la possibilità di fissare il coefficiente presente
% sulla diagonale)
%
%
% Massimo Davini 25/05/99 revised 17/04/2000

if nargin<2 label='';end;
delete(findobj('tag','matrice'));
drawnow;

delete(findobj('tag','inf'));

[row column]=size(matrix);

% enlarge text if java machine is running
global stack
jsz=stack.general.javasize;

if (row > 10)|(column > 10) 
   ed(1,1)=uicontrol('style','frame','units','normalized',...
       'position',[.15 .7 .7 .08],'backgroundcolor',[1 1 1],...
       'visible','off','tag','matrice');

   ed(1,2)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
       'Horizontalalignment','center','foregroundcolor',[1 0 0],...
       'backgroundcolor',[1 1 1],'position',[.16 .71 .68 .06],...
       'string',sprintf('The matrix %s exceeds the dimensions of the window',label),...
       'visible','off','tag','matrice');
    
   ed(1,3)=uicontrol('style','frame','units','normalized',...
       'backgroundcolor',[1 1 1],'Horizontalalignment','center',...
       'position',[.15 .27 .7 .37],'visible','off','tag','matrice');

  ed(1,4)=uicontrol('style','Text','units','normalized',...
       'fontunits','normalized','fontsize',2*jsz+.2,'fontweight','bold',...
       'Horizontalalignment','left','backgroundcolor',[1 1 1],...
       'position',[.18 .4 0.64 .2],...  
       'string',sprintf('The actual matrix %s is %u*eye(%u,%u) .\nYou can choose T such that the new value will be T*eye(%u,%u) .',label,matrix(1,1),row,column,row,column),...
       'visible','off','tag','matrice');

  ed(1,5)=uicontrol('style','Text','units','normalized',...
       'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
       'Horizontalalignment','left','backgroundcolor',[1 1 1],...
       'string','T =','position',[.18 .32 0.1 .06],...
       'visible','off','tag','matrice');

  ed(1,6)=uicontrol('style','edit','units','normalized',...
       'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
       'backgroundcolor',[1 1 0],'position',[0.265 0.32 0.09 0.06],...
       'string',num2str(matrix(1,1)),...
       'visible','off','tag','matrice');
    
  set(ed,'visible','on');

else
   
   for i=1:row ,for j=1:column
     if (column>4)
         larg=(0.9-0.02*(column-1))/column;
         pos=[.05+(larg+0.02)*(j-1) .8-i*.06 larg .06];
     else
         pos=[.05+0.12*(j-1) .8-i*.06 .1 .06];
     end;
       
     str=num2str(matrix(i,j));
     ed(i,j)=uicontrol('style','edit','units','normalized',...
         'position',pos,'tag','matrice','string',str,...
         'fontunits','normalized','fontsize',jsz+.5,'fontweight','bold',...
         'Horizontalalignment','left','backgroundcolor',[1 1 1]);
   end ,end;

end;

