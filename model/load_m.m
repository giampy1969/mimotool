function load_m
%LOAD MODEL: carica in memoria le matrici di un nuovo modello.
%
% Callback associata al comando "Load model" del menu file e al
% bottone "LOAD" della finestra di MODELING; 
% carica le matrici A B C D di un modello precedentemente salvato in
% un file .mat e modifica i rispettivi campi della variabile stack.
%
% Massimo Davini 13/05/99 --- revised 31/05/00

global stack;
creato=stack.general.M_flag;   % new (unsaved) model flag

if creato==0
   %-----------
   mv_p0=cd;
   
   mvt_path=which('mimotool.m');
   mvt_path=mvt_path(1:length(mvt_path)-11);
   if isunix, ds='/'; else ds='\'; end
   eval(['cd(''' mvt_path ds 'model' ds 'modelli'');']);
   
   [file path]=uigetfile('*.mat','Load model',100,100);
   if isstr(file)&isstr(path)
      if ~isempty(find_system('name','Closed_Loop_System'))
         close_system('Closed_Loop_System',0);
      end;
      
      nfile=[path file];
      try, load(nfile); end
      
      if length(file)>4
         if (strcmp(lower(file(length(file)-3:length(file))),'.mat')==0)
            file=[file,'.mat'];
         end;
      else file=[file,'.mat']; 
      end
      
      % new code to handle uncoherent matrices and
      % to load systems in different formats, giampy dec 03
      
      mv_errstr=['No useful data in file ' nfile];
      
      % see if ABCD matrices exist and are ok
      if exist('A','var') & exist('B','var') & exist('C','var') & exist('D','var') & ~isempty(A) & ~isempty(D),
         try, ss(A,B,C,D); mv_errstr='';
         catch, mv_errstr='Uncoherent ABCD matrices dimensions';
         end
      end
      
      % if ABCD are not existing or not ok
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
                     [A,B,C,D]=ssdata(ss(mv_var));
                     if isempty(A) | isempty(D), error(['A or D are empty in ' mv_list{i}]); end
                     mv_errstr=''; 
                  catch, 
                     mv_errstr=['Error in extracting ABCD matrices from ' mv_list{i}];
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
                  [A,B,C,D]=ltiss(mv_var);
                  mv_errstr='';
                  if isempty(A) | isempty(D), error(['A or D are empty in ' mv_list{i}]); end
               catch, 
                  mv_errstr=['Error in extracting ABCD matrices from ' mv_list{i}];
               end
            end
            
            % exit condition when system is found
            if isempty(mv_errstr), break, end
            
            % search for robust ctrl tbx uncertain system variables
            if (length(mv_cls)==3 & mv_cls=='uss'),
                if isct(mv_var),
                    try,
                        [A,B,C,D]=ssdata(get(mv_var,'Nominal'));
                        if isempty(A) | isempty(D), error(['A or D are empty in ' mv_list{i}]); end
                        mv_errstr='';
                    catch,
                        mv_errstr=['Error in extracting ABCD matrices from ' mv_list{i}];
                    end
                else
                    mv_errstr=['Model in variable ' mv_list{i} ' is not continuous time'];
                end
            end
            
            % exit condition when system is found
            if isempty(mv_errstr), break, end
            
         end
      end
      
      % if there are no useful data so far then exit load_m
      if ~isempty(mv_errstr), disp(mv_errstr); cd(mv_p0); return, end
      
      stack.general.model=file;
      stack.general.A=infnan2x(A);  stack.general.B=infnan2x(B);
      stack.general.C=infnan2x(C);  stack.general.D=infnan2x(D);
      
      delete(findobj('tag','matrice'));  drawnow;
      
      set(findobj('tag','FrameA'),'visible','off');
      set(findobj('tag','FrameB'),'visible','off');
      set(findobj('tag','FrameC'),'visible','off');
      set(findobj('tag','FrameD'),'visible','off');
      
      set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s',file));
      
      set(findobj('tag','bottA'),'Enable','on','String','[ A ]');
      set(findobj('tag','bottB'),'Enable','on','String','[ B ]');      
      set(findobj('tag','bottC'),'Enable','on','String','[ C ]');
      set(findobj('tag','bottD'),'Enable','on','String','[ D ]');
      set(findobj('tag','BottAna'),'Enable','on');
      set(findobj('tag','BottSyn'),'Enable','on');
      
      set(findobj('tag','file_4'),'enable','on');
      set(findobj('tag','file_5'),'enable','on');
      set(get(findobj('tag','tools_1'),'children'),'enable','on');
      set(get(findobj('tag','tools_2'),'children'),'enable','on');
      set(get(findobj('tag','tools_6'),'children'),'enable','on');
      
      if C==eye(size(C))
         if D==zeros(size(D))
            set(findobj('tag','tools_10'),'enable','off');
         end;
      end;
      
      set(findobj('tag','file_6'),'enable','off');
      set(findobj('tag','file_7'),'enable','off');
      set(get(findobj('tag','eval_1'),'children'),'enable','off');
      set(findobj('tag','simu_2'),'enable','off');
      set(findobj('tag','eval_1'),'enable','off');
      set(findobj('tag','simu_1'),'enable','off');
   end;
   cd(mv_p0);
   %----------- 
elseif creato==1
   messag(gcf,'l');
end;