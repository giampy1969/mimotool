function myrlocus(channel)

% does a simple rlocus plot without too many
% objects on the picture, it was necessary
% in version 6 because mimotool couln't handle 
% all the new callbacks and uicontextmenus

[r,k]=rlocus(channel);

if length(r)>0,

    r=r.';

    p1=plot(real(r),imag(r));
    hold on;
    p2=plot(real(r(1,:)),imag(r(1,:)),'xb');
    p3=plot(real(r(size(r,1),:)),imag(r(size(r,1),:)),'ob');
    set(p2,'MarkerSize',8);

    [Xl,Yl]=rloclims(r.',0);
    p4=plot(2*Xl,[0 0],':k');p5=plot([0 0],2*Yl,':k');
    set(gca,'Xlim',Xl);set(gca,'Ylim',Yl);
    hold off;
    
end
