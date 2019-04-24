% For any given plot handles in h, this function can be used to select and
% highlight a plot using mouse usage:
% hllSelected(h) where you pass the figure handle in h
% Eg : h(1) = plot(1:10,1:10);
%      h(2) = plot(1:10,(1:10).^2);
%      hllSelected(h);

function hllSelected(h)
set(h, 'ButtonDownFcn', {@linehighlight, h})
pause;
set(h,'Color','blue','LineWidth',1.0)
title([])

function linehighlight(ObjectH,EventData,H)
set(ObjectH, 'LineWidth', 2.5,'Color','red');
set(H(H ~= ObjectH), 'LineWidth', 0.5,'Color', 1/255*[200,200,200]);
title('Hit any key to exit');
