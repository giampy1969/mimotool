function sysinfo(sys,str,w)

% sysinfo(sys,str,w) displays nearly all kind of
% information about the system sys at freq w.
% If str contains 'v' then a singular vector analysis is performed.
% If str contains 'p' then an eigenvector analysis is performed,
% note that there will be a figure for each pole of the system.
% If str contains 'z' then a zeros analysis is performed.
% If str contains 's' and the system is stable then the
% function displays settling times and overshoots for each channel,
% and if the size less than 6 also step responses are displayed.
% If str contains 'n' then the function displays gain and phase
% margins for each channel.
% By default str is empty and w=0.
%
% Giampiero Campa 13/aug/95 - revised 9/4/97.

if nargin<3 ,w=0; elseif isempty(w),w=0; end
if nargin<2, str=''; elseif isempty(str), str=''; end
if nargin<1 | ~isstr(str) | length(w)~=1 | ~isfinite(w),
   error('Please read sysinfo help');
end
if isfinite(sys2pss(sys)),
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequency domain, controllability and observability :

[A0,B0,C0,D0]=unpck(sys);
disp(' ');
[ty,no,ni,ns]=minfo(sys);
minfo(sys);
 
disp(' ');
disp([ 'Rank(ctrb(A,B)) : ' num2str(rank(ctrb(A0,B0),eps^2)) ]);
disp([ 'Rank(obsv(A,C)) : ' num2str(rank(obsv(A0,C0),eps^2)) ]);

