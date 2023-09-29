function back_eval(back_dir,azione)


% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
delgraf;
delete(findobj('tag','eva'));
delete(findobj('tag','textgrafico'));
for i=2:33 set(findobj('tag',sprintf('eval_%u',i)),'enable','off');end;

if strcmp(azione,'close')
   %è possibile solo se abbiamo chiamato la valutazione 
   %da una directory di synthesis
   
   %se c'è un modello simulink aperto,viene chiuso 
   if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
   end;
   
   delete(stack.temp.handles);
   stack.temp=[];
   stack.evaluation=[];
   stack.simulation=[];
   set(findobj('tag','eval_31'),'visible','on','enable','off');
   set(findobj('tag','simu_2'),'enable','off');
   set(findobj('tag','file_6'),'enable','off');
   
   set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s',stack.general.model));
   set(findobj('tag','syn0'),'visible','on');
   
elseif strcmp(azione,'back')
   switch back_dir
     case 'model'
        set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s',stack.general.model));
        set(findobj('tag','bottA'),'visible','on');
        set(findobj('tag','bottB'),'visible','on');
        set(findobj('tag','bottC'),'visible','on');
        set(findobj('tag','bottD'),'visible','on');
        set(findobj('tag','bottNew'),'visible','on');
        set(findobj('tag','bottLoad'),'visible','on');
        set(findobj('tag','BottAna'),'visible','on');
        set(findobj('tag','BottSyn'),'visible','on');
        set(findobj('tag','file_2'),'enable','on');
        set(findobj('tag','file_3'),'enable','on');
        set(findobj('tag','file_5'),'enable','on');
        set(findobj('tag','file_6'),'enable','on');
     
        for i=1:9 set(findobj('tag',sprintf('tools_%u',i)),'enable','on');end;
        C=stack.general.C;D=stack.general.D;
        if C==eye(size(C))
          if D==zeros(size(D))
            set(findobj('tag','tools_10'),'enable','off');
          end;
        else set(findobj('tag','tools_10'),'enable','on');
        end;

        stack.evaluation.grafici=[];
     case 'lqg'
        set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> LQG',stack.general.model));
        set(findobj('tag','BQ'),'visible','on');
        set(findobj('tag','BR'),'visible','on');
        set(findobj('tag','BW'),'visible','on');
        set(findobj('tag','BV'),'visible','on');
     case 'lqg_opt'
        set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> LQG',stack.general.model));
        set(findobj('tag','optlqg'),'visible','on');
        set(findobj('tag','editlqg1'),'visible','on');
        set(findobj('tag','editlqg2'),'visible','on');
     case {'lqr','imfc','emfc','lqs'}
        set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> %s',stack.general.model,upper(back_dir)));
        set(findobj('tag','BQ'),'visible','on');
        set(findobj('tag','BR'),'visible','on');
     case {'eig \ assign'}
        set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> %s',stack.general.model,upper(back_dir)));
        set(findobj('tag','ea2'),'visible','on');
        set(findobj('tag','cla'),'visible','on');
        set(findobj('tag','cle'),'visible','on');
     case {'lqg \ ltr'}
        set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> LQG \ LTR',stack.general.model));
        set(findobj('tag','ltr_2'),'visible','on');
        ltr3(1); 
     case {'pid'}
        set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> PID',stack.general.model));
        set(findobj('tag','infopid'),'visible','on');
     case {'hi','hi_opt','h2','h2_opt','hmix','hmix_opt','mu','mu_opt'}
        if     strcmp(back_dir,'hi')
           set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> H - INFINITY',stack.general.model));
        elseif strcmp(back_dir,'hi_opt')
           set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> H - INFINITY',stack.general.model));
        elseif strcmp(back_dir,'h2')
           set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> H - 2',stack.general.model));
        elseif strcmp(back_dir,'h2_opt')
           set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> H - 2',stack.general.model));
        elseif strcmp(back_dir,'hmix')
           set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> H - MIX',stack.general.model));
        elseif strcmp(back_dir,'hmix_opt')
           set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> H - MIX',stack.general.model));
        elseif strcmp(back_dir,'mu')
           set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s --> MU',stack.general.model));
        elseif strcmp(back_dir,'mu_opt')
           set(gcf,'Name',sprintf(' MIMO Tool : OPTIMIZATION %s --> MU',stack.general.model));
        end;
        
        set(findobj('tag','h2'),'visible','on');
        set(findobj('tag','deriva1'),'visible','on');
        set(findobj('tag','deriva2'),'visible','on');
        set(findobj('tag','funz1'),'visible','on');
        set(findobj('tag','funz2'),'visible','on');
        set(findobj('tag','funz3'),'visible','on');
        set(findobj('tag','funz4'),'visible','on');
   end;
   
   set(findobj('tag','eval_31'),'visible','on','enable','on');
   set(findobj('tag','BREG'),'visible','on');
   set(findobj('tag','BottBC'),'visible','on');
   set(findobj('tag','BEVAL'),'visible','on');
   set(findobj('tag','BSIMU'),'visible','on');
   drawnow;
   a=~strcmp(back_dir,'model');
   a=a & isfield(stack.temp,'X1') & isfield(stack.temp,'X2') & isfield(stack.temp,'Fx');
   if a & (~isempty(stack.temp.X1)) & (~isempty(stack.temp.X2)) & (~isempty(stack.temp.Fx))
      if strcmp(back_dir,'lqg_opt') pos=[.41 .27 .52 .68];else pos=[.58 .27 .37 .5];end; 
      set(gca,'position',pos);
      surf(stack.temp.X1,stack.temp.X2,stack.temp.Fx);
      xlabel('Magnitude');ylabel('Frequency');
      set(gca,'tag','grafico');
      crea_pop(0,'crea');
   end;
   
   stack.evaluation=rmfield(stack.evaluation,'grafici');
end;





