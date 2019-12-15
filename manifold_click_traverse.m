% A helper function to plot and traverse 2d/3d manifolds.
% Inputs :
% --------
% griddata      :   2d or 3d manifold data nxd
% plotdata      :   A structure with the following fields
%                     xaxis   :   A column vector of common input Dxn
%                     yaxis   :   A matrix of vectorial outputs Dxn
% Options:
% --------
%   'plottype'  :   'embed'     :   Embeds the high dimensional response in the graph
%                   'paths'     :   Plot the data and grid in two seperate windows with
%                                   Window 1 to contain the clicked points and direction of traversal
%                   'terndata'  :   additionally plots ternary data in a 
%                                   in the data pplot as a subplot with a tracker using quiver plots
%                                   This mode requries MATLAB ternary plotting codes available at 
%                                   : https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots
%                                   The terplot.m function is provided along with the toolbox with few modifications
%     'exit'      :   1(default, close the windows at the end of the program)
%                     0 (keeps the windows so that the figures can be saved)
%     'zoom'      :   1(default, zoom into a region of data in the 2D grid) 0 (do not zoom in )
%     'plotverbose'   :   0 (default, does not show instruction on the figures to user)
%                         1 (show instructions on the figures)
% Outputs :
% ---------
% You can request to produce figure handles:
%        1) Emebdding Handle 2)Data Pullback figure handle
% Title shows the instructions to traverse and reset the plots as well as exiting the program
% Additional Notes: See the function using <open manifold_click_traverse.m>
% Examples:
% ---------
% x = linspace(-2*pi,2*pi,100);
% y = sin(x);
% griddata = [x;y];
% plotdata.xaxis = repmat(x,[10,1]);
% plotdata.yaxis = repmat(y,[10,1]);
% Embed the data plots with in the 2D manifold
% manifold_click_traverse(griddata,plotdata,'plottype','embed')
% Plot data plots seperately
% manifold_click_traverse(griddata,plotdata,'plottype','paths')
% Plot the data and a ternary composition seperately
% manifold_click_traverse(griddata,plotdata,'plottype','terndata')

% This function comes with three types of plotting options. 
% 
% 1)Embeddings : This mode is activated by just setting the 'plottype' option to 'embed'. 
% This results in one full size figure where you can click on a point and a small
% window of plot will appear with corresponding 2D vector plotted. Vectorial data which is plotted in the small
% embedded window needs to be store in proper format in plotdata.xaxis (dimension X Samples ) and .yaxis (dimension X Samples )
% 
% 2) Paths :  This mode first shows an pplot of 2D grid where you can click on points.
% Once you click on any point, corresponding 2D vector is plotted in a seperte window.
% Along with this, when morethan one point is selected, a vectororial path is shown on the 2D grid (refered as a manifold)
% Data needs to be stored in the same manner as previous mode
% 
% 3) Ternary data and 2D data :  This mode is similar to Paths mode along with the data points tracked 
% on a ternary plot
% Along with vectorial data in plotdata input, a .terndata needs to be added of the size (Samples X 3).
% This mode requires terplot.m function from <https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots>
%
% 

% (c) copyright Kiran Vaddi 05-2019

function [varargout]= manifold_click_traverse(griddata,plotdata,varargin)
pars.plottype='embed';
pars.exit = 1;
pars.zoom = 1;
pars.plotverbose = 0;

pars = extractpars(varargin,pars);

if size(plotdata.xaxis,2)==1
    plotdata.xaxis = repmat(plotdata.xaxis,[1,size(plotdata.yaxis,2)]);
end

switch pars.plottype
    case 'paths'
        gridfig=figure('Units','normalized','Position',[0,0.2,0.45,0.5]);
    case 'embed'
        gridfig=figure('Units','normalized','Position',[0,0,1,1]);
    case 'terndata'
        gridfig=figure('Units','normalized','Position',[0,0.2,0.35,0.4]);
        
end

fgrid=axes;
if size(griddata,2)==2
    my2dscatter(griddata);
    if pars.plotverbose
        fig_labels(2,'title','Click a point to plot Press any Key to exit')
    end
