function tbxStruct  = demos

% DEMOS Demo list for MIMOTool.

if nargout==0, demo toolbox; return; end

tbxStruct.Name='MIMO Tool';
tbxStruct.Type='toolbox';

tbxStruct.Help= ...                                             
   {'MIMOTool is a toolbox for Matlab 5.3 developed'
    'within the Department of Electrical Systems and'
    'Automation (DSEA) of the University of Pisa (Italy)'
    'with the aim to offering to the Matlab users '
    '(especially control engineers and control '
    'engineering students) a completely graphical'
    'toolbox for linear system analysis and robust'
    'control synthesis.'
    ' '
    'MIMOTool is not meant to replace the main control'
    'synthesis toolboxes, but instead it relies on them'
    'to yield a single environment in which all their best'
    'capabilities are integrated and easily achieved.' };
 
 tbxStruct.DemoList={
                'MIMOTool', 'MIMOTool'};
