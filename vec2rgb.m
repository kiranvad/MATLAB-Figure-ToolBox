% From a a CData vector, generate the corresponding RGB
% values
function [rgb,cmap]=vec2rgb(Cdata,varargin)
pars.cmap = 'parula';
pars = extractpars(varargin,pars);

h = figure('visible','off');
cmap = colormap(h,pars.cmap);
% make it into a index image.
cmin = min(Cdata(:));
cmax = max(Cdata(:));
m = length(cmap);
index = fix((Cdata-cmin)/(cmax-cmin)*m)+1; %A
% Then to RGB
RGB = ind2rgb(index,cmap);
rgb = reshape(RGB,[size(Cdata,1),3]);
close(h);
end

