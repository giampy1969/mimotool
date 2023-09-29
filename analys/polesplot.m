function polesplot(indice,tipo)
%POLES PLOT : grafico a barre e grafico 3D dei gramiani per ogni polo 
%
%          polesplot(indice,tipo)
%
% indice = intero che indica il numero d'ordine del polo considerato
% tipo   = intero che indica il tipo di grafico da plottare :
%          0 ---> grafico a barre del valore assoluto dell'autovettore 
%                 del polo rispetto agli stati
%          1 ---> grafico 3D dei gramiani di tutti i poli e del polo
%                 considerato
%
%
% Massimo Davini 15/05/99 --- revised 30/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

Gc=gram3(A,B);              %grahamiano di controllabilità
Go=gram3(A',C');            %grahamiano di osservabilità
[Uc,Sc,Vc]=svd(Gc);
[Uo,So,Vo]=svd(Go);

Di=pinv(D);
Ai=A-B*Di*C;
Bi=-B*Di;
Ci=Di*C;

[E,L]=eig(A);
cv=1./abs(sqrt(diag(pinv(E'*Uc*Sc*Uc'*E))));
ov=1./abs(sqrt(diag(pinv(E'*Uo*So*Uo'*E))));
l=diag(L);
[v0,id]=sort(real(l));

callbff=sprintf('polesplot(%u,%u);',indice+1,tipo);
callbrw=sprintf('polesplot(%u,%u);',indice-1,tipo);

if indice==length(E) set(findobj('tag','avanti'),'enable','off');
else  set(findobj('tag','avanti'),'enable','on','callback',callbff);
end;

if indice==1 set(findobj('tag','indietro'),'enable','off');
else  set(findobj('tag','indietro'),'enable','on','callback',callbrw);
end;


Ln=l(id(indice));
cn=cv(id(indice));
on=ov(id(indice));
En=E(:,id(indice));

delgraf;

if tipo==0
  set(gca,'Position',[0.1 0.3 0.8 0.6]);
  bar(abs(En));
  xlabel('States','fontsize',9);ylabel('abs( eigenvector )','fontsize',9);
  set(gca,'tag','grafico');
  title(sprintf('                POLE : %s   Ctrb : %s   Obsv : %s',num2str(Ln),num2str(cn),num2str(on)),...
      'color','y','fontsize',9,'fontweight','demi');
   set(findobj('tag','gramiani'),'string','CTRB-OBSV',...
      'callback',sprintf('polesplot(%u,1);',indice));
end;

if tipo==1
 set(gca,'Position',[0.08 0.3 0.85 0.6]);    
 plot3(real(l),imag(l),log10(cv),'r*','MarkerSize',5);
 xlabel('real axis','fontsize',9);ylabel('imag axis','fontsize',9);
 set(gca,'tag','grafico');
 title(sprintf('                  Ctrb (red) , Obsv (blue) , Pole = %s',num2str(l(id(indice)))),...
  'color','y','fontsize',9,'fontweight','demi');
 hold on
 plot3(real(l),imag(l),log10(ov),'b*','MarkerSize',5);
 grid;
 plot3(real(l(id(indice))),imag(l(id(indice))),log10(ov(id(indice))),'ko','MarkerSize',8);
 plot3(real(l(id(indice))),imag(l(id(indice))),log10(cv(id(indice))),'ko','MarkerSize',8);
 hold off
 set(findobj('tag','gramiani'),'string','POLE',...
    'callback',sprintf('polesplot(%u,0);',indice));
end;

  crea_pop(0,'crea');
