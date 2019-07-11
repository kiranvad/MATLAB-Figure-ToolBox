% Create two color blind friend color palleter and returns them as outputs
% Can request upto maximum of 10 colors
function [out]=my_color_palette(varargin)
if nargin<1
    n=10;
else
    n = varargin{1};
end
color_palette_full = [44,162,95;136,86,167;67,162,202;227,74,51;161,215,106;...
    221,28,119;28,144,153;250,159,181;253,187,132;127,205,187];
out = color_palette_full(1:n,:)/255;
% x = 1:length(out);
% y = 1:length(out);
% scatter(x,y,500,out,'filled');