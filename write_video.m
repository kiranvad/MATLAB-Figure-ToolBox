function []=write_video(movie_vector,varargin)
pars.path = 'myvideo';
pars.FrameRate = 5;

pars = extractpars(varargin, pars);

myWriter = VideoWriter(pars.path);
myWriter.FrameRate=pars.FrameRate;
myWriter.Quality = 100; 

open(myWriter)
writeVideo(myWriter, movie_vector);
close(myWriter);
