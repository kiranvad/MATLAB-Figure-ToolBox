%  Radial visualization of high dimensional data built based on radviz
%  function from :
% " Majumdar, Nivedita. MATLAB Graphics and Data Visualization Cookbook. 
%  Packt Publishing Ltd, 2012. " 
% 
% Inputs:
% ======
% data    :   High dimensional input space nxD
% colors  :   Color code to visualize the representation with nx1
% 
% Options:
% -------
% 'showcmap'      :   1 (to show colormap) 0 (show a legend instead, default)

% (c) Copyright Kiran Vaddi 2019

function [varargout]=plot_radviz(data,varargin)
pars.showcmap = 0;
pars.colors = [0 0 1];
pars.rescale = 1;
pars = extractpars(varargin,pars);

% determine legend mode
switch size(pars.colors,1)
    case 1
        show_legend = 0;
    case size(data,1)
        show_legend = 1;
end

set(gcf,'units','normalized','position',...
 [.30 .35 .35 .55]);
if pars.rescale
    data = myNormalizeData(data);
end
[ux, uy, R] = radviz(data);
for i=1:size(R,1)
    Rlabels{i} = ['D' num2str(i)];
end
h1=my2dscatter(R,'pointsize',100,'color','k');
text(R(:,1)+0.02,R(:,2)+0.02,Rlabels,'FontSize',20,...
    'Interpreter','latex')
h1.HandleVisibility='off';
hold on;
[~,hcb]=my2dscatter([ux' uy'],'colorcode',pars.colors,'pointsize',75);
if show_legend
    hcb.Visible = 'off';
    legend_labels = cellstr(string(unique(pars.colors)));
    legend(legend_labels','location','best','Interpreter','latex')
    legend('boxoff')
elseif pars.showcmap
    hcb.Location='southoutside';
else
    hcb.Visible = 'off';
end
hold on;
plot(cos((pi/180)*linspace(0,360,361)),...
 sin((pi/180)*linspace(0,360,361)),'k--',...
 'LineWidth',2.0,'HandleVisibility','off');
hold off;
set(gca,'Visible','off');


if nargout>1
    varargout{1}= ux;
    varargout{2}= uy;
    varargout{3}= R;
end

function [ux,uy,R] = radviz(data)

% This function accepts a n x m dataset, representing n observation of m
% dimensions each. (The m dimensions should each be scaled between 0 and 1. 
% It will calculate the 2D radial coordinates corresponding to
% the m dimensional data point using a non-linear mapping. The idea is, 
% consider a point in a 2D space, connected to m equally spaced point on 
% some circle with springs. Now, consider each of the m dimensions of the 
% data point as the spring constant for the corresponding springs. Now, 
% consider if the centre point is allowed to move and reach equilibrium position. 
% This would be the mapping of the m dimensional point onto 2D space. In order 
% to determine the location of the data point the sum of the spring forces needs 
% to equal zero. 

sj = linspace(0,360,size(data,2)+1);
xj = cos((pi/180)*sj(1:end-1));
yj = sin((pi/180)*sj(1:end-1));
R = [xj' yj'];
for i = 1:size(data,1)
    I=find(data(i,:)~=-inf);
    wij = zeros(size(data(i,:)));
    wij(I) = data(i,I)/nansum(data(i,I));
    ux(i) = nansum(wij(I).*xj(I));
    uy(i) = nansum(wij(I).*yj(I));    
end
