function pid3;
%Massimo Davini 08/11/99

watchon;
global stack;
stack.evaluation=[];stack.simulation=[];
stack.general.K_flag=0;

drawnow;

G=stack.temp.plant;                %original plant
P=stack.temp.augmplant;            %augmented plant (with integrators)
n=stack.temp.integratori;          %integrators added 
nm=stack.temp.canali;              %numero di canali controllati

[taug,noaug,niaug,nsaug]=minfo(P);

diagonale=[];
for j=1:nm diagonale=daug(diagonale,stack.temp.controllo{j});end;

[ac bc cc dc]=unpck(diagonale);
if size(cc,1)<niaug
   cc=[cc;zeros(niaug-size(cc,1),size(cc,2))];
   dc=[dc;zeros(niaug-size(dc,1),size(dc,2))];   
end;
if size(bc,2)<noaug
   bc=[bc zeros(size(bc,1),noaug-size(bc,2))];
   dc=[dc zeros(size(dc,1),noaug-size(dc,2))];   
end;

K=pck(ac,bc,cc,dc);

%se sono stati aggiunti degli integratori al sistema e se K
%esiste, allora bisogna aggiungere gli integratori al controllore
%riconsiderando il sistema originale

[ty,no,ni,ns]=minfo(G);   %original plant
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
  stack.evaluation.kind='pid';      %tipo del regolatore 
  stack.evaluation.K=K;             %regolatore
  stack.evaluation.plant=G;         %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='pid';  %tipo del regolatore 
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
  
end;
watchoff;