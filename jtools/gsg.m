function [out,x0,str,ts]=gsg(t,x,u,flag,g,x0)

% [out,x0,str,ts]=gsg(t,x,u,flag,g,x0); gain scheduling control.
% This s-function implements the polinomial version of the
% s-function passed to gsc.

% G.Campa 25/04/99

if flag==0,
   out=[g.ns 0 g.no g.ni 0 g.df 1];
   str=[];
   ts=[0 0];
   
elseif flag==1,
   x=x';u=u';Px=x(g.idx(g.Vx)).^g.Wx;Pu=u(g.idu(g.Vu)).^g.Wu;Pr=Px(1,:);
   for h=2:size(Px,1), Pr=prod(combvec(Pr,Px(h,:))); end
   for h=1:size(Pu,1), Pr=prod(combvec(Pr,Pu(h,:))); end
   out=zeros(g.ns,1); for p=1:g.ns, out(p)=Pr*g.C(p,:)'; end
   
elseif flag==3;
   x=x';u=u';Px=x(g.idx(g.Vx)).^g.Wx;Pu=u(g.idu(g.Vu)).^g.Wu;Pr=Px(1,:);
   for h=2:size(Px,1), Pr=prod(combvec(Pr,Px(h,:))); end
   for h=1:size(Pu,1), Pr=prod(combvec(Pr,Pu(h,:))); end
   out=zeros(g.no,1); for p=1:g.no, out(p)=Pr*g.C(g.ns+p,:)'; end
   
end


    
    
      

         
   
