function lqg1
%LQG1 : calcolo del controllore LQG
%
%Callback del bottone "COMPUTE LQG" : calcola il controllore
%ed inizializza i campi stack.evaluation (contenente
%le variabili per la valutazione) e stack.simulation (contenente
%le variabili per la simulazine) con la stringa 'lqg' per indicare
%il tipo di controllore e con la matrice K
%
%
% Massimo Davini 26/05/99 --- revised 31/05/99

global stack;
stack.evaluation=[];stack.simulation=[];
stack.general.K_flag=0;

delete(findobj('tag','inf'));
drawnow;

inf=uicontrol('style','text','units','normalized','position',[0.57 0.3 0.38 0.5],...
   'fontunits','normalized','fontsize',0.08,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
   'HorizontalAlignment','left','tag','inf','visible','off',...
   'string','ERROR : ( A,B ) may be uncontrollable or no solution exist for the corresponding Algebraic Riccati Equation !');


G=stack.temp.plant;                %original plant
P=stack.temp.augmplant;            %augmented plant (with integrators)
n=stack.temp.integratori;          %integrators added 
Q=stack.temp.Q;
R=stack.temp.R;
W=stack.temp.W;
V=stack.temp.V;

[ty,no,ni,ns]=minfo(G);
try,
   [A,B1,B2,C1,C2,D11,D12,D21,D22]=hinfpar(P,[no,ni]);
   [Ak,Bk,Ck,Dk]=reg(A,B2,C2,D22, lqr2(A,B2,Q,R) , lqe2(A,eye(size(A)),C2,W,V) );
   K=pck(Ak,Bk,Ck,Dk);
catch,
   set(findobj('tag','inf'),'visible','on');
   return;
end;

   
%se sono stati aggiunti degli integratori al sistema e se K
%esiste, allora bisogna aggiungere gli integratori al controllore
%riconsiderando il sistema originale

if n>0
   if size(K,1)*size(K,2)>0             
      %input and output integrators block
      nm=min(no,ni);
      Ibs=pck(zeros(nm),eye(nm),eye(nm),zeros(nm));
      if ni<no Ibi=Ibs;Ibo=eye(no);
      else Ibi=eye(ni);Ibo=Ibs;
      end;
      %controller with integrators
      for k=1:n
         K=mmult(Ibi,K,Ibo);
      end;
    end;
end;

if ~isempty(K)
  set(findobj('tag','eval_31'),'enable','on');
  set(findobj('tag','simu_2'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  stack.general.K_flag=1;
  
  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='lqg';      %tipo del regolatore 
  stack.evaluation.K=K;             %regolatore
  stack.evaluation.plant=G;         %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='lqg';  %tipo del regolatore 
  stack.simulation.Ak=Ak;       %regolatore
  stack.simulation.Bk=Bk;       %regolatore
  stack.simulation.Ck=Ck;       %regolatore
  stack.simulation.Dk=Dk;       %regolatore
  if rank(stack.general.A)==size(stack.general.A,1)
     G0=stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D;
     stack.simulation.pinvG0=pinv(G0);
  else 
     stack.simulation.pinvG0=zeros(size(stack.general.D'));
  end;
  

  set(findobj('tag','file_6'),'enable','on');
  set(findobj('tag','BEVAL'),'enable','on');
  set(findobj('tag','BSIMU'),'enable','on');
  drawnow;
  set(gcbo,'visible','off'); 
  
end;
