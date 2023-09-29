function stk=ins(stk,var,pos)

% stk=ins(stk,var,pos) insert var into the stack
% variable stk at the position given by pos and gives on 
% output the new value of stk which contains var.
% stk is a stack variable organized as:
% 
%       [a1 b1 ... an bn 0            ...                  0 ]
% stk = [n reshape(var1,1,a1*b1)  ...  reshape(varn,1,an*bn) ]
% 
% if pos is not specified, then by default the variable is 
% inserted in the last position of the stack (pos=n+1).
%
% var can then be recovered using:
% [var,stk]=extract(stk,pos) or var=reach(stk,pos)

% G.C. 13/5/97

[a,b]=size(var);

if size(stk,1)==2,
  % stack not empty

  % number of variables in stack
  n=stk(2,1);

  %  controls on pos
  if nargin<3,pos=n+1;end
  if pos>n+1, pos=n+1;
  elseif pos<1, pos=1;
  end

  % data from 1 to pos
  abv1=stk(1,1:2*(pos-1));
  eve1=2:2:2*(pos-1);odd1=eve1-1;
  blw1=stk(2,1+[1:sum(abv1(odd1).*abv1(eve1))]);

  pnt=abv1(odd1)*abv1(eve1)';
  if ~all(size(pnt)), pnt=0; end

  % data from pos to n
  abv2=stk(1,2*pos-1:2*n);
  eve2=2:2:2*(n-pos+1);odd2=eve2-1;
  blw2=stk(2,1+pnt+[1:sum(abv2(odd2).*abv2(eve2))]);

else 
  n=0;
  abv1=[];abv2=[];
  blw1=[];blw2=[];
end

above=[abv1 a b abv2];
below=[n+1 blw1 reshape(var,1,a*b) blw2];

% fullfill with zeros the ending unused space
l1=size(above,2);
l2=size(below,2);
if l2>l1,stk=[above zeros(1,l2-l1); below];
else stk=[above; below zeros(1,l1-l2)];
end
