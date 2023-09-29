function n=delgraf();

% delete axis who are descendant of mimotool window
% added by giampy 21-may-02

% modified by giampy , dec-03
% the tag of the main window is now "MvMain"

n=0;
ch0=get(0,'child');
if isempty(ch0), return, end

% find handle of mimotool window (mv)
for i=1:length(ch0),
    tagmv=get(ch0(i),'tag');
    if tagmv=='MvMain', mv=ch0(i); end
end

% find all objects of type axes
ta=findobj('type','axes');
if isempty(ta), return, end

 % delete axis if descendant of mv   
for i=1:size(ta,1),
    obj=ta(i);
    while obj ~= 0,
        if ishandle(obj), 
            obj=get(obj,'parent');
            if obj == mv, delete(ta(i)); n=n+1; end
        else obj=0;
        end
    end
end
