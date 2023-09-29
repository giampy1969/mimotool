function out = norm3(matin,p)

% Identical to MuTools's VNORM command, but
% NORM3 replaces inf with 1/eps and nan with zeros.
% It could be replaced with vnorm in 5.2 jtools version.
% See also: COND, EIG, SVD, VCOND, VEIG, and VNORM.

 if nargin == 0
   disp('usage: out = norm3(matin,p)');
   return
 end
 [mtype,mrows,mcols,mnum] = minfo(matin);
 if nargin == 1
   p = 2;
 end
 if mtype == 'cons'
   out = norm(infnan2x(matin),p);
 elseif mtype == 'vary'
   npts = mnum;
   nrout = mnum;
   ncout = 2;
   out = zeros(npts+1,2);
   ff = (npts+1)*mrows;
   pt = 1:mrows:ff;
   ptm1 = pt(2:npts+1)-1;
   for i=1:npts
     out(i,1) = norm(infnan2x(matin(pt(i):ptm1(i),1:mcols)),p);
   end
   out(1:npts,2) = matin(1:npts,mcols+1);
   out(npts+1,1) = npts;
   out(npts+1,2) = inf;
 elseif mtype == 'syst'
   error('NORM3 is undefined for SYSTEM matrices');
   return
 else
   out = [];
 end
