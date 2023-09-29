function back_syn(tag_to,ogg_prec,varargin)

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

if ~isempty(find_system('name','Closed_Loop_System'))
  close_system('Closed_Loop_System',0);
end;

delete(findobj('tag','inf'));
if ~strcmp(tag_to,'ltr_1')
     delgraf;
end;
delete(findobj('tag','matrice'));
set(findobj('tag','file_6'),'enable','off');
set(findobj('tag','eval_31'),'enable','off');

stack.evaluation=[];
stack.simulation=[];
set(findobj('tag','simu_2'),'enable','off');

if isempty(ogg_prec) ogg_prec=0;end;
x=length(stack.temp.handles);
delete(stack.temp.handles(ogg_prec+1:x));
stack.temp.handles(ogg_prec+1:x)=[];
if isempty(stack.temp.handles) stack.temp=rmfield(stack.temp,'handles');end;

for i=1:length(varargin)
 eval(sprintf('stack.temp=rmfield(stack.temp,''%s'');',varargin{i}));
end;
drawnow;

set(findobj('tag',tag_to),'visible','on');


switch tag_to
case 'syn0'
      set(gcf,'Name',sprintf(' MIMO Tool : SYNTHESIS %s',stack.general.model));
case 'integratori'
      set(findobj('tag','EditIntegr'),'visible','on');
case {'h0','mix1'}
      set(findobj('tag','opt1'),'visible','on');
      set(findobj('tag','opt2'),'visible','on');  
      if strcmp(tag_to,'mix1') stack.temp.type=[];stack.temp.X1X2=[];end;
case {'h1','mix2','mu2'}
      set(findobj('tag','EditX1'),'visible','on');
      set(findobj('tag','EditX2'),'visible','on');
      stack.temp.X1X2==plotlimiti('EditX1','EditX2',stack.temp.type,stack.temp.plant);  
case 'mfc1'
      set(findobj('tag','option1'),'visible','on');
      set(findobj('tag','option2'),'visible','on');
      set(findobj('tag','EditGain'),'visible','on');
      set(findobj('tag','EditOver'),'visible','on');
      set(findobj('tag','EditSett'),'visible','on');
      set(findobj('tag','BNext'),'visible','on');
case 'mix0'
      for i=1:6
         eval(sprintf('set(findobj(''tag'',''ck%u''),''visible'',''on'');',i));
         eval(sprintf('cond%u=isempty(stack.temp.new_param.p%u{4,1});',i,i));
      end;
      set(findobj('tag','BDFL'),'visible','on');
      set(findobj('tag','BNEW'),'visible','on');
      
      cond=cond1 & cond2 & cond3 & cond4 & cond5 & cond6;
      if strcmp(get(findobj('tag','BDFL'),'enable'),'off')|cond
         default; 
         set(findobj('tag','BDFL'),'enable','off');
      else set(findobj('tag','testo'),'visible','on'); 
      end;
case 'mu0'
      set(findobj('tag','opt1'),'visible','on');
      set(findobj('tag','opt2'),'visible','on');
      set(findobj('tag','opt3'),'visible','on');
      set(findobj('tag','opt4'),'visible','on');
      
      [no,ni]=size(stack.general.D);
      stack.temp.bTo=[no,no];
      stack.temp.bMo=[no,ni];
      stack.temp.bTi=[ni,ni];
      stack.temp.bMi=[ni,no];
      stack.temp.flag.ok1=0;
      stack.temp.flag.ok2=0;
case 'mu1'
      set(findobj('tag','BNEXT'),'visible','on');
      stack.temp.X1X2=[];
case 'opti1'
      set(findobj('tag','edit1'),'visible','on');
      set(findobj('tag','edit2'),'visible','on');
      set(findobj('tag','edit3'),'visible','on');
      set(findobj('tag','edit4'),'visible','on');
case 'ea0'
      set(findobj('tag','ea0_edit'),'visible','on');
      set(findobj('tag','eaopt1'),'visible','on');
      set(findobj('tag','eaopt2'),'visible','on');
      set(findobj('tag','eaopt3'),'visible','on');
case 'ea01'
      set(findobj('tag','mat'),'visible','on');
case 'ea1'
      set(findobj('tag','ea1_str'),'visible','on');
      set(findobj('tag','ea1_edit'),'visible','on');
      for i=1:size(stack.general.A,1) 
         set(findobj('tag',sprintf('ea1_vet_%u',i)),'visible','on');
         set(findobj('tag',sprintf('ea1_ach_%u',i)),'visible','on');
      end;
      set(findobj('tag','ea1<<'),'visible','on');
      set(findobj('tag','ea1>>'),'visible','on');
      set(findobj('tag','ea1_next'),'visible','on');
      stack.temp.cla_val=[];
      stack.temp.cla_vet=[];
case 'lqs0'
      set(findobj('tag','lqs0_next'),'visible','on');
      for i=1:size(stack.general.A,1)
        set(findobj('tag',sprintf('ck_%u',i)),'visible','on');
        set(findobj('tag',sprintf('cki_%u',i)),'visible','on');
     end;
case 'ltr_0'
      set(findobj('tag','ck_sg'),'visible','on');
      set(findobj('tag','ck_ib'),'visible','on');
      if get(findobj('tag','ck_sg'),'value')==1
            set(findobj('tag','sg'),'visible','on');
      else  set(findobj('tag','ib_text'),'visible','on');
            set(findobj('tag','ibg'),'visible','on');
            set(findobj('tag','ibf'),'visible','on');
      end;
      set(findobj('tag','opt_i'),'visible','on');
      set(findobj('tag','opt_o'),'visible','on');
      set(findobj('tag','cf'),'visible','on');
      set(findobj('tag','ro'),'visible','on');
