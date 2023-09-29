function valuta1(indice);
%VALUTA1 : grafici della finestra di evaluation
%
%
%Massimo Davini 15/02/99 --- revised 05/06/99 

% put delgraf instead of delete(findobj('tag','grafico'));
% 25/may/02 Giampy

global stack;
delgraf;
delete(findobj('tag','textgrafico'));
drawnow;

% enlarge text if java machine is running
jsz=stack.general.javasize;

sizetext=jsz/2+.6;

a=findobj('tag','eva');
set(a(1:3),'visible','off');

po=findobj('string','Po = To = inv( I+GK )*GK');
pi=findobj('string','Pi = Mi =  G*inv( I+KG )');
set(pi,'foregroundcolor',[0 0 0]);
set(po,'foregroundcolor',[0 0 0]);

drawnow;


switch indice
%-------------------------------------
% det(I+GK)=det(I+KG)
    case 1
    set(a(1:3),'visible','off');
    drawnow;   
    
    dIFo=stack.evaluation.grafici.dIFo;

    set(gca,'position',[0.15 0.27 0.7 0.63]);
    plot(real(dIFo),imag(dIFo),'r',0,0,'k+');
    
    axis([-3 3 -3 3]);
    title('det( I+GK ) = det( I+KG )','color','k','fontsize',9,'fontweight','normal');
    xlabel('Real axis','fontsize',8);ylabel('Imag axis','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    hold on;
    x=linspace(-1,1,200);
    for i=1:length(x)
      plot(x(i),sqrt(1-x(i)*x(i)),'b-',x(i),-sqrt(1-x(i)*x(i)),'b-');
    end;
    hold off;
    %-------------------------------------
% Input ant output open loop responses
    case 2
    set(a(1:3),'visible','off');
    drawnow;   
    
    w=stack.evaluation.grafici.w;
    sFi=stack.evaluation.grafici.sFi;
    sFo=stack.evaluation.grafici.sFo;
    sFiW=stack.evaluation.grafici.sFiW;
    sFoW=stack.evaluation.grafici.sFoW;

    set(gca,'position',[0.15 0.27 0.7 0.63]);
    semilogx(w,20*log10(sFi),'r',w,20*log10(sFo),'b',...
             w,20*log10(sFiW),'m',w,20*log10(sFoW),'c');
    if isnan(sFiW)&isnan(sFoW)
         title('F = GK (blue) , F = KG (red)','color','k','fontsize',9);
    else title('F = GK (blue) , F = KG (red) , weight (cyan,mag)','color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
%-------------------------------------
% Input ant output sensitivity.
    case 3
       
    set(a(1:3),'visible','off');
    drawnow;   

    w=stack.evaluation.grafici.w;
    sSi=stack.evaluation.grafici.sSi;
    sSo=stack.evaluation.grafici.sSo;
    sSiW=stack.evaluation.grafici.sSiW;
    sSoW=stack.evaluation.grafici.sSoW;

    set(gca,'position',[0.15 0.27 0.7 0.63]);
    semilogx(w,20*log10(sSi),'r',w,20*log10(sSo),'b',...
            w,20*log10(sSiW),'m',w,20*log10(sSoW),'c');
    if isnan(sSiW)&isnan(sSoW)
         title('So = inv(I+GK) (blue) , Si = inv(I+KG) (red)','color','k','fontsize',9);
    else title('So = inv(I+GK) (blue) , Si = inv(I+KG) (red) , weights (cyan,mag)','color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
%-------------------------------------
% Input and output control sensitivity.
    case 4
    set(a(1:3),'visible','off');
    drawnow;   
    
    w=stack.evaluation.grafici.w;
    sMi=stack.evaluation.grafici.sMi;
    sMo=stack.evaluation.grafici.sMo;
    sMiW=stack.evaluation.grafici.sMiW;
    sMoW=stack.evaluation.grafici.sMoW;

    set(gca,'position',[0.15 0.27 0.7 0.63]);
    semilogx(w,20*log10(sMi),'r',w,20*log10(sMo),'b',...
              w,20*log10(sMiW),'m',w,20*log10(sMoW),'c');
    if isnan(sMiW)&isnan(sMoW)
         title('Mo = K*inv(I+GK) (blue) , Mi = G*inv(I+KG) (red)','color','k','fontsize',9);
    else title('Mo = K*inv(I+GK) (b) , Mi = G*inv(I+KG) (r) , weights (cyan,mag)','color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
%-------------------------------------
% Input and output complementary sensitivity 
    case 5
    set(a(1:3),'visible','off');
    drawnow;   
    
    w=stack.evaluation.grafici.w;
    sTi=stack.evaluation.grafici.sTi;
    sTo=stack.evaluation.grafici.sTo;
    sTiW=stack.evaluation.grafici.sTiW;
    sToW=stack.evaluation.grafici.sToW;

    set(gca,'position',[0.15 0.27 0.7 0.63]);
    semilogx(w,20*log10(sTi),'r',w,20*log10(sTo),'b',...
              w,20*log10(sTiW),'m',w,20*log10(sToW),'c');
    if isnan(sTiW)&isnan(sToW)
        title('To = inv(I+GK)*GK (blue) , Ti = inv(I+KG)*KG (red)',...
          'color','k','fontsize',9);
    else title('To = inv(I+GK)*GK (b) , Ti = inv(I+KG)*KG (r) , weights (cyan,mag)',...
          'color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
%-------------------------------------
% gain and phase margins:
    case 6
    set(a(1:3),'visible','on');
    drawnow;
    
    mdo=stack.evaluation.grafici.mdo;
    pho=stack.evaluation.grafici.pho;
    gmho=stack.evaluation.grafici.gmho;
    gmlo=stack.evaluation.grafici.gmlo;
    phi=stack.evaluation.grafici.phi;
    gmhi=stack.evaluation.grafici.gmhi; 
    gmli=stack.evaluation.grafici.gmli;

    Frame=uicontrol('style','frame','units','normalized',...
       'position',[0.15 0.27 0.7 0.63],'backgroundcolor',[1 1 1],...
       'tag','textgrafico');
       
    Text(1)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.805 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Min( abs(det(I+GK)) )',...
       'tag','textgrafico');

    Text1(1)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.805 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(mdo),'tag','textgrafico');

    Text(2)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.72 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Output phase margin',...
       'tag','textgrafico');       
 
    Text1(2)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.72 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(pho),'tag','textgrafico');

    Text(3)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.635 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Output max gain margin',...
       'tag','textgrafico');

    Text1(3)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.635 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(gmho),'tag','textgrafico');

    Text(4)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.55 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Output min gain margin',...
       'tag','textgrafico');

    Text1(4)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.55 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(gmlo),'tag','textgrafico');

    Text(5)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.465 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Input phase margin',...
       'tag','textgrafico');

    Text1(5)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.465 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(phi),'tag','textgrafico');

    Text(6)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.38 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Input max gain margin',...
       'tag','textgrafico');

    Text1(6)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.38 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(gmhi),'tag','textgrafico');

    Text(7)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.2 0.295 0.4 0.06],'backgroundcolor',[1 1 1],...
       'HorizontalAlignment','left','string','Input min gain margin',...
       'tag','textgrafico');

    Text1(7)=uicontrol('style','text','units','normalized',...
       'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
       'position',[0.6 0.295 0.2 0.06],'backgroundcolor',[1 1 1],...
       'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
       'string',num2str(gmli),'tag','textgrafico');
    
