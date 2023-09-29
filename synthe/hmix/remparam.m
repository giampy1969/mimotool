function remparam(indice,azione)
%REMOVE PARAMETERS : callback dei bottoni REMOVE e CANCEL
%
%      remparam(indice,azione)
%
% indice   = intero che rappresenta l'indice del bottone check scelto
% azione   = stringa che serve distinguere il bottone chiamante
%            ('cancel' o 'remove')
%
%
%Massimo Davini 01/06/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack

handles=stack.temp.handles;
x=length(handles);

if strcmp(azione,'remove')
   delgraf;
   set(findobj('tag','Edit1'),'string','');
   set(findobj('tag','Edit2'),'string','');
   set(findobj('tag','Edit3'),'string','');

   set(gcbo,'enable','off');
   set(handles(x),'enable','on');

   for i=1:4
     eval(sprintf('stack.temp.new_param.p%u{%u,1}=[];',indice,i));
   end;

   region1=stack.temp.new_param.p1{4,1};
   region2=stack.temp.new_param.p2{4,1};
   region3=stack.temp.new_param.p3{4,1};
   region4=stack.temp.new_param.p4{4,1};
   region5=stack.temp.new_param.p5{4,1};
   region6=stack.temp.new_param.p6{4,1};

   new_region=lmireg(region1,region2,region3,region4,region5,region6);
   if isempty(new_region)  stack.temp.region=stack.temp.dfl_region;
   else                    stack.temp.region=new_region;end;
   
elseif strcmp(azione,'cancel')
   if ~isempty(findobj('tag','para'))
     delete(stack.temp.handles(x-11:x));
     handles(x-11:x)=[];
     stack.temp.handles=handles;   
   end;
   str=[sprintf('set(findobj(''tag'',''ck%u'')',indice),...
         ',''value'',0,''foregroundcolor'',[0 0 0],'...
         sprintf('''callback'',''setparam(%u);'');',indice)];
   eval(str);
%  eval(sprintf('set(findobj(''tag'',''ck%u''),''value'',0,''callback'',''setparam(%u);'');',indice,indice));
  
end;
