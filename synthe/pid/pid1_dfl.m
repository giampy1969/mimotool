function pid1_dfl;
%Massimo Davini 08/11/99

global stack;

   
for canale=1:stack.temp.canali
%inizio for   
   Num=stack.temp.Num(canale,:);
   Den=stack.temp.Den;
   [a,b,c,d]=tf2ss(Num,Den);
   tol=sqrt(eps)*10;p=[];
   while isempty(p)
     tol=tol/10;
     [amin,bmin,cmin,dmin]=minreal(a,b,c,d,tol);
     [z,p,k]=ss2zp(amin,bmin,cmin,dmin);
   end;
   
   sys=ss(amin,bmin,cmin,dmin);
   if ~isempty(find(real(p)>0))|...
      ~isempty(find(real(p)==0 & imag(p)==0))
   %canale instabile
   stabile=0;
   else stabile=1;
   end;

   stack.temp.stabili(canale)=stabile;
   
   if stabile
      dc=dcgain(sys);
      parametritipo=0;

      %canale stabile di ordine 1,senza zeri,con abs(dc)>10e-3
      if length(p)==1 & isempty(z) & isfinite(dc) & abs(dc)>1e-4
         parametritipo=1;
         T=-1/p; t0=T/100;
      %canale stabile con abs(dc)>10e-3 di ordine qualunque
      elseif length(p)>1 & isfinite(dc) & abs(dc)>1e-4
          %-------------------
          %stima del Rise Time
          %-------------------
          [y,t]=step(sys);
          %trova y / 10%dc <= y <= 90%dc , tra questi considera quelli
          %relativi alla prima salita ( se c'è overshoot ) infine
          %considera quelli relativi all'ultimo intervallo (se gli indici
          %degli y che soddisfano le condizioni non sono continuativi)
          x=find(y*sign(dc) >= dc*.1*sign(dc) & y*sign(dc) <= dc*.9*sign(dc));
          m=find(y*sign(dc) >= dc*sign(dc));
          if ~isempty(m)&~isempty(x) 
           x=find(y*sign(dc) >= dc*.1*sign(dc) & y*sign(dc) <= dc*.9*sign(dc) & y<m(1));
          end;
     
          if ~isempty(x)
              xx=[x(length(x))];
              for j=1:length(x)-1
                  if x(length(x)-j)==x(length(x)-j+1)-1 
                      xx=[x(length(x)-j);xx];
                  else break;
                  end;
              end;
              %Rise Time
              T=t(xx(length(xx)))-t(xx(1));
              t0=t(xx(1));
              parametritipo=1;     
          else %T non esiste => metodo classico di Z-N non applicabile
              parametritipo=2;  
          end;
       else
          parametritipo=2;
       end; 

      if parametritipo==1 %Ziegler-Nichols classico
          R=t0/T;C0=dc;N=C0/T;M0=1;  %M0=C0/k;
          %P
          Kp(1)=M0*(1+R/3)/(N*t0);
          Ti(1)=nan;Td(1)=nan;pd(1)=nan;
          %I = Kp2/s
          Kp(2)=4*M0*R^2/((1+5*R)*N*t0^2);
          Ti(2)=1;
          Td(2)=nan;pd(2)=nan;
          %PI
          Kp(3)=(M0/(N*t0))*(9/10+R/12);
          Ti(3)=t0*(30+3*R)/(9+20*R);
          Td(3)=nan;pd(3)=nan;
          %PD
          Kp(4)=(M0/(N*t0))*(5/4+R/6);
          Td(4)=t0*(6-2*R)/(22+3*R);
          pd(4)=-min(real(p))*10;
          Ti(4)=nan;
          %PID
          Kp(5)=(M0/(N*t0))*(4/3+R/4);
          Ti(5)=t0*(32+6*R)/(13+8*R);
          Td(5)=t0*4/(11+2*R);
          pd(5)=-min(real(p))*10;
  
          stack.temp.parametri{canale}=[Kp',Ti',Td',pd'];
          stack.temp.parametri_dfl{canale}=[Kp',Ti',Td',pd'];
          stack.temp.dfl(:,canale)=1;
          %fine parametritipo==1
       elseif parametritipo==2  % Ziegler-Nichols alternativo
          i=sqrt(-1);
          for j=1:length(Num) 
             numpiu(j,1)=Num(1,j)*(i^(length(Num)-j));
             nummeno(j,1)=Num(1,j)*((-i)^(length(Num)-j));
          end;
          for j=1:length(Den) 
             denpiu(j,1)=Den(1,j)*(i^(length(Den)-j));
             denmeno(j,1)=Den(1,j)*((-i)^(length(Den)-j));
          end;
          
          radici=roots(conv(numpiu,denmeno)-conv(denpiu,nummeno));
          for j=1:length(radici) 
             K(j,1)=-polyval(Den,i*radici(j))/polyval(Num,i*radici(j));
          end;
          j=1;vai=0;
          while ~vai & j<length(K) 
             app=[];appi=[];zeri=[];nonzeri=[];
             app=roots(Num*real(K(j))+Den);
             zeri=find(abs(real(app))<=1e-12 & imag(app)~=0);
             appi=app;
             appi(zeri)=[];
             nonzeri=find(real(appi)<0);
             if ~isempty(zeri)&(length(nonzeri)==length(app)-length(zeri))
                vai=1;
                periodo=abs(max(imag(app(zeri))));
                banda=real(K(j));
             end;
             j=j+1; 
          end;          
          if vai
           %---------------------------------------------------------             
           %NOTA :
           %La determinazione della banda (banda proporzionale
           %di pendolazione) non va bene nel caso di risposte 
           %al gradino che partono negativamente e arrivano al
           %dcgain (in questi casi molto vicino a zero) dal basso
           %facendo varie prove ho notato che basta cambiare di 
           %segno alla banda sopra calcolata per ottenere buone
           %risposte a ciclo chiuso.
           %Quindi aggiungo le righe sottostanti,anche se non ne ho
           %trovato conferma nel metodo di Ziegler/Nichols 
           [y,t]=step(Num,Den);
           ypiu=find(y>0);ymeno=find(y<0);
           if length(ypiu)<length(ymeno) banda=-banda;end;
           %---------------------------------------------------------
           %P
           Kp(1)=0.5*banda;
           Ti(1)=NaN;Td(1)=NaN;pd(1)=NaN;
           %I = Kp2/s
           Kp(2)=NaN;Ti(2)=NaN;Td(2)=nan;pd(2)=nan;
           %PI
           Kp(3)=0.45*banda;
           Ti(3)=0.85*periodo;
           Td(3)=NaN;pd(3)=NaN;
           %PD
           Kp(4)=0.5*banda;
           Td(4)=0.2*periodo;
           pd(4)=-min(real(p))*10;
           Ti(4)=NaN;
           %PID
           Kp(5)=0.6*banda;
           Ti(5)=0.5*periodo;
           Td(5)=0.12*periodo;
           pd(5)=-min(real(p))*10;
          
           stack.temp.parametri{canale}=[Kp',Ti',Td',pd'];
           stack.temp.parametri_dfl{canale}=[Kp',Ti',Td',pd'];
           stack.temp.dfl(:,canale)=1;
          end;
       %fine parametritipo==2
       end;
   end;
%fine for   
end;

