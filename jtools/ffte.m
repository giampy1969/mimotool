function fre=ffte(y,u,n)

% fre=ffte(y,u,n) very rough fft based transfer function estimate
% Each column of y,(u) contains the story of the related output,(input).
% n is the number of points in the fft, default n is size(y,1)
% the final fre is the frequency function estimate (varying matrix).
% Example:
% [b1,a1]=butter(4,.3);[b2,a2]=butter(3,.1);u=rand(200,3);
% y=[filter(b1,a1,u(:,1)) filter(b2,a2,u(:,1))];
% fr=ffte(y,u);vplot('bode',fr);

% G.Campa 11/12/96

ni=size(u,2);
no=size(y,2);
if nargin<3, n=size(y,1); end

Y=fft(y,n);
U=fft(u,n);
n=ceil(n/2);

M=zeros(no*n,ni);

for k=0:1:n,
M(k*no+[1:no],:)=(pinv(U(1+k,:))*Y(1+k,:)).';
end

fre=vpck(M,0:pi/n:pi);
