function n = mdt(p,n0,q0,t0)

% Macchina di turing : n=mdt(p,n0,q0,t0) , n=stringa 'nastro finale'.
% p = matrice funzionale (ogni riga è una stringa 'quintupla').
% n0=stringa 'nastro', t0=posizione testina, q0=carattere 'stato', (iniziali).
% Vedi 'Teoria della computabilità ... linguaggi formali' ETS 1976.

% Giampiero Campa 23/2/98.

[a,b]=size(n0);
[c,d]=size(p);
if a ~= 1, error('il nastro deve essere una stringa'), end
if d ~= 5, error('la matrice funzionale deve essere n*5'), end
if t0<1 | t0>b, error('posizione iniziale errata'), end

n=n0;q=q0;t=t0;
while 1,

found=0;
for j=1:c,
if p(j,1)==q & p(j,2)==n(t),
	
	n(t)=p(j,3); q=p(j,4);
	
	if p(j,5)=='s' | p(j,5)=='S', t=t-1; 
				      if t<1, t=1; n=[' ',n]; end
	else 			      t=t+1; 
	     			      if t>length(n), n=[n,' ']; end
	end

	found=1; break,
end
end

if found==0, return, end
end