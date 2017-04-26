function h = plotTraces(hObject, eventdata, h)

% open the figure
if isfield(h, 'plotHandles')
    figure(h.plotHandles.figure);
    set(gcf, 'Visible', 'on');
    
    idx = find(h.analyzedFrames);
    blinkIdx = find(h.analyzedFrames & h.results.blink);
    framesAxis = 1:h.vr.NumberOfFrames;

    h.plotHandles.xPlot.XData = framesAxis(idx);
    h.plotHandles.xPlot.YData = h.results.x(idx);
    h.plotHandles.xBlinks.XData = framesAxis(blinkIdx);
    h.plotHandles.xBlinks.YData = h.results.x(blinkIdx);
    h.plotHandles.yPlot.XData = framesAxis(idx);
    h.plotHandles.yPlot.YData = h.results.y(idx);
    h.plotHandles.yBlinks.XData = framesAxis(blinkIdx);
    h.plotHandles.yBlinks.YData = h.results.y(blinkIdx);
    h.plotHandles.areaPlot.XData = framesAxis(idx);
    h.plotHandles.areaPlot.YData = h.results.area(idx);
    h.plotHandles.areaBlinks.XData = framesAxis(blinkIdx);
    h.plotHandles.areaBlinks.YData = h.results.area(blinkIdx);

else
    h.plotHandles.figure = figure;
    try
        set(h.plotHandles.figure, 'Name', sprintf('Result for %s', h.FileName)); 
    end
    % Do not delete the figure when close, just make it invisible
    set(h.plotHandles.figure, 'CloseRequestFcn', 'set(gcf, ''Visible'', ''off'');'); 
    
    idx = find(h.analyzedFrames);
    blinkIdx = find(h.analyzedFrames & h.results.blink);
    framesAxis = 1:h.vr.NumberOfFrames;
    
    h.plotHandles.xAxes = subplot(3, 1, 1);
    h.plotHandles.xPlot = plot(framesAxis(idx), h.results.x(idx));
    hold on;
    h.plotHandles.xBlinks = plot(framesAxis(blinkIdx), h.results.x(blinkIdx), 'r.');
    hold off;
    ylabel('X_{pos} [px]');
    h.plotHandles.yAxes = subplot(3, 1, 2);
    h.plotHandles.yPlot = plot(framesAxis(idx), h.results.y(idx));
    hold on;
    h.plotHandles.yBlinks = plot(framesAxis(blinkIdx), h.results.y(blinkIdx), 'r.');
    hold off;
    ylabel('Y_{pos} [px]');
    h.plotHandles.areaAxes = subplot(3, 1, 3);
    h.plotHandles.areaPlot = plot(framesAxis(idx), h.results.area(idx));
    hold on;
    h.plotHandles.areaBlinks = plot(framesAxis(blinkIdx), h.results.area(blinkIdx), 'r.');
    hold off;
    xlabel('Frame #');
    ylabel('Area [px^2]');
    
    linkaxes([h.plotHandles.xAxes, h.plotHandles.yAxes, h.plotHandles.areaAxes], 'x');
end

