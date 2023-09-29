function [vt,vf,vs]=bach(nts,str,F)

% [vt,vf,vs]=bach(nts,str,F) sounds and displays notes.
% Each row of nts represents a note and is composed by four terms:
% ottava, tono, start time, finishing time.
%
% If str contains 't' then the function plots the tones versus time,
% and vt is the varying matrix such that vplot(vt) produces the plot.
%
% If str contains 'f' then the function plots the frequencies versus time,
% and out is the varying matrix such that vplot(vf) produces the plot.
%
% If str contains 's' then the function plays the notes, 
% with F as sampling rate,  (default 8192 Hz), the output
% vs is the varying matrix (with time as independent variable)
% such that sound(vunpck(out)) produces the sound.
% Note that because of Shannon theorem only the notes with 
% frequency within F/2 Hz can be correctly reproduced.
%
% If str contains 'q' then is the same as above but 
% no action (sound or plot) is made. 
% Default str is 'qtfs'.

% G. Campa 22/1/97

if nargin<3,F=8192;end
if nargin<2,str='qtfs';end
n=size(nts,1);
vs=[];
vt=[];
vf=[];

if any(str=='t') | any(str=='f'),
n=size(nts,1);
t=min(nts(:,3)):(max(nts(:,4))-min(nts(:,3)))/511:max(nts(:,4));

for k=1:n,
vk=vpck([nan;nts(k,1)*6+nts(k,2);nan;nan],[t(1)-1;nts(k,3);nts(k,4);max(nts(:,4))]);
vt=sbs(vt,vinterp(vk,vpck(t',t),0));
end

if any(str=='t')&~any(str=='q'),figure;vplot(vt);grid;end

if any(str=='f')&~any(str=='q'),
vf=vebe('440.*2.^',vebe('-4.75+6.\',vt));figure;vplot(vf);grid;
end

end

if any(str=='s')
F=max(F,4096);
st=min(nts(:,3)):1/F:max(nts(:,4))-1/F;
sd=zeros(size(st));

for k=1:n,
f=440*2^(nts(k,1)+nts(k,2)/6-4.75);
sd=sd+.25*sin(2*pi*f*st).*(sign(st-nts(k,3))+1).*(sign(nts(k,4)-st)+1);
end

vs=vpck(sd',st);
if any(str=='s')&~any(str=='q'),sound(sd',F);end
end
