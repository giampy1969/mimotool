function rlocmake(in,out,elimina)
%RLOCUS PLOT window
%
%   rlocmake(in,out,elimina)
%
%  in       = (intero) ingresso
%  out      = (intero) uscita
%  elimina  = (intero) viene settato automaticamente al numero
%              di handle da eliminare da stack{2,2} (contenente
%              gli oggetti creati in questa sezione) e dalla 
%              memoria
%
% Massimo Davini---21/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

handle=stack.temp.handles;
if ~isempty(elimina)
   for i=1:elimina 
      delete(handle(length(handle)));
      handle(length(handle))=[];
   end;
end;

delgraf;
delete(findobj('tag','poli1'));
delete(findobj('tag','poli2'));
delete(findobj('tag','zeri1'));
delete(findobj('tag','zeri2'));
delete(findobj('tag','gain'));
drawnow;

D=stack.general.D;
[no,ni]=size(D);

NUM=stack.general.tfNUM;
DEN=stack.general.tfDEN;

%[z,p,k]=tf2zp(NUM(out+(in-1)*no,:),DEN);
[num,den]=minreal(NUM(out+(in-1)*no,:),DEN);
[z,p,k]=tf2zp(num,den);

if length(p)<21                   %se i poli sono maggiori di 20
                                  %non lui visualizzo
                                  
% enlarge text if java machine is running
jsz=stack.general.javasize;
                                  
textsize=jsz+0.7;
if length(p)>10 lun=10;  else lun=length(p);end; 

   h(1)=uicontrol('style','text','units','normalized','position',[0.66 0.92 0.29 0.05],...
     'backgroundcolor',[.6 .7 .9],'Horizontalalignment','center',...
     'tag','poli1','foregroundcolor','black',...
     'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
     'string',sprintf('Poles : [1..%u] of %u',lun,length(p)));  
  
  for i=1:lun
      h(1+i)=uicontrol('style','text','units','normalized',...
       'position',[0.66 0.85-0.07*(i-1) .29 .05],...
       'Horizontalalignment','center','string',num2str(p(i)),...
       'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
       'backgroundcolor',[1 1 1],'tag','poli1',...
       'TooltipString',num2str(p(i)));
   
   if real(p(i))>0 
       set(h(1+i),'backgroundcolor',[1 1 0]);
    end;
  end;
  

  if length(p)>10
     
   h(12)=uicontrol('backgroundcolor',[.6 .7 .9],'visible','off',...
   'style','text','string',sprintf('Poles : [11..%u] of %u',length(p),length(p)),...
   'Horizontalalignment','center','tag','poli2','foregroundcolor','black',...
   'units','normalized','position',[0.66 0.92 0.29 0.05],...
   'fontunits','normalized','fontsize',textsize,'fontweight','bold');

   for i=11:length(p)
      h(2+i)=uicontrol('visible','off','style','text',...
             'string',num2str(p(i)),'units','normalized',...
             'Horizontalalignment','center','tag','poli2',...
             'position',[0.66 0.85-0.07*(i-11) .29 .05],...
             'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
             'backgroundcolor',[1 1 1],'TooltipString',num2str(p(i)));
    if real(p(i))>0 
       set(h(2+i),'backgroundcolor',[1 1 0]);
    end;
    end;
  end;
end;

plus=length(h);

