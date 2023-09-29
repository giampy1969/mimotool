% All'uscita di mimotool viene richiesto se un eventuale nuovo modello
% debba essere salvato o meno altrimenti viene chiuso il programma
% ripristinando il workspace e la directory di lavoro precedenti
% alla chiamata di mimotool stesso
%
%
% Massimo Davini 28/05/99 --- revised 17/02/00

% modified by giampy, dec 03, 
% does not clear the workspace anymore only clears the stack variable
% the tag is now MvMain

global stack;
if ~isfield(stack.general,'M_flag') stack.general.M_flag=0; end
   
creato=stack.general.M_flag;

if isempty(creato)|(~isempty(creato)&(creato==0))
   
   clf;drawnow;
   delete(gcf);drawnow;
   
   if ~isempty(find_system('name','Closed_Loop_System'))
     close_system('Closed_Loop_System',0);
   end;
   if isfield(stack.general,'adv_flag')
   advanced_flag=stack.general.adv_flag;
   save(which('advanced.mat'),'advanced_flag','-v4');
   end;
   
   mvt_path=which('mimotool.m');
   mvt_path=mvt_path(1:length(mvt_path)-9);
   
   clear creato advanced_flag mvt_path stack;
   
   warning on;
elseif (~isempty(creato)&(creato==1))
   %se è stato creato un nuovo sistema,chiede conferma 
   %prima di uscire
   clear creato;
   messag(gcf,'e');
end;
