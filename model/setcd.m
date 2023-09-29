function setcd;

global stack;

set(gcbo,'enable','off');

C=eye(size(stack.general.A));
D=zeros(size(stack.general.A,1),size(stack.general.B,2));

stack.general.C=C;
stack.general.D=D;
stack.general.M_flag=1;
stack.general.model='Untitled.mat';
set(gcf,'Name',sprintf(' MIMO Tool : MODELING Untitled.mat'));

if strcmp(get(findobj('tag','FrameC'),'visible'),'on')
   visual(stack.general.C,'C');
elseif strcmp(get(findobj('tag','FrameD'),'visible'),'on')
   visual(stack.general.D,'D');
end;

stack.evaluation=[];
stack.simulation=[];
stack.temp=[];
set(findobj('tag','file_5'),'enable','off');
set(findobj('tag','file_6'),'enable','off');
set(findobj('tag','eval_1'),'enable','off');
set(findobj('tag','simu_1'),'enable','off');