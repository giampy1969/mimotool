function lqr1
%LQR1 : calcolo del controllore LQR
%
%Callback del bottone "COMPUTE LQR" : calcola il controllore
%ed inizializza i campi stack.evaluation (contenente
%le variabili per la valutazione) e stack.simulation (contenente
%le variabili per la simulazine) con la stringa 'lqr' per indicare
%il tipo di controllore e con la matrice K
%
%
% Massimo Davini 25/05/99 --- revised 31/05/99

global stack;
delete(findobj('tag','inf'));

stack.simulation=[];
stack.evaluation=[];
stack.general.K_flag=0;

A=stack.general.A;
B=stack.general.B;
C=stack.general.C;
D=stack.general.D;

Q=stack.temp.Q;
R=stack.temp.R;

try, Ksf=lqr(A,B,Q,R);         %K state feedback
catch, 
   str=lasterr;
   if findstr(str,'non minimal') err=1;
   elseif findstr(str,'stabilizable') err=2;
   else err=3;
   end;
   if err==1
      stringa=[sprintf('ERROR :\n'),...
            'There are non minimal modes ( or eigenvalues) too close',...
            ' to the imaginary axis in the ARE solution : change',...
            ' the matrices (Q,R).'];
   elseif err==2
      stringa=[sprintf('ERROR :\n'),...
            'The plant is not stabilizable.'];
   else   
      stringa=[sprintf('ERROR :\n'),...
            'It is not possible to compute the ARE solution.'];
   end;

   inf=uicontrol('style','text',...
       'units','normalized','position',[0.5 0.3 0.45 0.5],...
       'fontunits','normalized','fontsize',0.08,...
       'fontweight','bold',...
       'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
       'HorizontalAlignment','left','tag','inf','string',stringa);

   return;
end;

K=Ksf*pinv(C-D*Ksf);      %K output feedback

if ~isempty(K)
  set(findobj('tag','simu_2'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  stack.general.K_flag=1;

  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='lqr';           %tipo del regolatore 
  stack.evaluation.K=K;                  %regolatore
  stack.evaluation.plant=pck(A,B,C,D);   %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='lqr';  %tipo del regolatore 
  stack.simulation.Ak=Ak;       %regolatore
  stack.simulation.Bk=Bk;       %regolatore
  stack.simulation.Ck=Ck;       %regolatore
  stack.simulation.Dk=Dk;       %regolatore
  stack.simulation.fdbk='state';
  stack.simulation.Ksf=Ksf;
  if rank(stack.general.A)==size(stack.general.A,1)
     G0=stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D;
     stack.simulation.pinvG0=pinv(G0);
  else 
     stack.simulation.pinvG0=zeros(size(stack.general.D'));
  end;
  
  set(findobj('tag','eval_31'),'enable','on');
  set(findobj('tag','file_6'),'enable','on');
  set(findobj('tag','BEVAL'),'enable','on');
  set(findobj('tag','BSIMU'),'enable','on');
  drawnow;
  set(gcbo,'visible','off'); 
  
end;

