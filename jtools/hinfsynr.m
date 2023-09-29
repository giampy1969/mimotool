function [k,g,gfin]=hinfsynr(p,nmeas,ncon,gmin,gmax,tol)

% [k,g,gfin]=hinfsynr(p,nmeas,ncon,gmin,gmax,tol);
% H infinity syntesis using robust control toolbox function hinfopt.
% Input and output are defined as in mu tools function hinfsyne.

% G.Campa 4/12/97

[A,B,C,D]=unpck(p);
[no,ni]=size(D);

B1=B(:,1:ni-ncon);
B2=B(:,ni-ncon+1:ni);
C1=C(1:no-nmeas,:);
C2=C(no-nmeas+1:no,:);
D11=D(1:no-nmeas,1:ni-ncon);
D12=D(1:no-nmeas,ni-ncon+1:ni);
D21=D(no-nmeas+1:no,1:ni-ncon);
D22=D(no-nmeas+1:no,ni-ncon+1:ni);

pr=mksys(A,B1,B2,C1,C2,D11,D12,D21,D22,'tss');
gamind=1:nmeas;
aux=[tol,gmax,gmin];

[gamma,kr,gr]=hinfopt(pr,gamind,aux);

gfin=1/gamma;

[A,B,C,D,ty]=branch(kr);
k=pck(A,B,C,D);

[A,B,C,D,ty]=branch(gr);
g=pck(A,B,C,D);
