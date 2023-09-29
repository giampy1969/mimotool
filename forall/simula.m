function simula
%SIMULA : crezione del modello per la simulazione
%
%Crea il modello simulink Closed_Loop_system copiando i blocchi
%dalla libreria mvt_blocks e dai modelli general_mod e mfc_mod
%a seconda del tipo di controllo.
%
%Nel caso di controllo emfc o imfc viene calcolato il SET POINT
%(funzione "setpoint.m") e le variabili necessarie alla simulaxione
%vengono memorizzate in stack.simulation.
%
%Dopo che il modello è stato creato,tutte le variabili necessarie alla
%simulazione sono presenti in stack.simulation
%
%
% Massimo Davini 08/06/99 revised 31/05/00

global stack;
%la libreria dei blocchi commands per le simulazioni prevede 
%un numero massimo di uscite del sistema (e quindi di comandi di
%riferimento) pari a 15
if size(stack.general.C,1)>15   
   messag(gcf,'snp');
   return;
end;

tipo=stack.simulation.kind;


%se il modello è attualmente aperto,viene chiuso 
if ~isempty(find_system('name','Closed_Loop_System'))
  close_system('Closed_Loop_System',0);
end;

switch tipo
case {'imfc','emfc'}, mfc_mod;    %schema per imfc/emfc con modello+setpoint
case {'eig \ assign','lqr'}
   plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   sp=setpoint(plant); %sp=0 --> setpoint statico
                       %sp=1 --> setpoint quasi statico
   A=stack.general.A;
   D=stack.general.D;
   if rank(A)==size(A,1) &...
         ( isempty(find(D~=0) )|( ~isempty(find(D~=0)) & sp==0 ))
        %possiamo utilizzare lo schema simulink con set point se:
        %1) la marice A è invertibile
        %2a) se D=0 è possibile calcolare entrambi i tipi di set point
        %2b) se D~=0 NON E' POSSIBILE calcolare il set point quasi statico
        general_sp;       %schema con il blocco del setpoint
        issetp=1;
   else general_mod;      %schema generale senza il blocco del setpoint     
        issetp=0;
   end;
otherwise,      general_mod;      %modello generale
end;
sys=bdroot;
%-------------------------------------------------------------------
%se è stato precedentemente salvato un modello "Closed_Loop_System",
%esso viene eliminato senza richiesta di conferma
[filepath]=which('Closed_Loop_System.mdl','file','-all');
if ~isempty(filepath)  delete(sprintf('%s',filepath)); end;

%-----------------------------------------
%posizionamento iniziale della finestra del modello

screensize=get(0,'screensize');
locazione=get(gcf,'position');

loc(1)=(locazione(1)+locazione(3)*0.015)*screensize(3);
loc(2)=(locazione(2)+locazione(4)*0.15)*screensize(4);
loc(3)=(locazione(3)*0.98+locazione(1))*screensize(3);
loc(4)=(locazione(2)+locazione(4)*.97)*screensize(4);
new_loc=loc;

set_param(sys,'Name','Closed_Loop_System')
set_param(bdroot,'zoomfactor','FitSystem');

%-----------------------------------------
[no,ni]=size(stack.general.D); 
sys=bdroot;

open_system('mvt_blocks');       %libreria 

%----------subsystem OUTPUTS -------------
sub_out=sprintf('out%u',no);
replace_block(sys,'name','outputs',['mvt_blocks/',sub_out],'noprompt');
set_param([sys,'/','outputs'],'LinkStatus', 'none','Mask Display','OUTPUTS')
set_param([sys,'/','outputs'],'hide name','off','Drop Shadow',4)

%----------subsystem COMMANDS -------------
sub_comm=sprintf('in%u',no);
replace_block(sys,'name','commands',['mvt_blocks/',sub_comm],'noprompt');
set_param([sys,'/','commands'],'LinkStatus', 'none','Mask Display','COMMANDS')
set_param([sys,'/','commands'],'hide name','off','Drop Shadow',4)


