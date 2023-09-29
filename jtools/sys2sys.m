function [s1,T,dim]=sys2sys(s0,str,nst)

% [s1,T,dim]=sys2sys(s0,str,nst) system fixing and transformation.
% 
% If str contains 'o' the system is transformed in obsv. comp. form.
% If str contains 'c' the system is transformed in ctbr. comp. form.
% If str contains 'm' the system is transformed in modal form.
% If str contains 'j' the system is transformed in jordan form.
% If str contains 's' the system is transformed into a block
% diagonal form with the function strans.
%
% The second output argument contains the transformation matrix
% for all the above cases (except for 'o' and 'c' cases, where
% T is the transformation matrix only if the system is SISO).
% 
% If str contains 'b' balancing on both stable and unstable
% parts of the input system s0 is performed, no truncation is allowed.
% 
% If str contains 'r' (default) balancing on both stable and unstable
% parts of the input system s0 is performed, then the whole system
% is balanced and then truncated (beginning from its stable part)
% in order to reduce the states to nst.
% If nst >= num of states, (default) the stable part of the system is
% truncated to retain all hsv greater than max(sig(1)*1.0E-12,1.0E-16).
% 
% If str contains 'a' and there are less than nst states, 
% dummy unobservable and uncontrollable states will be added in -1
% to achieve an nst states system.
% 
% If str contains 'k' the system is transformed in kalman form,
% T is the transformation matrix and dim is such that :
% dim(1) = dimension of   controllable & unobservable subsystem (A11)
% dim(2) = dimension of   controllable &   observable subsystem (A22)
% dim(3) = dimension of uncontrollable & unobservable subsystem (A33)
% dim(4) = dimension of uncontrollable &   observable subsystem (A44).
% 
% G.Campa 22/1/98

if nargin<2,str='r';end
if nargin<1,disp('Please read sys2sys help');error(1);end

s1=s0;T=[];dim=[];

% general info
[ty,no,ni,n]=minfo(s1);
if ty=='cons', s1=[s1,zeros(no,1);zeros(1,ni),-inf]; end
[A,B,C,D]=unpck(s1);

if nargin<3,nst=n;end

