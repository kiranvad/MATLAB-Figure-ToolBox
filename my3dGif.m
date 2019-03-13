function []=my3dGif(varargin)
% Call this function with a 3D plot to create a 20 dgree rotation of 3D
% plot as a GIF
% Options:
%         gifname     :   name of the GIF to be saved as (in the pwd)
        
pars.gifname = 'mygif';

pars = extractpars(varargin,pars);

degStep = 1;
k = 1;
for i = -25:-degStep:-45
  az = i;
  view([az,30])
  frame = getframe(gcf);
  im = frame2im(frame);
  [imind,cm] = rgb2ind(im,256);
  k = k + 1;
  if i == 0
      imwrite(imind,cm,[pars.gifname '.gif'],'gif', 'Loopcount',inf,'DelayTime',5);
  else
      imwrite(imind,cm,[pars.gifname '.gif'],'gif','WriteMode','append','DelayTime',5);
  end
end
