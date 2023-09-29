function messag(hf,stringa,label,tipo,gruppo)
%MESSAG : creazione delle finestre di messaggio.
%
%         messag(hf,stringa,label,tipo,gruppo)
%
%
% hf      = handle della finestra principale rispetto a cui il
%           messaggio deve essere posizionato.
%
% stringa = (str) identifica il tipo di azione richiesta e,quindi,
%           il testo da visualizzare :
%
%           'nn' : richiesta di una funzionalità non implementata
%
%           'pi' : i parametri inseriti dall'utente sono inconsistenti
%                  o non sono nel range permesso
%
%           'si' : il sistema in memoria è instabile e la funzionalità
%                  richiesta non può essere disponibile (richiesta
%                  di esecuzione della funzione "sysbal" o "balreal")
%
%           'so' : il sistema in memoria non è osservabile e la funzionalità
%                  richiesta non può essere disponibile (richiesta
%                  di esecuzione della funzione "balreal")
%
%           'me' : richiesta di visualizzazione di una matrice troppo
%                  grande rispetto alle dimensini della finestra
%                  (dimensione massimavisualizzabile 10x10)
%
%        'noreg' : errore nel caricamento di un controllore non
%                  relativo al modello in esame
%
%        'nsesd' : errore nel salvataggio di una matrice (il
%                  nome della matrice viene identificato dal
%                  terzo parametro di ingresso label)
%                  che dovrebbe risultare SIMMETRICA e SEMIDEFINITA
%                  POSITIVA
%
%         'nsed' : errore nel salvataggio di una matrice (il
%                  nome della matrice viene identificato dal
%                  terzo parametro di ingresso label)
%                  che dovrebbe risultare SIMMETRICA e DEFINITA
%                  POSITIVA
%
%             'n': richiesta di CREAZIONE di un nuovo sistema , quando
%                  quello attuale (se nuovo)  non è stato ancora salvato
%
%             'l': richiesta di CARICAMENTO di un sistema già presente
%                  nella cartella relativa ai modelli , quando
%                  quello attuale (se nuovo) non è stato ancora salvato
%
%             'e': richiesta di uscita con un nuovo sistema non ancora salvato
%
%             'h': richiesta di ritorno ad home con un nuovo sistema 
%                  non ancora salvato
%
%          'rpl' : richiesta di sostituzione del modello in memoria
%                  con una sua forma bilanciata o ridotta
%
%          'too' : sistema di ordine superiore a 18 nel caso di
%                  richiesta di controllore EIG\ASSIGN
%
%      'no_stde' : sistema nè stabilizzabile,nè detectabile 
%
%        'no_st' : sistema non stabilizzabile
%
%        'no_de' : sistema non detectabile 
%
%     'no_minph' : sistema non a fase minima 
%
%          'kns' : richiesta di CLOSE o di BACK da una 
%                  finestra di sintesi con un controllore
%                  non ancora salvato
%
%          'kns_m' : richiesta di inizio di nuova sintesi o 
%                  ottimizzazione da un ncomando dei menu 
%                  corrispondenti quando è presente in memoria
%                  un controllore non ancora salvato
%
%          'nnd' : matrice D non nulla 
%
%         'nmra' : matrice A non a rango minimo (non invertibile)
%
%          'anp' : autovalore non permesso (provoca un errore nel
%                  calcolo della pinv usata nella sintesi eig\assign
%                  quando deve essere ricavato l'autovettore relativo
%                  all'autovalore assegnato dall'utente)
%
%          'lqs' : matrice C~=I e/o D~=0 in caso di sintesi LQ-SERVO
%
%          'snp' : simulazione non permessa: la libreria dei blocchi
%                  commands per le simulazioni è dimensionata fino
%                  ad un massimo di 15 uscite del sistema
%
%      'no_norm' : grafico NORM(G(jw)) non disponibile perchè il 
%                  sistema è SISO o la sua parte stabile ha norma 0
%
% tipo    = (parametro necessario in caso di stringa='kns_m')
%            stringa indicante il tipo di regolatore
% gruppo  = (parametro necessario in caso di stringa='kns_m')
%            intero che indica il gruppo di comandi da cui proviene
%            la richiesta :
%            richiesta di sintesi output feedback --> gruppo=1
%            richiesta di sintesi state feedback  --> gruppo=2
%            richiesta di ottimizzazione          --> gruppo=3
%            sintesi eig\ssign o lq-servo         --> gruppo=4
%
%
% Massimo Davini 07/05/99 --- revised 18/04/2000

if nargin<5 gruppo=[];end;
if nargin<4 tipo=[];end;
if nargin<3 label='';end;

global stack;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sz(3)=800;
sizetext=jsz/2+.32;
cb_ok=['delete(gcf);'];

