function ssc=sclio(sus,fout,fin)

% ssc=sclio(sus,fout,fin) performs output and input scaling
% of system sus with vectors fout and fin

% by Giampiero Campa 25-aug-95

ssc=sus;

for i=1:length(fout);
ssc=sclout(ssc,i,fout(i));
end

for i=1:length(fin);
ssc=sclin(ssc,i,fin(i));
end
