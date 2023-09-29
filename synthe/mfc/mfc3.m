function mfc3(tipo)
%MFC3 :calcolo del controllore EMFC o IMFC 
%ed inizializzazzione dei campi stack.evaluation (contenente
%le variabili per la valutazione) e stack.simulation (contenente
%le variabili per la simulazine) con la stringa 'imfc' o 'emfc'
%per indicare il tipo di controllore e con la matrice K
%
%
%Massimo Davini 26/05/99 --- revised 31/05/99

global stack;
stack.simulation=[];
stack.evaluation=[];
stack.general.K_flag=0;

A=stack.general.A;
B=stack.general.B;
C=stack.general.C;
D=stack.general.D;
plant=pck(A,B,C,D);
[ty,no,ni,ns]=minfo(plant);

Q=stack.temp.Q;
R=stack.temp.R;

M=stack.temp.modello;   %model
[Am,Bm,Cm,Dm]=unpck(M);


if strcmp(tipo,'EMFC')       %CONTROLLORE EMFC

     %costruzione di un sistema aumentato costituito 
     %dal sistema e dal modello;

     Atilde=daug(A,Am);
     Btilde=[B;zeros(size(Am,1),size(B,2))];   
                 %matrice B del sistema aumentato
                 %consideriamo solo gli ingressi del sistema
                 %e non quelli del modello,che non sono disponibili
     Ctilde=daug(C,Cm);
     Dtilde=[D;zeros(size(Cm,1),size(B,2))];

     %l'indice di costo da minimizzare è dato da :
     %       J=integral( (y-ym)'Q(y-ym) +u'Ru )dt
     %con y uscite del sistema con gli integratori e ym uscite del modello.
     %Dalle equazioni di uscita otteniamo ( I SISTEMI DEVONO ESSERE PROPRI , CON D=0 ) :
     %        J=integral( x'[Caug - Cm]'Q [Caug - Cm] x +u'Ru )dt
     %con x =[ x stati del sistema,xm stati delmodello]'.
     
     %legge di controllo per l'inseguimento:
     %U=(U*)+kfb*(X*)+kff*(Xm*)-kfb*X-kff*Xm
     
     CC=[C -Cm];
     Qtilde=CC'*Q*CC;

     %state feedback degli stati (sistema + modello)
     kk=lqr(Atilde,Btilde,Qtilde,R);

     %state feedback del sistema
     Kfb=kk(:,1:size(A,1));

     %state feedback del modello
     Kff=kk(:,size(A,1)+1:size(kk,2));
     
     %output feedback del sistema
     K=Kfb*pinv(C-D*Kfb);         %controllore per la valutazione

elseif strcmp(tipo,'IMFC')     %CONTROLLORE IMFC

     %l'indice di costo da minimizzare è dato da :
     %    J=integral( (dy/dt-dym/dt)'Q(dy/dt-dym/dt) +u'Ru )dt
     %con y uscite del sistema con gli integratori e ym uscite del modello
     %e dym/dt=Am*ym ( Cm=I => xm=ym ).
     %Dalle equazioni otteniamo ( I SISTEMI DEVONO ESSERE PROPRI , CON D=0 ) :
     %    J=integral( x'*Qi*x + 2*x'*Si*u + u'*Ri*u )dt
     %con Qi,Si e Ri indicate sotto 

     %legge di controllo per l'inseguimento:
     %U=(U*)+kfb*(X*)-kfb*X
     
     T=C*A-Am*C;
     Qi=T'*Q*T;
     Si=B'*C'*Q*T;
     Ri=R+B'*C'*Q*C*B;
     
     %state feedback del sistema
     Kfb=lqr(A,B,Qi,Ri,Si');

     %output feedback del sistema
     K=Kfb*pinv(C-D*Kfb);         %controllore per la valutazione

end;


if ~isempty(K)
  set(findobj('tag','eval_31'),'enable','on');
  set(findobj('tag','simu_2'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  
  stack.general.K_flag=1;
  
  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind=lower(tipo);       %tipo del regolatore 
  stack.evaluation.K=K;                    %regolatore
  stack.evaluation.plant=plant;            %plant

  %aggiornamento stack per simulazione  
  stack.simulation.kind=lower(tipo);  %tipo del regolatore 
  stack.simulation.Ak=Ak;             %regolatore
  stack.simulation.Bk=Bk;             %regolatore
  stack.simulation.Ck=Ck;             %regolatore
  stack.simulation.Dk=Dk;             %regolatore
  stack.simulation.Am=Am;             %modello
  stack.simulation.Bm=Bm;             %modello
  stack.simulation.Cm=Cm;             %modello
  stack.simulation.Dm=Dm;             %modello
  if strcmp(tipo,'EMFC')
     stack.simulation.Kfb=Kfb;
     stack.simulation.Kff=Kff;
     Gm0=Cm*inv(-Am)*Bm+Dm;
     stack.simulation.Kpf0=Kff*inv(Am)*Bm*Gm0;   
  elseif strcmp(tipo,'IMFC')
     stack.simulation.Kfb=Kfb;
  end;
  
  set(findobj('tag','file_6'),'enable','on');
  set(findobj('tag','BEVAL'),'enable','on');
  set(findobj('tag','BSIMU'),'enable','on');
  drawnow;
  set(gcbo,'visible','off'); 
  
end;

