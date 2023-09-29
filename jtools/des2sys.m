function s=des2sys(d)

% s=des2sys(d) descriptor (lmi-tbx) to system (mu-tbx)

[A,B,C,D,E]=ltiss(d);IE=inv(E);
s=pck(IE*A,IE*B,C,D);