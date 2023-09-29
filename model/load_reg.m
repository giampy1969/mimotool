function load_reg
%LOAD REGOLATOR 
%
% Callback associata al comando "Load controller" del menu file
% (abilitato solo nella finestra di Modeling);
% Carica da un file .mat i campi da inserire in stack.evaluation e
% stack.simulation e abilita i menu Simulation e Evaluation
%
% Prima di caricare il controllore selezionato nella apposita finestra
% di dialogo,controlla che quel controllore sia effettivamente relativo
% al modello in esame ;
%
% Massimo Davini 13/05/99 --- revised 17/02/00

global stack;

mv_p0=cd;
mvt_path=which('mimotool.m');
mvt_path=mvt_path(1:length(mvt_path)-11);
if isunix, ds='/'; else ds='\'; end
eval(['cd(''' mvt_path ds 'model' ds 'control'');']);

[file path]=uigetfile('*.mat','Load controller');

if isstr(file)&isstr(path)
   %------------------------   
   if ~isempty(find_system('name','Closed_Loop_System'))
      close_system('Closed_Loop_System',0);
   end;
   
   try, load([path file]); end
   cd(mv_p0);
   
   % new code to load systems in different formats, giampy dec 03
   
   mv_errstr=['No useful data in file ' path file];
   
   % see if evaluation_var and simulation_var exist and are ok
   if exist('evaluation_var','var') & exist('simulation_var','var') & isfield(evaluation_var,'model'),
      if strcmp(lower(stack.general.model),lower(evaluation_var.model)) & isfield(simulation_var,'Dk'),
         if size(simulation_var.Dk(:,:))==size(stack.general.D'),
            stack.evaluation=evaluation_var;
            stack.simulation=simulation_var;
            mv_errstr='';
         end
      end
   end
   
   % if evaluation_var and simulation_var are not existing or not ok
   if ~isempty(mv_errstr),
      if exist('Ak','var') & exist('Bk','var') & exist('Ck','var') & exist('Dk','var'),
         if size(Dk(:,:))==size(stack.general.D'),
            try, 
               
               stack.evaluation.model=stack.general.model;
               stack.evaluation.kind='external';
               stack.evaluation.K=pck(Ak,Bk,Ck,Dk);
               stack.evaluation.plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
               
               stack.simulation.kind='external';
               stack.simulation.Ak=Ak;
               stack.simulation.Bk=Bk;
               stack.simulation.Ck=Ck;
               stack.simulation.Dk=Dk;
               
               if rank(stack.general.A)==size(stack.general.A,1),
                  stack.simulation.pinvG0=pinv(stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D);
               else 
                  stack.simulation.pinvG0=zeros(size(stack.general.D'));
               end;
               
               mv_errstr='';
               
            catch, 
               mv_errstr='Error in Processing Ak Bk Ck Dk';
            end
         else
            mv_errstr='Uncoherent Ak Bk Ck Dk matrices dimensions';
         end
      end
   end
   
   % if Ak Bk Ck Dk are not existing or not ok
   if ~isempty(mv_errstr),
      
      % list system files
      mv_list=who;
      
      for i=1:length(mv_list),
         
         % select variable and its class
         mv_var=eval(mv_list{i});
         mv_cls=class(mv_var);
         
         % search for ctrl tbx system variables
         if (length(mv_cls)==2 & mv_cls=='ss') | (length(mv_cls)==2 & mv_cls=='tf') | (length(mv_cls)==3 & mv_cls=='zpk'),
            if isct(mv_var), 
               try, 
                  [Ak,Bk,Ck,Dk]=ssdata(ss(mv_var));
                  if any(size(Dk(:,:))~=size(stack.general.D')), error(['Uncoherent Dk dimensions in ' mv_list{i}]); end
                  
                  stack.evaluation.model=stack.general.model;
                  stack.evaluation.kind='external';
                  stack.evaluation.K=pck(Ak,Bk,Ck,Dk);
                  stack.evaluation.plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
                  
                  stack.simulation.kind='external';
                  stack.simulation.Ak=Ak;
                  stack.simulation.Bk=Bk;
                  stack.simulation.Ck=Ck;
                  stack.simulation.Dk=Dk;
                  
                  if rank(stack.general.A)==size(stack.general.A,1),
                     stack.simulation.pinvG0=pinv(stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D);
                  else 
                     stack.simulation.pinvG0=zeros(size(stack.general.D'));
                  end;
                  
                  mv_errstr='';
               catch, 
                  mv_errstr=['Error in extracting Ak Bk Ck Dk matrices from ' mv_list{i}];
               end
            else
               mv_errstr=['Model in variable ' mv_list{i} ' is not continuous time'];
            end
         end
         
         % exit condition when system is found
         if isempty(mv_errstr), break, end
         
         % search for LMI tbx (mutools) system variables
         if length(mv_cls)==6 & all(mv_cls=='double') & all(size(mv_var(:,:))>[1 1]) & mv_var(end,end)==-Inf,
            try, 
               [Ak,Bk,Ck,Dk]=ltiss(mv_var);
               if any(size(Dk(:,:))~=size(stack.general.D')), error(['Uncoherent Dk dimensions in ' mv_list{i}]); end
               
               stack.evaluation.model=stack.general.model;
               stack.evaluation.kind='external';
               stack.evaluation.K=pck(Ak,Bk,Ck,Dk);
               stack.evaluation.plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
               
               stack.simulation.kind='external';
               stack.simulation.Ak=Ak;
               stack.simulation.Bk=Bk;
               stack.simulation.Ck=Ck;
               stack.simulation.Dk=Dk;
               
               if rank(stack.general.A)==size(stack.general.A,1),
                  stack.simulation.pinvG0=pinv(stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D);
               else 
                  stack.simulation.pinvG0=zeros(size(stack.general.D'));
               end;
               
               mv_errstr='';
            catch, 
               mv_errstr=['Error in extracting Ak Bk Ck Dk matrices from ' mv_list{i}];
            end
         end
         
         % exit condition when system is found
         if isempty(mv_errstr), break, end
         
            % search for robust ctrl tbx uncertain system variables
            if (length(mv_cls)==3 & mv_cls=='uss'),
               try,
                  
                  [Ak,Bk,Ck,Dk]=ssdata(get(mv_var,'Nominal'));
                  if any(size(Dk(:,:))~=size(stack.general.D')), error(['Uncoherent Dk dimensions in ' mv_list{i}]); end
                  
                  stack.evaluation.model=stack.general.model;
                  stack.evaluation.kind='external';
                  stack.evaluation.K=pck(Ak,Bk,Ck,Dk);
                  stack.evaluation.plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
                  
                  stack.simulation.kind='external';
                  stack.simulation.Ak=Ak;
                  stack.simulation.Bk=Bk;
                  stack.simulation.Ck=Ck;
                  stack.simulation.Dk=Dk;
                  
                  if rank(stack.general.A)==size(stack.general.A,1),
                     stack.simulation.pinvG0=pinv(stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D);
                  else 
                     stack.simulation.pinvG0=zeros(size(stack.general.D'));
                  end;
                  
                  mv_errstr=''; 
               catch,
                  mv_errstr=['Error in extracting Ak Bk Ck Dk matrices from ' mv_list{i}];
               end
               
            end
            
            % exit condition when system is found
            if isempty(mv_errstr), break, end
                    
         % search any other double matrix of the right dimensions
         if length(mv_cls)==6 & all(mv_cls=='double'),
            try, 
               [Ak,Bk,Ck,Dk]=unpck(mv_var);
               if any(size(Dk(:,:))~=size(stack.general.D')), error(['Uncoherent Dk dimensions in ' mv_list{i}]); end
               
               stack.evaluation.model=stack.general.model;
               stack.evaluation.kind='external';
               stack.evaluation.K=pck(Ak,Bk,Ck,Dk);
               stack.evaluation.plant=pck(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
               
               stack.simulation.kind='external';
               stack.simulation.Ak=Ak;
               stack.simulation.Bk=Bk;
               stack.simulation.Ck=Ck;
               stack.simulation.Dk=Dk;
               
               if rank(stack.general.A)==size(stack.general.A,1),
                  stack.simulation.pinvG0=pinv(stack.general.C*inv(-stack.general.A)*stack.general.B+stack.general.D);
               else 
                  stack.simulation.pinvG0=zeros(size(stack.general.D'));
               end;
               
               mv_errstr='';
            catch, 
               mv_errstr=['Error in extracting Ak Bk Ck Dk matrices from ' mv_list{i}];
            end
         end
         
         % exit condition when system is found
         if isempty(mv_errstr), break, end
         
      end
   end
   
   
   
   % if there are no useful data so far then exit load_reg
   if ~isempty(mv_errstr), 
      disp(mv_errstr); 
      
      set(findobj('tag','simu_1'),'enable','off');
      set(findobj('tag','eval_1'),'enable','off');
      set(findobj('tag','file_6'),'enable','off');
      set(get(findobj('tag','eval_1'),'children'),'enable','off');
      set(findobj('tag','simu_2'),'enable','off');
      stack.evaluation=[];
      stack.simulation=[];
      messag(gcf,'noreg');
      return, 
      
   end
   
   % enable all
   set(findobj('tag','eval_1'),'enable','on');
   set(findobj('tag','simu_1'),'enable','on');
   set(findobj('tag','file_6'),'enable','on');
   set(findobj('tag','eval_31'),'enable','on');
   set(findobj('tag','simu_2'),'enable','on');
   
   %------------------------
else
   cd(mv_p0);
end;