function [var,stk]=xtr(stk,pos)

% [var,stk]=xtr(stk,pos) extracts from the stack variable 
% stk at the position given by pos the variable var. 
% The extracted variable var is given as first output argument.
% If a second output argument is required then new value of stk
% (which no more contains var) is returned as the second output.
% 
% stk is a stack variable organized as:
% 
%       [a1 b1 ... an bn 0            ...                  0 ]
% stk = [n reshape(var1,1,a1*b1)  ...  reshape(varn,1,an*bn) ]
% 
% if pos is not specified, then by default the variable extracted
% is the last one (pos=n).
%

% G.C. 13/5/97

if size(stk,1)==2,
  % stack not empty

  % number of variables in stack
  n=stk(2,1);

  %  controls on pos
  if nargin<2,pos=n;end
  if pos>n, pos=n;
  elseif pos<1, pos=1;
  end

  % data from 1 to pos
  abv1=stk(1,1:2*(pos-1));
  eve1=2:2:2*(pos-1);odd1=eve1-1;
  blw1=stk(2,1+[1:sum(abv1(odd1).*abv1(eve1))]);

  pnt=abv1(odd1)*abv1(eve1)';
  if ~all(size(pnt)), pnt=0; end

  % data to be extracted
  sz=stk(1,2*pos+[-1:0]);
  var=reshape(stk(2,1+pnt+[1:sz(1)*sz(2)]),sz(1),sz(2));

  % data from pos+1 to n
  abv2=stk(1,2*(pos+1)-1:2*n);
  eve2=2:2:2*(n-pos);odd2=eve2-1;
  blw2=stk(2,1+pnt+sz(1)*sz(2)+[1:sum(abv2(odd2).*abv2(eve2))]);

else 
  var=[];n=[];
  abv1=[];abv2=[];
  blw1=[];blw2=[];
end

if nargout>1,
  % gives the new value of the stack

  % updates n
  n=n-1;
  if n==0, n=[]; end

  above=[abv1 abv2];
  below=[n blw1 blw2];

  % fullfill with zeros the ending unused space
  l1=size(above,2);
  l2=size(below,2);
  if l2>l1,stk=[above zeros(1,l2-l1); below];
  else stk=[above; below zeros(1,l1-l2)];
  end

end
