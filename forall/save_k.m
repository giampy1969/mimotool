function save_k
%SAVE CONTROLLER 
%
%     save_k
%
%Callback associata al comando "save controller" del menu file:
%salva nella directory ..\model\control le variabili relative
%al controllore : stack.evaluation e stack.simulation
%
%
% Massimo Davini 13/05/99 --- revised 17/02/00
 
 
global stack;

% save files that are compatible with older versions
vrs=version;if str2num(vrs(1:3)) >= 7, svopt='-v6'; else svopt=''; end

p_0=cd;      %directory di ritorno

mvt_path=which('mimotool.m');
mvt_path=mvt_path(1:length(mvt_path)-10);
cd([mvt_path,'model\control']);

[file path]=uiputfile(sprintf('reg_%s',stack.general.model),'Save controller');
if isstr(file) & isstr(path); 
     stack.evaluation.model=stack.general.model;
     
     evaluation_var=stack.evaluation;
     simulation_var=stack.simulation;
     if isfield(stack.evaluation,'grafici') 
        evaluation_var.grafici=[];
     end;
     save([path file],'evaluation_var','simulation_var',svopt);
     stack.general.K_flag=0;
end;
cd(p_0); 
