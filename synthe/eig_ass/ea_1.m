function ea_1
%EA_1 : funzione di creazione della terza finestra EIG/ASS
%
%
% Massimo Davini 07/10/99 revised 17/04/2000

global stack;
KVIN=[];

%tipo di feedback law
if     get(findobj('tag','eaopt1'),'value') tipo=1;  %state-fdb
elseif get(findobj('tag','eaopt2'),'value') tipo=2;  %output-fdb
elseif get(findobj('tag','eaopt3'),'value') tipo=3;  %constrained-fdb
end;

if tipo==3 %controlla la consistenza della matrice dei vincoli
  rows=size(stack.general.B,2);
  columns=size(stack.general.C,1);
  a=findobj('tag','mat');
  for i=1:rows, for j=1:columns
      x=a(length(a));
      n=str2num(get(x,'string'));
      if isempty(n)|(~isnan(n)&(n~=0)) 
         n=NaN; set(x,'string',num2str(NaN)); return;
      end;
      KVIN(i,j)=n;
      a(length(a))=[];
  end; end;
end;
  
num=str2num(get(findobj('tag','ea0_edit'),'string'));
ns=size(stack.general.A,1);
rb=rank(stack.general.B);

stack.temp.tipo=tipo;
stack.temp.constrain=KVIN;
stack.temp.num_autov=num;
stack.temp.cont_autov=1;
stack.temp.a_val=zeros(0,num);
stack.temp.a_vet=zeros(ns,0);
stack.temp.ach_vet=zeros(ns,0);
stack.temp.flag=zeros(1,num);
stack.temp.cla_val=[];
stack.temp.cla_vet=[];

set(stack.temp.handles,'visible','off');
drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext1=jsz/2+.6;

eaa(1)=uicontrol('style','text','units','normalized','position',[.05 .885 .7 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'visible','off',...
   'HorizontalAlignment','left','tag','ea1_str',...
   'string',sprintf('Desired eigenvalue 1 of %u  ( rank(B) = %u )',num,rb));

eaa(2)=uicontrol('style','edit','units','normalized','position',[0.76 0.885 0.19 0.06],...
   'fontunits','normalized','fontsize',jsz/2+.5417,'fontweight','bold',...
   'backgroundcolor','yellow','tag','ea1_edit','visible','off',...
   'HorizontalAlignment','left','string','NaN');

eaa(3)=uicontrol('style','text','units','normalized','position',[.05 .8 .39 0.05],...
   'fontunits','normalized','fontsize',jsz/2+.72,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'visible','off',...
   'HorizontalAlignment','left','tag','ea1',...
   'string','Desired eigenvector :');

eaa(4)=uicontrol('style','text','units','normalized','position',[.56 .8 .39 0.05],...
   'fontunits','normalized','fontsize',jsz/2+.72,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'visible','off',...
   'HorizontalAlignment','left','tag','ea1',...
   'string','Achievable eigenvector :');

eaa(5)=uicontrol('style','text','units','normalized','position',[.05 .75 .18 0.05],...
   'fontunits','normalized','fontsize',jsz/2+sizetext1,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'visible','off',...
   'HorizontalAlignment','left','tag','ea1');

eaa(6)=uicontrol('style','text','units','normalized','position',[.56 .75 .19 0.05],...
   'fontunits','normalized','fontsize',jsz/2+sizetext1,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'visible','off',...
   'HorizontalAlignment','left','tag','ea1');

if ns<10 set(eaa(5:6),'string',sprintf('(entries 1..%u)',ns));
else   
  set(eaa(5:6),'string','(entries 1..9)');
  
  eaa(7)=uicontrol('style','text','units','normalized','position',[.25 .75 .19 0.05],...
     'fontunits','normalized','fontsize',jsz/2+sizetext1,'fontweight','bold',...
     'backgroundcolor',[.6 .7 .9],'visible','off',...
     'HorizontalAlignment','left','tag','ea1');

  eaa(8)=uicontrol('style','text','units','normalized','position',[.76 .75 .19 0.05],...
     'fontunits','normalized','fontsize',jsz/2+sizetext1,'fontweight','bold',...
     'backgroundcolor',[.6 .7 .9],'visible','off',...
     'HorizontalAlignment','left','tag','ea1');
  
  if ns==10 set(eaa(7:8),'string','(entry 10)');
  else set(eaa(7:8),'string',sprintf('(entries 10..%u)',ns));
  end;
end;

for i=1:ns
  if i>9 j=1;else j=0;end;
  ea1_vet(i)=uicontrol('style','edit','units','normalized','position',[0.05+0.2*j 0.68-0.06*(i-1)+j*0.54 0.19 0.05],...
     'fontunits','normalized','fontsize',jsz*0.8+.65,'fontweight','bold',...
     'backgroundcolor','yellow','visible','off','tag',sprintf('ea1_vet_%u',i),...
     'HorizontalAlignment','center','string',num2str(nan));
  
  ea1_ach(i)=uicontrol('style','text','units','normalized','position',[0.56+0.2*j 0.68-0.06*(i-1)+j*0.54 0.19 0.05],...
     'fontunits','normalized','fontsize',jsz*0.8+.65,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'visible','off','tag',sprintf('ea1_ach_%u',i),...
     'HorizontalAlignment','left');
end;

campi=['''constrain'',''tipo'',''num_autov'',''cont_autov'',''a_val'',''a_vet'',''flag'',''ach_vet'',''cla_val'',''cla_vet'''];

ea(1)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','BACK','Horizontalalignment','center','tag','ea1',...
   'TooltipString','Back to the previous window');

if tipo==1|tipo==3 
   cb=sprintf('back_syn(''ea01'',%u,%s);',length(stack.temp.handles),campi);
elseif tipo==2
   cb=sprintf('back_syn(''ea0'',%u,%s);',length(stack.temp.handles),campi);
end;
set(ea(1),'callback',cb);

ea(2)=uicontrol('style','push','unit','normalized','position',[0.2 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','CLOSE','Horizontalalignment','center','tag','ea1',...
   'TooltipString','Back to the main SYNTHESIS window',...
   'callback',sprintf('back_syn(''syn0'',0,%s);',campi));

ea(3)=uicontrol('style','push','unit','normalized','position',[0.4 0.05 0.11 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string',sprintf('SET'),'Horizontalalignment','center','tag','ea1',...
   'TooltipString','Set the values of the eigenvalue\eigenvector pair',...
   'callback','ea_set0;');

ea(4)=uicontrol('style','push','unit','normalized','position',[0.52 0.05 0.11 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','<<','Horizontalalignment','center','tag','ea1<<',...
   'TooltipString','Previous eigenvalue\eigenvector',...
   'enable','off','callback','ea_ffrw(''rw'');');

ea(5)=uicontrol('style','push','unit','normalized','position',[0.64 0.05 0.11 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'string','>>','Horizontalalignment','center','tag','ea1>>',...
   'TooltipString','Next eigenvalue\eigenvector','callback','ea_ffrw(''ff'');');
if num==1 set(ea(5),'enable','off');end; 

ea(6)=uicontrol('style','push','unit','normalized','position',[0.81 0.05 0.14 0.12],...
   'fontunits','normalized','fontsize',.35,'fontweight','bold',...
   'Horizontalalignment','center','string','NEXT','tag','ea1_next',...
   'TooltipString','Go to the next window','callback','ea_2;',...
   'enable','off');

drawnow;
set(eaa,'visible','on');
set(ea1_vet,'visible','on');
set(ea1_ach,'visible','on');

%aggiornamento handles temporanei
stack.temp.handles=[stack.temp.handles,eaa,ea1_vet,ea1_ach,ea];