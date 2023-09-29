function [x,y]=rsk(r,b)

% Simulate risiko battle ,[x,y]=rsk(r,b).
% x,y 1*1 integers , guns lost by red and blue.
% r,b 3*1 integers , roll of red and blue dice results.

% Giampiero Campa 15-1-94

x=0;
y=0;
r=sort(r);
b=sort(b);

for i = 3:-1:1,

if ( b(i,1)==0 | r(i,1)==0 ) ,break, end 
if ( r(i,1) > b(i,1) ) y=y+1;
else x=x+1;
end

end
