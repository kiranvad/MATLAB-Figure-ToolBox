% Make a waterfall plot for any given data matrix Y : Size n X d with its X
% axis specified as n X d matrix
% n -- samples d -- dimension 
% 
% Written based on a stack overflow answer here: 
% https://stackoverflow.com/questions/30133723/matlab-multiple-stacked-plots
%
% Example usage:
%   t=10:20:110;
%   x=0:1:200;
%   Y=bsxfun(@(x,t) normpdf(x,t,20),x,t.');
%   x = repmat(x,size(Y,1),1);
%   plot_waterfall(x,Y);
%   when you've a seperate colorcode:
%   ccode = 1:size(Y,1); % Colorcode as a vector
%   plot_waterfall(x,Y,'colorcode',ccode)
%   ccode = jet(size(Y,1)); % Colorcode as RGB
%   plot_waterfall(x,Y,'colorcode',ccode)

%   Copyright (c) Kiran Vaddi, 11-2019
function [varargout]=plot_waterfall(X,Y,varargin)

pars.tspace = 1;
pars.colorcode = zeros(size(Y,1),1);
pars.cmap = 'jet';
pars = extractpars(varargin,pars);

if size(pars.colorcode,2)==3
    plottype = 2;
elseif size(pars.colorcode,2)==1
    plottype = 1;
else
    plottype = 1;
end

switch plottype
    case 1
        %// create some sample data
        t=1:pars.tspace:pars.tspace*size(Y,1);
        t = repmat(t',1,size(X,2));
        %// Plot the first set of lines (red ones)
        ccode = repmat(pars.colorcode,1,size(Y,2));
        h=waterfall(X,t,Y,ccode);
        set(h,'FaceColor','none','LineWidth',2) %// tweak the properties
        colormap(pars.cmap);
        fig_labels(3)
    case 2
        for i = 1:size(Y,1)
            h(i) = plot3(i*ones(1,size(Y,2)),X(i,:),Y(i,:),'Color',pars.colorcode(i,:),'LineWidth',2.0);
            hold on;
        end
        hold off;
        fig_labels(3)
end
if nargout==1
    varargout{1}=h;
end
