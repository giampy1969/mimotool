function [fr,sp,dfr,dsp]=ff2vm(ff)

% [fr,sp,dfr,dsp]=ff2vm(ff) converts ff in the frequency function format
% (ident tbx) into four varying matrices (mutools tbx) fr,sp,dfr,dsp  
% containing frequency responses, output noise power spectral density,
% and their standard deviations.
% 
% Example:
% [a,b,c,d]=unpck(bilins2z(sysrand(4,2,3,1),1));
% th0=ms2th(modstruc(a,b,c,d,zeros(size(c'))),'d');
% ff=th2ff(th0);fr=ff2vm(ff);ff2=vm2ff(fr);
% norm(phasefix(ff)-phasefix(ff2),1)

% G. Campa 22/11/96

rf=size(ff,1);

mn=min(ff(1,:));
mx=max(ff(1,:));
no=fix(mx/1000)+1;
ni=rem(mx-(no-1)*1000,100);

w=ff(2:rf,find(ff(1,:)==mx));

V=[];
D=[];
V0=[];
D0=[];

for i=1:no,
for j=mn:ni,

   wx=ff(2:rf,find(ff(1,:)==(i-1)*1000+100+j));
   if max(abs(w-wx))>0,
   disp('ff2vm warning : different frequency vectors');
   end

   if j==0,

   V0=[V0 ff(2:rf,find(ff(1,:)==(i-1)*1000+j))];
   D0=[D0 ff(2:rf,find(ff(1,:)==(i-1)*1000+50+j))];

   else

   m=ff(2:rf,find(ff(1,:)==(i-1)*1000+j));
   p=pi*ff(2:rf,find(ff(1,:)==(i-1)*1000+20+j))/180;
   [x,y]=pol2cart(p,m);
   V=[V x+y*sqrt(-1)];

   md=ff(2:rf,find(ff(1,:)==(i-1)*1000+50+j));
   pd=pi*ff(2:rf,find(ff(1,:)==(i-1)*1000+70+j))/180;
   [xd,yd]=pol2cart(pd,md);
   D=[D xd+yd*sqrt(-1)];

   end

end
end

if size(V)>0,fr=vpck(reshape(V',ni,no*(rf-1))',w);end
if size(V0)>0,sp=vpck(reshape(V0',1,no*(rf-1))',w);end
if size(D)>0,dfr=vpck(reshape(D',ni,no*(rf-1))',w);end
if size(D0)>0,dsp=vpck(reshape(D0',1,no*(rf-1))',w);end
