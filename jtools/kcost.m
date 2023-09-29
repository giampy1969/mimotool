function [f,g]=kcost(x,mv,gf,pstr,cost);

% [f,g]=kcost(x,mv,gf,pstr,cost); Cost function evaluation
% f is a quality index of the controller, which should be 
% minimised over x, g is a constraint to be kept < 0.
% mv and gf are output from the function keval (see keval help)
% for the meaning of pstr, and for all general informations
% on the use of the function see the file khelps.m
  
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ %
% VARIABLES USED (TO BE CHANGED IF NEEDED).

% if pstr contains 'm' then
% x(1)        = Mmax(0) (decibel).
% 10^x(2)     = Mmax(jw) pole freq. (rad/sac);
% else if pstr contains 't' then
% x(1)        = Tmax(0) (decibel).
% 10^x(2)     = Tmax(jw) pole freq. (rad/sac);

% mv(6,1)     = min ratio SoW/So over w
% mv(7,1)     = min ratio MoW/Mo over w
% mv(8,1)     = min ratio ToW/To over w
% mv(11,1)    = min ratio diag(MoW,SoW)/mu[Mo Mo;So So] over w
% mv(12,1)    = min ratio diag(ToW,SoW)/mu[To To;So So] over w
% gf/mf       = final gamma/mu value

% 1/mv(18,1)  = inverse min det(I+GK)
% mv(15,1)    = max output gain margin
% mv(17,1)    = output phase margin
% mv(21,1)    = max control signal value.

% mv(19,1)    = max real part of closed loop poles in closed loop plant.
% mv(20,1)    = magnitude of higher frequency pole in closed loop plant.
% mv(23,1)    = max overshoot of step responses in closed loop plant.
% mv(22,1)    = max settling time of step responses in closed loop plant.
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ %

% INDEX VECTOR :

t=any(pstr=='t');
q=[      x(1);       x(2); ...
      mv(6,1);  mv(7+t,1);   mv(11+t,1);         gf; ...
   1/mv(18,1);   mv(15,1);     mv(17,1);   mv(21,1); ...
     mv(19,1);   mv(20,1);     mv(23,1);   mv(22,1)];

% COST FUNCTION TO BE MINIMIZED :
f=[   0,              0, ...
      0,              0,         0,          0, ...
      cost(1),        0,         0,          0, ...
      0,        cost(2),   cost(3),     cost(4)]*q;

% CONSTRAIN TO BE < 0 :
g=[1e-2-mv(22,1);mv(22,1)-1e3;1e5*mv(19,1)];