elseif size(griddata,2)==3
    my3dscatter(griddata);
    if pars.plotverbose
        fig_labels(3,'title','Click a point to plot Press any Key to exit')
    end
else
    error('Only 2d or 3d manifold data are allowed')
end


set(0, 'CurrentFigure', gridfig)
if pars.zoom
    disp('Zoom into an area and press enter')
    pause;
end
W = waitforbuttonpress;

switch pars.plottype
    case 'paths'
        figure('Units','normalized','Position',[0.5,0.2,0.45,0.7]);
        fdata=axes;
        fig_labels(2,'title','Data selected')
        [Wout]=plotter_manifold_traverse(W,gridfig,fgrid,fdata,griddata,plotdata);
    case 'embed'
        [Wout]=plotter_manifolddataembed(W,fgrid,griddata,plotdata);
    case 'terndata'
        figure('Units','normalized','Position',[0.4,0.2,0.5,0.5]);
        for subplotid = 1:2
            fdata(subplotid) = subplot(1,2,subplotid);
        end
        [Wout]=plotter_data_ternary_traverse(W,gridfig,fgrid,fdata,griddata,plotdata);
end

if Wout==1
    set(0, 'CurrentFigure', gridfig)
    if pars.plotverbose
        fig_labels(2,'title','Click to reset or Press key to exit')
    end
    Wnew = waitforbuttonpress;
    if Wnew==0
        close all;
        manifold_click_traverse(griddata,plotdata,'plottype',pars.plottype,'zoom',pars.zoom,'exit',pars.exit);
    elseif pars.exit
        close all;
        fprintf('Program Exit requested \n')
    end
end
if nargout==1
    varargout{1}=fgrid;
elseif nargout==2
    varargout{1}=fgrid;
    varargout{2}=fdata;
end

end

% Plot data seperately in a figure next to the manifold plot
function [W]=plotter_manifold_traverse(W,gridfig,fgrid,fdata,griddata,plotdata)
while W==0
    set(0, 'CurrentFigure', gridfig)
    Cp = get(gca,'CurrentPoint');
    clickind = getnearestclickedpoint(Cp,griddata);
    pt_new = [griddata(clickind(1),1),griddata(clickind(1),2)];
    
    fdata.NextPlot='add';
    plot(fdata,plotdata.xaxis(:,clickind(1)),plotdata.yaxis(:,clickind(1)),'linewidth',2.0,'Color','b');
    ylim(fdata,[min(plotdata.yaxis(:)) max(plotdata.yaxis(:))]);
    fig_labels(fdata)
    if size(griddata,2)==2
        fgrid.NextPlot='add';
        plot(fgrid,pt_new(1),pt_new(2),'ro','MarkerSize', 10,'LineWidth',2.0)
        if exist('pt_old','var')
            dp = pt_new - pt_old;
            fgrid.NextPlot='add';
            qh = quiver(fgrid,pt_old(1),pt_old(2),dp(1),dp(2),0);
            qh.LineWidth = 2.0;
            qh.LineStyle = '-';
            qh.Color = [1 0 0];
            qh.MaxHeadSize = 1;
        end
    else
        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
    end
    
    W = waitforbuttonpress;
    pt_old = pt_new;
end
end

% Embedd data plot to manifold
function [W]=plotter_manifolddataembed(W,fgrid,griddata,plotdata)
while W==0
    Cp = get(gca,'CurrentPoint');
    clickind = getnearestclickedpoint(Cp,griddata);
    
    fgrid.NextPlot='add';
    if size(griddata,2)==2
        plot(fgrid,griddata(clickind,1),griddata(clickind,2),'ro','MarkerSize', 10,'LineWidth',2.0)
    else
        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),...
            griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
    end
    
    clicfigpos = co2nfu(gca,[Cp(1,1),Cp(1,2)]);
    if any(isnan(clicfigpos))
        W = waitforbuttonpress;
        continue;
    end
    axes('Position',[ clicfigpos(1) clicfigpos(2) 0.1 0.1]);
    box on
    plot(plotdata.xaxis(:,clickind),plotdata.yaxis(:,clickind)...
        ,'linewidth',2.0,'Color','b');
    ylim([min(plotdata.yaxis(:)) max(plotdata.yaxis(:))]);
    %fig_labels(2)
    
    W = waitforbuttonpress;
