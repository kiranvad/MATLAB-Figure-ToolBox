MATLAB Figures Tool Box
==================================
This package contains some useful matlab scripts to generate figures that are edited to be near publication ready

Use `help filename` for a sample usage of each file and various options that exist

Manifold Traverser
------------------
This package now contains a function that can be used to trace a 2D/3D manifold that can be used as an agnostic tool to for Manifold Learning.

In simple terms, given a 2D/3D data and its corresponding high dimensional vectors (such as time series) it produces MATLAB figues where you can intreactively click a point on the manifold and corresponding high dimenisonal response will be plotted in the window next to it

Use `help manifold_click_traverse` for a sample usage of the script.


Radial Visualization
--------------------
This package now contains a radial visualization plot (popularly known as RadViz) implementation in MATLAB. The function `plot_radviz` takes a high dimenisonal input in `data` and corresponding colorcode in `colors` and produces a 2D projection onto a radial plane.

This is built using the radviz function from
> Majumdar, Nivedita. MATLAB Graphics and Data Visualization Cookbook. 
> Packt Publishing Ltd, 2012

(c) Copyright Kiran Vaddi 2019