if strcmp(tipo,'emfc')|strcmp(tipo,'imfc')
   set_param([sys,'/','outputs'],'position',[405, 101, 495, 139]);
   set_param([sys,'/','commands'],'position',[405, 171, 495, 209]);
   
   replace_block(sys,'name','controller',['mvt_blocks/',tipo,'_controller'],'noprompt');
   set_param([sys,'/controller'],'LinkStatus', 'none','hide name','off','position',[150, 147, 260, 203])

   replace_block(sys,'name','matrix',['mvt_blocks/',tipo,'_kpf'],'noprompt');
   set_param([sys,'/matrix'],'LinkStatus', 'none','hide name','off','position',[150, 213, 260, 247])
   
   %calcolo dei parametri necessari al sottosistema relativo al setpoint
   plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   [sp,ome12,ome22,S11,S12,S21,S22,A12,A21,C1,B2,T,x1,n_x2]=setpoint(plant);

   if sp==0     %set point statico
      stack.simulation.ome12=ome12;
      stack.simulation.ome22=ome22;
      
      replace_block(sys,'name','setpoint',['mvt_blocks/static_sp'],'noprompt');
      set_param([sys,'/matrix/setpoint'],'LinkStatus', 'none','hide name','off');
   elseif sp==1     %set point quasi statico
      
      stack.simulation.S11=S11;
      stack.simulation.S12=S12;
      stack.simulation.S21=S21;
      stack.simulation.S22=S22;
      stack.simulation.A12=A12;
      stack.simulation.A21=A21;
      stack.simulation.C1=C1;
      stack.simulation.B2=B2;
      stack.simulation.T=T;
      stack.simulation.x1=x1;
      stack.simulation.n_x2=n_x2;
      
      replace_block(sys,'name','setpoint',['mvt_blocks/quasistatic_sp'],'noprompt');
      set_param([sys,'/matrix/setpoint'],'LinkStatus', 'none','hide name','off');
   end;
   
elseif (strcmp(tipo,'eig \ assign')|strcmp(tipo,'lqr')) & issetp
   if strcmp(stack.simulation.fdbk,'state') str='sf';else str='of';end;
   
   replace_block(sys,'name','matrix',['mvt_blocks/',str,'_setpoint'],'noprompt');
   set_param([sys,'/matrix'],'LinkStatus', 'none','hide name','off')
   
   %calcolo dei parametri necessari al sottosistema relativo al setpoint
   plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   [sp,ome12,ome22,S11,S12,S21,S22,A12,A21,C1,B2,T,x1,n_x2]=setpoint(plant);
   
   if sp==0     %set point statico
      stack.simulation.ome12=ome12;
      stack.simulation.ome22=ome22;
      
      replace_block(sys,'name','setpoint',['mvt_blocks/static_sp'],'noprompt');
      set_param([sys,'/matrix/setpoint'],'LinkStatus', 'none','hide name','off');
      
   elseif sp==1     %set point quasi statico
      stack.simulation.S11=S11;
      stack.simulation.S12=S12;
      stack.simulation.S21=S21;
      stack.simulation.S22=S22;
      stack.simulation.A12=A12;
      stack.simulation.A21=A21;
      stack.simulation.C1=C1;
      stack.simulation.B2=B2;
      stack.simulation.T=T;
      stack.simulation.x1=x1;
      stack.simulation.n_x2=n_x2;
      
      replace_block(sys,'name','setpoint',['mvt_blocks/quasistatic_sp'],'noprompt');
      set_param([sys,'/matrix/setpoint'],'LinkStatus', 'none','hide name','off');
   end;
   
else
   set_param([sys,'/','outputs'],'position',[415, 96, 505, 134]);
   set_param([sys,'/','commands'],'position',[415, 151, 505, 189]);
   
   if strcmp(tipo,'lqs')
      %dentro il blocco commands relativo ai comandi devo eliminare 
      %le righe relative ai comandi non assegnati (cioè alle uscite
      %per cui non è stato richiesto l'inseguimento)
      
      l=find(stack.simulation.outs==0);
      for i=1:length(l)
         if l(i)==1 
              outport='Sum/1';
         else outport=sprintf('Sum%s/1',num2str(l(i)-1));
         end;
         inport=sprintf('Mux/%s',num2str(l(i)));
         delete_line([sys,'/','commands'],sprintf('%s',outport),sprintf('%s',inport));
      end;
   end;
end;
   
close_system('mvt_blocks');      %libreria

set_param(bdroot,'location',new_loc);
if screensize(3)==800 zoomfactor='100';
else zoomfactor='Fitsystem';
end;

set_param(bdroot,'zoomfactor',zoomfactor);
%pause
%set_param(bdroot,'zoomfactor','FitSelection');


