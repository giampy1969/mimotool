% function [sysout,sig] = sysbal3(sys,tol)
%
% Identical to MuTools's sysbal command, but
% uses a more robust algorithm, is used by sys2sys.
% Anyway, it is suggested to use the lmi function sbalanc
% instead of sysbal3 or sys2sys.

% Copyright (c) 1991-93 by MUSYN, Inc.
% $Revision: 1.1 $  $Date: 1993/09/03 17:22:18 $

function [sysout,sig] = sysbal3(sys,tol)
   if nargin == 0
     disp(['usage: [sysout,sig] = sysbal3(sys,tol)']);
     return
   end %if nargin<1

   [A,B,C,D]=unpck(sys);
   [n,m]=size(B); [p,n]=size(C);
   [T,A]=schur(A);
   B = T'*B;
   C = C*T;
 % find observability Gramian, S'*S (S upper triangular)
   S = sjh6(A,C);
 % find controllability Gramian R*R' (R upper triangular)
   perm = n:-1:1;
   R = sjh6(A(perm,perm)',B(perm,:)');
   R = R(perm,perm)';
 % calculate the Hankel-singular values
   [U,T,V] = svd(infnan2x(S*R));
   sig = diag(T);
 % balancing coordinates
   T = U'*S;
   B = T*B; A = T*A;
   T = R*V; 
   C = C*T; A = A*T;
    % calculate the truncated dimension nn
   if nargin<2 tol=max([sig(1)*1.0E-12,1.0E-16]);end;
   nn = n;
   for i=n:-1:1, if sig(i)<=tol nn=i-1; end; end;
   if nn==0, sysout=D;
     else
     sig = sig(1:nn);
     % diagonal scaling  by sig(i)^(-0.5)
     irtsig = sig.^(-0.5);
     onn=1:nn;
     A(onn,onn)=A(onn,onn).*(irtsig*irtsig');
     B(onn,:)=(irtsig*ones(1,m)).*B(onn,:);
     C(:,onn)=C(:,onn).*(ones(p,1)*irtsig');
     sysout=pck(A(onn,onn),B(onn,:),C(:,onn),D);
    end
