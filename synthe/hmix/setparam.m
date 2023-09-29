function setparam(indice)
%SET PARAMETERS : callback dei bottoni check
%
%
%Massimo Davini 01/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
set(gcbo,'foregroundcolor',[0 0 1]);

for i=1:6
   str=sprintf('isempty(stack.temp.new_param.p%u{4,1})',i);
   str1=sprintf('set(findobj(''tag'',''ck%u''),''value'',0,''foregroundcolor'',[0 0 0]);',i);
   if (i~=indice)&eval(str) , eval(str1);end;
end;

delgraf;

handles=stack.temp.handles;
if ~isempty(findobj('tag','para'))
   x=length(handles);
   delete(stack.temp.handles(x-11:x));
   handles(x-11:x)=[];
   stack.temp.handles=handles;   
end;
drawnow;

%------------------------finestra----------------------------------

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext1=.7;

par(1)=uicontrol('style','frame','units','normalized',...
   'backgroundcolor',[1 1 1],'position',[0.39 0.63 0.56 0.32],...
   'tag','para','visible','off');

par(2)=uicontrol('style','text','units','normalized','position',[0.41 0.88 0.25 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
   'foregroundcolor',[1 0 0],'string','Parameters of :','tag','para',...
   'visible','off');

par(3)=uicontrol('style','text','units','normalized','position',[0.67 0.88 0.26 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'HorizontalAlignment','right','tag','para',...
   'visible','off');
   
par(4)=uicontrol('style','text','units','normalized','position',[0.41 0.81 0.41 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
   'tag','para');

par(5)=uicontrol('style','text','units','normalized','position',[0.41 0.74 0.41 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
   'tag','para');

par(6)=uicontrol('style','text','units','normalized','position',[0.41 0.67 0.41 0.06],...
   'fontunits','normalized','fontsize',sizetext1,'fontweight','bold',...
   'backgroundcolor',[1 1 1],'visible','off','HorizontalAlignment','left',...
   'tag','para');

par(7)=uicontrol('style','edit','units','normalized','position',[0.85 0.81 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz*1.5+.3,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'visible','off','string','',...
   'tag','Edit1');

par(8)=uicontrol('style','edit','units','normalized','position',[0.85 0.74 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz*1.5+.3,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'visible','off','string','',...
   'tag','Edit2');
   
par(9)=uicontrol('style','edit','units','normalized','position',[0.85 0.67 0.08 0.06],...
   'fontunits','normalized','fontsize',jsz*1.5+.3,'fontweight','bold',...
   'backgroundcolor',[1 1 0],'visible','off','string','',...
   'tag','Edit3');

par(10)= uicontrol('style','push','unit','normalized','position',[0.81 0.505 0.14 0.08],...
   'fontunits','normalized','fontsize',jsz+.3,'fontweight','bold',...
   'TooltipString','Set and view the subregion',...
   'string','SET','Horizontalalignment','center','tag','para');

par(11)=uicontrol('style','push','unit','normalized','position',[0.81 0.41 0.14 0.08],...
   'fontunits','normalized','fontsize',jsz+.3,'fontweight','bold',...
   'TooltipString','Remove the subregion from the global one',...
   'string','REMOVE','Horizontalalignment','center','tag','para',...
   'enable','off');

par(12)=uicontrol('style','push','unit','normalized','position',[0.81 0.315 0.14 0.08],...
   'fontunits','normalized','fontsize',jsz+.3,'fontweight','bold',...
   'string','CANCEL','Horizontalalignment','center','tag','para',...
   'TooltipString','Close this subregion''s section',...
   'enable','off');

set(par(1:2),'visible','on');

set(par(10),'callback',sprintf('setparam1(%u);',indice));
set(par(11),'callback',sprintf('remparam(%u,''remove'');',indice));
set(par(12),'callback',sprintf('remparam(%u,''cancel'');',indice));


stack.temp.handles=[handles,par];


switch indice
case 1
   %-------------half plane---------------
   set(par(3),'string','Half plane','visible','on');
   set(par(4),'string','Orientation ( -1,1 )','visible','on');
   set(par(5),'string','X0 ( real )','visible','on');
   set(par(7),'string',stack.temp.new_param.p1{1,1},'visible','on');
   set(par(8),'string',stack.temp.new_param.p1{2,1},'visible','on');
   if (~isempty(stack.temp.new_param.p1{1,1}))&(~isempty(stack.temp.new_param.p1{2,1}))
      setparam1(1);
   else set(par(12),'enable','on');end;
   
case 2
   %------------------disk------------------
   set(par(3),'string','Disk','visible','on');
   set(par(4),'string','Center''s absciss','visible','on');
   set(par(5),'string','Radius ( real + )','visible','on');
   set(par(7),'string',stack.temp.new_param.p2{1,1},'visible','on');
   set(par(8),'string',stack.temp.new_param.p2{2,1},'visible','on');
   if (~isempty(stack.temp.new_param.p2{1,1}))&(~isempty(stack.temp.new_param.p2{2,1}))
      setparam1(2);
   else set(par(12),'enable','on');end;

case 3
   %------------conic sector------------------
   set(par(3),'string','Conic sector','visible','on');
   set(par(4),'string','Absciss of sector''s tip','visible','on');
   set(par(5),'string','Inner angle ( deg + )','visible','on');
   set(par(7),'string',stack.temp.new_param.p3{1,1},'visible','on');
   set(par(8),'string',stack.temp.new_param.p3{2,1},'visible','on');
   if (~isempty(stack.temp.new_param.p3{1,1}))&(~isempty(stack.temp.new_param.p3{2,1}))
      setparam1(3);
   else set(par(12),'enable','on');end;
   
case 4
   %----------------ellipsoid-----------------   
   set(par(3),'string','Ellipsoid','visible','on');
   set(par(4),'string','Center''s absciss','visible','on');
   set(par(5),'string','Semi-Orizontal axis','visible','on');
   set(par(6),'string','Semi-Vertical  axis','visible','on');
   set(par(7),'string',stack.temp.new_param.p4{1,1},'visible','on');
   set(par(8),'string',stack.temp.new_param.p4{2,1},'visible','on');
   set(par(9),'string',stack.temp.new_param.p4{3,1},'visible','on');
   
   a=stack.temp.new_param.p4{1,1};
   b=stack.temp.new_param.p4{2,1};
   c=stack.temp.new_param.p4{3,1};
   if (~isempty(a))&(~isempty(b))&(~isempty(c))
      setparam1(4);
   else set(par(12),'enable','on');end;
   
case 5
   %-----------------parabola------------------
   set(par(3),'string','Parabola','visible','on');
   set(par(4),'string','eq. : y^2+P*(x-X0) < 0','visible','on');
   set(par(5),'string','X0 ( real )','visible','on');
   set(par(6),'string','P   ( real + )','visible','on');
   set(par(8),'string',stack.temp.new_param.p5{2,1},'visible','on');
   set(par(9),'string',stack.temp.new_param.p5{3,1},'visible','on');
   if (~isempty(stack.temp.new_param.p5{2,1}))&(~isempty(stack.temp.new_param.p5{3,1}))
      setparam1(5);
   else set(par(12),'enable','on');end;
   
case 6
   %-------------horizontal strip---------------
   set(par(3),'string','Horizontal strip','visible','on');
   set(par(4),'string','equation :   -R < y < R','visible','on');
   set(par(5),'string','R ( real + )','visible','on');
   set(par(8),'string',stack.temp.new_param.p6{2,1},'visible','on');
   if ~isempty(stack.temp.new_param.p6{2,1})
      setparam1(6);
   else set(par(12),'enable','on');end;


end;

