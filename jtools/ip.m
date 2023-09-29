function [x,lambda,how]=ip(f,A,B,vlb,vub,x,neqcstr,verbosity)

%	X=ip(f,A,b); finds a suboptimal solution to the Integer programming problem:
%        
%            min f'x    subject to:   Ax <= b 
%             x
%   
%	[X,LAMBDA]=ip(f,A,b); returns the set of Lagrangian multipliers,
%	LAMBDA, at the solution. 
%	
%	X=ip(f,A,b,VLB,VUB) defines a set of lower and upper
%	bounds on the design variables, X, so that the solution is always in
%	the range VLB < X < VUB.
%
%	X=ip(f,A,b,VLB,VUB,X0) sets the initial starting point to X0.
%
%	X=ip(f,A,b,VLB,VUB,X0,N) indicates that the first N constraints defined
%	by A and b are equality constraints.
%
%	IP produces warning messages when the solution is either unbounded
%	or infeasible. Warning messages can be turned off with the calling
%	syntax: X=ip(f,A,b,VLB,VUB,X0,N,-1).

%	Giampiero Campa 3-2-90.
         
if nargin<8, verbosity = 0; 
	if nargin<7, neqcstr=0; 
		if nargin<6, x=[]; 
			if nargin<5, vub=[];
				if nargin<4, vlb=[];
end, end, end, end, end
[x,lambda,how]=qp([],f(:),A,B(:),vlb, vub, x(:),neqcstr,verbosity);                                
          
if isempty(vlb), vlb=-inf*ones(size(x)); end
if isempty(vub), vub=inf*ones(size(x)); end

for i=1:length(x),
if (x(i)-round(x(i)))~=0,

	if f(i)>0,	vlb(i)=ceil(x(i)); 
	elseif f(i)<0, 	vub(i)=floor(x(i));
	end

	[x,lambda,how]=qp([],f(:),A,B(:),vlb,vub,x,neqcstr,verbosity);	
end
end
