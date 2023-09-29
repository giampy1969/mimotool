function ea_ffrw(dir);
%EA_FFRW : callback dei bottoni << e >> in EIG\ASSIGN
%
%           ea_ffrw(dir)
%
%  dir = 'ff' callback di >>
%  dir = 'rw' callback di <<
%
% Massimo Davini 12/10/99 --- revised 21/10/99

global stack;
if nargin<1 dir='ff';end;

switch dir
case 'ff' ,stack.temp.cont_autov=stack.temp.cont_autov+1;
case 'rw' ,stack.temp.cont_autov=stack.temp.cont_autov-1;
end;

flag=stack.temp.flag;
ns=size(stack.general.A,1);
rb=rank(stack.general.B);
num=stack.temp.num_autov;
corrente=stack.temp.cont_autov;

set(findobj('tag','ea1_str'),'string',sprintf('Desired eigenvalue %u of %u  ( rank(B) = %u )',corrente,num,rb));

if flag(corrente)
   
  set(findobj('tag','ea1_edit'),'string',num2str(stack.temp.a_val(corrente)),...
      'enable','on');

  desvet=stack.temp.a_vet(:,corrente);
  achvet=stack.temp.ach_vet(:,corrente);
  for i=1:ns
     x=desvet(i);
     y=achvet(i);
     set(findobj('tag',sprintf('ea1_vet_%u',i)),...
        'string',num2str(x),'enable','on');
     if isnan(y) , set(findobj('tag',sprintf('ea1_ach_%u',i)),'string','');
     else set(findobj('tag',sprintf('ea1_ach_%u',i)),'string',num2str(y));
     end;
     set(findobj('tag',sprintf('ea1_ach_%u',i)),...
        'TooltipString',sprintf('Va(%u) = %u',i,stack.temp.ach_vet(i,corrente)));
  end;
  
  if (strcmp(dir,'ff')&(~isreal(stack.temp.a_val(:,corrente)))&...
     (stack.temp.a_val(:,corrente)==conj(stack.temp.a_val(:,corrente-1))))|...
     (strcmp(dir,'rw')&(corrente>1)&(~isreal(stack.temp.a_val(:,corrente)))&...
     (stack.temp.a_val(:,corrente)==conj(stack.temp.a_val(:,corrente-1))))
  
     set(findobj('tag','ea1_edit'),'enable','off');
  end;   
  
else
   
  set(findobj('tag','ea1_edit'),'string','NaN','enable','on');
  for i=1:ns
    set(findobj('tag',sprintf('ea1_vet_%u',i)),'string','NaN','enable','on');
    set(findobj('tag',sprintf('ea1_ach_%u',i)),'string','');
  end;
  
end;

if corrente==num set(findobj('tag','ea1>>'),'enable','off');
else set(findobj('tag','ea1>>'),'enable','on');end;

if corrente==1 set(findobj('tag','ea1<<'),'enable','off');
else set(findobj('tag','ea1<<'),'enable','on');end;

