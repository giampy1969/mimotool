function P=pmaker(G,str)

% P=pmaker(G,str); creates an lft control structure for synthesis use.
% G is the system and str is a string specifying the structure of P.
% 
% The first letter of str is a number from '0' to '9' indicating how 
% many integrator blocks must be placed on the minimun size side of G,
% i.e. if no <= ni, we will consider an augmented Ga = (1/s)^n * Io * G,
% otherwise we will consider Ga = G * Ii * (1/s)^n .
% 
% The final plant P is such that P22 = Ga (from control to control),
% while P11 is specified by the last two letters of string str :
% str([2 3])=='tf' : full P11 with Si,Ti,To,So along its main diagonal.
% str([2 3])=='ts' : square P11 = [To To; So So];
% str([2 3])=='tr' : rectangular P11 = [To;So];
% str([2 3])=='mf' : full P11 with Si,Mi,Mo,So along its main diagonal.
% str([2 3])=='ms' : square P11 = [Mo Mo; So So];
% str([2 3])=='mr' : rectangular P11 = [Mo;So];
% where So=inv(I+GK), Si=inv(I+KG), Mo=KSo, Mi=GSi, To=GKSo, Ti=KGSi.
% In any case, the matrices on the diagonal of P11 are those measured
% when the integrators are considered as a part of the controller.
% 
% If str([2 3])=='ab' then P11 has z=d(x2)/dt as input and [x;u] 
% as output, where G is partitioned to have B=[0;B2].
% 
% Eventually, if str has only the first letter : P11=[] => P=Ga.

% G.Campa 22/08/98

if nargin<2 | isempty(str), str='0tr'; end
[ty,no,ni,ns]=minfo(G);

% input and output integrator blocks
n=str2num(str(1));nm=min(no,ni);P=G;
Ibs=pck(zeros(nm),eye(nm),eye(nm),zeros(nm));
if ni<no, Ibi=Ibs;Ibo=eye(no); else Ibi=eye(ni);Ibo=Ibs; end
for k=1:n, P=mmult(Ibo,P,Ibi); end

if (size(str,2)~=3 & size(str,2)~=1) | (size(str,2)==1 & isempty(str2num(str))),
  error('second argument unknown, please read pmaker help');

elseif size(str,2)==1 & ~isempty(str2num(str)),
  % str is a one digit integer, just skip the other choices

elseif str([2 3])=='tf',

  % T full block plant (P11=[Si Si Mo Mo; Ti Ti Mo Mo; Mi Mi To To; Mi Mi So So])
  s_in=[zeros(2*no+ni,2*ni) eye(2*no+ni);eye(ni) eye(ni) zeros(ni,2*no) eye(ni)];
  s_G=abv(eye(2*no+2*ni),mmult([eye(no);eye(no)],P,[zeros(ni,2*no+ni) eye(ni)]));
  s_out=[daug(zeros(ni,no),[zeros(ni,no) eye(ni); zeros(no,no+ni)]) ...
         daug(eye(ni),[zeros(ni,2*no); eye(no) zeros(no)]);...
        [eye(no);eye(no)]*[eye(no) eye(no) zeros(no,2*ni+no) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);

elseif str([2 3])=='ts', 

  % T square output plant 
  s_in=eye(2*no+ni);s_G=daug(eye(2*no),mmult([eye(no);eye(no)],P));
  s_out=[zeros(no,2*no) eye(no) zeros(no);...
        [eye(no);eye(no)]*[eye(no) eye(no) zeros(no) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);

elseif str([2 3])=='tr',

  % T rectangular output plant
  s_in=eye(no+ni);s_G=daug(eye(no),mmult([eye(no);eye(no)],P));
  s_out=[zeros(no) eye(no) zeros(no);...
        [eye(no);eye(no)]*[eye(no) zeros(no) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);

elseif str([2 3])=='mf',

  % M full block plant (P11=[Si Si Mo Mo; Mi Mi To To; Ti Ti Mo Mo; Mi Mi So So])
  s_in=[zeros(2*no+ni,2*ni) eye(2*no+ni);eye(ni) eye(ni) zeros(ni,2*no) eye(ni)];
  s_G=abv(eye(2*no+2*ni),mmult([eye(no);eye(no)],P,[zeros(ni,2*no+ni) eye(ni)]));
  s_out=[daug(zeros(ni,no),zeros(no),eye(ni)) daug(eye(ni),eye(no),zeros(ni,no));...
       [eye(no);eye(no)]*[eye(no) eye(no) zeros(no,2*ni+no) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);

  for k=1:n,
      P=sderiv(P,ni+[1:no],[1 0]);P=mmult(daug(eye(ni+no),...
      pck(zeros(ni),eye(ni),eye(ni),zeros(ni)),eye(2*no)),P);
  end

elseif str([2 3])=='ms',

  % M square output plant
  s_in=[eye(2*no+ni);zeros(ni,2*no) eye(ni)];s_G=daug(eye(2*no+ni),P);
  s_out=[zeros(ni,2*no) eye(ni) zeros(ni,no);...
        [eye(no);eye(no)]*[eye(no) eye(no) zeros(no,ni) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);

  for k=1:n,
    P=mmult(daug(pck(zeros(ni),eye(ni),eye(ni),zeros(ni)),eye(2*no)),P);
  end

elseif str([2 3])=='mr',

  % M rectangular output plant
  s_in=[eye(no+ni);zeros(ni,no) eye(ni)];s_G=daug(eye(no+ni),P);
  s_out=[zeros(ni,no) eye(ni) zeros(ni,no);...
        [eye(no);eye(no)]*[eye(no) zeros(no,ni) -eye(no)] ];
  P=mmult(s_out,s_G,s_in);
  for k=1:n,
    P=mmult(daug(pck(zeros(ni),eye(ni),eye(ni),zeros(ni)),eye(2*no)),P);
  end

elseif str([2 3])=='ab',

  % Vsc-like form
  [a,b,c,d]=unpck(G);[A,B,C,T,m]=ctrbf(a,b,c);m=m(1);B2=B(ns-m+1:ns,:);
  s_in=[zeros(ni,m) eye(ni); eye(m) B2];
  s_G=daug(eye(ni),pck(A,[zeros(ns-m,m);eye(m)],eye(ns),zeros(ns,m)));
  s_out=[eye(ni+ns);-d -C];
  P=mmult(s_out,s_G,s_in);
  for k=1:n,
    P=mmult(daug(eye(ni+ns),Ibo),P,daug(eye(m),Ibi));
  end

else
  error('second argument unknown, please read pmaker help');
end
