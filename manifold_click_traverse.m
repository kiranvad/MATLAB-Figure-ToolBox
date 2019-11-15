% A helper function to plot and traverse 2d/3d manifolds.
% Inputs :
% --------
% griddata      :   2d or 3d manifold data nxd
% plotdata      :   A structure with the following fields
%                     xaxis   :   A column vector of common input Dx1
%                     yaxis   :   A matrix of vectorial outputs Dxn
% Outputs :
% ---------
% You can request to produce figure handles:
%        1) Emebdding Handle 2)Data Pullback figure handle
% Title shows the instructions to traverse and reset the plots as well as exiting the program

% (c) copyright Kiran Vaddi 05-2019
function [varargout]= manifold_click_traverse(griddata,plotdata,varargin)
pars.plottype=2;
pars.exit = 1;
pars.zoom = 1;
pars.plotverbose = 0;

pars = extractpars(varargin,pars);

if size(plotdata.xaxis,2)==1
    plotdata.xaxis = repmat(plotdata.xaxis,[1,size(plotdata.yaxis,2)]);
end

switch pars.plottype
    case 1
        gridfig=figure('Units','normalized','Position',[0,0.2,0.45,0.5]);
    case 2
        gridfig=figure('Units','normalized','Position',[0,0,1,1]);
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
    case 1
        figure('Units','normalized','Position',[0.5,0.2,0.45,0.5]);
        fdata=axes;
        fig_labels(2,'title','Data selected')
        [Wout]=plotter_manifold_traverse(W,gridfig,fgrid,fdata,griddata,plotdata);
    case 2
        [Wout]=plotter_manifolddataembed(W,fgrid,griddata,plotdata);
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
    
    fdata.NextPlot='add';
    plot(fdata,plotdata.xaxis(:,clickind),plotdata.yaxis(:,clickind),'linewidth',2.0,'Color','b');
    ylim(fdata,[min(plotdata.yaxis(:)) max(plotdata.yaxis(:))]);
    fig_labels(2)
    fgrid.NextPlot='add';
    if size(griddata,2)==2
        plot(fgrid,griddata(clickind,1),griddata(clickind,2),'ro','MarkerSize', 10,'LineWidth',2.0)
    else
        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
    end
    
    W = waitforbuttonpress;
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