case 'ltr_1'
      set(findobj('tag','BNext'),'visible','on');
      set(findobj('tag','barra_syn'),'visible','on');
      set(findobj('tag','rangemin'),'visible','on');
      set(findobj('tag','rangemax'),'visible','on');
      set(findobj('tag','edit_romu'),'visible','on');
      set(findobj('tag','ck_TlqTkf'),'visible','on');
      drawnow;
      
      w=stack.temp.w;
      sg=stack.temp.param(2);             %static gain
      
      set(gca,'drawmode','fast','NextPlot','add');
      delete(findobj('tag','plot_GKKG'));
      if ~get(findobj('tag','ck_TlqTkf'),'value')
            delete(findobj('tag','plot_Tlq'));
            delete(findobj('tag','plot_Tkf'));
      end;
      if strcmp(stack.temp.incer,'in') tipo=1;else tipo=2;end;
      if tipo==1   
           semilogx(w,stack.temp.sv_Trol,'b','tag','plot_Trol');
           titolo='   LQR SYNTHESIS with Q = H''H and R = ro*I';
      else semilogx(w,stack.temp.sv_Tfol,'b','tag','plot_Tfol');
           titolo='   KFB SYNTHESIS with Qn = WW'' and Rn = mu*I';
      end;   
      ylabel('dB','fontsize',8);
      set(gca,'Xlim',[w(1),w(length(w))],'Ylim',[-3*sg,2*sg],...
         'tag','grafico','NextPlot','replace');
      delete(get(gca,'title'));
      title(titolo,'color',[0 0 0],'fontsize',9,'fontweigh','demi');
      crea_pop(1,'crea');
case 'ltr_12'
      set(findobj('tag','BNext12'),'visible','on');
      set(findobj('tag','barra_rec'),'visible','on');
      set(findobj('tag','rangemink'),'visible','on');
      set(findobj('tag','rangemaxk'),'visible','on');
      set(findobj('tag','editq'),'visible','on');
      set(findobj('tag','editr'),'visible','on');
      drawnow;
      
      w=stack.temp.w;
      sg=stack.temp.param(2);             %static gain
            
      axes('Position',[0.12 0.46 0.78 0.44]);
      set(gca,'drawmode','fast');
      semilogx(w,nan*zeros(size(w)));
      set(gca,'NextPlot','add');
      plot(stack.temp.param(1),0,'*');
      fill(stack.temp.gates(1,:),stack.temp.gates(2,:),'y');
      if strcmp(stack.temp.incer,'in') tipo=1;else tipo=2;end;
      if tipo==1   
           semilogx(w,stack.temp.sv_Tlq,'r','tag','plot_Tlq' );
           titolo='      KFB RECOVERY with Qf = Qo + q*q*B*V*B'' and Rf = I';
      else semilogx(w,stack.temp.sv_Tkf,'r','tag','plot_Tkf' );
           titolo='      LQE RECOVERY with Qf = Qo + q*q*C''*V*C and Rf = r*I';
      end;         
      semilogx(w,stack.temp.sv_GKKG,'b','tag','plot_GKKG');
      ylabel('dB','fontsize',8);
      set(gca,'Xlim',[w(1),w(length(w))],'Ylim',[-3*sg,2*sg],...
         'tag','grafico','NextPlot','replace');
      
      title(titolo,'color',[0 0 0],'fontsize',9,'fontweigh','demi');
      crea_pop(1,'crea');
case 'pid1'
      set(findobj('tag','pid1<<'),'visible','on');
      set(findobj('tag','pid1>>'),'visible','on');
      set(findobj('tag','pidnext'),'visible','on');
      set(findobj('tag','tx1'),'visible','on');
      set(findobj('tag','ed1'),'visible','on');
      set(findobj('tag','ed2'),'visible','on');
      set(findobj('tag','ed3'),'visible','on');
      set(findobj('tag','ed4'),'visible','on');
      set(findobj('tag','pidopt1'),'visible','on');
      set(findobj('tag','pidopt2'),'visible','on');
      set(findobj('tag','pidopt3'),'visible','on');
      set(findobj('tag','pidopt4'),'visible','on');
      set(findobj('tag','pidopt5'),'visible','on');
      set(findobj('tag','f1'),'visible','on');
      set(findobj('tag','f2'),'visible','on');
      set(findobj('tag','f3'),'visible','on');
%      set(findobj('tag','grafico'),'visible','on');
%      set(findobj('tag','plotol'),'visible','on');
%      set(findobj('tag','plotcl'),'visible','on');

      t=stack.temp.grafico{1};
      yol=stack.temp.grafico{2};
      ycl=stack.temp.grafico{3};
      
      ymin=min(min(ycl),min(yol))-0.2*abs(min(min(ycl),min(yol)));
      ymax=max(max(ycl),max(yol))+0.2*abs(max(max(ycl),max(yol)));
 
      axes('Position',[0.43 0.41 0.52 0.34]);
      set(gca,'drawmode','fast','nextplot','add');
      plot(t,yol,'b','tag','plotol');
      plot(t,ycl,'r','tag','plotcl');
      set(gca,'tag','grafico','NextPlot','replace','userdata',[min(yol) max(yol) max(t)],...
          'Ylim',[ymin,ymax],'Xlim',[0,max(t)]); 
      crea_pop(1,'crea');
      drawnow;

      set(findobj('tag','pidnota'),'visible','on');
      
end;

