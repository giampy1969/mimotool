%function SAVEPPT(filespec,prnopt) saves the current Matlab figure
%  window or Simulink model window to a PowerPoint file designated by
%  filespec.  If filespec is omitted, the user is prompted to enter
%  one via UIPUTFILE.  If the path is omitted from filespec, the 
%  PowerPoint file is created in the current Matlab working directory.
%
%  Optional input argument prnopt is used to specify additional save
%  options:
%    -fHandle   Handle of figure window to save
%    -sName     Name of Simulink model window to save
%
%  Examples:
%  >> saveppt
%       Prompts user for valid filename and saves current figure
%  >> saveppt('junk.ppt')
%       Saves current figure to PowerPoint file called junk.ppt
%  >> saveppt('junk.ppt','-f3')
%       Saves figure #3 to PowerPoint file called junk.ppt
%  >> saveppt('models.ppt','-sMainBlock')
%       Saves Simulink model named "MainBlock" to file called models.ppt
%
%  The command-line method of invoking SAVEPPT will also work:
%  >> saveppt models.ppt -sMainBlock

%Ver 1.2, Copyright 1999, Mark W. Brown, mwbrown@ieee.org
%  added support for Simulink model windows using prnopt.

function saveppt(filespec,prnopt)

% Establish valid file name:
if nargin<1 | isempty(filespec);
  [fname, fpath] = uiputfile('*.ppt');
  if fpath == 0; return; end
  filespec = fullfile(fpath,fname);
else
  [fpath,fname,fext] = fileparts(filespec);
  if isempty(fpath); fpath = pwd; end
  if isempty(fext); fext = '.ppt'; end
  filespec = fullfile(fpath,[fname,fext]);
end

% Capture current figure/model into clipboard:
if nargin<2
  print -dmeta
else
  print('-dmeta',prnopt)
end

% Start an ActiveX session with PowerPoint:
ppt = actxserver('PowerPoint.Application');
ppt.Visible = 1;

if ~exist(filespec,'file');
  % Create new presentation:
  op = invoke(ppt.Presentations,'Add');
else
  % Open existing presentation:
  op = invoke(ppt.Presentations,'Open',filespec);
end

% Get current number of slides:
slide_count = get(op.Slides,'Count');

% Add a new slide:
new_slide = invoke(op.Slides,'Add',slide_count+1,12);

% Get height and width of slide:
slide_H = op.PageSetup.SlideHeight;
slide_W = op.PageSetup.SlideWidth;

% Paste the contents of the Clipboard:
pic1 = invoke(new_slide.Shapes,'Paste');

% Get height and width of picture:
pic_H = get(pic1,'Height');
pic_W = get(pic1,'Width');

% Center picture on page:
set(pic1,'Left',(slide_W - pic_W)/2);
set(pic1,'Top',(slide_H - pic_H)/2);

if ~exist(filespec,'file')
  % Save file as new:
  invoke(op,'SaveAs',filespec,1);
else
  % Save existing file:
  invoke(op,'Save');
end

% Close the presentation window:
invoke(op,'Close');

% Quit PowerPoint
invoke(ppt,'Quit');

% Close PowerPoint and terminate ActiveX:
delete(ppt);

return