Gc=gram3(A0,B0);
Go=gram3(A0',C0');
[Uc,Sc,Vc]=svd(Gc);
[Uo,So,Vo]=svd(Go);
c0=1./abs(sqrt(diag(pinv(Uc*Sc*Uc'))));
o0=1./abs(sqrt(diag(pinv(Uo*So*Uo'))));

[ss0,su0] = sdecomp(sys,-1e-12);
[tyu,nou,niu,nsu]=minfo(su0);

disp(' ');
disp([ 'max eig : ' num2str(max(real(spoles(sys)))) ]);
disp([ 'unstable part : ' num2str(nsu) ' states.' ]);

gs0=zeros(no,ni);
for j=1:ni,
for i=1:no,
  [A,B,C,D]=unpck(sel(ss0,i,j));
  if size(A,1)==0, Gs=D;
  else Gs=C*pinv(sqrt(-1)*w*eye(size(A))-A)*B+D;
  end 
  gs0(i,j)=abs(Gs);	
end
end

figure;

subplot(2,2,1);
pzmap(A0,B0,C0,D0);xlabel('');
title([ 'system poles & zeros' ]);

subplot(2,2,2);
sigma(A0,B0,C0,D0);xlabel('');
title([ 'system singular values' ]);

subplot(2,2,3);
semilogy(c0,'r');
hold on
semilogy(o0,'b');
xlabel('state');
ylabel('ctrb (red), obsv (blue)');
title('ctrb & obsv gram. sv');
% grid
hold off

subplot(2,2,4);
gs0(gs0<1e-20)=nan*gs0(gs0<1e-20);
if min(size(gs0))>1 & norm(real(isfinite(log10(gs0)))),
   contour(1:ni,-1:-1:-no,log10(gs0));end
xlabel('input')
ylabel('output')
title('max.sv.(G(jw,i,j))')
grid;


disp(' ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% poles analisys :

% inverse realization
Di=pinv(D0);Ai=A0-B0*Di*C0;Bi=-B0*Di;Ci=Di*C0;

[E,L]=eig(A0);
cv=1./abs(sqrt(diag(pinv(E'*Uc*Sc*Uc'*E))));
ov=1./abs(sqrt(diag(pinv(E'*Uo*So*Uo'*E))));
l=diag(L);
[v0,id]=sort(real(l));

if any(findstr('p',str)),
  figure;
  plot3(real(l),imag(l),log10(cv),'rx');
  xlabel('real axis');
  ylabel('imag axis');
  title('ctrb (red), obsv (blue)');
  hold on
  plot3(real(l),imag(l),log10(ov),'bx');
  grid

  for n=1:min(size(A0));
    Ln=l(id(n));
    cn=cv(id(n));
    on=ov(id(n));
    En=E(:,id(n));

    figure;
    bar(abs(En));
    xlabel('states');
    ylabel('abs(eigenvector)');
    title([ 'Pole : ' num2str(Ln) '    ctrb : ' num2str(cn) '    obsv : ' num2str(on) ]);

%   this was for the pole i/o direction but it was unreliable
%   Gi=Ci*pinv(Ln*eye(size(Ai))-Ai)*Bi+Di;[U,S,V]=svd(Gi);
%   Sn=S(ni,no);Un=U(:,ni);Vn=V(:,no);

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zeros analisys :

if any(findstr('z',str)),
  z=tzero(A0,B0,C0,D0);

  for n=1:size(z,1),

    Gs=C0*pinv(z(n)*eye(size(A0))-A0)*B0+D0;

    [U,S,V]=svd(Gs);
    Sn=S(no,ni);
    Un=U(:,no);
    Vn=V(:,ni);
    x0=pinv(z(1)*eye(size(A0))-A0)*B0*Vn;

    figure;
    subplot(3,1,1);
    bar(abs(x0));
    ylabel('abs(x0)');

    title([ 'Zero : ' num2str(z(n)) '    G(s) rank : ' num2str(rank(Gs)) ...
            '    norm(x0) : ' num2str(norm(x0)) ]);

    subplot(3,1,2);
    bar(abs(Un));
    ylabel('output dir.');

    subplot(3,1,3);
    bar(abs(Vn));
    ylabel('input dir.');

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% singular vectors channel analisys at w :

if any(findstr('v',str)),
  sz=min(no,ni);
  Gs=C0*pinv(sqrt(-1)*w*eye(size(A0))-A0)*B0+D0;
  [U,S,V]=svd(Gs);

  disp([ 'Rank at w=' num2str(w) '             : ' num2str(rank(Gs)) ]);
  disp([ 'Condition Number at w=' num2str(w) ' : ' num2str(20*log10(cond(Gs))) ' dB ' ]);

  for n=1:sz;

    Sn=S(n,n);
    Un=U(:,n);
    Vn=V(:,n);

    figure;
    subplot(2,1,1);
    bar(abs(Un));
    xlabel('output');
    ylabel('abs(s. vec.)');
	
    title([ 'w=' num2str(w) ', Singular Value : ' num2str(Sn) ]);

    subplot(2,1,2);
    bar(abs(Vn));
    xlabel('input');
    ylabel('abs(s. vec.)');

  end
end

disp(' ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel analisys :

% nyquist 
if any(findstr('n',str)),

  ct=0;
  figure;
  gm=zeros(no,ni);
  pm=zeros(no,ni);

  for n1=1:no
  for n2=1:ni

    if no<6 & ni<6
       ct=ct+1;
       subplot(no,ni,ct);
       title('step response');
       nyquist(A0,B0(:,n2),C0(n1,:),D0(n1,n2));
       axis([-4 4 -2 2]);
       add_disk;
    end

    [gmi,pmi]=margin(A0,B0(:,n2),C0(n1,:),D0(n1,n2));
    gm(n1,n2)=gmi;
    pm(n1,n2)=pmi;

  end
  end

  disp(' ');
  disp('gain margins :');
  gm

  disp(' ');
  disp('phase margins :');
  pm

end

% steps
if (nsu==0) & any(findstr('s',str)),

  % settling time and overshoot for each channel
  gp=D0-C0*pinv(A0)*B0;

  ts=zeros(no,ni);os=zeros(no,ni);
  ct=0;if no<6 & ni<6, figure; end
  
  for n1=1:no
  for n2=1:ni

    ct=ct+1;
    [y,xsys,t]=step(A0,B0(:,n2),C0(n1,:),D0(n1,n2));
    g0=gp(n1,n2);
    if g0<1e-1, g0=1; end

    ts(n1,n2)=max(t'.*(abs(y-g0)>.05*abs(g0)));
    os(n1,n2)=max(y-g0)/g0;

    if no<6 & ni<6,
       subplot(no,ni,ct);
       title('step response');
       plot(t,y);
    end

  end
  end

  disp(' ');
  disp('settling times :');
  if min(size(ts))==1,ts=ts(1,1);else ts=diag(ts); end

  disp(' ');
  disp('overshoots :');
  if min(size(os))==1,os=os(1,1);else os=diag(os); end

end

else
   error('Inf or NaN not allowed in a system matrix');
end
