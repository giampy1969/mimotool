function ea_3;
%ea_3: funzione per il calcolo del controllore EIG/ASSIGN
%
%
%Massimo Davini revised 17/04/2000

global stack;
watchon;
delete(findobj('tag','inf'));
drawnow;

set(findobj('tag','cle'),'enable','off');
set(findobj('tag','cla'),'enable','off');
set(findobj('tag','BEVAL'),'enable','off');
set(findobj('tag','BSIMU'),'enable','off');
stack.evaluation=[];stack.simulation=[];
stack.general.K_flag=0;

inf=uicontrol('style','text','units','normalized','position',[0.55 0.3 0.4 0.5],...
   'fontunits','normalized','fontsize',.08,'fontweight','bold',...
   'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
   'HorizontalAlignment','left','tag','inf','visible','off',...
   'string','');

%-------------------------------------
A=stack.general.A;
B=stack.general.B;
C=stack.general.C;
D=stack.general.D;

[na,ma]=size(A);
[nb,mb]=size(B);
[nc,mc]=size(C);
rb=rank(B);

va=stack.temp.ach_vet;
num=stack.temp.num_autov;
autoval=stack.temp.a_val;

%  2. Feedback Gain Computation

%  (1) Define transformation matrix  T,
%
[u,ss,v] = svd(B);
pu = u(:,mb+1:na);
T = [B   pu];
at = inv(T)*A*T;
bt = inv(T)*B;
ct = C * T;
vt = inv(T)*va ;

%  (2) Define vz matrix  : vz = desired eigenvalue achivable eigenvector
%
vtm=vt(1:mb,:);         % vtm = the first mb vector of vt ,rb=mb
ii=1;
it=0;
while ii <= num
   if imag(autoval(ii))==0,
      vz(:,ii)=autoval(ii)*vtm(:,ii);  
      ii=ii+1;
   else
      rero =real(autoval(ii));
      imro =imag(autoval(ii));
      vz(:,ii)=rero*vtm(:,ii)-imro*vtm(:,ii+1);
      vz(:,ii+1)=rero*vtm(:,ii+1)+imro*vtm(:,ii);  
      ii=ii+2;
      it=it+1;
   end;
end;


%  (3) Define Feedback Gain
%
q=at(1:mb,:)*vt-vz;
ome=ct*vt;    % dimensiom of ome = nc*mc

% ---> checking rank to check singularity
[nome,mome]=size(ome);
rkome=rank(ome);

[nvt,mvt]=size(vt);
rkvt=rank(vt);

tipo=stack.temp.tipo; %tipo della retroazione
switch tipo
case 1  %full state feedback
   if rkvt < min(nvt,mvt),
     set(inf,'string',sprintf('\nERROR :\nIrrational eigenstructure assignment . Some reachable eigenvalues are linearly dependent .'),...
         'visible','on');
     watchoff;
     return;
   end
   Kfedb=q*pinv(T*vt);
   cla=A-B*Kfedb;   
case 2  %output feedback
   if rkome < min(nome,mome),
     set(inf,'string',sprintf('\nERROR :\nIrrational eigenstructure assignment . Some reachable eigenvalues are linearly dependent .'),...
         'visible','on');
     watchoff;
     return;
   end
   Kfedb=q*pinv(ct*vt);
   cla=A-B*Kfedb*C;
case 3  %constrained output feedback
   Y=0; N=1;
   x=NaN;
   f=stack.temp.constrain;
   for ii=1:mb
      kf=f(ii,:);
      j=find(kf~=0);
      omet=ome(j,:);
      qt=q(ii,:);
      kf=qt*pinv(omet);
      f(ii,j)=kf;
   end;
   Kfedb=f;
   cla=A-B*Kfedb*C;
end;

[clove,clova]=eig(cla);
stack.temp.cla_val=clova;
stack.temp.cla_vet=clove;

if   tipo==1  K=Kfedb*pinv(C-D*Kfedb); %lo converto in output feedback
else K=Kfedb;
end;

if ~isempty(K)
  set(findobj('tag','simu_2'),'enable','on');
  
  [Ak,Bk,Ck,Dk]=unpck(K);
  stack.general.K_flag=1;
  
  %aggiornamento stack per la valutazione 
  stack.evaluation.model=stack.general.model; %nome modello 
  stack.evaluation.kind='eig \ assign';       %tipo del regolatore
  stack.evaluation.K=K;                       %regolatore
  stack.evaluation.plant=pck(A,B,C,D);        %plant
  
  %aggiornamento stack per simulazione  
  stack.simulation.kind='eig \ assign';  %tipo del regolatore 
  switch tipo
  case 1, stack.simulation.fdbk='state';
          stack.simulation.Ksf=Kfedb;
  case 2, stack.simulation.fdbk='output';
  case 3, stack.simulation.fdbk='constrain';
  end;
  stack.simulation.Ak=Ak;           %regolatore
  stack.simulation.Bk=Bk;           %regolatore
  stack.simulation.Ck=Ck;           %regolatore
  stack.simulation.Dk=Dk;           %regolatore
  if rank(stack.general.A)==size(stack.general.A,1)
     G0=stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D;
     stack.simulation.pinvG0=pinv(G0);
  else 
     stack.simulation.pinvG0=zeros(size(stack.general.D'));
  end;
  
  set(findobj('tag','eval_31'),'enable','on');
  set(findobj('tag','file_6'),'enable','on');
  set(findobj('tag','cle'),'enable','on'); 
  set(findobj('tag','cla'),'enable','on');
  set(findobj('tag','BEVAL'),'enable','on');
  set(findobj('tag','BSIMU'),'enable','on');
  drawnow;
  
end;
watchoff;

