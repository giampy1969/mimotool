function d = days(t1,t2)
%DAYS	Convert any time representation to a DAYS scalar value.
%	MATLAB works with three different representations of time.
%	   DAYS      scalar        728431.75
%	   DATE      string        '17-May-1994, 18:00:00'
%	   CLOCK     vector        [1994 5 17 18 0 0]
%
%	DAYS(T) converts any of the three representations to a DAYS scalar
%	value, which is the elapsed time, in units of days, from an origin
%	roughly 2000 years ago, on the day before January first of year 0.
%	DAYS(T) is like a "continuous" function of time which takes on
%	integer values at midnight of each day.  Leap years, calendar months
%	and negative values of T are all handled correctly.
%
%	The statement
%	    days julian
%	causes subsequent calculations to use Julian Days, which has an
%	origin over 4700 years earlier, at noon on Nov. 23 of year "-4713".
%	This is the last time the solar cycle, the lunar cycle and the Roman
%	fiscal year all began on the same day.  In this mode, DAYS(T) takes
%	on integer values at noon of each day.
%	The statement
%	    days zero
%	restores the origin to the point where DAYS([0 0 0 0 0 0]) is 0.0.
%
%	DAYS(T1,T2), with two arguments in any of the three representations,
%	is the same as DAYS(T2) - DAYS(T1), which is the number of days from
%	T1 to T2.  This is negative if T2 represents an earlier time than T1.
%
%	DAYS, with no input arguments, converts the current CLOCK to a DAYS
%	scalar value.
%
%	Examples: Let d = 'Dec-24-1984', c = [1984 12 24 18 0 0]
%	    Then, with days('zero'),
%	    days(d) is 725000.00, days(c) is 725000.75 
%	    
%	    And, with days('julian'),
%	    days(d) is 2446058.50, days(c) is 2446059.25
%	    
%	    On any date, the number of days until Christmas is
%	    days(date,'Dec-25')
%	    
%	    The number of days in the 20th century is
%	    days('1/1/1901','1/1/2001') = 36525
%	    This is one more than the number of days in the 19th century,
%	    days('1/1/1801','1/1/1901') = 36524
%	    because 2000 is a leap year, but 1900 is not.
%
%	See also: DATE, CLOCKF, ETIME.


global DaysOrigin
if isempty(DaysOrigin)
   DaysOrigin = 0;
end
if nargin == 2
   d = days(t2) - days(t1);
   return
elseif nargin == 0
   c = clockf;
elseif length(t1) == 1;
   d = t1;
   return
elseif strcmp(lower(t1),'julian')
   DaysOrigin = 1721058.5;
   return
elseif strcmp(lower(t1),'zero')
   DaysOrigin = 0;
   return
elseif isstr(t1)
   c = clockf(t1);
else
   c = [t1 zeros(1,6-length(t1))];
end

dpm = [0 31 28 31 30 31 30 31 31 30 31 30 31];

% result = (365 days/year)*(number of years) + number of leap years ...
%      + days in previous months + days in this month + fraction of a day.
y = c(1);
m = c(2);
while m > 12, m = m-12; y = y+1; end
while m < 0, m = m+12; y = y-1; end
d = c(3);
hms = c(4:6);
d = 365*y + ...
    ceil(y/4)-ceil(y/100)+ceil(y/400) + ...
    sum(dpm(1:m)) + ...
    ((m > 2) & ((rem(y,4) == 0 & rem(y,100) ~= 0) | rem(y,400) == 0)) + ...
    d + DaysOrigin + ...
    hms*[3600 60 1]'/86400;
