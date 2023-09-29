function viewmat(handlefigure);

dati=get(handlefigure,'userdata');

switch dati{2}
case 'sy', str0=sprintf(' STATE_SPACE SYSTEM : matrix %s',dati{1});
case 'co', str0=sprintf(' CONTROLLABILITY FORM : matrix %s',dati{1});
case 'ob', str0=sprintf(' OBSERVABILITY FORM : matrix %s',dati{1});
case 'mo', str0=sprintf(' MODAL FORM : matrix %s',dati{1});
case 'cf', str0=sprintf(' COMPANION FORM : matrix %s',dati{1});
case 'jf', str0=sprintf(' JORDAN FORM : matrix %s',dati{1});
case 'kf', str0=sprintf(' KALMAN FORM : matrix %s',dati{1});
case 'ba', str0=sprintf(' BALANCED REALIZATION : matrix %s',dati{1});
case 'br', str0=sprintf(' BRUNOWSKY FORM : matrix %s',dati{1});
end;

disp(sprintf('\n'))
disp(str0);
str1='';for i=1:34,str1=strcat(str1,'-');end; 
disp(str1);
disp(dati{3});
disp(str1);
disp(sprintf('\n'));
