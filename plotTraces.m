function h = plotTraces(hObject, eventdata, h)

% open the figure
if isfield(h, 'plotHandles')
    figure(h.plotHandles.figure);
    set(gcf, 'Visible', 'on');
    
    idx = find(h.analyzedFrames);
    blinkIdx = find(h.analyzedFrames & h.results.blink);
    % analyzed, but not blink frames - used for ylim
    nonBlinkIdx = find(h.analyzedFrames & ~h.results.blink);
    framesAxis = 1:h.vr.NumberOfFrames;
    
    h.plotHandles.xPlot.XData = framesAxis(idx);
    h.plotHandles.xPlot.YData = h.results.x(idx);
    h.plotHandles.yPlot.XData = framesAxis(idx);
    h.plotHandles.yPlot.YData = h.results.y(idx);
    h.plotHandles.areaPlot.XData = framesAxis(idx);
    h.plotHandles.areaPlot.YData = h.results.area(idx);
    h.plotHandles.rhoPlot.XData = framesAxis(idx);
    h.plotHandles.rhoPlot.YData = h.results.blinkRho(idx);
    
    try
        h.plotHandles.xBlinks.XData = framesAxis(blinkIdx);
        h.plotHandles.xBlinks.YData = h.results.x(blinkIdx);
        h.plotHandles.yBlinks.XData = framesAxis(blinkIdx);
        h.plotHandles.yBlinks.YData = h.results.y(blinkIdx);
        h.plotHandles.areaBlinks.XData = framesAxis(blinkIdx);
        h.plotHandles.areaBlinks.YData = h.results.area(blinkIdx);
        h.plotHandles.rhoBlinks.XData = framesAxis(blinkIdx);
        h.plotHandles.rhoBlinks.YData = h.results.blinkRho(blinkIdx);
    catch
        % if initially there were no blanks during the first run of the function
        % we need to plot them using plot(), to generate proper handles
        axes(h.plotHandles.xAxes);
        hold on;
        h.plotHandles.xBlinks = plot(framesAxis(blinkIdx), h.results.x(blinkIdx), 'r.');
        hold off
        axes(h.plotHandles.yAxes);
        hold on;
        h.plotHandles.yBlinks = plot(framesAxis(blinkIdx), h.results.y(blinkIdx), 'r.');
        hold off;
        axes(h.plotHandles.areaAxes);
        hold on;
        h.plotHandles.areaBlinks = plot(framesAxis(blinkIdx), h.results.area(blinkIdx), 'r.');
        hold off;
        axes(h.plotHandles.rhoAxes);
        hold on;
        h.plotHandles.rhoBlinks = plot(framesAxis(blinkIdx), h.results.blinkRho(blinkIdx), 'r.');
        hold off;
        
    end
    
    ylim(h.plotHandles.xAxes, [min(h.results.x(nonBlinkIdx)), max(h.results.x(nonBlinkIdx))]);
    ylim(h.plotHandles.yAxes, [min(h.results.y(nonBlinkIdx)), max(h.results.y(nonBlinkIdx))]);
    ylim(h.plotHandles.areaAxes, [min(h.results.area(nonBlinkIdx)), max(h.results.area(nonBlinkIdx))]);
    
    
else
    h.plotHandles.figure = figure;
    set(h.plotHandles.figure, 'UserData', h);
    set(h.plotHandles.figure, 'WindowButtonDownFcn', @clickAction);
    
    try
        set(h.plotHandles.figure, 'Name', sprintf('Results for %s', h.FileName));
    end
    % Do not delete the figure when close, just make it invisible
    set(h.plotHandles.figure, 'CloseRequestFcn', 'set(gcf, ''Visible'', ''off'');');
    
    idx = find(h.analyzedFrames);
    blinkIdx = find(h.analyzedFrames & h.results.blink);
    % analyzed, but not blink frames - used for ylim
    nonBlinkIdx = find(h.analyzedFrames & ~h.results.blink);
    framesAxis = 1:h.vr.NumberOfFrames;
    
    h.plotHandles.xAxes = subplot(4, 1, 1);
    h.plotHandles.xPlot = plot(framesAxis(idx), h.results.x(idx));
    hold on;
    h.plotHandles.xBlinks = plot(framesAxis(blinkIdx), h.results.x(blinkIdx), 'r.');
    hold off;
    ylabel('X_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.x(nonBlinkIdx)), max(h.results.x(nonBlinkIdx))]);
    title('Ctrl+Click to navigate to that frame in the GUI');
    
    h.plotHandles.yAxes = subplot(4, 1, 2);
    h.plotHandles.yPlot = plot(framesAxis(idx), h.results.y(idx));
    hold on;
    h.plotHandles.yBlinks = plot(framesAxis(blinkIdx), h.results.y(blinkIdx), 'r.');
    hold off;
    ylabel('Y_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.y(nonBlinkIdx)), max(h.results.y(nonBlinkIdx))]);
    
    h.plotHandles.areaAxes = subplot(4, 1, 3);
    h.plotHandles.areaPlot = plot(framesAxis(idx), h.results.area(idx));
    hold on;
    h.plotHandles.areaBlinks = plot(framesAxis(blinkIdx), h.results.area(blinkIdx), 'r.');
    hold off;
    xlabel('Frame #');
    ylabel('Area [px^2]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.area(nonBlinkIdx)), max(h.results.area(nonBlinkIdx))]);
    
    h.plotHandles.rhoAxes = subplot(4, 1, 4);
    h.plotHandles.rhoPlot = plot(framesAxis(idx), h.results.blinkRho(idx));
    hold on;
    h.plotHandles.rhoBlinks = plot(framesAxis(blinkIdx), h.results.blinkRho(blinkIdx), 'r.');
    hold off;
    xlabel('Frame #');
    ylabel('blink \rho');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([0 1]);
    
    linkaxes([h.plotHandles.xAxes, h.plotHandles.yAxes,...
        h.plotHandles.areaAxes, h.plotHandles.rhoAxes], 'x');
end

