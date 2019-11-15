% Function to compute position of a figure coordinates
% Example usage : 
% pos = co2nfu(gca,[xpos,ypos]) to compute a from a 2D plot coordinates to
% corresponding figure coordinates in normalized fashion
% Written by Mriganka Roy
%
% (c) 2019 Kiran Vaddi, Mriganaka Roy
function varargout = co2nfu(varargin)
%CO2NFU(fig_handle,[x1,x2,...,y1,y2,...])

narginchk(1, 3)
if length(varargin)~= 1 && ishandle(varargin{1}) 
    if strcmp(get(varargin{1},'type'),'axes')
        hAx = varargin{1};
    else
        warning('The first argument should have been the Axis handle of the figure\nTaking the current axis.')
        hAx = gca;
    end
    varargin = varargin(2:end);
else % Figure handle not given
	hAx = gca;
end

% Proceed with remaining inputs
errmsg = 'X and Y coordinates must be in pairs';
if length(varargin)==1	% Must be 4 elt POS vector
    pos = varargin{1};
    if isinteger(length(pos)/2)
        error(errmsg);
    end
else
    [X,Y] = deal(varargin{:});
    if length(X) ~= length(Y)
        error('Please provide start and end coordinate')
    end
end


%% Get limits
set(hAx,'Units','normalized');
axpos = get(hAx,'Position');
axlim = axis(hAx);
axOuterPos = get(hAx,'OuterPosition');
% axwidth = diff(axlim(1:2));
% axheight = diff(axlim(3:4));
% AX = axis(hAx);
% Xrange = AX(2) - AX(1);
% Yrange = AX(4) - AX(3);
%% Transform data
if exist('X','var')
	varargout{1} = interp1(axlim(1:2),[axpos(1),axpos(3)+axpos(1)],X);%(X-axlim(1))*axpos(3)/axwidth + axpos(1);
	varargout{2} = interp1(axlim(3:4),[axpos(2),axpos(4)+axpos(2)],Y);%(Y-axlim(3))*axpos(4)/axwidth + axpos(2);
else
	pos(1:end/2) = interp1(axlim(1:2),[axpos(1),axpos(3)+axpos(1)],pos(1:end/2));%(pos([1,2])-axlim(1))/axwidth*axpos(3) + axpos(1);
	pos(end/2+1:end) = interp1(axlim(3:4),[axpos(2),axpos(4)+axpos(2)],pos(end/2+1:end));%(pos([3,4])-axlim(3))/axheight*axpos(4) + axpos(2);
	varargout{1} = pos;
end
