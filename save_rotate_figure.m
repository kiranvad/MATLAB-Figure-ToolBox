% This function rotates a figure using its axis handle.
% You can request it to produce a structure that cab be used it save the
% rotations as a video using another utilty function with in the tool box
% called 'write_video.m'
% Example:
% ----------
% s = surf(peaks(20));
% [video_struct] = save_rotate_figure(s.Parent);
% write_video(video_struct);
% See also write_video.m, view.m

% (c) copyright Kiran Vaddi 11-2019

function [varargout]=save_rotate_figure(handle,varargin)

pars.minangle = -90;
pars.maxangle = 90;
pars.direction = [0 0 1]; % Z-axis rotation
pars = extractpars(varargin,pars);

angles = linspace(pars.minangle,pars.maxangle,50);
angles = [angles flipud(angles')'];
for i = 1:length(angles)
    view(handle,angles(i),30);
    axis off
    axis image
    pause(0.1);
    movieVector(i)=getframe(gcf);
end
if nargout>=1
    varargout{1} = movieVector;
end

