function []=fig_labels(d,varargin)
%function []=fig_labels(d,varargin)
%Inputs	:	dimension as d (default 2)
%
%Options : 	xlabel	:	xlabel name
%		ylabel	:	ylabel name
%		zlabel	:	zlabel name if d is set to 3
%		title	:	title name 
%		axtight	:	1 (to activate axis tight,default) 0 (otherwise) 

%%
global pars

pars.xlabel = 'x';
pars.ylabel = 'y';
pars.zlabel = 'z';
pars.title  =  [];
pars.axtight = 1;

pars = extractpars(varargin,pars);


xlabel(pars.xlabel,'Interpreter','latex','FontSize',20)
ylabel(pars.ylabel,'Interpreter','latex','FontSize',20)

if d==3
    zlabel(pars.zlabel,'Interpreter','latex','FontSize',20)
end
ax=gca;
ax.Box = 'on';
ax.LineWidth = 2.0;
ax.TickLabelInterpreter='latex';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
if ~isempty(pars.title)
    t = title(pars.title);
    t.Interpreter = 'latex';
    t.FontSize = 20;
end
if d==3
    ax.ZMinorTick = 'on';
end
ax.FontSize = 18;
if pars.axtight
    axis tight
end

clear global pars
