% MIMO Tool : Jtools
% Version 2.2.1 (R11.1,R2009a)  02-Apr-2005
% 
% ---------- OPTIMAL CONTROLLERS -------------------------------
% 
% khelps   : details on kopt,kmaker,pmaker,kcost,kman
% 
% kopt     : controller optimization
% kcost    : controller cost function
% 
% kmaker   : automatic controller synthesis
% pmaker   : weighted plant construction
% 
% keval    : controller evaluation, output to input feedback
% keval2   : controller evaluation,  state to input feedback
% keval3   : controller evaluation, output to state feedback
% 
% kman     : controller optimization with manual shaping
% 
% dlopt    : discrete lqg optimal controller
% dlidx     : subroutine
% 
% musynl   : mu syntesis (batch function using lmi tools)
% musyne   : mu syntesis (batch function using mu tools)
% h2synr   : same as mu tools h2syn using robust control tbx
% hinfsynr : same as mu tools hinfsyn using robust control tbx
% 
% stdc     : inversion based static decoupling control
% 
% lqrt     : finite time lqr
% 
% 
% ---------- GAIN SCHEDULING -----------------------------------
% 
% gsc      : polynomial gain scheduling controller computation
% gsk      : polynomial controller s-function
% gsg      : polynomial system s-function
% 
% 
%  --------- SCALING -------------------------------------------
% 
% sclopt   : optimal scaling
% 
% sclidx   :
% sclgap   : subroutines
% 
% 
%  --------- INTERPOLATION -------------------------------------
% 
% inter    : polinomial interpolation
% iidx     : subroutine
% 
% 
%  --------- IDENTIFICATION ------------------------------------
% 
% arx4     : arx MIMO system identification
% rarx4    : recursive arx MIMO system identification
% 
% thfix    : fix the theta model to a certain number of states
% 
% phasefix : move phase angles between -pi and pi
% 
% ff2vm    : frequency format to varying matrices
% vm2ff    : varying matrices to frequency format
% 
% fre4sys  : sys fitting from frequency response
% ffte     : fft based transfer function estimate
% 
% 
%  --------- LINEAR ALGEBRA ------------------------------------
% 
% gram2    : ctrb gramian with a robust algorithm
% gramcr   : cross ctrb-obsv gramian with the above algorithm
% gram3    : ctrb gramian with a pseudo-inverse algorithm
% 
% gsvd     : generalized singular value decomposition
% 
% norm3    : like vnorm but avoids inf and nan
% 
% 
%  --------- SYSTEMS ------------------------------------------
% 
% sysinfo  : all info on a continuous time system
% 
% reds     : several model reductions
% sys2sys  : transformation, balancing, truncation and so on.
% sysbal3  : like sysbal but avoids inf and nans.
% 
% des2sys  : descriptor to system
% m2c      : mutools system to control toolbox system
% c2m      : control toolbox system to mutools system
% 
% tfdraw   : draw a square diagonal transfer function
% fotf     : create a first order square diag tf
% 
% laguerre : laguerre transfer function step response
% 
% 
%  --------- R3 SPACE -----------------------------------------
% 
% t2x      : transformation matrix to generalized position
% x2t      : generalized position to transformation matrix
% m2m      : generalized mass-inertia tensor transformation
% 
% 
%  --------- INTEGRATION --------------------------------------
% 
% ode78    : differential equation integration    (*)
% invlap   : numerical inverse laplace transform  (*)
% 
% 
%  --------- GRAPHICS ------------------------------------------
% 
% azzoel   : puts sliders on current figure
% contoura : 3d contour plot                      (*)
% 
% 
%  --------- AUTOMA --------------------------------------------
% 
% f3np1    : 3n+1 automa problem
% mdt      : turing machine
% 
% 
%  --------- TIME ----------------------------------------------
%  
% sum60    : mins and secs sum
% days     : converts time to number of days      (*)
% clockf   : converts time to a clock vector      (*)
% infcal   : infinite calendar                    (*)
% 
% 
%  --------- OTHER STUFF ---------------------------------------
% 
% ins      : insert matrix into a stack
% xtr      : extract matrix from stack
% 
% keep     : keep some variables and clear others (*)
% mscan    : format m-files (*, excellent)
% 
% infnan2x : replaces all infinities and nans with given values
% 
% ip       : integer programming trial
% chb      : change numerical base
% rsk      : risiko battle
% bach     : tones history varying matrix
% soldi    : on drifting money
% 
% saveppt  : save a picture in powerpoint        (*)
% 
% cockpit  : flight simulator on a surface plot  (*)
% fifteens : game                                (*)
% curve.mdl: quasiperiodic curves designer
% 
% contents : this file
% 
% -------------------------------------------------------------
% (*) = file took from The Mathworks ftp site
% 
% Giampiero Campa, PhD, Research Assistant Professor
% Mechanical & Aerospace Engineering Dept. WVU
% Tel: +1 304 293 4111 x 2313, Fax: +1 304 293 6689
% campa@cemr.wvu.edu; gcampa@dsea.unipi.it