pos=get(hf,'position');
posnew=[pos(1)+pos(3)/6,pos(2)+pos(4)/3,2*pos(3)/3,pos(4)/3];

mess(1)=figure('unit','normalized','WindowStyle','modal','visible','off',...
   'position',posnew,'resize','off',...
   'color',[0.6 0.6 0.9],'NumberTitle','off','menubar','none',...
   'CloseRequestFcn',cb_ok); 

mess(2)=uicontrol('style','push','unit','normalized','position',[0.1 0.1 0.2 0.2],...
   'fontunits','normalized','fontsize',0.4+jsz,'fontweight','bold',...
   'Horizontalalignment','center','visible','off');

mess(3)=uicontrol('style','push','unit','normalized','position',[0.7 0.1 0.2 0.2],...
   'fontunits','normalized','fontsize',0.4+jsz,'fontweight','bold',...
   'Horizontalalignment','center','string','NO','visible','off');

mess(4)=uicontrol('style','frame','units','normalized','position',[0.1 0.45 0.8 0.45],...
   'backgroundcolor',[1 1 1],'visible','off');

mess(5)=uicontrol('style','text','ForegroundColor',[1 0 0],'BackgroundColor',[1 1 1],...
   'Horizontalalignment','center','visible','off');

mess(6)=uicontrol('style','push','unit','normalized','position',[0.4 0.1 0.2 0.2],...
   'fontunits','normalized','fontsize',0.4+jsz,'fontweight','bold',...
   'Horizontalalignment','center','string','CANCEL','visible','off',...
   'callback',cb_ok);

set(gcf,'visible','on');

switch stringa
case {'nn','me','too','lqs','snp','no_stde','nmra','no_st',...
         'no_de','no_minph','nnd','no_norm'}
   
   set(mess(1),'Name',' INFORMATION :');   
   
   if strcmp(stringa,'nn')
     str1=sprintf('Functionality NOT yet\nIMPLEMENTED !');
   elseif strcmp(stringa,'me') 
     str1=sprintf('The selected matrix exceeds the\ndimensions of the window !');
   elseif strcmp(stringa,'too') 
     str1=sprintf('The order of the system\nis too large !');
   elseif strcmp(stringa,'lqs') 
     str1=sprintf('The system %s hasn''t\nC=I and/or D=0',stack.general.model);
   elseif strcmp(stringa,'snp') 
     str1=sprintf('The number of the system outputs\nis too large (max 15) !');
   elseif strcmp(stringa,'no_stde')   
     str1=sprintf('The system is not stabilizable\nand not detectable !');
   elseif strcmp(stringa,'nmra')   
     str1=sprintf('The dynamic matrix A has not\nmaximum rank !');
   elseif strcmp(stringa,'no_st')
     str1=sprintf('The system %s\nis not stabilizable !',stack.general.model);
   elseif strcmp(stringa,'no_de')
     str1=sprintf('The system %s\nis not detectable !',stack.general.model);
   elseif strcmp(stringa,'no_minph')
     str1=sprintf('The system %s\nis not minimum phase !',stack.general.model);
   elseif strcmp(stringa,'nnd')
     str1=sprintf('The matrix D of the system\n%s is not null !',stack.general.model);
   elseif strcmp(stringa,'no_norm')
     str1=sprintf('The plot could not be performed because either the system is SISO or its stable part has zero norm !');
   end;
   
   if strcmp(stringa,'lqs')
        pos_frame=[0.1 0.34 0.8 0.62]; pos_str=[0.11 0.64 0.78 0.3];
   elseif strcmp(stringa,'no_norm')
        pos_frame=[0.1 0.38 0.8 0.54]; pos_str=[0.15 0.43 0.7 0.46];
        sizetext=jsz*0.8+.1;
   else pos_frame=[0.1 0.45 0.8 0.45]; pos_str=[0.11 0.47 0.78 0.36];
   end;
      
   set(mess(2),'visible','on','string','OK','fontsize',0.4+jsz,'callback',cb_ok);
   set(mess(4),'units','normalized','position',pos_frame,'visible','on');
   
   set(mess(5),'string',str1,'unit','normalized','position',pos_str,...
      'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
      'backgroundcolor',[1 1 1]);
   set(mess(5),'visible','on');
   
   if strcmp(stringa,'lqs')
      mess(7)=uicontrol('style','text','ForegroundColor',[0 0 1],...
         'fontunits','normalized','fontsize',sizetext,...
         'BackgroundColor',[1 1 1],'Horizontalalignment','center',...
         'unit','normalized','position',[0.11 0.36 0.78 0.3],...
         'string',sprintf('To set C=I and D=0, you can use the Tools\nmenu in the Modeling section'));
   end;
   