end
end

% Plot the data and a corresponding position in a ternary plot
function [W]=plotter_data_ternary_traverse(W,gridfig,fgrid,fdata,griddata,plotdata)
while W==0
    set(0, 'CurrentFigure', gridfig)
    Cp = get(gca,'CurrentPoint');
    clickind = getnearestclickedpoint(Cp,griddata);
    pt_new = [griddata(clickind(1),1),griddata(clickind(1),2)];
    fdata(1).NextPlot='add';
    subplot(fdata(1)) % Add high dimensional data to subplot 1
    plot(fdata(1),plotdata.xaxis(:,clickind(1)),plotdata.yaxis(:,clickind(1)),'linewidth',2.0,'Color','b');
    ylim(fdata(1),[min(plotdata.yaxis(:)) max(plotdata.yaxis(:))]);
    fig_labels(fdata(1))
    
    ternax = subplot(fdata(2));
    if ~exist('pt_old','var')
        terplot(5,ternax);
        [ternx,terny]=get_tern_coords(plotdata.terndata);
        ternax.NextPlot = 'add';
        plot(ternax,ternx,terny,'ko','MarkerSize', 5,'LineWidth',0.5)
    end
    tern_new = [ternx(clickind(1)),terny(clickind(1))];
        
    ternax.NextPlot = 'add';
    plot(ternax,tern_new(1),tern_new(2),'k.','MarkerSize', 10,'LineWidth',2.0)
    if exist('pt_old','var')
        dp = tern_new - tern_old;
        fgrid.NextPlot='add';
        qh = quiver(ternax,tern_old(1),tern_old(2),dp(1),dp(2),0);
        qh.LineWidth = 2.0;
        qh.LineStyle = '-';
        qh.Color = [1 0 0];
        qh.MaxHeadSize = 1;
    end
    if size(griddata,2)==2
        fgrid.NextPlot='add';
        plot(fgrid,pt_new(1),pt_new(2),'ro','MarkerSize', 10,'LineWidth',2.0)
        if exist('pt_old','var')
            dp = pt_new - pt_old;
            fgrid.NextPlot='add';
            qh = quiver(fgrid,pt_old(1),pt_old(2),dp(1),dp(2),0);
            qh.LineWidth = 2.0;
            qh.LineStyle = '-';
            qh.Color = [1 0 0];
            qh.MaxHeadSize = 1;
        end
    else
        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
    end
    
    W = waitforbuttonpress;
    pt_old = pt_new;
    tern_old = tern_new;
end
end


function[Ip]= getnearestclickedpoint(Cp,griddata)
X = griddata(:,1);
Y = griddata(:,2);
if size(griddata,2)==3
    Z=griddata(:,3);
else
    Z=ones(size(griddata,1));
end
Xp = 0.5*(Cp(1,1)+Cp(2,1));  % X-point
Yp = 0.5*(Cp(1,2)+Cp(2,2));  % Y-point
Zp = 0.5*(Cp(1,3)+Cp(2,3));  % Z-point
% Find the minimum distance to determine
% which point is closest to the mouse
% click and return indices
[~,Ip] = min((X-Xp).^2+(Y-Yp).^2+(Z-Zp).^2);
% disp(Ip(1))
end

function [x,y]=get_tern_coords(terndata)
c1 = terndata(:,1);
c2 = terndata(:,2);
c3 = terndata(:,3);
if max(c1+c2+c3)>1
    c1=c1./(c1+c2+c3);
    c2=c2./(c1+c2+c3);
    c3=c3./(c1+c2+c3);
end
for i=1:length(c1)
    x(i)=0.5-c1(i)*cos(pi/3)+c2(i)/2;
    y(i)=0.866-c1(i)*sin(pi/3)-c2(i)*cot(pi/6)/2;
end
end
