function ff=vm2ff(fr,sp,dfr,dsp)

% ff=vm2ff(fr,sp,dfr,dsp) converts four varying matrices (mutools tbx) 
% fr,sp,dfr,dsp containing frequency response, output noise power
% spectral density, and their standard deviations, into matrix ff
% in the frequency function format (ident tbx).
% 
% Example:
% [a,b,c,d]=unpck(bilins2z(sysrand(4,2,3,1),1));
% th0=ms2th(modstruc(a,b,c,d,zeros(size(c'))),'d');
% ff=th2ff(th0);fr=ff2vm(ff);ff2=vm2ff(fr);
% norm(phasefix(ff)-phasefix(ff2),1)

% G. Campa 22/11/96

ff=[];
if nargin<4,dsp=[];end
if nargin<3,dfr=[];end
if nargin<2,sp=[];end

fr=sortiv(fr);[ty1,no1,ni1,np1]=minfo(fr);
sp=sortiv(sp);[ty2,no2,ni2,np2]=minfo(sp);
dfr=sortiv(dfr);[ty3,no3,ni3,np3]=minfo(dfr);
dsp=sortiv(dsp);[ty4,no4,ni4,np4]=minfo(dsp);

if np1>0 ,if np1~=128 | fr(1,ni1+1)<=0,
wmx=fr(np1,ni1+1);fr=vinterp(fr,frsp(1,wmx/128:wmx/128:wmx),1);
end,end

if np2>0 ,if np2~=128 | sp(ni2+1,1)<=0,
wmx=fr(np2,ni2+1);sp=vinterp(sp,frsp(1,wmx/128:wmx/128:wmx),1);
end,end

if np3>0 ,if np3~=128 | dfr(ni3+1,1)<=0,
wmx=fr(np3,ni3+1);dfr=vinterp(dfr,frsp(1,wmx/128:wmx/128:wmx),1);
end,end

if np4>0 ,if np4~=128 | dsp(ni4+1,1)<=0,
wmx=fr(np4,ni4+1);dsp=vinterp(dsp,frsp(1,wmx/128:wmx/128:wmx),1);
end,end

if no1*ni1>0,
for i=1:no1,
for j=1:ni1,

[xy,rp,w]=vunpck(sel(fr,i,j));
[p,m]=cart2pol(real(xy),imag(xy));
ff=[ff [(i-1)*1000+100+j;w] [(i-1)*1000+j;m] [(i-1)*1000+20+j;180*unwrap(p)/pi] ];

end
end
end

if no2*ni2>0,
for i=1:no2,

[m,rp,w]=vunpck(sel(sp,i,1));
ff=[ff [(i-1)*1000+100;w] [(i-1)*1000;m] ];

end
end

if no3*ni3>0,
for i=1:no3,
for j=1:ni3,

[xy,rp,w]=vunpck(sel(dfr,i,j));
[p,m]=cart2pol(real(xy),imag(xy));
ff=[ff [(i-1)*1000+50+j;m] [(i-1)*1000+70+j;180*unwrap(p)/pi] ];

end
end
end

if no4*ni4>0,
for i=1:no4,

[m,rp,w]=vunpck(sel(dsp,i,1));
ff=[ff [(i-1)*1000+50;m] ];

end
end
