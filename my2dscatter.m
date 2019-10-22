function [varargout]=my2dscatter(data,varargin)
% function []=my2dscatter(data,varargin)
% Creates a 2D scatter plot of the data with each column on one axis
% Inputs:     data: an N-by-3 column matrix
%             Options:
%                     pointsize       :   Point Size in the scatter plot (default, 35)
%                     colorcode       :   Color code for each data point. An integer vectors on size N-by-1
%                     color           :   Single color for a data point. (default, Blue)
%                     xlabel          :   xlabel name
%                     ylabel          :   ylabel name
% Outputs:    h       :   Figure handle
%             hcb     :   Colorbar handle    
% See also fig_labels, my3dscatter

global pars

pars.pointsize = 35;
pars.colorcode = [];
pars.color = 'b';
pars.xlabel = 'x';
pars.ylabel = 'y';
pars.marker = 'filled';
pars.legend = 0;

pars = extractpars(varargin,pars);

% identify the colorcode type
if isempty(pars.colorcode)
    colorcode_type = 1;
elseif size(pars.colorcode,2)>1
    colorcode_type = 2;
else
    colorcode_type = 3;
end

switch colorcode_type
    case 3
        uniqueLabels = (unique(pars.colorcode))';
        try
            colors = my_color_palette(length(unique(pars.colorcode)));
        catch ME
            if strcmp(ME.identifier,'MATLAB:badsubscript')
                fprintf('Using hsv... \n')
                colors = hsv(length(unique(pars.colorcode)));
            else
                rethrow(ME)
            end
        end
        for i=1:length(uniqueLabels)
            h = scatter(data(pars.colorcode==uniqueLabels(i),1),...
                data(pars.colorcode==uniqueLabels(i),2),...
                pars.marker,...
                'MarkerFacecolor',colors(i,:),'MarkerEdgeColor','none');
            hold on;
            h.SizeData = pars.pointsize;
        end
        hold off;
        hcb = colorbar;
        colormap(colors)
        hcb.Ticks = linspace(0.05,1,length(uniqueLabels));
        hcb.TickLabels=cellstr(string(uniqueLabels));
        hcb.TickLabelInterpreter = 'latex';
        hcb.FontSize = 15;
        if pars.legend
            hcb.Visible = 'off';
            legend(hcb.TickLabels,'location','best',...
                'Interpreter','latex')
        end
    case 1
        h = scatter(data(:,1),data(:,2),pars.marker);
        h.MarkerFaceColor=pars.color;
        hcb=[];
        h.SizeData = pars.pointsize;
    case 2
        h = scatter(data(:,1),data(:,2),[],pars.colorcode,pars.marker);
        hcb=[];
        h.SizeData = pars.pointsize;

end

if nargout>1
    varargout{1}=h;
    varargout{2}=hcb;
else
    varargout{1}=h;
end
fig_labels(2,'xlabel',pars.xlabel,'ylabel',pars.ylabel);
grid off;
clear globar pars