case {'pi','anp','noreg','nsesd','nsed','si','so'}
   
   set(mess(1),'Name',' ERROR :');

   if strcmp(stringa,'pi') 
     str1=sprintf('Parameters INCONSISTENT\nor NOT VALID !');
   elseif strcmp(stringa,'anp') 
     str1=sprintf('Eigenvalue not allowed\n( prevented convergence in "pinv" )');
   elseif strcmp(stringa,'noreg')   
      str1=sprintf('The controller is not relative\nto the model %s !',stack.general.model);
   elseif strcmp(stringa,'nsesd')   
      str1=sprintf('The matrix %s must be symmetrix \nand positive semidefinite !',label);
   elseif strcmp(stringa,'nsed')   
      str1=sprintf('The matrix %s must be symmetrix \nand positive definite !',label);
   elseif strcmp(stringa,'si')   
      str1=sprintf('The system must be\nSTABLE !');
   elseif strcmp(stringa,'so')   
      str1=sprintf('The system must be\nOBSERVABLE !');
   end;
   
   pos_frame=[0.1 0.45 0.8 0.45];
   pos_str=[0.11 0.47 0.78 0.36];
   
   set(mess(2),'visible','on','string','OK','fontsize',0.4+jsz,'callback',cb_ok);
   set(mess(4),'units','normalized','position',pos_frame,'visible','on');
   
   set(mess(5),'string',str1,'unit','normalized','position',pos_str,...
         'fontunits','normalized','fontsize',sizetext,'fontweight','bold');
   set(mess(5),'visible','on');
   
case {'n','l','e','h','rpl','kns','kns_m'}
   
   set(mess(1),'Name',' QUESTION :'); 
   
   if strcmp(stringa,'kns')|strcmp(stringa,'kns_m')
        str=sprintf('Do you want to save the computed \ncontroller for %s ?',stack.general.model);
   else str=sprintf('Do you want to save the NEW\nmodel %s ?',stack.general.model);
   end;
   
   set(mess(5),'string',str,'unit','normalized',...
        'position',[0.11 0.47 0.78 0.36],'fontunits','normalized',...
        'fontsize',sizetext,'fontweight','bold');
   set(mess(2),'string','YES');
   set(mess(2:6),'visible','on');
   
   switch stringa
   case 'n'
     set(mess(2),'callback',[cb_ok,'save_m;if stack.general.M_flag==0 pause(0.2);new0;end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.M_flag=0;new0;']);
   case 'l'
     set(mess(2),'callback',[cb_ok,'save_m;if stack.general.M_flag==0 pause(0.2);load_m;end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.M_flag=0;load_m;']);
   case 'e'
     set(mess(2),'callback',[cb_ok,'save_m;if stack.general.M_flag==0 pause(0.2);esci;end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.M_flag=0;esci;']);
   case 'h'
     set(mess(2),'callback',[cb_ok,'save_m;pause(0.2);if stack.general.M_flag==0 gohome;end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.M_flag=0;gohome;']);
   case 'rpl'
     set(mess(2),'callback',[cb_ok,'save_m;if stack.general.M_flag==0 pause(0.2);replace;end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.M_flag=0;replace;']);
   case 'kns'
     a=findobj('tag','eva','string','CLOSE');
     if isempty(a) a=findobj('tag','BottBC');end;
     if strcmp(label,'close') cc=get(a(1),'userdata');
     else                     cc=get(a(2),'userdata');end;
     set(mess(2),'callback',[cb_ok,sprintf('save_k;if stack.general.K_flag==0 pause(0.2);%s;end;',cc)]);
     set(mess(3),'callback',[cb_ok,sprintf('stack.general.K_flag=0;%s;',cc)]);
  case 'kns_m'
     
     ist0=['delete(findobj(''tag'',''grafico''));delete(findobj(''tag'',''eva''));',...
      'delete(findobj(''tag'',''textgrafico''));',...
      'for i=2:33 set(findobj(''tag'',sprintf(''eval_%u'',i)),''enable'',''off'');end;'];

     if gruppo==1     , funzione=sprintf('o_feed0(''%s'');',tipo);
     elseif gruppo==2 , funzione=sprintf('optim0(''%s'');',tipo);
     elseif gruppo==3 , funzione=sprintf('s_feed0(''%s'');',tipo);
     elseif gruppo==4 ,
        if strcmp(tipo,'eig \ assign'), funzione='ea_0;';
        elseif strcmp(tipo,'lqs'), funzione='lqs_0;';
        end;
     end;
     set(mess(2),'callback',[cb_ok,'save_k;if stack.general.K_flag==0 pause(0.2);',ist0,funzione,'end;']);
     set(mess(3),'callback',[cb_ok,'stack.general.K_flag=0;',ist0,funzione]);  
  end;
   
end;

set(gcf,'color',[0.6 0.6 0.9]);drawnow;  