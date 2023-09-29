function [SG,OS,IS]=sclopt(G,w);

% [SG,OS,IS]=sclopt(G,w); diagonal scaling of the system "G"
% at the frequency w (by default w=0.05).
% SG is the scaled system and OS and IS are the 
% scaling matrices: SG=OS*(C(sI-A)^-1*B+D)*IS 
% press 3 times ^C to stop the program.

% G. Campa 25-7-95.


if nargin<2 | isempty(w), w=0.05; end
if nargin<1, error('RTFH !!'); end

CT=0;
F=inf;
options=[];
[ty,no,ni,ns]=minfo(G);
n=ni+no;
options(14)=20*n;              % # max iterations

% STARTING POINT :
x=zeros(n,1);X=x;

% BOUNDS :
vlb=x-6;                      % lower bound
vub=x+6;                      % upper bound

% THIS IS FOR THE STARTING POINT,
% CAN BE SKIPPED IF YOU ALREADY KNOW A GOOD ONE.
% (or if there are problems near the edges). 
for i1=1:length(x);
	stp=(vub(i1)-vlb(i1))/5;
	for Xi=linspace(vlb(i1)+stp,vub(i1)-stp,3);
		if i1>1,x(i1-1)=(vlb(i1-1)+vub(i1-1))/2;end
		x(i1)=Xi;
		eval('[f,g,X,F]=sclgap(x,G,w,X,F);','');
	end
end

X=constr('sclgap',X,options,vlb,vub,[],G,w,X,F);
[f,g]=sclgap(X,G,w,X,F);

% scaled system
X=(ones(n,1)*10).^X;
SG=sclio(G,X(1:no)/sqrt(-g),X(no+1:n)/sqrt(-g));

% OS*C (sI-A)^-1 B*IS + OS*D*IS 
OS=diag(X(1:no)/sqrt(-g));
IS=diag(X(no+1:n)/sqrt(-g));
