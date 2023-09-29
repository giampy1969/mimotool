function con_obs_p2(tipo)
%CTRB with selected INPUT or OBSV from selected OUTPUT
%
%
% Massimo Davini 18/05/99 --- revised 30/05/99

global stack;

A=stack.general.A; B=stack.general.B;
C=stack.general.C; D=stack.general.D;

[no,ni]=size(D);
[ns,ns]=size(A);
poli=eig(A);

cv_ov=stack.temp.gramians;

if strcmp(tipo,'ctrbp')     tipo=1; limite=ni; str1='CONTROLLABLE';
elseif strcmp(tipo,'obsvp') tipo=2; limite=no; str1='OBSERVABLE';
end;

a=eye(limite);
for i=1:limite
   a(i,i)= get(findobj('tag',sprintf('check_%u',i)),'value');
end;

if tipo==1
   BBB=B*a;
   if BBB==zeros(ns,ni)
     for i=1:ns
       set(findobj('tag',sprintf('P_%u',i)),'foregroundcolor',[0 0 0]);
       set(findobj('tag',sprintf('CO_%u',i)),'string','');
     end;
     set(findobj('tag','testo'),'string','');
     return;
   else
     rango=rank(ctrb(A,BBB));
     [AA BB CC T K]=ctrbf(A,BBB,C);
     G=gram3(AA,BB);  %ctrb gramian sul sistema in ctrb form 
   end;  
   
elseif tipo==2
   CCC=a'*C;
   if CCC==zeros(no,ns)
      for i=1:ns
        set(findobj('tag',sprintf('P_%u',i)),'foregroundcolor',[0 0 0]);
        set(findobj('tag',sprintf('CO_%u',i)),'string','');
      end;
      set(findobj('tag','testo'),'string','');
      return;
   else
      rango=rank(obsv(A,CCC));
      [AA BB CC T K]=obsvf(A,B,CCC,1e-5);
      G=gram3(AA',CC');  %obsv gramian sul sistema in obsv form 
   end;
end;

[U,S,V]=svd(G);
[E,L]=eig(AA);
cv_ov=1./abs(sqrt(diag(pinv(E'*U*S*U'*E))));
     
p=diag(L);   
a=[cv_ov,p];
ordinati=sortrows(a,1);
     
for j=1:ns
   set(findobj('tag',sprintf('P_%u',j)),'string',num2str(ordinati(j,2)),...
      'foregroundcolor','red','TooltipString',num2str(ordinati(j,2)));
   set(findobj('tag',sprintf('CO_%u',j)),'string',num2str(ordinati(j,1)),...
      'TooltipString',num2str(ordinati(j,1)));
end;

if tipo==1
   if rank(ctrb(A,BBB))==ns
     set(findobj('tag','testo'),...
        'string',sprintf('THE SYSTEM IS \n COMPLETELY %s !',str1));
   else
     set(findobj('tag','testo'),...
        'string',sprintf('THE %s SUBSYSTEM \n HAS RANK %u !',str1,rank(ctrb(A,BBB))));
   end;
elseif tipo==2
   if rank(obsv(A,CCC))==ns
     set(findobj('tag','testo'),...
        'string',sprintf('THE SYSTEM IS \n COMPLETELY %s !',str1));
   else
     set(findobj('tag','testo'),...
        'string',sprintf('THE %s SUBSYSTEM \n HAS RANK %u !',str1,rank(obsv(A,CCC))));
   end;
end;   
  
