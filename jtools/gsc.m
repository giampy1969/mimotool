function [k,g]=gsc(name,x0,u0,XR,UR,pstr,kstr,wstr,lrg,bMo,bMi,bTo,bTi)

% [k,g]=gsc(name,x0,u0,XR,UR,pstr,kstr,wstr,lrg,bMo,bMi,bTo,bTi);
% Gain Scheduling control polynomial interpolation coefficients,
% and  system polynomial interpolation coefficients. 
% This function takes as inputs the name of an s-function, and a grid
% of points in the space x-u, then for each of these points it calculate:
% 1) a controller with a given method.
%    For each element of the controller matrix,
%    an interpolating polynomial which gives the element versus the x-u
%    coordinates is computed, and then the whole polynomial coefficient
%    matrix is given as output (in k).
%    This coefficient matrix is then used by the control s-function gsk,
%    which implements the control on the s-function 'name'.
% 2) system state derivatives and system output.
%    For each element of the derivatives-outputs vector,
%    an interpolating polynomial which gives the element versus the x-u
%    coordinates is computed, and then the whole polynomial coefficient
%    matrix is given as output (in g).
%    This coefficient matrix is then used by the s-function gsg,
%    which implements the polynomial version of the s-function 'name'.
% 
% More in detail:
% 1) name in string containing the name of the s-function for which the
%    control and system are to be calculated.
% 2) x0,u0 is the 'central' point in the space x-u, in which the control
%    (system) is supposed to operate mainly.
% 3) XR is a matrix in which each row consists of:
%    1) an index i, indicating the variable x(i).
%    2) a row vector of values that x(i) assumes apart from x0(i).
%    XR=[] means x=x0 always.
% 4) UR is the same of XR with u(i) instead of x(i).
%    It is suggested to avoid repeated points (in particular +1 and -1).
% 5) The arguments pstr,kstr,wstr,lrg,bMo,bMi,bTo,bTi
%    determine the type of linear control to be implemented,
%    they (and their default values) are explained in khelps.
% The output k is a structure containing the interpolating coefficients
% of the control, k has to be passed to the s-function gsk.
% The output g is a structure containing the interpolating coefficients
% of the system, k has to be passed to the s-function gsg.
% 
% Example:
% k=gsc('auv',zeros(12,1),-ones(3,1),[1 -1 1; 5 -2 1],[3 1 2]);
% computes the interpolating coefficients of the h-inf controller
% for the s-function 'auv', where the first state assume the values
% -1, x0(1)=0, 1, the fifth -2, x0(5)=0, 1, and the third input
% u0(1)=-1, 1, 2.
% For all 3*3*3=27 points, an h-infinity (default) control is computed,
% and the interpolating polynomial coefficients are enclosed in k.
  
% G.Campa 25/04/99

if nargin<13,bTi=[]; end
if nargin<12,bTo=[]; end
if nargin<11,bMi=[]; end
if nargin<10,bMo=[]; end

if nargin<9,lrg=[];end

if nargin<8,kstr='hi3';end
if nargin<7,wstr='ae';end
if nargin<6,pstr='0tr';end

if nargin<5,UR=[]; end
if nargin<4,XR=[]; end

% system state and input sizes
sizes=feval(name,[],[],[],0);
g.ns=sizes(1);g.no=sizes(3);g.ni=sizes(4);k.nx=g.ns;k.nu=g.ni;

if any(size(x0)~=[g.ns 1]),
   error(['x0 should be a ' num2str(sizes(1)) ' elements column vector']);
end

if any(size(u0)~=[g.ni 1]),
   error(['u0 should be a ' num2str(sizes(4)) ' elements column vector']);
end

if isempty(UR), k.idu=1;UG=u0(k.idu);
else k.idu=UR(:,1);UG=[u0(k.idu) UR(:,2:size(UR,2))];
end

if isempty(XR), k.idx=1;XG=x0(k.idx);
else k.idx=XR(:,1);XG=[x0(k.idx) XR(:,2:size(XR,2))];
end

g.idx=k.idx;g.idu=k.idu;

% combination matrices
I0=1:size(XG,2);I=I0;
J0=1:size(UG,2);J=J0;
for i=1:size(XG,1)-1;I=combvec(I,I0);end
for j=1:size(UG,1)-1;J=combvec(J,J0);end

% hypercube vertex trip
S=[];K=[];c=0;
for i=I;
   for j=J;
      c=c+1;
      x0(k.idx)=diag(XG(:,i));
      u0(k.idu)=diag(UG(:,j));
      
      % controller values
      [A,B,C,D]=linmod(name,x0,u0);G=sbalanc(pck(A,B,C,D));
      [fc,gc,Kc]=kmaker([0 0],G,'',pstr,wstr,kstr,lrg,bMo,bMi,bTo,bTi);
      if isempty(Kc),
         error([ 'K is empty at the point number ' num2str(c) ]);
      end
      [ty,no,ni,ns]=minfo(Kc);
      if c==1, k.no=no;k.ni=ni;k.ns=ns;
      elseif any ([k.ns k.no k.ni]~=[ns no ni]),
         error(['K has a different size at the point number ';num2str(c) ]);
      end
      K(:,:,c)=sbalanc(Kc);
      
      % system values
      feval(name,0,x0,u0,'compile');
      y0=feval(name,0,x0,u0,3);d0=feval(name,0,x0,u0,1);
      feval(name,0,x0,u0,'term');
      S(:,c)=[d0;y0];
      
   end
end

% direct feedtrough
k.df=any(any(any(K(ns+[1:no],ns+[1:ni],:))));
g.df=any(any(S(g.ns+[1:g.no],:)));

% exponent vs. dimension combinations matrices
[k.Wx,k.Vx]=meshgrid([1:size(XG,2)]-1,1:size(XG,1));
[k.Wu,k.Vu]=meshgrid([1:size(UG,2)]-1,1:size(UG,1));
g.Wx=k.Wx;g.Vx=k.Vx;g.Wu=k.Wu;g.Vu=k.Vu;

% final polynomial data matrix
Pf=[];x0=x0';u0=u0';
for i=I,
   for j=J,
      c=c+1;
      x0(k.idx)=diag(XG(:,i));
      u0(k.idu)=diag(UG(:,j));
      Px=x0(k.idx(k.Vx)).^k.Wx;Pu=u0(k.idu(k.Vu)).^k.Wu;Pr=Px(1,:);
      for h=2:size(Px,1), Pr=prod(combvec(Pr,Px(h,:))); end
      for h=1:size(Pu,1), Pr=prod(combvec(Pr,Pu(h,:))); end
      Pf=[Pf;Pr];
   end
end

% controller polynomial coefficients
for q=1:(k.no+k.ns),
   for r=1:(k.ni+k.ns),
      k.C(q,r,:)=Pf\squeeze(K(q,r,:));
   end
end

% system polynomial coefficients
for p=1:(g.ns+g.no),
   g.C(p,:)=Pf\S(p,:)';
end
