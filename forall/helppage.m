function helppage;
%HELPPAGE : funzione di scelta della pagina di "help on context"
%
% Massimo Davini 25/11/99 
% Modified by Giampy Apr-2009 - Switched to "system" instead of "web"


handle=findobj('tag','sfnota');
if ~isempty(handle) & strcmp(get(handle(1),'visible'),'on'),
   eval(['! ' which('nohelp.htm')]);
   return;
end;

handle=findobj('tag','integratori');
if ~isempty(handle) & strcmp(get(handle(1),'visible'),'on')
   system(which('syn01.htm'));
   return;
end;

%------------------------------------------------
titolo=get(gcf,'name');
h=findobj('tag','help_1');

if     ~isempty(findstr(titolo,'MODELING'))&...
         isempty(findstr(titolo,'NEW'))
    pagina='mod01.htm';
elseif ~isempty(findstr(titolo,'MODELING'))&...
         ~isempty(findstr(titolo,'NEW'))
    pagina='mod02.htm';
elseif ~isempty(findstr(titolo,'ANALYSIS'))&...
         isempty(findstr(titolo,'-->'))
    pagina='ana01.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         isempty(findstr(titolo,'-->'))
    pagina='syn01.htm';
elseif ~isempty(findstr(titolo,'--> Singular'))|...
         ~isempty(findstr(titolo,'--> Norm'))
    pagina='ana02.htm';
elseif (~isempty(findstr(titolo,'Poles'))|...
        ~isempty(findstr(titolo,'Zeros')))&...
          isempty(findstr(titolo,'of'))
    pagina='ana03.htm';
elseif ~isempty(findstr(titolo,'Root Locus'))
    pagina='ana04.htm';
elseif ~isempty(findstr(titolo,'with'))|...
        ~isempty(findstr(titolo,'from'))
    pagina='ana05.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         isempty(findstr(titolo,'-->'))
    pagina='syn01.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> LQR'))
     pagina='syn02.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> IMFC'))
     pagina='syn03.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> EMFC'))
     pagina='syn04.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> EIG \ ASS'))
      pagina='syn05.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         (~isempty(findstr(titolo,'--> H - I'))|...
                  ~isempty(findstr(titolo,'--> H - 2')))
               pagina='syn09.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> H - MIX'))
      pagina='syn10.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> MU'))
      pagina='syn11.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
        ~isempty(findstr(titolo,'--> LQG'))&...
          isempty(findstr(titolo,'LTR'))
      pagina='syn06.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> LQG \ LTR'))
      pagina='syn07.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> PID'))
      pagina='syn08.htm';
elseif ~isempty(findstr(titolo,'SYNTHESIS'))&...
         ~isempty(findstr(titolo,'--> LQ - SERVO'))
      pagina='syn12.htm';
elseif ~isempty(findstr(titolo,'OPTIMIZATION'))
      pagina='opt01.htm';
elseif ~isempty(findstr(titolo,'EVALUATION'))
      pagina='eva01.htm';
else pagina='nohelp.htm';    
end;
 
eval(['! ' which(pagina)]);
