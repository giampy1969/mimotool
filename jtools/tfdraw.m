function [sout,sinv,pts]=tfdraw(in,dim,string,init_pts)

% function [sout,sinv,pts]=tfdraw(in,dim,string,init_pts);
%
%  Interactive mouse-based loglog sketching and fitting tool
%
%   inputs:  in = either VARYING data which will be plotted each time
%  		or  CONSTANT specifying window on data [xmin xmax ymin ymax]
%            dim = dimension of the square diagonal system
%            string = string to be displayed as title
%            init_pts = VARYING file with initial points (optional)
%
%   outputs: sout = fitted SYSTEM
%            sinv = inverse fitted SYSTEM
%
%            pts    = VARYING file with final points
%
%  With the mouse in plot window the following keys are recognized
%	-click mouse to add points ( may be added outside current window)
%	-type 'a' to add points ( same as clicking mouse button)
%	-type 'r' to remove nearest frequency point
%	-enter integer (0-9) order for stable, minphase fit of points 
%	-type 'w' to window and click again to specify second window coordinate
%	-type 'p' to replot 
%	-type 'g' to toggle grid 
%
%  See Also: FITMAG, GINPUT, MAGFIT, PLOT, and VPLOT.

%  Copyright (c) 1991-93 by MUSYN, Inc.
%  $Revision: 1.1 $  $Date: 1993/09/03 17:18:40 $


%%%%%%%%%%%%%%%% initial setup and argument parsing %%%%%%%%%%%%
usage = 'usage: [sout,sinv,pts]=tfdraw(in,dim,string,init_pts)';
xlab = '0-9=fit p=plot  q=quit r=remove(v4.2 only)  w=window g=grid';
ylab = 'click to add';
sout=[];sinv=[];

if nargin == 0,   disp(usage);   return
end %if

[dtype,drows,dcols,dnum] = minfo(in);

if dtype=='cons'
    if (drows == 1) & (dcols == 4)
       in = vpck(in(3:4)',in(1:2)');	insym = '.y';
     else disp([usage ' in = [xmin xmax ymin ymax] ']);return;
    end % if (drows
 elseif dtype == 'vary',	insym = ':';
 else   disp([usage ':  in must be constant or varying']);   return;
end % if dtype=='cons'

if nargin <4,	mf=[]; omega=[];clf;hold off;vplot('liv,lm',in,insym);
 else	[dtype,drows,dcols,dnum] = minfo(init_pts);
	if (dtype ~='vary')|(drows~=1)|(dcols~=1) 
	  disp([usage ': init_pts must be 1x1 varying']	);  return;
	end% if 
	[mf,rowpoint,omega] = vunpck(init_pts);
	clf; hold off; vplot('liv,lm',in,insym,init_pts,'+g');  
end % if nargin ==1

if nargin <3,string=''; end
if nargin <2,dim=1; end

title([ string ': ' 'initial data' ]);xlabel(xlab);ylabel(ylab);
grid_on = 0;
sysout_g = xtract(in,0); sysout_g_old = sysout_g; old_ord = ' ' ; new_ord = ' ';
hold on;   [x,y,button]=ginput(1);
matlab_ver = version;

%%%%%%%%%%%%%%%%%%%%%%%% main loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while button ~= abs('q')  

	if any(button == [1 2 3 abs('a')]);		    % add mode
	  if strcmp(matlab_ver(1),num2str(3))
 		loglog(x,y,'+r')                            % version 3
	  else
		loglog(x,y,'+r','EraseMode','xor');         % version 4 
	  end
		mf = [mf ; y]; omega = [ omega ; x];
	elseif button ==  abs('r');		            % remove mode
		[dummy,indx] = min(abs(omega - x));
	  if strcmp(matlab_ver(1),num2str(4))
		loglog(omega(indx), mf(indx),'+i','EraseMode','background');
	  else
		loglog(omega(indx), mf(indx),'+i');
	  end
		omega = [omega(1:(indx-1)); omega((indx+1):length(omega))];
		mf = [mf(1:(indx-1)); mf((indx+1):length(mf))];
	elseif (button >= 48)&(button <= 57)&(~isempty(omega));	% fit mode
		order = button - 48; 
		new_ord = ['fit order: new(solid) = ' num2str(order) '  '];
		[omega,indx] = sort(omega); mf = mf(indx);
		pts = vpck(mf,omega);
		sysout = magfit(pts,[.26 .1 order order ]);
		log_min = floor(log10(min(omega)));
		log_max = ceil(log10(max(omega)));
		omega_ex = sort([logspace(log_min,log_max,100) omega']);
		sysout_g_old = sysout_g;
		sysout_g = frsp(sysout,omega_ex);
		hold off;clf; axis([0 0.001 0 0.001]); axis;
	    vplot('liv,lm',in,insym,sysout_g,'-r',sysout_g_old,'--b',pts,'+g');
		title([ string ': ' new_ord old_ord]);
		if grid_on, grid; end 
		hold on;xlabel(xlab);ylabel(ylab);
		old_ord = ['old(dashed) = ' num2str(order) '  '];
	elseif (button >= 48)&(button <= 57)&(isempty(omega));	% fit mode
		disp('must have data to fit');
	elseif (button == abs('w'));			% window mode
		[x1,y1,button]=ginput(1);
		x = [x x1]; y = [y y1];
		hold off;clf; 
		[omega,indx] = sort(omega); mf = mf(indx);
		pts = vpck(mf,omega);
	  if strcmp(matlab_ver(1),num2str(3))
                axis(log10( [min(x),max(x),min(y),max(y)] ));    % version 3
                vplot('liv,lm',in,insym,sysout_g,'-r',pts,'+g');
	  else
                vplot('liv,lm',in,insym,sysout_g,'-r',pts,'+g'); % not version 3
                axis( [10^(floor(log10(min(x)))),10^(ceil(log10(max(x)))),...
                       10^(floor(log10(min(y)))),10^(ceil(log10(max(y)))) ] )
	  end
		if grid_on, grid; end 
		hold on;xlabel(xlab);ylabel(ylab);
		title([ string ': ' 'window mode:  ' new_ord ]);
	elseif (button == abs('p'));			% plot mode
		hold off;clf; axis([0 0.0001 0 0.0001]); axis;
		[omega,indx] = sort(omega); mf = mf(indx);
		pts = vpck(mf,omega);
		vplot('liv,lm',in,insym,sysout_g,'-r',pts,'+g');
		if grid_on, grid; end 
		hold on;xlabel(xlab);ylabel(ylab);
		title([ string ': ' new_ord ]);
	elseif (button == abs('k'))
		keyboard;
	elseif (button == abs('g'))
		grid_on = ~grid_on;
	end %if 

	[x,y,button]=ginput(1);

end %while
%%%%%%%%%%%%%%%%%%%%%%% clean up and return %%%%%%%%%%%%%%%%%%
[omega,indx] = sort(omega); mf = mf(indx);

pts = vpck(mf,omega);
for n=1:dim,
sout=daug(sout,sysout);
sinv=daug(sinv,minv(sysout));
end

% hold off; axis([0 0.0001 0 0.0001]); axis('auto');
hold off; axis([0 0.0001 0 0.0001]); axis;
clf
