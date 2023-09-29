function G=phasefix(ff)

% G=phasefix(ff), takes ff in frequency function format (ident tbx),
% moves the phase angle in the interval from -pi to pi,
% and then gives in output G with these new angles.
% Typical usage : bodeplot(phasefix([G0 G1 ... ])).
% It is also useful to compare different frequency format 
% matrices as in: norm(phasefix(G1)-phasefix(G2))

% G. Campa 22/11/96

rf=size(ff,1);

mn=min(ff(1,:));
mx=max(ff(1,:));
no=fix(mx/1000)+1;
ni=rem(mx-(no-1)*1000,100);

G=[];

for i=1:no,
for j=mn:ni,

   G=[G ff(:,find(ff(1,:)==(i-1)*1000+100+j))];
   G=[G ff(:,find(ff(1,:)==(i-1)*1000+j))];
   G=[G ff(:,find(ff(1,:)==(i-1)*1000+50+j))];

   if j>0,
   id1=find(ff(1,:)==(i-1)*1000+20+j);
   id2=find(ff(1,:)==(i-1)*1000+70+j);
   G=[G [ff(1,id1); 360*(ff(2:rf,id1)/360-.5-floor(ff(2:rf,id1)/360-.5))-180] ];
   G=[G [ff(1,id2); 360*(ff(2:rf,id2)/360-.5-floor(ff(2:rf,id2)/360-.5))-180] ];
   end

end
end
