function h=finlowax();

% find lowest axis label handle, used in the bode plot (makeplot)
% added by giampy 21-june-02

h=[];
ch0=get(0,'child');
if isempty(ch0), return, end

% find handle of mimotool window (mv)
for i=1:length(ch0),
    tagmv=get(ch0(i),'tag');
    ltmv=length(tagmv);
    if ltmv>4,
        if tagmv=='MvMain', mv=ch0(i); end
    end
end

% find all objects of type axes
ta=findobj('type','axes');
if isempty(ta), return, end

% find axis if descendant of mv   
lowpos=[1 1 1]*1e12;
for i=1:size(ta,1),
    obj=ta(i);
    while obj ~= 0,
        if ishandle(obj), 
            obj=get(obj,'parent');
            if obj == mv, 
                pos=get(ta(i),'position');
                if pos(2)<lowpos(2), 
                    lowpos=pos;h=ta(i);
                end              
            end
        else obj=0;
        end
    end
end
