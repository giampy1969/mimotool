function singvect1
%SINGULAR VECTORS's bar plot
%
%
% Massimo Davini 15/05/99 --- revised 30/05/99

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

indice=stack.temp.ind_grafico;

sys=pck(A,B,C,D);
[ty,no,ni,ns]=minfo(sys);
sz=min(no,ni);

if sz>1 set(findobj('tag','BA'),'enable','on');end;

if indice==sz set(findobj('tag','BA'),'enable','off');
else set(findobj('tag','BA'),'enable','on');
end;

if indice==1 set(findobj('tag','BI'),'enable','off');
else set(findobj('tag','BI'),'enable','on');
end;

edit=findobj('tag','frequenza');
freq=str2num(get(edit,'string'));
if isempty(freq)|(~isreal(freq))|(freq<0)
    set(edit,'string',num2str(0.001));
    freq=0.001;
end;
 
Gs=C*pinv(sqrt(-1)*freq*eye(size(A))-A)*B+D;
[U,S,V]=svd(Gs);

set(findobj('tag','testo1'),...
   'string',sprintf(' Freq. %s rad/s :',get(edit,'string')));
drawnow;
set(findobj('tag','testo2'),...
   'string',num2str(rank(Gs)));
drawnow;
set(findobj('tag','testo3'),...
   'string',sprintf('%u dB',20*log10(cond(Gs))));
drawnow;

if indice<=sz
   Sn=S(indice,indice);
   Un=U(:,indice);
   Vn=V(:,indice);
   
   delgraf;

   axes('position',[0.44 0.6 0.5 0.35]);
   bar(abs(Un));
   set(gca,'tag','grafico');
   xlabel('output','fontsize',9);ylabel('abs(s.vec.)','fontsize',9);
   crea_pop(0,'crea');
   
   axes('position',[0.44 0.12 0.5 0.35]);
   bar(abs(Vn));
   set(gca,'tag','grafico');
   crea_pop(0,'crea');
   xlabel('input','fontsize',9);ylabel('abs(s.vec.)','fontsize',9);

   set(findobj('tag','num_vett'),...
     'string',sprintf(' S. Vector : %u of %u',indice,sz));
   set(findobj('tag','valore'),...
     'string',sprintf(' S. Value : %s',num2str(Sn)));
end;

