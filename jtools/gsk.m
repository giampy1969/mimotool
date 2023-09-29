function [out,x0,str,ts]=gsk(t,x,u,flag,k,x0)

% [out,x0,str,ts]=gsk(t,x,u,flag,k,x0); gain scheduling control.
% This s-function implements the gain scheduled controller k,
% which is computed by the function gsc.
% The inputs of the controller are : 
% 1) system state, 2) system input, 3) controller input. 

% G.Campa 25/04/99

if flag==0,
   out=[k.ns 0 k.no k.ni+k.nx+k.nu 0 k.df 1];
   str=[];
   ts=[0 0];
   
elseif flag==1,
   AB=zeros(k.ns,k.ns+k.ni);xk=x;
   ug=u([1:k.nu])';xg=u(k.nu+[1:k.nx])';uk=u(k.nu+k.nx+[1:k.ni]);
   
   Px=xg(k.idx(k.Vx)).^k.Wx;Pu=ug(k.idu(k.Vu)).^k.Wu;Pr=Px(1,:);
   for h=2:size(Px,1), Pr=prod(combvec(Pr,Px(h,:))); end
   for h=1:size(Pu,1), Pr=prod(combvec(Pr,Pu(h,:))); end
   
   for q=1:size(AB,1);
      for r=1:size(AB,2);
         AB(q,r)=Pr*squeeze(k.C(q,r,:));
      end
   end
   out=AB*[xk;uk];
   
elseif flag==3;
   CD=zeros(k.no,k.ns+k.ni);xk=x;
   ug=u([1:k.nu])';xg=u(k.nu+[1:k.nx])';uk=u(k.nu+k.nx+[1:k.ni]);
   
   Px=xg(k.idx(k.Vx)).^k.Wx;Pu=ug(k.idu(k.Vu)).^k.Wu;Pr=Px(1,:);
   for h=2:size(Px,1), Pr=prod(combvec(Pr,Px(h,:))); end
   for h=1:size(Pu,1), Pr=prod(combvec(Pr,Pu(h,:))); end
   
   for q=1:size(CD,1);
      for r=1:size(CD,2);
         CD(q,r)=Pr*squeeze(k.C(k.ns+q,r,:));
      end
   end
   out=CD*[xk;uk];
end


    
    
      

         
   
