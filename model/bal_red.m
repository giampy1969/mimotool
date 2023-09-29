function bal_red(indice)
%BAL_RED : callabck di un comando qualunque del menu Tools
% Creazione della finestra relativa alla forma bilanciata o ridotta 
% del modello in esame
%          
%              bal_red(indice)
%
% indice = 1,2,3,4,5 o 6 a seconda del comando del menu Tools da cui
%          la funzione viene richiamata (vedi codice relativo del file
%          crea_menu.m
%
% Massimo Davini 28/06/99 revised 19/03/00

global stack;
if (indice==1)|(indice==2)
 if any(real(eig(stack.general.A))>=0)
  %sistema stabile e/o osservabile per usare "sysbal" o "balreal"
  messag(gcf,'si');
  return;
 end;
 if indice==2
  if rank(obsv(stack.general.A,stack.general.C))<size(stack.general.A,1)
  %il sistema (stabile) deve essere osservabile per usare "balreal"
  messag(gcf,'so');
  return;
  end;
 end;
end;

if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
end;

delete(findobj('tag','matrice'));drawnow;
   
if isfield(stack.temp,'handles')&(~isempty(stack.temp.handles))
      delete(stack.temp.handles);
end;
stack.temp.handles=[];
   
set(findobj('tag','file_2'),'enable','off');
set(findobj('tag','file_3'),'enable','off');
set(findobj('tag','file_5'),'enable','off');
set(findobj('tag','file_6'),'enable','off');
set(findobj('tag','file_7'),'enable','off');
set(findobj('tag','tools_10'),'enable','off');

set(get(findobj('tag','eval_1'),'children'),'enable','off');
set(findobj('tag','simu_2'),'enable','off');
   
set(findobj('tag','FrameA'),'visible','off');
set(findobj('tag','bottA'),'visible','off');
set(findobj('tag','FrameB'),'visible','off');
set(findobj('tag','bottB'),'visible','off');
set(findobj('tag','FrameC'),'visible','off');
set(findobj('tag','bottC'),'visible','off');
set(findobj('tag','FrameD'),'visible','off');
set(findobj('tag','bottD'),'visible','off');
set(findobj('tag','bottNew'),'visible','off');
set(findobj('tag','bottLoad'),'visible','off');
set(findobj('tag','BottAna'),'visible','off');
set(findobj('tag','BottSyn'),'visible','off');
drawnow;
   
switch indice
   case {1,2,3}
      lab='bal';tipo='Balanced Realization';
   case {4,5,6}
      lab='red';tipo='Model Reduction';
   end;
   
   set(gcf,'Name',sprintf(' MIMO Tool : MODELING %s --> %s',stack.general.model,tipo));
   
   n(1)=uicontrol('style','frame','units','normalized','position',[.037 .833 .106 .11],...
      'backgroundcolor',[1 1 1],'Visible','off','tag','balred');
   
   n(2)=uicontrol('style','frame','units','normalized','position',[0.167 0.833 0.106 0.11],...
     'backgroundcolor',[1 1 1],'Visible','off','tag','balred');
  
   n(3)=uicontrol('style','frame','units','normalized','position',[0.297 0.833 0.106 0.11],...
      'Visible','off','backgroundcolor',[1 1 1],'tag','balred');
  
   n(4)=uicontrol('style','frame','units','normalized','position',[0.427 0.833 0.106 0.11],...
      'Visible','off','backgroundcolor',[1 1 1],'tag','balred');
   
   ABCDoff='set(stack.temp.handles(1:4),''visible'',''off'');';
  
   n(5)=uicontrol('style','push','unit','normalized','position',[0.05 0.85 0.08 0.08],...
      'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
      'string',['A',lab],'Horizontalalignment','center',...
      'TooltipString','Visualize matrix','tag','balred',...
      'callback',[ABCDoff,'set(stack.temp.handles(1),''visible'',''on'');visual(stack.temp.newA,''A'',''text'');']);

   n(6)=uicontrol('style','push','unit','normalized','position',[0.18 0.85 0.08 0.08],...
      'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
      'string',['B',lab],'Horizontalalignment','center',...
      'TooltipString','Visualize matrix','tag','balred',...
      'callback',[ABCDoff,'set(stack.temp.handles(2),''visible'',''on'');visual(stack.temp.newB,''B'',''text'');']);  

   n(7)=uicontrol('style','push','unit','normalized','position',[0.31 0.85 0.08 0.08],... 
      'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
      'string',['C',lab],'Horizontalalignment','center',...
      'TooltipString','Visualize matrix','tag','balred',...
      'callback',[ABCDoff,'set(stack.temp.handles(3),''visible'',''on'');visual(stack.temp.newC,''C'',''text'');']);

   n(8)=uicontrol('style','push','unit','normalized','position',[0.44 0.85 0.08 0.08],... 
      'fontunits','normalized','fontsize',0.5,'fontweight','bold',...
      'string',['D',lab],'Horizontalalignment','center',...
      'TooltipString','Visualize matrix','tag','balred',...
      'callback',[ABCDoff,'set(stack.temp.handles(4),''visible'',''on'');visual(stack.temp.newD,''D'',''text'');']);
   
   n(9)=uicontrol('style','push','unit','normalized','position',[0.05 0.05 0.12 0.12],...
      'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
      'string','BACK','Horizontalalignment','center',...
      'TooltipString','Back to the main MODELING window',...
      'callback','back(0,''balred'');','tag','balred');
   
   n(10)=uicontrol('style','push','unit','normalized','position',[0.65 0.05 0.3 0.12],...
      'fontunits','normalized','fontsize',0.35,'fontweight','bold',...
      'Horizontalalignment','center','string','REPLACE MODEL',...
      'TooltipString','Replace the model in memory with his balanced/reduced form',...
      'callback','replace;','tag','balred');

   n(11)=uicontrol('style','text','unit','normalized','position',[0.22 0.08 0.38 0.05],...
      'fontunits','normalized','fontsize',0.8,'fontweight','bold',...
      'Horizontalalignment','center','string','','visible','off',...
      'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
      'tag','balred');
   
   stack.temp.handles=n;
   stack.temp.newA=[];
   stack.temp.newB=[];
   stack.temp.newC=[];
   stack.temp.newD=[];
   
   A=stack.general.A;
   B=stack.general.B;   
   C=stack.general.C;
   D=stack.general.D;
   sys=ss(A,B,C,D);
   
  
   switch indice
   case {1,2,3}   
       %balanced realization
       if indice==1,      [newsys,sig] = sysbal(pck(A,B,C,D));
                          [newA,newB,newC,newD]=unpck(newsys);
       elseif indice==2,  [newsys]=balreal(sys);
                          [newA,newB,newC,newD]=ssdata(newsys);
       elseif indice==3,  [newsys,Tbal,dim]=sys2sys(pck(A,B,C,D),'b');
                          [newA,newB,newC,newD]=unpck(newsys);
       end;
       stack.temp.newA=newA;
       stack.temp.newB=newB;
       stack.temp.newC=newC;
       stack.temp.newD=newD;
   case 4
   % minreal reduction
      [newsys]=minreal(sys,1e-4);
      [newA,newB,newC,newD]=ssdata(newsys);
      
      stack.temp.newA=newA;
      stack.temp.newB=newB;
      stack.temp.newC=newC;
      stack.temp.newD=newD;
      
      nsA=length(eig(stack.general.A));
      nsnewA=length(eig(stack.temp.newA));
      set(n(11),'string',sprintf(' %u state(s) REMOVED ',nsA-nsnewA),'visible','on');
      
   case {5,6}
      s0=pck(A,B,C,D);
      [ss0,su0] = sdecomp(s0,-1e-12);
      [ty,no,ni,ns]=minfo(ss0);
      if ty=='syst',
         [s6,h6]=sysbal3(ss0);
      	[ty,no,ni,ns]=minfo(s6);
         if ty=='syst', 
				hlw=hinfnorm(s6);
 		     	[A6,B6,C6,D6]=unpck(s6);
      	
      		[T,L]=eig(A6);
      		[a,b,c,d]=ss2ss(A6,B6,C6,D6,inv(T));
	
		      Gc=gram2(a,b); 
   		   Go=gram2(a',c');
      		[Uc,Sc,Vc]=svd(Gc);
      		[Uo,So,Vo]=svd(Go);
      		c6=1./abs(sqrt(diag(pinv(Uc*Sc*Uc'))));
      		o6=1./abs(sqrt(diag(pinv(Uo*So*Uo'))));
      		co6=sqrt(flipud(sort(c6.*o6)));
      		if indice==5
         		% order to keep the gap in the gram. sv. between "gap"
          		gap2=1e3;
          		ord=max((co6/max(co6)>1/gap2).*[1:size(co6,1)]');     % c&o s.v.
      		elseif indice==6
        		  	% order to keep the gap in the gram. sv. between "gap"
          		gap3=1e4;
          		ord=max((h6/max(h6)>1/gap3).*[1:size(h6,1)]');      % hankel s.v.
      		end;
      		% system truncation
            newsys=madd(strunc(s6,ord),su0);
         else
            newsys=madd([s6,zeros(size(s6,1));zeros(size(s6,2)),-inf],su0);
         end
      else
         newsys=s0;
      end
      [newA,newB,newC,newD]=unpck(newsys);
      stack.temp.newA=newA;
      stack.temp.newB=newB;
      stack.temp.newC=newC;
      stack.temp.newD=newD;
      
      nsA=length(eig(stack.general.A));
      nsnewA=length(eig(stack.temp.newA));
      set(n(11),'string',sprintf(' %u state(s) REMOVED ',nsA-nsnewA),'visible','on');
      
   end;