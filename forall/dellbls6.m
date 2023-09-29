function dellbls6()

% delete labels of ltiplots in version 6
% Giampy June 2001 

versione=version;
if str2num(versione(1:3))>5.3,

    chs=get(get(gca,'parent'),'children');
    for i=1:size(chs,1),
        if strcmp(get(chs(i),'type'),'uicontextmenu'),
            roj=get(chs(i),'userdata');
            if ~isempty(roj), pvset(roj,'Title','','Xlabel','','Ylabel',''); end
        end
    end

    set(get(gca,'Title'),'Visible','on');
    set(get(gca,'Xlabel'),'Visible','on');
    set(get(gca,'Ylabel'),'Visible','on');
    
else
    
    xlabel('');ylabel('');title('');
    
end
