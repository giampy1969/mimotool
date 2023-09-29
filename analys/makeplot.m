function makeplot(tipo,in,out)
%MAKE PLOT : callback dei bottoni >> e <<
%
% makeplot(tipo,in,out)
%
% tipo = stringa che indica il tipo di grafico
%        ('Step','Impulse','Bode','Nyquist')
%
%        nel caso di diagramma di Bode,nella finestra
%        precedente sono presenti altri due bottoni che
%        permettono di visualizzare seperatamente i due diagrammi
%        di bode : in questo caso la funzione viene richiamata
%        con questa sintassi --> makeplot('single') 
%
%        per visualizzare i grafici relativi a tutti i canali
%        contemporaneamente viene usata --> makeplot(tipo)
%        (se i canali sono troppi la visualizzazione non è 
%        molto efficace => eventualmente disabilitare il bottone
%        ALL della finestra da cui viene richiamata questa 
%        funzione nel file "responses.m"
%
% in   = intero che indica il canale di ingresso
% out  = intero che indica il canale di uscita
%
%
% Massimo Davini---19/05/99


global stack;
delgraf;

[no,ni]=size(stack.general.D);

if (nargin==1)&isstr(tipo)
   %se questa funzione viene richiamata da un bottone ALL,
   %devono essere mostrati tutti i grafici contemporaneamente
   
   sys=ss(stack.general.A,stack.general.B,stack.general.C,stack.general.D);
   axes('Position',[0.09 0.22 0.84 0.77],'tag','grafico');
   eval(sprintf('%s(sys);',lower(tipo)));
   dellbls6; 
       
   set(gcbo,'enable','off');
   set(findobj('tag','gain'),'enable','off');
   set(findobj('tag','phase'),'enable','off');
   
   crea_pop(1);      
   return;     %se non verifica le conzioni dell'if fa il return
end;

if (ni*no==1) set(findobj('tag','all'),'enable','off');
else set(findobj('tag','all'),'enable','on');end;

set(findobj('tag','gain'),'enable','on');
set(findobj('tag','phase'),'enable','on');

%in base a in e out sceglie il canale
channel=tf(stack.general.tfNUM(out+(in-1)*no,:),stack.general.tfDEN);

switch tipo
   case 'single'   %caso in cui voglio un singolo diagramma di Bode

     [mag,phase,w]=bode(channel);
     magdb=20*log10(mag);
     if strcmp(get(gcbo,'tag'),'gain')       
                semilogx(w,magdb(:));str='GAIN';str1='( dB - rad/s )';
     elseif strcmp(get(gcbo,'tag'),'phase')  
                semilogx(w,phase(:));str='PHASE';str1='( deg - rad/s )';
     end;
     set(gca,'Position',[0.12 0.31 0.76 0.58],'tag','grafico');
   
     title(sprintf('%s DIAGRAM %s : IN %u - OUT %u',str,str1,in,out),...
         'color','y','fontsize',9,'fontweight','demi');

     crea_pop(1,'crea');

   otherwise

     if (in==ni)&(out==no) set(findobj('tag','avanti'),'enable','off');
     else set(findobj('tag','avanti'),'enable','on'); end;
     if (in==1)&(out==1) set(findobj('tag','indietro'),'enable','off');
     else set(findobj('tag','indietro'),'enable','on'); end;

     if out==no in_a=in+1;out_a=1;else in_a=in;out_a=out+1;end;
     set(findobj('tag','avanti'),'callback',sprintf('makeplot(''%s'',%u,%u);',tipo,in_a,out_a));
     if out==1 in_i=in-1;out_i=no;else in_i=in;out_i=out-1;end;
     set(findobj('tag','indietro'),'callback',sprintf('makeplot(''%s'',%u,%u);',tipo,in_i,out_i));

     axes('Position',[0.09 0.31 0.84 0.58],'tag','grafico');
     eval(sprintf('%s(channel);',lower(tipo)));
     dellbls6;
     
     switch tipo
         case 'Bode'
            [Gm,Pm,Wcg,Wcp]=margin(channel);
            x=sprintf('        Gm=%s dB (at %s rad/s) , Pm=%s deg (at %s rad/s)',num2str(Gm),num2str(Pm),num2str(Wcg),num2str(Wcp));
            
            vrs=version;
            if str2num(vrs(1:3)) > 5.3
                bxlh=get(finlowax,'xlabel');
                set(bxlh,'String',x,'fontsize',9,'Visible','on');
            else
                bxlh=get(findobj('Tag','grafico'),'Xlabel');bxlp=get(bxlh,'Position');
                set(bxlh,'String',x,'fontsize',9,'Visible','on','Position',[bxlp(1)  -0.14 bxlp(3)]);
            end
        
            titolo=[upper(tipo),' DIAGRAMS'];
            set(findobj('tag','gain'),'callback',sprintf('makeplot(''single'',%u,%u);',in,out));
            set(findobj('tag','phase'),'callback',sprintf('makeplot(''single'',%u,%u);',in,out));
         case 'Nyquist'
             xlabel('');titolo=[upper(tipo),' DIAGRAM'];
         otherwise
            vrs=version;
            if str2num(vrs(1:3)) > 5.3, timelabel='Time'; else timelabel='Time (sec)'; end
            xlabel(timelabel,'fontsize',9);titolo=[upper(tipo),' RESPONSE'];
     end;

     title(sprintf('                  %s : IN %u - OUT %u',titolo,in,out),...
       'color','y','fontsize',9,'fontweight','demi');
    
    crea_pop(1);
    
 end;
 


