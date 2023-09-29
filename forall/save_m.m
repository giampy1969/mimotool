function save_m
%SAVE MODEL 
%
%     save_m
%
%Callback associata al comando "save model" del menu file:
%salva le matrici A B C D di un sistema in un file .mat
%nella directory ..\model\modelli
%
%
% Massimo Davini 13/05/99 --- revised 17/02/00

global stack;

A=stack.general.A;
B=stack.general.B;
C=stack.general.C;
D=stack.general.D;

% save files that are compatible with older versions
vrs=version;if str2num(vrs(1:3)) >= 7, svopt='-v6'; else svopt=''; end

p_0=cd;      %directory di ritorno

mvt_path=which('mimotool.m');
mvt_path=mvt_path(1:length(mvt_path)-10);
cd([mvt_path,'model\modelli']);
[file path]=uiputfile(sprintf('%s',stack.general.model),'Save model');
if isstr(file) & isstr(path); 
     nfile=[path file]; 
     save(nfile,'A','B','C','D',svopt);
     oldmod=stack.general.model;
     titolo=get(gcf,'name');
     titolo=titolo(1:length(titolo)-length(oldmod));
     
     if length(file)>4
       if (strcmp(file(length(file)-3:length(file)),'.mat')==0)
          file=[file,'.mat'];
       end;
     else file=[file,'.mat']; end;

     new=[titolo,file];
     set(gcf,'name',new);
     
     stack.general.model=file;   %nome modello
     stack.general.M_flag=0;       %flag di creazione
end;
cd(p_0);