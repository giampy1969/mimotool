function [s1,s2,s3]=reds(s0,gap2,gap3,grf)

% [s1,s2,s3]=reds(s0,gap2,gap3,grf) performs different types
% of reduction, all systems are packed by pck.
% s0 original linear system.
% s1 minreal reduced system from s0.
% s2 strunc reduced system from stable part of s1.
% s3 strunc reduced system from stable part of s1.
% The truncations are made in order to keep the gap between 
% the values of ctrb*obsv in s2 under gap2 and to keep the
% gap between the hankel singular values in s3 under gap3.
% If grf==1 some results about the systems are printed,
% if grf==2 also some plots are shown,
% if grf==0 no action is taken.
% By default gap2=1e3 gap3=1e4 grf=2.
%
% Giampiero Campa 13/aug/95 revised 10/4/97

if nargin<4,grf=2;end
if nargin<3,gap3=1e4;end
if nargin<2,gap2=1e3;end
if nargin<1,error('Please read reds help');end

if grf
disp(' ')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if grf
disp('complete linear system :')
end

[A0,B0,C0,D0]=unpck(s0);

[ss0,su0] = sdecomp(s0,-1e-12);
[s6,h6]=sysbal(ss0);
[ty,no,ni,ns]=minfo(s6);
if ty=='cons', s6=[s6,zeros(size(s6,1));zeros(size(s6,2)),-inf]; end
hlw=hinfnorm(s6);
[A6,B6,C6,D6]=unpck(s6);

if grf>1,
disp('s0 :');
sysinfo(s0,'s',hlw(3));
end

if grf,
disp(' ')
disp(' ')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% minreal reduction (s1 system)

if grf
disp('minreal reduction :')
end

[A1,B1,C1,D1]=minreal(A0,B0,C0,D0,.01);
s1=pck(A1,B1,C1,D1);

if grf>1,
disp('s1 :');
sysinfo(s1,'s',hlw(3));
end

if grf,
disp(' ')
disp(' ')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strunc reduction of the stable part (s2 system) poles ctrb and obsv.

if grf,
disp('strunc reduction of the stable part (poles ctrb and obsv) :')
end

[T,L]=eig(A6);
[a,b,c,d]=ss2ss(A6,B6,C6,D6,inv(T));
Gc=gram(a,b);
Go=gram(a',c');
[Uc,Sc,Vc]=svd(Gc);
[Uo,So,Vo]=svd(Go);
c6=1./abs(sqrt(diag(pinv(Uc*Sc*Uc'))));
o6=1./abs(sqrt(diag(pinv(Uo*So*Uo'))));
co6=sqrt(flipud(sort(c6.*o6)));

% order to keep the gap in the gram. sv. between "gap"
ord=max((co6/max(co6)>1/gap2).*[1:size(co6,1)]');     % c&o s.v.

% system truncation
s2=madd(strunc(s6,ord),su0);

if grf>1,
disp('s2 :');
sysinfo(s2,'s',hlw(3));
end

if grf,
disp(' ')
disp(' ')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strunc reduction of the stable part (s3 system) hankel singular values.

if grf,
disp('strunc reduction of the stable part (hankel singular values) :')
end

% order to keep the gap in the gram. sv. between "gap"
ord=max((h6/max(h6)>1/gap3).*[1:size(h6,1)]');      % hankel s.v.

% system truncation
s3=madd(strunc(s6,ord),su0);

if grf>1,
disp('s3 :');
sysinfo(s3,'s',hlw(3));
end
