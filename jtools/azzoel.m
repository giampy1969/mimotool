% put azimuth and elevation sliders on current figure

% Giampiero Campa & Vincenzo Bianco 18-11-94

fig=gcf;

xlim=get(gca,'xlim');
ylim=get(gca,'ylim');
zlim=get(gca,'zlim');

xbar=.5*(xlim(1)+xlim(2));
ybar=.5*(ylim(1)+ylim(2));
zbar=.5*(zlim(1)+zlim(2));

sli_azm=uicontrol(fig,'style','slider',...
'units','normalized',...
'position',[37 10 120 20]/560,...
'min',-90,'max',90,'value',-37.5,...
'callback',['set(azm_cur,''string'',',...
                'num2str(get(sli_azm,''value''))),',...
            'set(gca,''view'',',...
            '[get(sli_azm,''value''),get(sli_elv,''value'')])']);


sli_elv=uicontrol(fig,'style','slider',...
'units','normalized',...
'position',[407 10 120 20]/560,...
'min',-90,'max',90,'value',30,...
'callback',['set(elv_cur,''string'',',...
                'num2str(get(sli_elv,''value''))),',...
            'set(gca,''view'',',...
            '[get(sli_azm,''value''),get(sli_elv,''value'')])']);


sli_zoom=uicontrol(fig,'style','slider',...
'units','normalized',...
'position',[222 10 120 20]/560,...
'min',-1,'max',1,'value',0,...
'callback',['set(zoom_cur,''string'',',...
            'num2str(get(sli_zoom,''value''))),',...
            'set(gca,',...
            '''xlim'',xbar-10^get(sli_zoom,''value'')*(xbar-xlim),',...
            '''ylim'',ybar-10^get(sli_zoom,''value'')*(ybar-ylim),',...
            '''zlim'',zbar-10^get(sli_zoom,''value'')*(zbar-zlim))',...
           ]);
            
azm_min=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[7 10 30 20]/560,...
'string',num2str(get(sli_azm,'min')));

elv_min=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[377 10 30 20]/560,...
'string',num2str(get(sli_elv,'min')));

zoom_min=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[192 10 30 20]/560,...
'string',num2str(get(sli_zoom,'min')));

azm_max=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[157 10 30 20]/560,...
'string',num2str(get(sli_azm,'max')));

elv_max=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[527 10 30 20]/560,...
'string',num2str(get(sli_elv,'max')));

zoom_max=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[342 10 30 20]/560,...
'string',num2str(get(sli_zoom,'max')));

azm_label=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[37 30 65 20]/560,...
'string','azimuth');

elv_label=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[407 30 65 20]/560,...
'string','elevation');

zoom_label=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[222 30 65 20]/560,...
'string','zoom');

azm_cur=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[107 30 50 20]/560,...
'string',num2str(get(sli_azm,'value')));

elv_cur=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[477 30 50 20]/560,...
'string',num2str(get(sli_elv,'value')));

zoom_cur=uicontrol(fig,'style','text',...
'units','normalized',...
'position',[292 30 50 20]/560,...
'string',num2str(get(sli_zoom,'value')));
