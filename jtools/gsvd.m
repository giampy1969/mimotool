function [u1,u2,x,c,s]=gsvd(a,b)

% [u1,u2,x,c,s]=gsvd(a,b) Generalized Singular Value Decomposition
% of matrices A and B. The two matrices must have the same number
% of columns and A cannot have more columns than rows.  The
% GSVD is a joint decomposition of the form
%             U1'*A*X = C  and  U2'*B*X = S
% where X is nonsingular and U1 and U2 are orthogonal matrices.
% C and S are diagonal matrices (not necessarily square) whose
% diagonal entries are nonnegative. Furthermore the diagonal
% entries of C are in nondecreasing order and
%          C'* C + S'* S = I
% ( Submitted by S. J. Leon )

[q,d,z]=svd([a;b],0);
[m,n]=size(a);[p,n]=size(b);
q1=q(1:m,:);q2=q(m+1:m+p,:);
[u1,u2,v,c,s]=csd(q1,q2);
x=z*(d\v);

