% Discrete Lqg OPTimized controller
% this m-file founds the controller for the discrete time system 
% contained in the variable G, with Ts as sampling time.
% usage   : put in G your system, in Ts the sampling time,
%           if necessary trim the cost function in dlidx,
%           the max number of steps and the starting point here,
%           and then run this m-file. 
% results : K is the controller to be connected in negative feedback
%           Df is a feed forward matrix on the reference signal (output).
% press several times ^C to stop the program.

% G. Campa 24-2-96.

if (~exist('G'))|(~exist('Ts')),
error('You should put in G your system and in Ts the sampling time.');
end

tic
pack
format long

ct=0;
F=inf;
X=zeros(2,4);
%G=sys2sys(G);

options=[];
options(1)=1;                         % displays some results
options(2)=1e-1;                      % term tolerance for x
options(3)=1e-1;                      % term tolerance for f
options(14)=100;                      % # max iterazioni

%------------------------------------------------------------------------%
% MEANING OF VARIABLES :
% Q = 10^x(1)*eye(size(A)) , R = eye(ni) ;
% W = 10^x(2)*eye(size(A)) , V = eye(no) ;
%------------------------------------------------------------------------%

% STARTING POINT :
x=[0 0]';

% BOUNDS :
vlb=x-[5 5]';                 % lower bound
vub=x+[5 5]';                 % upper bound

%------------------------------------------------------------------------%
% THIS IS FOR THE STARTING POINT,
% CAN BE SKIPPED IF YOU ALREADY KNOW A GOOD ONE.
% (or if there are problems near the edges). 

% central point
eval('[f,g,K,Df,X,F]=dlidx(x,G,Ts,X,F);','');
% each hypercube vertex (4 points)
stp1=(vub(1)-vlb(1))/5;
for i1=[vlb(1)+stp1 vub(1)-stp1],
  stp2=(vub(2)-vlb(2))/5;
  for i2=[vlb(2)+stp2 vub(2)-stp2],
      x=[i1 i2];
      eval('[f,g,K,Df,X,F]=dlidx(x,G,Ts,X,F);','');
      ct=ct+1,
  end
end

%------------------------------------------------------------------------%

% MINIMIZATION :
x=X(:,1);
x=constr('dlidx',x,options,vlb,vub,[],G,Ts);
[f,g,K,Df,X,F]=dlidx(x,G,Ts,X,F,1);

pack
toc
