function mypzmap(a,b,c,d)

% does a simple pzmap plot without too many
% objects on the picture, it was necessary
% in version 6 because mimotool couln't handle 
% all the new callbacks and uicontextmenus

if size(a,1)>0,

    [p,z]=pzmap(a,b,c,d);

    p1=plot(real(p),imag(p),'xr');
    set(p1,'MarkerSize',8);
    hold on;
    p2=plot(real(z),imag(z),'ob');
    set(p2,'MarkerSize',6);
    
    Xl=get(gca,'Xlim');Yl=get(gca,'Ylim');
    p4=plot(2*Xl,[0 0],':k');p5=plot([0 0],2*Yl,':k');
    set(gca,'Xlim',Xl*1.1);set(gca,'Ylim',Yl*1.1);
    hold off;
    
    xlabel('Real Axis');ylabel('Imag Axis');title('Pole-Zero Map');
    
end
