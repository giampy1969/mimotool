function x=plotlimiti(tagx1,tagx2,tipe,pckplant)
%PLOTLIMITI : (funzione generale)
% Mostra il grafico degli andamenti limite per le funzioni 
% (o matrici) T S ed M all'interno della sintesi o della 
% ottimizzazione H2,H-INFINITY,H-MIX e MU 
%
% Per creare il grafico è necessari conoscere i valori delle
% variabili X1 e X2 (vedi manuale per il loro significato)
% inserite dall'utente nei due campi edit della finestra.
%
%     x=plotlimiti(tagx1,tagx2,type,pckplant)
%
% tagx1 , tagx2 = (stringhe) rappresentano i 'tag' con cui
%                 è possibile accedere agli handles dei due 
%                 campi edit e quindi alle loro stringhe
% tipe          = (intero) serve per identificare il tipo di 
%                 grafico : 
%                 1 --> grafico dei limiti di [T,S]
%                 2 --> grafico dei limiti di [M,S]
% pckplant      = matrice del sistema in forma packed
%                 ( pckplant=pck(A,B,C,D) )
% x             = vettore dei due valori di X1 e X2
%
% Massimo Davini---27/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy


global stack

G=pckplant;

w=logspace(-10,10,100);
fr=20*log10(vunpck(norm3(frsp(G,w))));
cn=20*log10(vunpck(vcond(frsp(G,w))));
k0=mean(fr(1:10));
bd=log10(max(w'.*((k0-fr)<3)));
k1=mean(cn(1:10)-fr(1:10));

if tipe==2        x_default=[(k1+k0)/2 min(max(-2,bd),2)]';
elseif tipe==1    x_default=[min(max(0,k0),10) min(max(-2,bd),2)]';
end;   

x1=str2num(get(findobj('tag',tagx1),'string'));
x2=str2num(get(findobj('tag',tagx2),'string'));

if isempty(x1)|(x1<0 & tipe==2) x1=x_default(1);set(findobj('tag',tagx1),'string',num2str(x1));
elseif ~isreal(x1) messag(gcf,'pi');return;
end; 
if isempty(x2) x2=x_default(2);set(findobj('tag',tagx2),'string',num2str(x2));
elseif (~isreal(x2))|(abs(x2) > 8) messag(gcf,'pi');return;
end;

x=[x1;x2];

switch tipe
   case 1
    appoggio1=-20*(log10(w)-x(2))+x(1);
    appoggio2=20*(log10(w)-x(2))+x(1);
    for i=1:length(w)
        if w(1,i)< 10^x(2),  W1(i,1)=x(1); W2(i,1)=appoggio2(1,i);
        else                 W1(i,1)=appoggio1(1,i); W2(i,1)=x(1);
        end;
     end;   

   case 2 
     appoggio1=-20*(log10(w)-x(2));
     appoggio2=20*(log10(w)-x(2))+3;
     w0=10^(-x(1)/20+x(2));       
     for i=1:length(w)
       if w(1,i)<= w0  W1(i,1)=x(1);
       else W1(i,1)=appoggio1(1,i);end;
     end;   
     for i=1:length(w)
       if w(1,i)<= 10^x(2)  W2(i,1)=appoggio2(1,i);
       else W2(i,1)=3;end;
     end;   
end;

delgraf;
ay=3*abs(x(1));if ay==0 ay=20;end;
set(gca,'position',[0.43 0.29 0.52 0.6]);
semilogx(w,W1,'b');hold on
semilogx(w,W2,'r');hold off
set(gca,'tag','grafico','Ylim',[-ay ay]);
Xlabel('dB -- rad/sec','fontsize',8');
if tipe==1 title('UPPER LIMIT OF T ( blue ) AND S ( red )','color','y',...
   'fontsize',9,'fontweight','bold');
elseif tipe==2 title('UPPER LIMIT OF M ( blue ) AND S ( red )','color','y',...
   'fontsize',9,'fontweight','bold');
end;

crea_pop(1,'crea');

