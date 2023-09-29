function lqs_2;

global stack;
delete(findobj('tag','inf'));

stack.simulation=[];
stack.evaluation=[];
stack.general.K_flag=0;

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

ind_x1=find(stack.temp.outsi==1);
ind_x2=find(stack.temp.outs-stack.temp.outsi==1);
ind_x3=find(stack.temp.outs==0);
ind=[ind_x1;ind_x2;ind_x3];
l_x1=length(ind_x1); l_x2=length(ind_x2); l_x3=length(ind_x3);

T=stack.temp.T;
Q=stack.temp.Q;
R=stack.temp.R;
[Atilde,Btilde,Ctilde,Dtilde]=unpck(stack.temp.Ptilde);

try, Ksf=lqr(Atilde,Btilde,Q,R);         %K state feedback
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
            ' the matrices (Q,R) or make a different selection of the',...
            ' outputs that have to be assigned.'];
   elseif err==2
      stringa=[sprintf('ERROR :\n'),...
            'The plant is not stabilizable : make a different',...
            ' selection of the outputs that have to be assigned.'];
   else   
      stringa=[sprintf('ERROR :\n'),...
            'It is not possible to compute the ARE solution : change',...
            ' the matrices (Q,R) or make a different selection of the',...
            ' outputs that have to be assigned.'];
   end;

   inf=uicontrol('style','text',...
       'units','normalized','position',[0.5 0.3 0.45 0.5],...
       'fontunits','normalized','fontsize',0.08,...
       'fontweight','bold',...
       'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
       'HorizontalAlignment','left','tag','inf','string',stringa);

   return;
end;

Ki=Ksf(:,1:l_x1);
K1=Ksf(:,l_x1+1:2*l_x1);
K2=Ksf(:,2*l_x1+1:2*l_x1+l_x2);
K3=Ksf(:,2*l_x1+l_x2+1:2*l_x1+l_x2+l_x3);

Ak=zeros(l_x1,l_x1);
Bk=[eye(l_x1),zeros(l_x1,l_x2+l_x3)]*T;
Ck=Ki;
Dk=[K1 K2 K3]*T;

K=pck(Ak,Bk,Ck,Dk);

if ~isempty(K)
  set(findobj('tag','simu_2'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  stack.general.K_flag=1;

  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='lqs';           %tipo del regolatore 
  stack.evaluation.K=K;                  %regolatore
  stack.evaluation.plant=pck(A,B,C,D);   %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='lqs';  %tipo del regolatore 
  stack.simulation.Ak=Ak;       %regolatore
  stack.simulation.Bk=Bk;       %regolatore
  stack.simulation.Ck=Ck;       %regolatore
  stack.simulation.Dk=Dk;       %regolatore
       %indici delle uscite da assegnare
  stack.simulation.outs=stack.temp.outs;
   
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

