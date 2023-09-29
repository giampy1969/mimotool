% MimoTool Script file:
% Starts mimotool GUI (Matlab ver 5.3 or higher)
% (The mimotool main folder should be in the Matlab path)
%
% Massimo Davini 12/05/99 --- revised 31/05/00

% modified by giampy, dec 03
% it does not clear the workspace anymore
% revised on march 05 to adapt to matlab 7

versione=version;

% added by giampy on sep-2023 to properly capture version number
vcell = regexp(versione,'\d+\.\d','match');
vnum=str2num(vcell{1});

if vnum < 5.3
    disp(sprintf('\n'))
    disp('  ERROR : Matlab version NOT COMPATIBLE .')
    disp('          MIMOTool is designed for Matlab version 5.3 (or higher) !')
    disp(sprintf('\n'))
    clear versione;
    return;
end

% check if java machine is running
jsz=0;
if vnum > 6,
    if usejava('jvm'),
        jsz=0.2;
    end
end

% versions greater than 7.7 actually require java machine to work
if (vnum > 7.6) & (jsz == 0),
    disp(sprintf('\n'))
    disp('  ERROR : Matlab versions greater than 7.6 (R2008a)')
    disp('          must be used with the java machine enabled')
    disp(sprintf('\n'))
    return;
end

if exist('stack') & isfield(stack,'general')
    disp(sprintf('\n'))
    disp('     ERROR : MIMOTool can have only one active session')
    disp('             at a time for each Matlab command window')
    disp(sprintf('\n'))
    clear versione;
    return;
end;

if isempty(ver('control'))
    disp(sprintf('\n'))
    disp('     ERROR : It''s impossible to run MIMOTool because')
    disp('             of the absence of the Control Toolbox')
    disp(sprintf('\n'))
end;

if vnum > 7
    
    if isempty(ver('robust')),
        disp(sprintf('\n'))
        disp('     ERROR : It''s impossible to run MIMOTool because')
        disp('             of the absence of the Robust Control Toolbox')
        disp(sprintf('\n'))
    end
    
else
    
    % versions before 7 used to have independent control toolboxes
    if isempty(ver('mutools'))|isempty(ver('lmi')),
        if isempty(ver('lmi'))
            if ~isempty(ver('control')) disp(sprintf('\n'));end;
            disp('     ERROR : It''s impossible to run MIMOTool because of')
            disp('             the absence of the LMI Toolbox')
            disp(sprintf('\n'))
        end;
        if isempty(ver('mutools'))
            if ~isempty(ver('control')) & ~isempty(ver('lmi')), disp(sprintf('\n'));end;
            disp('     ERROR : It''s impossible to run MIMOTool because of')
            disp('             the absence of the Mu-Tools Toolbox')
            disp(sprintf('\n'))
        end;
    else
        if isempty(ver('robust'))
            disp(sprintf('\n'))
            disp('     WARNING : Some functionality will be disabled because of')
            disp('               the absence of the Robust Control Toolbox .')
            disp(sprintf('\n'))
        end;
        if isempty(ver('optim'))
            disp(sprintf('\n'))
            disp('     WARNING : The Optimization section will be disabled because')
            disp('               of the absence of the Optimization Toolbox .')
            disp(sprintf('\n'))
        end;
    end;
    
end

clear versione vnum;

%Nuova directory di lavoro.
mvt_path=which('mimotool.m');
mvt_path=mvt_path(1:length(mvt_path)-10);

%Inserisce nel path di Matlab la directory del JTOOLS
%la directory ForAll e la directory Helps
path([mvt_path,'forall'],path);
path([mvt_path,'jtools'],path);
path([mvt_path,'model'],path);
path([mvt_path,'analys'],path);
path([mvt_path,'synthe'],path);
path([mvt_path,'helps'],path);

% directory symbol
if isunix, ds='/'; else ds='\'; end

% synthesis subfolders
path([mvt_path,'synthe' ds 'eig_ass'],path);
path([mvt_path,'synthe' ds 'h'],path);
path([mvt_path,'synthe' ds 'hmix'],path);
path([mvt_path,'synthe' ds 'lq_s'],path);
path([mvt_path,'synthe' ds 'lqg'],path);
path([mvt_path,'synthe' ds 'lqg_ltr'],path);
path([mvt_path,'synthe' ds 'lqr'],path);
path([mvt_path,'synthe' ds 'mfc'],path);
path([mvt_path,'synthe' ds 'mu'],path);
path([mvt_path,'synthe' ds 'pid'],path);

clear mvt_path ds;

mvt_hf=figure('unit','normalized',...
    'position',[.5-.345,.5-.275,.69,.55],...
    'resize','off','selected','on',...
    'CloseRequestFcn','esci;','color',[0.6 0.7 0.9],...
    'NumberTitle','off','menubar','none','visible','off',...
    'Name',' MIMOTool for MIMO LTI Continuous Time dynamical Systems',...
    'Tag','MvMain');

set(mvt_hf,'unit','characters');
mvt_a=get(gcf,'position');
set(gcf,'position',[mvt_a(1),mvt_a(2),95,20]);
set(gcf,'unit','normalized');
set(gcf,'visible','off');

global stack;
stack=struct('general',[],'evaluation',[],'simulation',[],'temp',[]);

stack.general.javasize=jsz;

clear mvt_hf mvt_a jsz;
warning off;
avvio_1;