if length(z)<21             %se gli zeri di trasmissione sono
                            %maggiori di 20 non li visualizzo
  if length(z)>10 lun=10;
  else lun=length(z);end; 
  
  h(plus+1)=uicontrol('backgroundcolor',[.6 .7 .9],'visible','off',...
  'style','text','string',sprintf('Zeros : [1..%u] of %u',lun,length(z)),...
  'Horizontalalignment','center','tag','zeri1','foregroundcolor','black',...
  'units','normalized','position',[0.66 0.92 0.29 0.05],...
  'fontunits','normalized','fontsize',textsize,'fontweight','bold');
  if lun==0 set(h(plus+1),'string','Zeros :');end;
  for i=1:lun
     h(plus+1+i)=uicontrol('visible','off',...
     'style','text','string',num2str(z(i)),'tag','zeri1',...
     'units','normalized','Horizontalalignment','center',...
     'position',[0.66 0.85-0.07*(i-1) .29 .05],'backgroundcolor',[1 1 1],...
     'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
     'TooltipString',num2str(z(i)));
      
     if real(z(i))>0 
        set(h(plus+1+i),'backgroundcolor',[1 1 0]);
     end;
  end;
  
  if length(z)>10
    h(plus+12)=uicontrol('backgroundcolor',[.6 .7 .9],'visible','off',...
    'style','text','string',sprintf('Zeros : [11..%u] of %u',length(z),length(z)),...
    'Horizontalalignment','center','tag','zeri2','foregroundcolor','black',...
    'units','normalized','position',[0.66 0.92 0.29 0.05],...
    'fontunits','normalized','fontsize',textsize,'fontweight','bold');

    for i=11:length(z)
       h(plus+2+i)=uicontrol('visible','off','style','text',...
             'string',num2str(z(i)),'units','normalized',...
             'Horizontalalignment','center','tag','zeri2',...
             'position',[0.66 0.85-0.07*(i-11) .29 .05],...
             'fontunits','normalized','fontsize',textsize,'fontweight','bold',...
             'backgroundcolor',[1 1 1],'TooltipString',num2str(z(i)));
       if real(z(i))>0 
        set(h(plus+i+2),'backgroundcolor',[1 1 0]);
       end;
    end;
  end;
end;

plus=length(h);

h(plus+1)=uicontrol('backgroundcolor',[.6 .7 .9],'foregroundcolor','black',...
  'style','text','string','Gain :','visible','off',...
  'Horizontalalignment','center','tag','gain',...
  'units','normalized','position',[0.66 0.92 0.29 0.05],...
  'fontunits','normalized','fontsize',textsize,'fontweight','bold');

h(plus+2)=uicontrol('visible','off','style','text',...
'string',num2str(k),'units','normalized','tag','gain',...
'Horizontalalignment','center','position',[0.66 0.85 .29 .05],...
'backgroundcolor',[1 1 1],'TooltipString',num2str(k),...
'fontunits','normalized','fontsize',textsize,'fontweight','bold');

if length(p)>=11 set(findobj('tag','P'),'string','P...');
else set(findobj('tag','P'),'string','P');
end;
if length(p)>20  set(findobj('tag','P'),'enable','off');end;

if length(z)<11 set(findobj('tag','Z'),'string','Z');
else set(findobj('tag','Z'),'string','Z...');
end;
if length(z)>20 set(findobj('tag','Z'),'enable','off');end;


stack.temp.handles=[handle,h];

drawnow;

channel=tf(num,den);

if (in==ni)&(out==no) set(findobj('tag','avanti'),'enable','off');
else set(findobj('tag','avanti'),'enable','on');
end;
if (in==1)&(out==1) set(findobj('tag','indietro'),'enable','off');
else set(findobj('tag','indietro'),'enable','on');
end;

ist1=['set(findobj(''tag'',''FZ''),''visible'',''off'');'];
ist2=['set(findobj(''tag'',''FK''),''visible'',''off'');'];
ist3=['set(findobj(''tag'',''FP''),''visible'',''on'');'];

if out==no in_a=in+1;out_a=1;else in_a=in;out_a=out+1;end;
set(findobj('tag','avanti'),'callback',[ist1,ist2,ist3,sprintf('rlocmake(%u,%u,%u);',in_a,out_a,length(h))]);
if out==1 in_i=in-1;out_i=no;else in_i=in;out_i=out-1;end;
set(findobj('tag','indietro'),'callback',[ist1,ist2,ist3,sprintf('rlocmake(%u,%u,%u);',in_i,out_i,length(h))]);

set(gca,'Position',[0.08 0.29 0.5 0.61]);

myrlocus(channel);

set(gca,'tag','grafico');
title(sprintf('ROOT LOCUS : In %u - Out %u',in,out),...
   'color','y','fontsize',9,'fontweight','demi');

crea_pop(1,'crea');
