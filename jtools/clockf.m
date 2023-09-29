function c = clockf(t)
%CLOCKF	Convert any time representation to a CLOCK vector.
%	MATLAB works with three different representations of time.
%	   DAYS      scalar        728431.75
%	   DATE      string        '17-May-1994, 18:00:00'
%	   CLOCK     vector        [1994 5 17 18 0 0]
%
%	CLOCKF(T) converts any of the three representations to a six element
%	CLOCK vector, [year month date hour mins secs].
%
%	CLOCKF, with no arguments, uses the built-in function CLOCK to obtain
%	the current system time.
%
%	A six element vector used as input to DAYS, DATE or CLOCKF allows a
%	flexible representation.  The components need not be integers.  Any
%	components which are outside their conventional ranges are added to
%	or subtracted from the next higher component.  A zero-th month, with
%	zero days, is allowed.  The output vector produced by CLOCKF always
%	has integer values for the first five components and the last five
%	components are in the ranges implied by the units involved.  
%	
%	Examples: Let
%	    d = '12/24/1984'
%	    t = '725000.00',
%	    c = [1984 12 23 23 59 60]
%	Then clockf(d), clockf(t) and clockf(c) all generate
%	    [1984 12 24 0 0 0]
%
%	The expression  date(days([1901 0 36525*rand 24*rand 0 0])) generates
%	a random date and time, uniformly distributed in the 20th century.

%	See also: DAYS, DATE, CLOCK.


if nargin == 0

   % Use built-in CLOCK to get system time.
   c = clock;

elseif isstr(t)

   % Convert DATE to CLOCK
   % Initially, the six fields are all unknown.

   c = NaN*ones(1,6);
   d = [' ' lower(t) ' '];
   
   % Replace 'a ', 'am', 'p ' or 'pm' with ': '.
   
   p = max(find(d == 'a' | d == 'p'));
   if ~isempty(p)
      if d(p+1) == 'm' | d(p+1) == ' '
         pm = (d(p) == 'p');
         if d(p-1) == ' '
            d(p-1:p+1) = ':  ';
         else
            d(p:p+1) = ': ';
         end
      end
   end
   
   % Any remaining letters must be in the month field; interpret and delete them.
   p = find(isletter(d));
   if ~isempty(p)
      k = min(p);
      if d(k+3) == '.', d(k+3) = ' '; end
      M = ['jan'; 'feb'; 'mar'; 'apr'; 'may'; 'jun'; ...
           'jul'; 'aug'; 'sep'; 'oct'; 'nov'; 'dec'];
      c(2) = find(all((M == d(ones(12,1),k:k+2))'));
      d(p) = setstr(' '*ones(size(p)));
   end
   
   % Find all nonnumbers.
   
   p = find((d < '0' | d > '9') & (d ~= '.'));
   
   % Pick off and classify numeric fields, one by one.
   % Colons delinate hour, minutes and seconds.
   
   k = 1;
   while k < length(p)
      if d(p(k)) ~= ' ' & d(p(k)+1) == '-'
         f = str2num(d(p(k)+1:p(k+2)-1));
         k = k+1;
      else
         f = str2num(d(p(k)+1:p(k+1)-1));
      end
      if ~isempty(f)
         if d(p(k))==':' | d(p(k+1))==':'
            if isnan(c(4))
               c(4) = f;             % hour
               if pm
                  c(4) = f+12;
               end
            elseif isnan(c(5))
               c(5) = f;             % minutes
            elseif isnan(c(6)) 
               c(6) = f;             % seconds
            else
               error(['Too many time fields in ' t])
            end
         elseif isnan(c(2))
            if f > 12
               error([num2str(f) ' is too large to be a month.'])
            end
            c(2) = f;                % month
         elseif isnan(c(3))
            c(3) = f;                % date
         elseif isnan(c(1))
            if (f >= 0) & (p(k+1)-p(k) == 3)
               c(1) = f + 1900;      % year in 20th century
            else
               c(1) = f;             % year
            end
         else
            error(['Too many date fields in ' t])
         end
      end
      k = k+1;
   end

   if sum(isnan(c)) >= 5
      error(['Cannot parse date ' t])
   end
   
   % If year, month or date has not been specified, use today's.
   
   p = find(isnan(c(1:3)));
   if ~isempty(p)
      clk = clock;
      c(p) = clk(p);
   end
   
   % If hour, minutes or seconds has not been specified, set it to zero. 
   
   p = find(isnan(c));
   if ~isempty(p)
      c(p) = zeros(1,length(p));
   end

elseif length(t) == 1

   % Convert scalar DAYS to CLOCK.

   dpm = [31 28 31 30 31 30 31 31 30 31 30 31];
   global DaysOrigin
   if isempty(DaysOrigin)
      DaysOrigin = 0;
   end
   t = t - DaysOrigin;

   % If necessary, make t positive.
   % Shift by an integer multiple of 400 years, which is p days.
   p = 400*365+97;
   shift = max(0,ceil(-t/p));
   t = t + shift*p;

   % Now convert to seconds, then peel off components.

   t = 86400*t;                % seconds.
   c(6) = rem(t,60);
   t = floor(t/60);            % minutes.
   c(5) = rem(t,60);
   t = floor(t/60);            % hours.
   c(4) = rem(t,24);
   t = floor(t/24);            % days.
   a = 365+97/400;
   y = floor(t/a);             % year
   if t <= 365*y + ceil(y/4)-ceil(y/100)+ceil(y/400)
      y = y - 1;
   end
   t = t - (365*y + ceil(y/4)-ceil(y/100)+ceil(y/400));
   if (rem(y,4) == 0 & rem(y,100) ~= 0) |  rem(y,400) == 0
      dpm(2) = 29;
   end
   m = 1;                      % month
   while t > dpm(m)
      t = t - dpm(m);
      m = m + 1;
   end
   c(1) = y - shift*400;
   c(2) = m;
   c(3) = t;
   
else

   % Use DAYS to normalize input CLOCK format.
   c = clockf(days(t));

end
