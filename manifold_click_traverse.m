% A helper function to plot and traverse 2d/3d manifolds.
% Inputs : 
% --------
% griddata      :   2d or 3d manifold data nxd 
% plotdata      :   A structure with the following fields
%                     xaxis   :   A column vector of common input Dx1
%                     yaxis   :   A matrix of vectorial outputs Dxn
% Title shows the instructions to traverse and rest the plots as well as exiting the program

% (c) copyright Kiran Vaddi 05-2019
function manifold_click_traverse(griddata,plotdata,varargin)
pars.plottype=2;

pars = extractpars(varargin,pars);


gridfig=figure('Units','normalized','Position',[0,0.2,0.45,0.5]);
fgrid=axes;
if size(griddata,2)==2
    my2dscatter(griddata);
    fig_labels(2,'title','Click a point to plot Press any Key to exit')
elseif size(griddata,2)==3
    my3dscatter(griddata);
    fig_labels(3,'title','Click a point to plot Press any Key to exit')
else
    error('Only 2d or 3d manifold data are allowed')
end

figure('Units','normalized','Position',[0.5,0.2,0.45,0.5]);
fdata=axes;
fig_labels(2,'title','Data selected')
set(0, 'CurrentFigure', gridfig)
W = waitforbuttonpress;
plottype=pars.plottype;

Wout=plotter_manifold_traverse(W,fgrid,fdata,griddata,plotdata,plottype);
if Wout==1
    set(0, 'CurrentFigure', gridfig)
    fig_labels(2,'title','Click to reset or Press key to exit')
    Wnew = waitforbuttonpress;
    if Wnew==0
        close all;
        manifold_click_traverse(griddata,plotdata,'plottype',pars.plottype);
    else
        close all;
        fprintf('Program Exit requested \n')
    end
end

    function W=plotter_manifold_traverse(W,fgrid,fdata,griddata,plotdata,plottype)
        while W==0
            if plottype==1
                Cp = get(gca,'CurrentPoint');
                clickind = getnearestclickedpoint(Cp,griddata);
                try
                    plot(fdata,plotdata.xaxis,plotdata.yaxis(:,clickind),'linewidth',2.0,'Color','b')
                    fgrid.NextPlot='add';
                    if size(griddata,2)==2
                        plot(fgrid,griddata(clickind,1),griddata(clickind,2),'ro','MarkerSize', 10,'LineWidth',2.0)
                    else
                        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
                    end
                catch ME
                    rethrow(ME)
                end
                W = waitforbuttonpress;
            else
                Cp = get(gca,'CurrentPoint');
                clickind = getnearestclickedpoint(Cp,griddata);
                try
                    fdata.NextPlot='add';
                    plot(fdata,plotdata.xaxis,plotdata.yaxis(:,clickind),'linewidth',2.0,'Color','b')
                    fgrid.NextPlot ='add';
                    if size(griddata,2)==2
                        plot(fgrid,griddata(clickind,1),griddata(clickind,2),'ro','MarkerSize', 10,'LineWidth',2.0)
                    else
                        plot3(fgrid,griddata(clickind,1),griddata(clickind,2),griddata(clickind,3),'ro','MarkerSize', 10,'LineWidth',2.0)
                    end
                catch ME
                    rethrow(ME)
                end
                W = waitforbuttonpress;
            end
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
        
    end
end