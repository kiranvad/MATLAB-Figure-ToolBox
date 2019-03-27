function []=fig_save(varargin)
%function []=fig_save(varargin)
% Options: 	
%	format 		: 	Specifiy the format such as epsc, png (default), fig
%                   etc
%	fname 		: 	specify a name to save the file (default figure)
%	directory  	: 	Specify the directory to save the image in (default pwd)
%

%%
pars.format = 'png';
pars.fname = 'figure';
pars.directory = pwd;
pars = extractpars(varargin,pars);

if ~strcmp(pars.directory,pwd)
    if ~exist(pars.directory, 'dir')
        mkdir(pars.directory)
        fprintf('Requested directory does not exist \n')
        fprintf(['Created directory' pars.directory '\n'])
    end
else
    pars.directory = [pwd '/Figures'];
    if ~exist(pars.directory, 'dir')
        mkdir(pars.directory)
        fprintf(['Figure would be saved in: ' pars.directory '\n'])
    end
end

fname = [pars.directory '/' pars.fname '.' pars.format];
saveas(gcf,fname, pars.format);

    
