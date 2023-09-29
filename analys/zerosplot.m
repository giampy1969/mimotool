function zerosplot(indice)
%TRANSMISSION ZEROS's plot
%
%
% Massimo Davini 15/05/99 --- revised 30/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

sys=pck(A,B,C,D);
[ty,no,ni,ns]=minfo(sys);
z=tzero(A,B,C,D);
Gs=C*pinv(z(indice)*eye(size(A))-A)*B+D;

[U,S,V]=svd(Gs);
Sn=S(no,ni);
Un=U(:,no);
Vn=V(:,ni);
x0=pinv(z(indice)*eye(size(A))-A)*B*Vn;

set(findobj('tag','numzero'),'string',sprintf(' Zero : %u of %u',indice,length(z)));
set(findobj('tag','zero'),'string',num2str(z(indice)));
set(findobj('tag','rank'),'string',num2str(rank(Gs)));
set(findobj('tag','norm'),'string',num2str(norm(x0)));


callbff=sprintf('zerosplot(%u);',indice+1);
callbrw=sprintf('zerosplot(%u);',indice-1);

if indice==length(z) set(findobj('tag','avanti'),'enable','off');
else  set(findobj('tag','avanti'),'enable','on','callback',callbff);
end;

if indice==1 set(findobj('tag','indietro'),'enable','off');
else  set(findobj('tag','indietro'),'enable','on','callback',callbrw);
end;


delgraf;

if indice<=length(z)
   
   axes('position',[0.44 0.7 0.5 0.23]);
   bar(abs(x0));  ylabel('abs(x0)','fontsize',9);
   set(gca,'tag','grafico');
   crea_pop(0,'crea');
   
   axes('position',[0.44 0.38 0.5 0.23]);
   bar(abs(Un));  ylabel('output dir.','fontsize',9);
   set(gca,'tag','grafico');
   crea_pop(0,'crea');

   axes('position',[0.44 0.07 0.5 0.23]);
   bar(abs(Vn));  ylabel('input dir.','fontsize',9);
   set(gca,'tag','grafico');
   crea_pop(0,'crea');

end;


