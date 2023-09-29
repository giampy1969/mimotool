function [v,w,m,d]=f3np1(n1,n2)

% "3n+1" iterations problem from number theory
% IN:  n1,n2 1*1 >0 integers (solve problem for integers from n1 to n2)
% OUT: v (n2-n1)*1 >0 integers (iterations for each number) 
% OUT: w (n2-n1)*1 >0 integers (max value reached for each number) 
% OUT: m (n2-n1)*1 >0 integers (mean value for each number) 
% OUT: d (n2-n1)*1 >0 integers (std. deviation for each number)
% SEF: none

% Giampiero Campa 18-12-93

p=[];
n1=abs(n1);
n2=abs(n2);
v=zeros(1+n2-n1,1);
w=zeros(1+n2-n1,1); 
m=zeros(1+n2-n1,1);

for k=n1:1:n2,

n=k;
while n>1
	p=[p,n];
	
	if rem(n,2)==0 n=n/2;
	else           n=3*n+1;
	end
end
v(1+k-n1,1)=length(p);
w(1+k-n1,1)=max(p);
m(1+k-n1,1)=mean(p);
d(1+k-n1,1)=std(p);
p=[];

end