%---------------------------------------------------------------------------
% kalman form
if any(str=='k'),

  cp=null(ctrb(A,B)');
  if isempty(cp); cp=zeros(n,1); end
  o=orth(obsv(A,C)');
  if isempty(o); o=zeros(n,1); end
  v1=null([cp o]');
  if isempty(v1); w1=zeros(n,1); else w1=v1; end	%  ctrb & ~obsv.
  v2=null([w1 cp]');
  if isempty(v2); w2=zeros(n,1); else w2=v2; end	%  ctrb &  obsv.
  v3=null([w1 o]');
  if isempty(v3); w3=zeros(n,1); else w3=v3; end	% ~ctrb & ~obsv.   
  v4=null([w1 w2 w3]');				% ~ctrb &  obsv.

  dim=[min(size(v1)) min(size(v2)) min(size(v3)) min(size(v4))];
  T=[v1 v2 v3 v4];
  [Ak,Bk,Ck,Dk]=ss2ss(A,B,C,D,T);
  s1=pck(Ak,Bk,Ck,Dk);
end

%---------------------------------------------------------------------------
% observability companion form
if any(str=='o'),
  P=zeros(n,n);
  al=poly(A);

  for i=1:n,
    P=P+diag(al(n-i+1)*ones(1,i),n-i);
  end

  Ao=zeros(no*n,no*n);
  Bo=zeros(no*n,ni);
  Co=zeros(no,no*n);
  Do=D;
  T=Ao;

  for k=1:no,
    Tk=inv(flipud(inv(ctrb(A',C(k,:)')*P))');
    [Ak,Bk,Ck,Dk]=ss2ss(A,B,C(k,:),D(k,:),Tk);

    Ao(1+(k-1)*n:k*n,1+(k-1)*n:k*n)=Ak;
    T(1+(k-1)*n:k*n,1+(k-1)*n:k*n)=Tk;
    Bo(1+(k-1)*n:k*n,1:ni)=Bk;
    Co(k,1+(k-1)*n:k*n)=Ck;
  end

  s1=pck(Ao,Bo,Co,Do);
end

%---------------------------------------------------------------------------
% controllability companion form
if any(str=='c'),
  al=poly(A);
  P=zeros(n,n);

  for i=1:n,
  P=P+diag(al(n-i+1)*ones(1,i),n-i);
  end

  Ac=zeros(ni*n,ni*n);
  Bc=zeros(ni*n,ni);
  Cc=zeros(no,ni*n);
  Dc=D;
  T=Ac;

  for k=1:ni,
    Tk=flipud(inv(ctrb(A,B(:,k))*P));
    [Ak,Bk,Ck,Dk]=ss2ss(A,B(:,k),C,D(:,k),Tk);

    T(1+(k-1)*n:k*n,1+(k-1)*n:k*n)=Tk;
    Ac(1+(k-1)*n:k*n,1+(k-1)*n:k*n)=Ak;
    Bc(1+(k-1)*n:k*n,k)=Bk;
    Cc(1:no,1+(k-1)*n:k*n)=Ck;
  end

s1=pck(Ac,Bc,Cc,Dc);
end

%---------------------------------------------------------------------------
% jordan form
if any(str=='j'),

  T=[];
  
  if n==0,
   [Aj,Bj,Cj,Dj]=ss2ss(A,B,C,D,T);
   return
  end
  
  l=sort(eig(A));
  lm=[];
  lm(1)=l(1);
  for i=2:n,
    if l(i) ~= l(i-1);  lm=[l(i) lm];  end
  end

  ln=length(lm);
  e=zeros(ln*n,n*n);
  ef=zeros(ln*n,n*n);
  s=zeros(1,ln);

  for i=ln:-1:1,
    krc=[];

    for p=1:n+1,
      m=(A-lm(i)*eye(n))^p;
      if min(size(null(m)))==min(size(krc)), s(i)=p-1; break, end
      krp=krc;
      krc=null(m);
      es=null([krp null(krc')]');
      e(n*(i-1)+1:n*i,n*(p-1)+1:n*(p-1)+min(size(es)))=es;
    end

    p=s(i);
    esf=e(n*(i-1)+1:n*i,n*(p-1)+1:n*p);
    ef(n*(i-1)+1:n*i,n*(p-1)+1:n*p)=esf;
    for p=s(i):-1:2,
      esr=e(n*(i-1)+1:n*i,n*(p-2)+1:n*(p-1));
      exm=(A-lm(i)*eye(n))*e(n*(i-1)+1:n*i,n*(p-1)+1:n*p);
      ess=null([exm null(esr')]');
      ex=[exm ess];
      [x,y]=size(ex);
      x=0;
      for r=1:y,
	if rank(ex(:,r)) > 0,
	  x=x+1;
	  ef(n*(i-1)+1:n*i,n*(p-2)+x)=ex(:,r);
        end
      end
    end

    for p=s(i):-1:1,
      esf=ef(n*(i-1)+1:n*i,n*(p-1)+1:n*p);
      for r=1:n,
         if rank(esf(:,r)) > 0, T=[esf(:,r) T]; end
      end
    end

  end

  [Aj,Bj,Cj,Dj]=ss2ss(A,B,C,D,inv(T));
  s1=pck(Aj,Bj,Cj,Dj);
end

%---------------------------------------------------------------------------
% modal form with real part sorted eigenvalues
if any(str=='m'),
  [T,E]=eig(A);
  [l,i]=sort(real(diag(E)));
  T=T(:,i);
  s1=statecc(s1,T);
end

%---------------------------------------------------------------------------
% modal form with frequency sorted eigenvalues (strans)
if any(str=='s'),
  [s1,T]=strans(s1);
end

%---------------------------------------------------------------------------
% balanced realization
if any(str=='b') & ~any(str=='r') & n>0,

  [ss,su] = sdecomp(s1,0);
  [tys,nos,nis,nss]=minfo(ss);
  [tyu,nou,niu,nsu]=minfo(su);

  % unstable part balanced realization
  if nsu>0,
    [A,B,C,D]=unpck(su);su=pck(-A,-B,C,D);
    [su,hu]=sysbal3(su,-1);
    [A,B,C,D]=unpck(su);su=pck(-A,-B,C,D);
  end
  if tyu=='cons', su=[su,zeros(nou,1);zeros(1,niu),-inf]; end

  % stable part balanced realization
  if nss>0,[ss,hs]=sysbal3(ss,-1);end
  if tys=='cons', ss=[ss,zeros(nos,1);zeros(1,nis),-inf]; end

  % reassembling
  s1=madd(ss,su);
  
  %aggiunto 24/05/99 da Massimo Davini:
  %matlab5.3 dà errore se non vengono asegnate tutte le uscite
  T=[];dim=[];
end

%---------------------------------------------------------------------------
% reduction 
if any(str=='r') & n>0,

  % extract unstable part
  [ss,su] = sdecomp(s1,0);
  [tys,nos,nis,nss]=minfo(ss);
  [tyu,nou,niu,nsu]=minfo(su);

  % unstable part balanced realization
  if nsu>0,
    [A,B,C,D]=unpck(su);su=pck(-A,-B,C,D);
    [su,hu]=sysbal3(su,-1);
    [A,B,C,D]=unpck(su);su=pck(-A,-B,C,D);
  end
  if tyu=='cons', su=[su,zeros(nou,1);zeros(1,niu),-inf]; end

  % stable part balanced realization
  if nss>0,[ss,hs]=sysbal3(ss);end
  [tys,nos,nis,nss]=minfo(ss);
  if tys=='cons', ss=[ss,zeros(nos,1);zeros(1,nis),-inf]; end

  % stable part truncation and reduced system construction
  s2=madd(strunc(ss,max(0,nst-nsu)),su);
  [ty2,no2,ni2,ns2]=minfo(s2);
  if ty2=='cons', s2=[s2,zeros(no2,1);zeros(1,ni2),-inf]; end

  % truncs the unstable part of the system if necessary
  s1=strunc(s2,nst);

end

%---------------------------------------------------------------------------
% general info
[ty,no,ni,n]=minfo(s1);
if ty=='cons', s1=[s1,zeros(no,1);zeros(1,ni),-inf]; end
dst=nst-n;

%---------------------------------------------------------------------------
% augmentation
if any(str=='a') & dst>0,
  [A,B,C,D]=unpck(s1);
  A=[A zeros(size(A,1),dst); zeros(dst,size(A,2)) -eye(dst,dst)];
  B=[B; zeros(dst,size(B,2))];
  C=[C zeros(size(C,1),dst)];
  s1=pck(A,B,C,D);
end
