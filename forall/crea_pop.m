function crea_pop(tipo,azione)
%CREATE OR ADD POP UP MENU 
%     
%          crea_pop(tipo,azione)
%
%Creazione di un menu di pop up per il grafico visualizzato
%sulla finestra;
%Nel caso di grafici (dati dai comandi step,impulse,bode,...) 
%è già presente un menu predefinito associato ad essi nel
%control toolbox e,in questi casi,la funzione aggiunge ai comandi
%del menu alcuni bottoni( azione='aggiungi' o non specificata).
%Nel caso invece di grafici dati da plot,semilogx,... il menu deve
%essere completamente definito (azione='crea').
%(La funzione va a vedere se esiste già un menu di pop_up predefinito
%per il grafico visualizzato e si comporta di conseguenza)
%
%Il parametro di ingresso tipo (intero) serve per specificare se
%deve essere abilitato o meno il comando "zoom" 
%
%  tipo = 1 ---> creazione di un pop_up menu con zoom abilitato
%                (per grafici plot ,semilogx,...)
%  tipo = 0 ---> creazione di un pop_up menu con zoom disabilitato
%                (per grafici da bar,...)
%
%
% Massimo Davini---21/05/99


if nargin==0 tipo=0;azione='crea';end;
if nargin==1 azione='aggiungi';end;
isnot=1;
  
switch azione
   case 'aggiungi'
       
       versione=version;
       if str2num(versione(1:3))==5.3,
            popmenu=get(get(gca,'children'),'userdata');
           %la riga seguente è stata aggiunta perchè senza di essa
           %dava degli errori (non so il perchè,visto che aveva sempre
           %funzionato prima)
           % popmenu=popmenu{length(popmenu)};
       else
           % giampy june 2001 
           % in matlab 6 uicontext menu is a brother of gca
           chs=get(get(gca,'parent'),'children');
           for i=1:size(chs,1),
               if strcmp(get(chs(i),'type'),'uicontextmenu'),
                   popmenu=chs(i);
                   break
               end
           end
       end
       
   case 'crea'
      isnot=0;

      popmenu=uicontextmenu('tag','pop_up');
      %---Zoom---   
      pop=uimenu(popmenu,'label','Zoo&m');
      uimenu(pop,'label','In X','callback','zoom xon;');
      uimenu(pop,'label','In Y','callback','zoom yon;');
      uimenu(pop,'label','In X-Y','callback','zoom on;');
      uimenu(pop,'label','Out','callback','zoom out;zoom off;');
      if tipo==0 set(pop,'enable','off');end;   
   
      %---Grid---
      cb1=['if strcmp(get(gcbo,''checked''),''off'') set(gcbo,''checked'',''on'');grid;return;end;'];
      cb2=['if strcmp(get(gcbo,''checked''),''on'') set(gcbo,''checked'',''off'');grid;return;end;'];
      callb=[cb1,cb2];
      pop=uimenu(popmenu,'label','Gri&d','callback',callb);
end;   

colo=uimenu(popmenu,'label','Co&lors','separator','on');

%-------background colors----------
back=uimenu(colo,'label','Bac&kground');

ist1=['set(findobj(''tag'',''coloripop''),''checked'',''off'');'];
ist2=['set(gcbo,''checked'',''on'');'];
colori(1)=uimenu(back,'label','w&hite','tag','coloripop','checked','on',...
      'callback',[ist1,ist2,'set(gca,''Color'',[1 1 1]);']);
colori(2)=uimenu(back,'label','&grey','tag','coloripop',...
      'callback',[ist1,ist2,'set(gca,''Color'',[.8 .8 .8]);']);
colori(3)=uimenu(back,'label','&others','separator','on',...
      'callback',[ist1,'uisetcolor(gca,''BACKGROUND''''s COLOR'');']);

%------------label colors----------
lab=uimenu(colo,'label','La&bel','separator','on');

ist1=['set(findobj(''tag'',''colorilab''),''checked'',''off'');'];
cb1=[ist1,ist2,'set(gca,''xColor'',[1 1 1],''yColor'',[1 1 1]);set(get(gca,''Title''),''Color'',[1 1 1]);'];
cb2=[ist1,ist2,'set(gca,''xColor'',[.5 .5 .5],''yColor'',[.5 .5 .5]);set(get(gca,''Title''),''Color'',[.5 .5 .5]);'];
cb3=[ist1,ist2,'set(gca,''xColor'',[0 0 0],''yColor'',[0 0 0]);set(get(gca,''Title''),''Color'',[0 0 0]);'];

cololab(1)=uimenu(lab,'label','&white','tag','colorilab','callback',cb1);
cololab(2)=uimenu(lab,'label','&grey','tag','colorilab','callback',cb2);
cololab(3)=uimenu(lab,'label','&black','tag','colorilab','callback',cb3);

%------------title colors----------
if isnot==0
   pop=uimenu(colo,'label','Ti&tle','callback','uisetcolor(get(gca,''title''),''TITLE''''s COLOR'');');
   
   cb1=[ist1,ist2,'set(gca,''xColor'',[1 1 1],''yColor'',[1 1 1]);'];
   cb2=[ist1,ist2,'set(gca,''xColor'',[.5 .5 .5],''yColor'',[.5 .5 .5]);'];
   cb3=[ist1,ist2,'set(gca,''xColor'',[0 0 0],''yColor'',[0 0 0]);'];
   
   set(cololab(1),'callback',cb1);
   set(cololab(2),'callback',cb2);
  set(cololab(3),'callback',cb3);
end;

%----Setup grafico selezionato----
pop=uimenu(popmenu,'label','Gra&phic Setup ...','separator','on','callback','setupg;');
if strcmp(azione,'aggiungi')
   set(pop,'label','Prin&t ...','callback','print(''-noui'',''-v'',gcf);');
end;
%------------Print----------------
if ~strcmp(azione,'aggiungi')
   pop=uimenu(popmenu,'label','Prin&t Window ...','callback','print(''-v'',gcf);');
end;
%---------------------------------
set(gca,'uicontextmenu',popmenu);