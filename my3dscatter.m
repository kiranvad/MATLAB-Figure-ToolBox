function [h,hcb]=my3dscatter(data,varargin)
% function []=my3dscatter(data,varargin)
% Creates a 3D scatter plot of the data with each column on one axis
% Inputs:     data: an N-by-3 column matrix
%             Options:
%                     pointsize       :   Point Size in the scatter plot (default, 35)
%                     colorcode       :   Color code for each data point. An integer vectors on size N-by-1
%                     color           :   Single color for a data point. (default, Blue)
%                     xlabel          :   xlabel name
%                     ylabel          :   ylabel name
%                     zlabel          :   zlabel name
% Outputs:    h       :   Figure handle
%             hcb     :   Colorbar handle    
%

global pars

pars.pointsize = 35;
pars.colorcode = [];
pars.color = 'b';
pars.xlabel = 'x';
pars.ylabel = 'y';
pars.zlabel = 'z';


pars = extractpars(varargin,pars);

if ~isempty(pars.colorcode)
    uniqueLabels = (unique(pars.colorcode))';
    colors = hsv(length(uniqueLabels));
    for i=1:length(uniqueLabels)
        h = scatter3(data(pars.colorcode==uniqueLabels(i),1),...
            data(pars.colorcode==uniqueLabels(i),2),...
            data(pars.colorcode==uniqueLabels(i),3),'filled',...
            'MarkerFacecolor',colors(i,:),'MarkerEdgeColor','none');
        hold on;
    end
    hold off;
    hcb = colorbar;
    colormap(hsv(length(unique(pars.colorcode))))
    hcb.Ticks = linspace(0.05,1,length(uniqueLabels));
    hcb.TickLabels=cellstr(string(uniqueLabels));
    hcb.TickLabelInterpreter = 'latex';
    hcb.FontSize = 15;
else
    h = scatter3(data(:,1),data(:,2),data(:,3),'filled');
    h.MarkerFaceColor=pars.color;
    hcb=[];
end
h.SizeData = pars.pointsize;

fig_labels(3,pars);
grid off;
clear globar pars
