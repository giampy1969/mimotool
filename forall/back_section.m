function back_section(from,to)
%BACK FROM SECTION from TO SECTION to
%
%      back_section(from,to)
%
%Massimo Davini 13/05/99 --- revised 28/09/99

global stack;

switch from
   
 case 'synthesis'
  delete(findobj('tag','syn0'));
  set(findobj('tag','file_5'),'enable','off');
  set(findobj('tag','file_6'),'enable','off');
  
  for i=2:13,set(findobj('tag',sprintf('synt_%u',i)),'enable','off');end;
  for i=2:6,set(findobj('tag',sprintf('opti_%u',i)),'enable','off');end;
      
 case 'analysis'      
  delete(findobj('tag','ana0'));
  for i=2:54,set(findobj('tag',sprintf('view_%u',i)),'enable','off');end;
  for i=2:16,set(findobj('tag',sprintf('anal_%u',i)),'enable','off');end;

end;

drawnow;

switch to
    
 case 'modeling' 
  stack.general=rmfield(stack.general,'tfNUM');
  stack.general=rmfield(stack.general,'tfDEN');

  %-----------------------------------------------------------
  %abilitazione e disabilitazione comandi della barra dei menù
   set(findobj('tag','tools_1'),'enable','on');
   set(findobj('tag','view_1'),'enable','off');
   set(findobj('tag','anal_1'),'enable','off');
   set(findobj('tag','synt_1'),'enable','off');
   set(findobj('tag','opti_1'),'enable','off');
   set(findobj('tag','eval_1'),'enable','off');
   set(findobj('tag','simu_1'),'enable','off');
  %-----------------------------------------------------------
  delete(findobj('tag','cascade'));drawnow;

      
  set(findobj('tag','file_2'),'enable','on');
  set(findobj('tag','file_3'),'enable','on');
  set(findobj('tag','file_5'),'enable','on');
  for i=1:9,set(findobj('tag',sprintf('tools_%u',i)),'enable','on');end;
  
  C=stack.general.C;D=stack.general.D;
  if C==eye(size(C))
    if D==zeros(size(D))
      set(findobj('tag','tools_10'),'enable','off');
    end;
  else set(findobj('tag','tools_10'),'enable','on');
  end;

  set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s',stack.general.model));

  set(findobj('tag','bottA'),'visible','on');
  set(findobj('tag','bottB'),'visible','on');
  set(findobj('tag','bottC'),'visible','on');
  set(findobj('tag','bottD'),'visible','on');
  set(findobj('tag','bottNew'),'visible','on');
  set(findobj('tag','bottLoad'),'visible','on');
  set(findobj('tag','BottAna'),'visible','on');
  set(findobj('tag','BottSyn'),'visible','on');
      
case 'analysis' 

   set(gcf,'Name',sprintf(' MIMO Tool : ANALYSIS %s',stack.general.model));
   set(findobj('tag','ana0'),'visible','on');
   
  %-----------------------------------------------------------
  %abilitazione e disabilitazione comandi della barra dei menù
   set(findobj('tag','tools_1'),'enable','off');
   set(findobj('tag','view_1'),'enable','on');
   set(findobj('tag','anal_1'),'enable','on');
   set(findobj('tag','synt_1'),'enable','off');
   set(findobj('tag','opti_1'),'enable','off');
   set(findobj('tag','eval_1'),'enable','off');
   set(findobj('tag','simu_1'),'enable','off');
  %-----------------------------------------------------------
  
  for i=1:10,set(findobj('tag',sprintf('view_%u',i)),'enable','on');end;
   
  A=stack.general.A;B=stack.general.B;
  C=stack.general.C;D=stack.general.D;
  
  [ns,ns]=size(A);[no,ni]=size(D);
  %la forma compagna esiste se è controllabile con il 1° ingresso
  if rank(ctrb(A,B(:,1)))<ns , set(findobj('tag','view_6'),'enable','off'); end;

  %il calcolo della forma di jordan è affidabile se max(ns)=7
  if ns>8 set(findobj('tag','view_7'),'enable','off');end;
   
  %per la forma di Brunowsky Tx (vedi stdc.m) deve essere quadrata
  G=pck(A,B,C,D); [K Kf P ro Tx]=stdc(G,0); [rig col]=size(Tx);
  if rig~=col set(findobj('tag','view_10'),'enable','off');end;
   
  for i=1:54,set(findobj('tag',sprintf('anal_%u',i)),'enable','on');end;
   
  %per limitazioni grafiche,relative degree è disabilitato se ni>12
  if ni>12 set(findobj('tag','anal_11'),'enable','off');end;
      
end;