%-------------------------------------
% PZmaps
    case 7
    set(a(1:3),'visible','on');
    drawnow;   
    
    AFo=stack.evaluation.grafici.AFo;
    BFo=stack.evaluation.grafici.BFo;
    CFo=stack.evaluation.grafici.CFo;
    DFo=stack.evaluation.grafici.DFo;
    ASo=stack.evaluation.grafici.ASo;
    BSo=stack.evaluation.grafici.BSo;
    CSo=stack.evaluation.grafici.CSo;
    DSo=stack.evaluation.grafici.DSo;
    AMo=stack.evaluation.grafici.AMo;
    BMo=stack.evaluation.grafici.BMo;
    CMo=stack.evaluation.grafici.CMo;
    DMo=stack.evaluation.grafici.DMo;
    ATo=stack.evaluation.grafici.ATo;
    BTo=stack.evaluation.grafici.BTo;
    CTo=stack.evaluation.grafici.CTo;
    DTo=stack.evaluation.grafici.DTo;

    ax(1,:)=axes('position',[.1 .67 .35 .25]);
    mypzmap(AFo,BFo,CFo,DFo);
    title('GK','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(2,:)=axes('position',[.55 .67 .35 .25]);
    mypzmap(ASo,BSo,CSo,DSo);
    title('So = inv( I+GK )','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(3,:)=axes('position',[.1 .25 .35 .25]);
    mypzmap(AMo,BMo,CMo,DMo);
    title('Mo = K*inv( I+GK )','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(4,:)=axes('position',[.55 .25 .35 .25]);
    mypzmap(ATo,BTo,CTo,DTo);
    title('To = inv( I+GK )*GK','color','k','fontsize',9);
    xlabel('');ylabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');

    case 8
    set(a(1:3),'visible','on');
    drawnow;   
    
    AFi=stack.evaluation.grafici.AFi;
    BFi=stack.evaluation.grafici.BFi;
    CFi=stack.evaluation.grafici.CFi;
    DFi=stack.evaluation.grafici.DFi;
    ASi=stack.evaluation.grafici.ASi;
    BSi=stack.evaluation.grafici.BSi;
    CSi=stack.evaluation.grafici.CSi;
    DSi=stack.evaluation.grafici.DSi;
    AMi=stack.evaluation.grafici.AMi;
    BMi=stack.evaluation.grafici.BMi;
    CMi=stack.evaluation.grafici.CMi;
    DMi=stack.evaluation.grafici.DMi;
    ATi=stack.evaluation.grafici.ATi;
    BTi=stack.evaluation.grafici.BTi;
    CTi=stack.evaluation.grafici.CTi;
    DTi=stack.evaluation.grafici.DTi;
       
    ax(1,:)=axes('position',[.1 .67 .35 .25]);
    mypzmap(AFi,BFi,CFi,DFi);
    title('KG','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(2,:)=axes('position',[.55 .67 .35 .25]);
    mypzmap(ASi,BSi,CSi,DSi);
    title('Si = inv( I+KG )','color','k','fontsize',9);
    xlabel('');ylabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(3,:)=axes('position',[.1 .25 .35 .25]);
    mypzmap(AMi,BMi,CMi,DMi);
    title('Mi = G*inv( I+KG )','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    
    ax(4,:)=axes('position',[.55 .25 .35 .25]);
    mypzmap(ATi,BTi,CTi,DTi);
    title('Ti = inv( I+KG )*KG','color','k','fontsize',9);
    ylabel('');xlabel('');
    set(gca,'tag','grafico');
    crea_pop(1,'crea');

%-------------------------------------
% poles drifting:
    case 9
    set(a(1:3),'visible','off');
    drawnow;   
    
    Aol=stack.evaluation.grafici.Aol;
    Bol=stack.evaluation.grafici.Bol;
    Col=stack.evaluation.grafici.Col;
    Dol=stack.evaluation.grafici.Dol;
    avm=stack.evaluation.grafici.avm;
    l=stack.evaluation.grafici.l;

    set(gca,'position',[0.15 0.29 0.7 0.61]);
    set(gca,'tag','grafico');
    mypzmap(Aol,Bol,Col,Dol);hold on;
    xlabel('Real axis','fontsize',8);ylabel('Imag axis','fontsize',8)
    title('Closed loop poles drifting ( from blue to red )','color','k','fontsize',9);
    for j=1:size(avm,1),
          plot(real(avm(j,1)),imag(avm(j,1)),'b*');
          plot(real(avm(j,2:l-1)),imag(avm(j,2:l-1)),'g.');
          plot(real(avm(j,l)),imag(avm(j,l)),'r*','MarkerSize',8)
    end;
    set(gca,'tag','grafico');
    crea_pop(1,'crea');
    hold off;
 %-------------------------------------------------
 %---questa parte è stata aggiunta in seguito------
 % Poles drifting text (poli a ciclo chiuso
    case 24
       
    set(a(1:3),'visible','off');
    drawnow;   
   
    avm=stack.evaluation.grafici.avm;
    l=stack.evaluation.grafici.l;
    %avm(:,1) --->  poli a ciclo aperto
    %avm(:,l) --->  poli a ciclo chiuso
    
    eva(1)=uicontrol('style','Frame','units','normalized','position',[0.09 0.89 0.82 0.08],...
     'backgroundcolor',[1 1 1],'tag','textgrafico');

    eva1(2)=uicontrol('style','text','units','normalized','position',[0.1 0.9 0.4 0.06],...
     'fontunits','normalized','fontsize',sizetext+jsz/2,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
     'HorizontalAlignment','left','string',' Open Loop poles :',...
     'tag','textgrafico');
    
    eva1(3)=uicontrol('style','text','units','normalized','position',[0.5 0.9 0.4 0.06],...
     'fontunits','normalized','fontsize',sizetext+jsz/2,'fontweight','bold',...
     'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
     'HorizontalAlignment','right','string','Closed Loop poles : ',...
     'tag','textgrafico');
  
    eva1(4)=uicontrol('style','push','unit','normalized','position',[0.73 0.05 0.1 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'string','<<','Horizontalalignment','center','tag','textgrafico',...
     'TooltipString','Previous set of poles',...
     'callback','valuta2(2);','enable','off'); 
 
    eva1(5)=uicontrol('style','push','unit','normalized','position',[0.85 0.05 0.1 0.12],...
     'fontunits','normalized','fontsize',.35,'fontweight','bold',...
     'string','>>','Horizontalalignment','center','tag','textgrafico',...
     'TooltipString','Next set of poles',...
     'callback','valuta2(2);'); 
  
    drawnow;
  
    for i=1:10
      p_o_l(i)=uicontrol('style','text','units','normalized','position',[0.1 0.82-.065*(i-1) 0.35 0.06],...
       'fontunits','normalized','fontsize',sizetext+jsz/3,'fontweight','bold',...
       'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
       'HorizontalAlignment','left','string','','tag','textgrafico',...
       'visible','off');
     end;          
     for i=1:10
      p_c_l(i)=uicontrol('style','text','units','normalized','position',[.55 0.82-.065*(i-1) 0.35 0.06],...
       'fontunits','normalized','fontsize',sizetext+jsz/3,'fontweight','bold',...
       'backgroundcolor',[.6 .7 .9],'foregroundcolor',[0 0 0],...
       'HorizontalAlignment','right','string','','tag','textgrafico',...
       'visible','off');
     end;
     
     poli=findobj('tag','textgrafico');
     text_open=poli(11:20);
     text_closed=poli(1:10);
     
     if size(avm,1)<=10 limite=size(avm,1);set(eva1(5),'enable','off');
     else limite=10;end;
     
     for i=1:limite
       set(text_open(11-i),'string',num2str(avm(i,1)),'visible','on');
       if real(avm(i,1))>0 set(text_open(11-i),'foregroundcolor','yellow');
       else set(text_open(11-i),'foregroundcolor',[0 0 0]);end;
       set(text_closed(11-i),'string',num2str(avm(i,l)),'visible','on');
       if real(avm(i,l))>0 set(text_closed(11-i),'foregroundcolor','yellow');
       else set(text_closed(11-i),'foregroundcolor',[0 0 0]);end;
     end;
     
 %-------------------------------------------------   
 % Both sensitivities: robust performance condition
    case 10
    set(a(1:3),'visible','off');
    drawnow;   
    
    sTSi=stack.evaluation.grafici.sTSi;
    sTSo=stack.evaluation.grafici.sTSo;
    sTSiW=stack.evaluation.grafici.sTSiW;
    sTSoW=stack.evaluation.grafici.sTSoW;
    sMSiW=stack.evaluation.grafici.sMSiW;
    sMSoW=stack.evaluation.grafici.sMSoW;
    wm=stack.evaluation.grafici.wm;
    sMSi=stack.evaluation.grafici.sMSi;
    sMSo=stack.evaluation.grafici.sMSo;

    ax(1,:)=axes('position',[.1 .65 .8 .25]);
    semilogx(wm,20*log10(sTSi),'r',wm,20*log10(sTSo),'b',...
              wm,20*log10(sTSiW),'m',wm,20*log10(sTSoW),'c');
    if isnan(sTSiW)&isnan(sTSoW)
         title('max(mu([T T; S S])) : output (b) , input (r)','color','k','fontsize',9);
    else title('max(mu([T T; S S])) : output (b) , input (r) , weights (cyan,mag)',...
          'color','k','fontsize',9);
    end;
    ylabel('dB','fontsize',8);
    set(gca,'tag','grafico','xTickLabel',[]);
    crea_pop(1,'crea');

    ax(2,:)=axes('position',[.1 .27 .8 .25]);
    semilogx(wm,20*log10(sMSi),'r',wm,20*log10(sMSo),'b',...
                wm,20*log10(sMSiW),'m',wm,20*log10(sMSoW),'c');
    if isnan(sMSiW)&isnan(sMSoW)
         title('max(mu([M M; S S])) : output (b) , input (r)','color','k','fontsize',9);
    else title('max(mu([M M; S S])) : output (b) , input (r) , weights (cyan,mag)',...
          'color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');

%----------------------------------------------------------   
% All sensitivities: ultimate robust performance condition
    case 11
    set(a(1:3),'visible','off');
    drawnow;   
    
    sM=stack.evaluation.grafici.sM;
    sMW=stack.evaluation.grafici.sMW;
    sT=stack.evaluation.grafici.sT;
    sTW=stack.evaluation.grafici.sTW;
    wm=stack.evaluation.grafici.wm;

    ax(1,:)=axes('position',[.1 .65 .8 .25]);
    semilogx(wm,20*log10(sM),'b',wm,20*log10(sMW),'g');
    if isnan(sMW)
         title('max(mu(diag(Si Mi Mo So)))','color','k','fontsize',9');
    else title('max(mu(diag(Si Mi Mo So))) (green=weight)','color','k','fontsize',9');
    end;
    ylabel('dB','fontsize',8);
    set(gca,'tag','grafico','xTickLabel',[]);
    crea_pop(1,'crea');

    ax(2,:)=axes('position',[.1 .27 .8 .25]);
    semilogx(wm,20*log10(sT),'b',wm,20*log10(sTW),'g');
    if isnan(sTW)
         title('max(mu(diag(Si Ti To So)))','color','k','fontsize',9);
    else title('max(mu(diag(Si Ti To So))) (green=weight)','color','k','fontsize',9);
    end;
    xlabel('Frequency (rad/s)','fontsize',8);ylabel('dB','fontsize',8);
    set(gca,'tag','grafico');
    crea_pop(1,'crea');

%-------------------------------------------------   
% Displays main results on Po and Pi for w0=1e-2
% and plot step responses
    otherwise   
    set(a(1:3),'visible','on');
    drawnow;   
    
    Po=stack.evaluation.grafici.Po;
    Pi=stack.evaluation.grafici.Pi;
    w0=1e-2;
      
    switch indice
    case {12,13,14,15,20,22},
       sys=Po;ois='o';
       set(pi,'foregroundcolor',[0 0 0]);
       set(po,'foregroundcolor',[1 0 0]);
    case {16,17,18,19,21,23},
       sys=Pi;ois='i';
       set(pi,'foregroundcolor',[1 0 0]);
       set(po,'foregroundcolor',[0 0 0]);
    end;
    
    [Ap,Bp,Cp,Dp]=unpck(sys);
    [ty,no,ni,ns]=minfo(sys);
    mrp=max(real(spoles(sys)));
    mfp=max(abs(spoles(sys)));

    Gc=gram3(Ap,Bp);
    Go=gram3(Ap',Cp');
    [Uc,Sc,Vc]=svd(Gc);
    [Uo,So,Vo]=svd(Go);
    cp=1./abs(sqrt(diag(pinv(Uc*Sc*Uc'))));
    op=1./abs(sqrt(diag(pinv(Uo*So*Uo'))));

    [ss,su] = sdecomp(sys,-1e-12);
    [tyu,nou,niu,nsu]=minfo(su);
    
    gsp=zeros(no,ni);
    for j=1:ni, for i=1:no,
       [a,b,c,d]=unpck(sel(ss,i,j));
       if size(a,1)==0, Gs=d;
       else Gs=c*inv(sqrt(-1)*w0*eye(size(a))-a)*b+d;
       end
       gsp(i,j)=abs(Gs);
    end; end;

    switch indice
    case {12,16}
         set(gca,'position',[0.15 0.27 0.7 0.63]);
         mypzmap(Ap,Bp,Cp,Dp);ylabel('');xlabel('');
         title([ 'P' ois ' poles & zeros' ],'color','k','fontsize',9);
         set(gca,'tag','grafico');
         crea_pop(1,'crea');
         
    case {13,17}
         set(gca,'position',[0.1 0.27 0.77 0.63]);
         sigma(Ap,Bp,Cp,Dp);xlabel('');ylabel('');
         title([ 'P' ois ' singular values in dB' ],'color','k','fontsize',9);
         set(gca,'tag','grafico','xColor',[0 0 0],'yColor',[0 0 0]);
         crea_pop(0,'aggiungi');
         
    case {14,18}
         set(gca,'position',[0.15 0.27 0.7 0.63]);
         semilogy(cp,'r');hold on;semilogy(op,'b');xlabel('');ylabel('');
         title([ 'P' ois ' ctrb (red) & obsv (blue) gram. sv' ],'color','k','fontsize',9);
         hold off;
         set(gca,'tag','grafico');
         crea_pop(1,'crea');
         
    case {15,19}
         set(gca,'position',[0.15 0.27 0.7 0.63]);
         if min(size(gsp))>1,contour(1:ni,-1:-1:-no,log10(gsp));end
         xlabel('');ylabel('');
         title(['max( svd( P' ois '( jw,i,j ) ) )' ],'color','k','fontsize',9);
         set(gca,'tag','grafico');
         crea_pop(1,'crea');
         
    otherwise
        % settling time and overshoot for each channel
        gp=Dp-Cp*inv(Ap)*Bp;
        ts=zeros(no,ni);os=zeros(no,ni);ct=0;
          
        for n1=1:no, for n2=1:ni
             [y,xs,t]=step(Ap,Bp(:,n2),Cp(n1,:),Dp(n1,n2));
             g0=gp(n1,n2);
             if g0<1e-1, g0=1; end

             ts(n1,n2)=max(t'.*(abs(y-g0)>.05*abs(g0)));
             os(n1,n2)=max(y-g0)/g0;

             index=n2+ni*(n1-1);
             st1=sprintf('y%u=y;',index);
             st2=sprintf('t%u=t;',index);
             eval(st1);eval(st2);clear y xs t;
        end;end;
       
        if (indice==20)|(indice==21) 
             axes('Position',[0.06 0.22 0.85 0.75],'tag','grafico');
             step(Ap,Bp,Cp,Dp);
             dellbls6;
             crea_pop(1,'aggiungi');
        end;
          
        if (indice==22)|(indice==23)
      
          eval([ 'if min(size(ts))==1,ts' ois '=ts(1,1);else ts'...
          ois '=diag(ts); end' ]);
          eval([ 'if min(size(os))==1,os' ois '=os(1,1);else os'...
          ois '=diag(os); end' ]);
          eval([ 'xs' ois '=mrp;' ]);
          eval([ 'mf' ois '=mfp;' ]);
          
          Frame=uicontrol('style','frame','units','normalized','visible','off',...
          'position',[0.05 0.27 0.9 0.63],'backgroundcolor',[1 1 1],...
          'tag','textgrafico');

          Text(1)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.805 0.14 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'HorizontalAlignment','left','tag','textgrafico',... 
          'string','System');

          Text1(1)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.25 0.805 0.65 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'tag','textgrafico',... 
          'HorizontalAlignment','right',...
          'string',sprintf('%u states , %u outputs , %u inputs',ns,no,ni));

          Text(2)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.72 0.4 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'HorizontalAlignment','left','string','Rank( ctrb matrix )',...
          'tag','textgrafico');

          Text1(2)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.6 0.72 0.3 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'HorizontalAlignment','right',...
          'tag','textgrafico','string',num2str(rank(ctrb(Ap,Bp),eps^2)));

          Text(3)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.635 0.4 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'HorizontalAlignment','left','tag','textgrafico',... 
          'string','Rank( obsv matrix )');

          Text1(3)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.6 0.635 0.3 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'tag','textgrafico',... 
          'HorizontalAlignment','right',...
          'string',num2str(rank(obsv(Ap,Cp),eps^2)));

          Text(4)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.55 0.4 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'HorizontalAlignment','left','tag','textgrafico',... 
          'string','Maximum eigenvalue');

          Text1(4)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.6 0.55 0.3 .06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'tag','textgrafico',... 
          'HorizontalAlignment','right','string',num2str(mrp));
 
          Text(5)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.465 0.49 0.06],'tag','textgrafico',... 
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'backgroundcolor',[1 1 1],'HorizontalAlignment','left',...
          'string','Unstable part');

          Text1(5)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.6 0.465 0.3 0.06],'tag','textgrafico',... 
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'backgroundcolor',[1 1 1],'foregroundcolor',[1 0 0],...
          'HorizontalAlignment','right','string',sprintf('%u states',nsu));

          Text(6)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.38 0.59 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'tag','textgrafico','HorizontalAlignment','left');

          Text1(6)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.7 0.38 0.2 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'tag','textgrafico',... 
          'HorizontalAlignment','right');

          Text(7)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.1 0.295 0.59 0.06],'backgroundcolor',[1 1 1],...
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'tag','textgrafico','HorizontalAlignment','left');

          Text1(7)=uicontrol('style','text','units','normalized','visible','off',...
          'position',[0.7 0.295 0.2 0.06],'backgroundcolor',[1 1 1],...     
          'fontunits','normalized','fontsize',sizetext,'fontweight','bold',...
          'foregroundcolor',[1 0 0],'tag','textgrafico',... 
          'HorizontalAlignment','right');
       
          if indice==22 
            set(Text(6),'string','Maximum Po Diagonal Settling Time'); 
            set(Text1(6),'string',num2str(max(tso)));
            set(Text(7),'string','Maximum Po Diagonal Overshoot'); 
            set(Text1(7),'string',num2str(max(oso)));
          elseif indice==23
            set(Text(6),'string','Maximum Pi Diagonal Settling Time'); 
            set(Text1(6),'string',num2str(max(tsi)));
            set(Text(7),'string','Maximum Pi Diagonal Overshoot'); 
            set(Text1(7),'string',num2str(max(osi)));
          end;
      
          set(Frame,'visible','on');
          set(Text,'visible','on');
          set(Text1,'visible','on');
          
        end;        
        
     end;
     
end;
  


 