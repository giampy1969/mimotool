function [k,g]=h2synr(p,nmeas,ncon)

% [k,g]=h2synr(p,nmeas,ncon);
% H 2 syntesis using robust control toolbox function h2lgg.
% Input and output are defined as in mu tools function h2syn.

% G.Campa 15/12/97

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

[kr,gr]=h2lqg(pr);

[A,B,C,D,ty]=branch(kr);
k=pck(A,B,C,D);

[A,B,C,D,ty]=branch(gr);
g=pck(A,B,C,D);
