function visual(matrix,label,azione,forma,dim)
%VISUALIZZA una matrice 
%
%        visual(matrix,label,azione,forma,dim)
%
%
% matrix      = matrice da visualizzare
% label       = nome della matrice
% azione      = serve per determinare se i coefficienti devono
%               essere editabili (azione='edit') o non editabili
%               (parametro azione non presente)
% forma , dim = vengono usate quando questo file è richiamato
%               dalla sezione di analisi e servono per modificare
%               il colore dei coefficienti della matrice 
%               (forma='ctrb','obsv' o 'kalman')
%
%(La dimensione massima delle matrici A B C D inseribili da programma 
%è 10x10 ; è comunque possibile caricare matrici di dimensioni
%maggiori salvate in un file .mat nella directory ..\model\modelli)
%
%Massimo Davini 24/05/99

% modified by giampy march 25 - (lar instead of variable size)

if nargin<4 forma='';dim=[];end;
if nargin<3 forma='';dim=[];azione='';end;
if (nargin==3)&(~strcmp(azione,'edit')) azione='';
end;


delete(findobj('tag','inf'));
delete(findobj('tag','matrice'));
pause(0.05);
set(findobj('tag','file_7'),'enable','on');

[row column]=size(matrix);

if (row > 10)|(column > 10) messag(gcf,'me');
else
   
   if strcmp(azione,'edit') stile='edit';add=.025;
   else stile='text';add=0;
   end;
   
   for i=1:row ,for j=1:column
       if (column>4)
         lar=(0.9-0.02*(column-1))/column;
         pos=[.05+(lar+0.02)*(j-1) .8+add-i*(.06+add*.16) lar .05+.28*add];
       else
         pos=[.05+0.12*(j-1) .8+add-i*(.06+add*.16) .1 .05+.3*add];
       end;
       
       str=num2str(matrix(i,j));
       
       % get java size
       global stack
       jsz=stack.general.javasize;
       
       if strcmp(stile,'edit') sz=3*jsz+.1;else sz=jsz+.6;end;
       
       ed(i,j)=uicontrol('style',stile,'units','normalized',...
         'position',pos,'tag','matrice','string',str,...
         'fontunits','normalized','fontsize',sz,'fontweight','bold',...
         'Horizontalalignment','left','backgroundcolor',[1 1 1]);
      
      if strcmp(stile,'text')
         set(ed(i,j),'TooltipString',sprintf(' %s(%u,%u) = %s ',label,i,j,str));   
      end;
      
   end ,end;

   switch forma
    case {'ctrb','obsv'}
       
       switch label(1)
          case 'A'
          set(ed(1:row-dim,1:row-dim),'foregroundcolor',[.5 .5 .5]);
          set(ed(row-dim+1:row,row-dim+1:column),'foregroundcolor','red');
          case 'B'
          set(ed(1:row-dim,:),'foregroundcolor',[.5 .5 .5]);
          set(ed(row-dim+1:row,:),'foregroundcolor','red');
          case 'C'
          set(ed(:,1:column-dim),'foregroundcolor',[.5 .5 .5]);
          set(ed(:,column-dim+1:column),'foregroundcolor','red');
       end;
       
    case 'kalman'
       switch label(1)
          case 'A'
             gruppo1=ed(1:dim(1),1:dim(1));
             gruppo2=ed(dim(1)+1:dim(1)+dim(2),dim(1)+1:dim(1)+dim(2));
             gruppo3=ed(dim(1)+dim(2)+1:dim(1)+dim(2)+dim(3),dim(1)+dim(2)+1:dim(1)+dim(2)+dim(3));
             gruppo4=ed(dim(1)+dim(2)+dim(3)+1:dim(1)+dim(2)+dim(3)+dim(4),dim(1)+dim(2)+dim(3)+1:dim(1)+dim(2)+dim(3)+dim(4));
          case 'B'   
             gruppo1=ed(1:dim(1),:);
             gruppo2=ed(dim(1)+1:dim(1)+dim(2),:);
             gruppo3=ed(dim(1)+dim(2)+1:dim(1)+dim(2)+dim(3),:);
             gruppo4=ed(dim(1)+dim(2)+dim(3)+1:dim(1)+dim(2)+dim(3)+dim(4),:);
          case 'C'   
             gruppo1=ed(:,1:dim(1));
             gruppo2=ed(:,dim(1)+1:dim(1)+dim(2));
             gruppo3=ed(:,dim(1)+dim(2)+1:dim(1)+dim(2)+dim(3));
             gruppo4=ed(:,dim(1)+dim(2)+dim(3)+1:dim(1)+dim(2)+dim(3)+dim(4));
       end;
          
       set(gruppo1,'foregroundcolor',[0 1 0]);
       set(gruppo2,'foregroundcolor',[1 0 0]);
       set(gruppo3,'foregroundcolor',[0 0 1]);
       set(gruppo4,'foregroundcolor',[1 0 1]);
       
    end;
  
end;

