
function []=fig_noticks(d)
%Remove all the ticks for a 2D/3D plot
%function []=fig_noticks(d)
%Inputs  :   d: dimension of the plot 2/3

set(gca,'xtick',[]);
set(gca,'xticklabel',[]);
set(gca,'ytick',[])
set(gca,'yticklabel',[]);
if d==3
    set(gca,'ztick',[])
    set(gca,'zticklabel',[]);
end
axis tight