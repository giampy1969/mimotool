function pzmaps
%POLES AND ZEROS's window
%
%
% Massimo Davini 15/05/99 --- revised 28/09/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

% enlarge text if java machine is running
jsz=stack.general.javasize;

%---------------------inizializzazione--------------------------
delgraf;
delete(findobj('tag','matrice'));
set(findobj('tag','ana0'),'visible','off');
set(findobj('tag','file_7'),'enable','off');

if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
   delete(stack.temp.handles);
end;
stack.temp=[];
drawnow;
stack.temp.handles=[];
%---------------------------------------------------------------

set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s --> Poles and Zeros',stack.general.model));

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

p=eig(A);
z=tzero(A,B,C,D);

pz(1)=uicontrol('style','text','units','normalized','position',[0.69 0.92 0.26 0.05],...
   'fontunits','normalized','fontsize',jsz+0.7,'fontweight','bold',...
   'backgroundcolor',[0.8 0.8 0.8],'Horizontalalignment','left',...
   'TooltipString','Total number of system''s poles','tag','TestoP',...   
   'string',sprintf(' # of poles :  %u',length(p)));

if length(p)<17   %se length(p)>16 non li visualizzo
   
   if length(p)>8 lun=8; else lun=length(p); end; 
   
   for i=1:lun
      pz(1+i)=uicontrol('style','text','units','normalized',...
          'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
          'position',[0.69 0.85-0.07*(i-1) .26 .05],...
          'visible','off','backgroundcolor',[1 1 1],'tag','poli1',...
          'TooltipString',sprintf(' P(%u) = %s ',i,num2str(p(i))),...   
          'Horizontalalignment','center','string',num2str(p(i)));
     if real(p(i))>0 
       set(pz(1+i),'backgroundcolor',[1 1 0]);
     end;
   end;
   set(pz(2:length(pz)),'visible','on');

   if length(p)>8
     for i=9:length(p)
       pz(1+i)=uicontrol('style','text','units','normalized',...
          'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
          'position',[0.69 0.85-0.07*(i-9) .26 .05],...
          'visible','off','backgroundcolor',[1 1 1],'tag','poli2',...
          'TooltipString',sprintf(' P(%u) = %s ',i,num2str(p(i))),...   
          'Horizontalalignment','center','string',num2str(p(i)));
       if real(p(i))>0 
           set(pz(1+i),'backgroundcolor',[1 1 0]);
       end;
     end;
   end;

end;

x=length(pz);
pz(x+1)=uicontrol('style','text','units','normalized',...
   'fontunits','normalized','fontsize',jsz+0.7,'fontweight','bold',...
   'position',[0.69 0.92 0.26 0.05],...
   'backgroundcolor',[0.8 0.8 0.8],'Visible','off',...
   'Horizontalalignment','left','tag','zeri',...
   'TooltipString','Total number of system''s zeros',...   
   'string',sprintf(' # of zeros :  %u',length(z)));

if length(z)<9      %se length(z)>=9 non li visualizzo

   for i=1:length(z)
      pz(x+1+i)=uicontrol('style','text','units','normalized',...
         'fontunits','normalized','fontsize',jsz+0.6,'fontweight','bold',...
         'string',num2str(z(i)),'Visible','off','tag','zeri',...
         'Horizontalalignment','center','backgroundcolor',[1 1 1],...
         'TooltipString',sprintf(' Z(%u) = %s ',i,num2str(z(i))),...   
         'position',[0.69 0.85-0.07*(i-1) .26 .05]);
      if real(z(i))>0 
         set(pz(x+1+i),'backgroundcolor',[1 1 0]);
      end;
   end;

end;

x=length(pz);
pz(x+1)=uicontrol('style','frame','units','normalized',...
   'Visible','on','backgroundcolor',[1 1 1],'tag','FP',...
   'position',[0.68 0.215 0.139 0.11]);

pz(x+2)=uicontrol('style','push','unit','normalized',...
   'fontunits','normalized','fontsize',0.4+jsz/2,'fontweight','bold',...
   'position',[0.69 0.23 0.12 0.08],...
   'Horizontalalignment','center','tag','pzmaps');

if length(p)<9
     set(pz(x+2),'string','POLES','callback','pzvalue(''poli1'');');
else set(pz(x+2),'string','POLES..','callback','pzvalue(''poli2'');');
end;

if length(p)>16 set(pz(x+2),'enable','off');end;

pz(x+3)=uicontrol('backgroundcolor',[1 1 1],'style','frame','tag','zeri',...
    'Visible','off','units','normalized','position',[0.82 0.215 0.139 0.11]);

pz(x+4) = uicontrol('style','push','unit','normalized','position',[0.83 0.23 0.12 0.08],...
   'fontunits','normalized','fontsize',0.4+jsz/2,'fontweight','bold',...
   'string','TZEROS','Horizontalalignment','center',...
   'callback','pzvalue(''zeri'');','tag','pzmaps');

if (length(z)==0)|(length(z)>8) set(pz(x+4),'Enable','off');end;

pz(x+5)=uicontrol('backgroundcolor',[1 1 1],'style','frame','tag','pzmaps',...
   'units','normalized','position',[0.05 0.22 0.58 0.1]);

pz(x+6)=uicontrol('backgroundcolor',[1 1 1],'style','text',...
   'fontunits','normalized','fontsize',jsz+0.7,'fontweight','bold',...
   'string',sprintf('MAX { Real( EIG ) } : %u',max(real(spoles(pck(A,B,C,D))))),...
   'units','normalized','position',[0.06 0.245 0.56 0.05],...
   'foregroundcolor','red','tag','pzmaps');

pz(x+7)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center',...
   'TooltipString','Back to the main ANALYSIS window','tag','pzmaps');

callb=sprintf('back_ana(''ana0'',%u);',length(stack.temp.handles));
set(pz(x+7),'callback',callb);


pz(x+8) = uicontrol('style','push','unit','normalized','position',[0.42 0.05 0.25 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','EigenStructure','Horizontalalignment','center',...
   'TooltipString','Go to the POLES ANALYSIS window','tag','pzmaps',...
   'callback','polesana;');

pz(x+9) = uicontrol('style','push','unit','normalized','position',[0.69 0.05 0.26 0.12],...
   'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
   'string','ZEROS Analysis','tag','pzmaps',...
   'TooltipString','Go to the ZEROS ANALYSIS window',...
   'Horizontalalignment','center','callback','zerosana;');

if (length(z)==0) set(pz(x+9),'Enable','off');end;

stack.temp.handles=pz;

drawnow

set(gca,'Position',[0.1 0.45 0.49 0.45]);
mypzmap(A,B,C,D);
title('       PZMAP ( Open Loop System )',...
   'fontweight','demi','color','y','fontsize',9);

set(gca,'tag','grafico');
xlabel('');ylabel('');
crea_pop(1,'crea');

