function normgjw1
%NORM(G(Jw,i,j))'s plot function
%
%
% Massimo Davini 15/05/99 --- revised 30/05/99
% revised 04/10/2000, Giampiero Campa 

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
delgraf;
A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

sys=pck(A,B,C,D);
[ty,no,ni,ns]=minfo(sys);

f=str2num(get(findobj('tag','frequenza'),'string'));
if (isempty(f))|(~isreal(f))|(f < 0)
    set(findobj('tag','frequenza'),'string',num2str(0.001));
    f=0.001;
end;

[ss0,su0]=sdecomp(sys,-1e-12);
gs0=zeros(no,ni);
for j=1:ni
  for i=1:no
       [A1 B1 C1 D1]=unpck(sel(ss0,i,j));
       if size(A1,1)==0
             Gs=D1;
       else Gs=C1*pinv(sqrt(-1)*f*eye(size(A1))-A1)*B1+D1;
       end;
       gs0(i,j)=abs(Gs);
  end;
end;
     
gs0(gs0<-1e-20)=nan*gs0(gs0<-1e-20);

if (min(size(gs0))>1)&(norm(real(isfinite(log10(gs0))))),
   %sistema non SISO e con parte stabile maggiore di 0
    set(gca,'position',[0.21 0.28 0.58 0.62]);
    contour(1:ni,-1:-1:-no,log10(gs0));
    xlabel('Inputs','fontsize',9);ylabel('Outputs','fontsize',9);
    title('Max sv. (G(jw,i,j))','color','y','fontsize',10,...
       'fontweight','demi');
    set(gca,'tag','grafico');
    crea_pop(0,'crea');
 else messag(gcf,'no_norm');
 end;
    


