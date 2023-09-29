% File khelps.m
% This file contains details on the arguments of the following functions :
% 
% [K,x]=kopt(G,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi);
% [f,g,K,X,F]=kmaker(x,G,str,pstr,wstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
% 
% [f,g,K,X,F]=kman(G,str,pstr,kstr,cost,lrg,bMo,bMi,bTo,bTi,X,F);
% 
% P=pmaker(G,str);
% [Po,Pi,mv]=keval(G,K,str,w);
% [f,g]=kcost(x,mv,gf,pstr,cost);
% 
% kopt   is the main function, which calls the other ones and 
%        performs an optimisation of K with respect to x.
% kmaker creates a the controller related to the variable x.
% 
% kman   creates a controller allowing manual shaping of
%        the weighting functions.
% 
% Since the kopt optimisation can take a long time, it is often
% appropriate to use directy kmaker or kman to create a controller.
% 
% The following three functions are used internally and could
% be skipped in a first reading, while keval is very useful
% for general evaluation purposes.
% 
% pmaker creates an lft control structure for synthesis use.
% keval  evaluates the overall behaviour of a linear controller K,
%        it can be used separately from the other functions, and
%        it has a separate help.
% kcost  gives as output a quality index related to the controller K.
% 
% 
% WHAT are G and K ? 
% --------------------------------------------------------------------------------- %
% G is the system to be controlled, with no augmentation. 
% K is the controller to be connected  as a negative 
% output to input feedback on G (u=-Ky).
% 
% 
% WHAT ARE f AND g ? 
% --------------------------------------------------------------------------------- %
% f is a quality index of the controller, which should be 
% minimised over x, g is a constraint to be kept < 0.
% The computation of f and g, which involve the vector cost, 
% is enclosed in the function kcost, so both f and g can easily
% be modified changing the value of cost or editing the file kcost.m
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS cost ? 
% --------------------------------------------------------------------------------- %
% cost is a four elements vector which is used in kcost to create f,
% specifically, cost(1) multipilies the inverse of min det(I+GK),
% and for what concerns the closed loop plant results,
% cost(2) multiplies the magnitude of its higher frequency pole,
% cost(3) multiplies its maximum overshoot,
% and cost(4) multiplies its maximum settling time.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS str ? 
% --------------------------------------------------------------------------------- %
% str is a string used by keval, (see keval help for more details).
% If str contains 'p', Po and Pi will be analysed, where 
% Po is the closed loop system from control input to plant output,
% and Pi is the closed loop system from plant input to plant output.
% If str contains 'd' data and plots related to Pi and Po will be shown.
% If str contains 'm' performance robustness will be analysed by mean
% of mu{blk} values of several sensitivity matrices (it may be long).
% 
% By default str is 'p'. 
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS pstr (Plant STRing) ? 
% --------------------------------------------------------------------------------- %
% pstr is a string used by pmaker, (see pmaker help for more details).
% The first letter of pstr is a number from '0' to '9' indicating how 
% many integrator blocks must be placed on the minimun size side of G,
% i.e. if no <= ni, we will consider an augmented Ga = (1/s)^n * Io * G,
% otherwise we will consider Ga = G * Ii * (1/s)^n .
% 
% The unweighted plant P is such that P22 = Ga 
% (P22 is the transfer function seen by the controller),
% while P11 is specified by the last two letters of string pstr :
% pstr([2 3])=='tf' : full P11 with Si,Ti,To,So along its main diagonal.
% pstr([2 3])=='ts' : square P11 = [To To; So So];
% pstr([2 3])=='tr' : rectangular P11 = [To;So];
% pstr([2 3])=='mf' : full P11 with Si,Mi,Mo,So along its main diagonal.
% pstr([2 3])=='ms' : square P11 = [Mo Mo; So So];
% pstr([2 3])=='mr' : rectangular P11 = [Mo;So];
% where So=inv(I+GK), Si=inv(I+KG), Mo=KSo, Mi=GSi, To=GKSo, Ti=KGSi.
% In any case, the matrices on the diagonal of P11 are those measured
% when the integrators are considered as a part of the controller.
% 
% If pstr([2 3])=='ab' then P11 has z=d(x2)/dt as input and [x;u] 
% as output, where G is partitioned to have B=[0;B2].
% 
% Eventually, if pstr has only the first letter : P11=[] => P=Ga.
% 
% By default pstr is '0tr'.
% --------------------------------------------------------------------------------- %
% 
% the above plant is then weighted, by multipling P11 for some 
% weigthing functions, (determined by x and wstr), and then
% the resulting plant is passed to a standard controller computation
% algorithm to calculate the controller which minimises LFT(plant,K)
% 
% 
% WHAT ARE bMo, bMi, bTo, bTi ?
% --------------------------------------------------------------------------------- %
% bMo, bMi, bTo, bTi, are matrices n by 2 describing the uncertainty
% structures on Mo, Mi, To, Ti, see mutools manual for details.
% They affect only the Mu synthesis, and by default is assumed to be
% full and complex, like the uncertainty block relative to Si and So.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS lmr ?
% --------------------------------------------------------------------------------- %
% lmr is a matrix describing the region in the complex plane in which 
% closed loop poles are to be located, this matrix is generated by the
% lmi toolbox function 'lmireg', see the lmi toolbox manual for details.
% This matrix affects only the H-infinity with pole placement synthesis,
% when  empty (default) then the region is automatically selected as the
% intersection between a 2 radians conic sector starting at the origin,
% symmetric with respect to the real axis, and the half plane 
% Re(s) < -1/2*bd where bd is the cutoff frequency of G.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS kstr (controller STRing) ?
% --------------------------------------------------------------------------------- %
% kstr contains the type of control to be applied to the plant, 
% specified by pstr and weighted by x and wstr :
% 
%   Mu synthesis :
%      It founds K which minimises the maximum mu value over frequency
%      of LFT(plant,K), (with respect to an uncertainty block
%      relative to P11 and assembled from the uncertainty blocks
%      relative to Mo, Mi, To, Ti, namely bMo, bMi, bTo, bTi).
%      Note that if the plant is not full or square, since the whole block
%      relative to P11 is full, then Mu synthesis reduces itself to H-inf synt.
%      Note that when the plant is not full or square, since the whole block
%      relative to P11 is full, then Mu synthesis reduces itself to H-inf synt.
%      Warning : Mu synthesis takes a very long time ...
%   Mu synthesis is exploited by the two following strings :
%      'mu2' - uses only the mu tools functions.
%      'mu3' - uses also the lmi toolbox function 'hinfric'.
% 
%   H-infinity synthesis :
%      It founds K which minimises the maximum singular value
%      over frequency (infinity-norm) of LFT(plant,K), 
%   H-infinity synthesis is exploited by the five following strings :
%   Riccati-based approach:
%      'hi1' - uses the robust control toolbox 'hinfopt' function.
%      'hi2' - uses the mu tools 'hinfsyne' function.
%      'hi3' - uses the lmi toolbox 'hinfric' function.
%   Lmi-based approach:
%      'hlm' - uses the lmi toolbox 'hinflmi' function.
%              Warning: this approach is numerically intensive, and 
%              usually takes a longer time than the riccati based one.
% 
%   H-infinity synthesis with pole placement objective:
%      It founds K which minimises the maximum singular value
%      over frequency (infinity-norm) of LFT(plant,K), between
%      all the K that causes the closed loop poles to lie 
%      in a certain region of the complex plane that depends also on x.
%      Warning 1: this additional constraint may cause conflict with 
%      the position of the poles of the weighting functions, so should
%      be used carefully (see lmi control toolbox manual for details).
%   This kind of synthesis is exploited by the string 'hmx'.
%   Warning 2: this uses the general Lmi-based approach, which
%   is rather nurerically intensive, and so it may take a long time.
% 
%   H-2 synthesis :
%      It founds K which minimises the root mean square (2-norm)
%      of the output of LFT(plant,K) with white noise in input.
%   It is exploited by the following string :
%      'h21' - uses the robust control toolbox functions.
%      'h22' - uses the mu tools 'h2syn' function.
%      'h23' - uses the lmi toolbox 'hinfric' function.
% 
%   Lqr synthesis :
%   This type of control involves only the part of the plant
%   seen by the controller: namely A,B2,C2,D22.
%   The controller K is inv(I+k*pinv(C2)*D22)*k*pinv(C2),
%   with k=lqr(A,B2,Q,R) where Q=10^x(1)*I and R=10^x(2)*I 
%   are the well known lqr cost matrices.  When C2=I and D22=0, then
%   this control becames the classical state feedback lqr control.
%   This control is exploited by the string 'lqr'.
% 
%   Pole placement synthesis :
%   This type of control involves only the part of the plant
%   seen by the controller, namely A,B2,C2,D22.
%   The controller K is inv(I+k*pinv(C2)*D22)*k*pinv(C2), where k
%   is the state feedback control that places the eigenvalues of A
%   on the left real axis in the decade 10^x(1) 10^(x(2)+1).
%   When C2=I and D22=0, then this control becames the classical
%   state feedback pole placement control.
%   This control is exploited by the string 'plc'.
% 
%   Lqg synthesis :
%   This type of control implements the classical lqg control on the 
%   the part of plant seen by the controller : A,B2,C2,D22.
%   The controller K is composed by a kalman filter as observer,
%   with matrix L=lqe(A,I,C2,W,V) where W=10^x(2)*I and V=I are the
%   linear quadratic estimator cost matrices, the estimated
%   state is then multiplied by the matrix k=lqr(A,B2,Q,R) where 
%   Q=10^x(1)*I and R=I are the lqr cost matrices, and then feeded back
%   in the plant input. This control is exploited by the string 'lqg'.
% 
% Note that there is no point to use the last two letters of the string
% pstr (i.e. 'tf', 'ab', 'mr') when the control is 'lqg', 'lqr', 'plc',
% because these controls are in no way affected by the other part of the
% plant but P22, therefore the resulting control is the same if the last
% two letters of pstr are present or not and whatever they are.
% 
% By default pstr is 'hi3'.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS x ? 
% --------------------------------------------------------------------------------- %
% x contains two real numbers which determine the tuning of the controller.
% 
% For Lqr and Lqg, synthesis x selects the gains of the relative diagonal
% matrices (Q and R for lqr, Q and W for lqg), see also the kstr section.
% 
% For Pole Placement synthesis, x selects the decade on the negative real axis
% in which the closed loop poles should be placed, see also the kstr section.
% 
% Eventually, for Mu, Hinf, H2 synthesis x and wstr determine the weigthing
% functions shape as shown below:
% 
% If the P11 part of the plant contains complementary sensitivity,
% ( pstr([2 3] is 'tf','ts' or 'tr' ), then the weights are :
% Sensitivity weights : (Si,So)
%   The sensitivities are left-multiplied by square diagonal
%   matrices containing the following stable, minimum-phase 
%   transfer function on their main diagonal:
%   'pole near zero, zero in 10^x(2), and then constant at -x(1) dB'.
% Complementary sensitivity weights : (Ti,To)
%   The complementary sensitivities are left-multiplied by square
%   diagonal matrices containing the following stable, minimum-phase 
%   transfer function on their main diagonal:
%   'constant at -x(1) dB, zero in 10^x(2), and a pole almost at infinity'.
% 
% If the P11 part of the plant contains control sensitivity,
% ( pstr([2 3] is 'mf','ms' or 'mr' ), then the weights are :
% Control sensitivity weights : (Mi,Mo)
%   The control sensitivities are left-multiplied by square diagonal
%   matrices containing the following stable, minimum-phase 
%   transfer function on their main diagonal:
%   'constant at -x(1) dB, zero in 10^x(2), and a pole almost at infinity'.
% Sensitivity weights : (Si,So)
%   The sensitivities are left-multiplied by square diagonal
%   matrices containing the following stable, minimum-phase 
%   transfer function on their main diagonal:
%   'pole near zero, zero in the point where the control sensitivity
%    crosses the 0 dB line, and then constant at -3 dB'.
% 
% x is reuired as input (like G) by kmaker, no default is allowed,
% It is not required by kman since kman only allows manual shaping.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT IS wstr (Weighting STRing) ? 
% --------------------------------------------------------------------------------- %
% The string wstr contains two letters determining the way in which
% the plant is weighted, of course, since the weighting affects only
% the P11 part of the plant, it does not affect the lqr, lqg 
% or pole placement controls.
% 
% The first letter specifies the sensitivity weight: 
%     'a' stands for approximate : is as depicted above in the kstr section
%     'e' stands for exact       : as above but the pole is exactly in zero
%     'c' stands for constant    : at -x(1) dB, or -3 dB, depending on pstr
% 
% The second one specifies the control or complementary sens. weight: 
%     'a' stands for approximate : is as depicted above in the kstr section
%     'e' stands for exact       : as above but there is no pole at all,
%         ( this uses a derivative action, if the resulting system is not proper,
%           then the approximate weighting is used instead of this one )
%     'c' stands for constant    : at -x(1) dB.
% 
% By default wstr is 'ae'.
% It is not required by kman since kman only allows manual shaping.
% --------------------------------------------------------------------------------- %
% 
% 
% WHAT ARE X and F ? 
% --------------------------------------------------------------------------------- %
% X(:,1) = current minimum point, F=max(0,1e5*g(X(:,1)))+f(X(:,1))
% They are used internally by kopt, and could be used if one wants
% to implement his personal kind of optimisation, different from kopt.
% --------------------------------------------------------------------------------- %

% G.Campa 28/12/98
