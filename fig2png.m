% Takes all fig files in a folder and saves them as PNG in a seperate
% folder/PNG folder
% Input the folder with the fig files in full excluding the last slash
%
% (c) Kiran Vaddi 10-2019
function []=fig2png(folder)

fig_files = dir([folder '/*.fig']);
png_folder = [folder '/PNGs'];
if ~exist(png_folder,'dir')
    mkdir(png_folder)
end

for figs = 1:length(fig_files)
    save_name = [png_folder '/' strtok(fig_files(figs).name,'.fig')];
    openfig([fig_files(figs).folder '/' fig_files(figs).name],'invisible')
    print(save_name,'-dpng','-r400');
    close;
end
