function xt=sum60(x)
% xt=sum60(x) for minute's and second's sum :
% x=initial time : x(1) = min, x(2) = sec. 
% ( or min.sec both with two digit, if x is 1by1 )
% prompts for other times and sums them until 
% a vector 1by1 or 1by2 2by1 is entered.  
% xt = total time.

%clc
s=0;
xt=[0 0];

c=0;
while 1

    if size(x,1)*size(x,2)==2;
	c=c+1;
    elseif size(x)==[1 1];
	x=[fix(x) 100*(x-fix(x))];
	c=c+1;
    else 
	x=[0 0];
	break
    end

    s=s+x(1)+x(2)/60;

    xt=[ fix(s) 1e-4*round(1e4*60*(s-fix(s)))];
    disp(' ')
    disp([ 'Total time = ' num2str(xt(1)) ' min. & ' num2str(xt(2)) ' sec.' ]);

    x=input([ 'Inserisci il tempo n° ' num2str(c) ' : ' ]);


end
