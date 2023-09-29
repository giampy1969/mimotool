function r=infnan2x(m,infval,nanval)

% r=infnan2x(m,infval,nanval);
% r is equal to m except that it has all infs replaced with the value 
% infval, (default 1/eps), and all nans with the value nanval, (default 0).

if nargin<3,nanval=0;end
if nargin<2,infval=1/eps;end
r=m;

[in,jn,vn]=find(isnan(r));
[ii,ji,vi]=find(isinf(r));

if min(size(in))>0, for k=1:size(in,1);r(in(k),jn(k))=nanval;end, end
if min(size(ii))>0, for k=1:size(ii,1);r(ii(k),ji(k))=infval;end, end
