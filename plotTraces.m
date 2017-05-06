function h = plotTraces(hObject, eventdata, h)


if sum(h.analyzedFrames & ~h.results.blink)<2
    % do not plot anything if there are less than 2 frames without blinks
    % prevents crashes from happening
    return;
end

if isfield(h, 'plotHandles')
    % make the correct figure current (switch focus)
    figure(h.plotHandles.figure);
    % make it visible (e.g. when it was 'closed' bu the user)
    set(h.plotHandles.figure, 'Visible', 'on');
    
    onlyBlinks = ones(size(h.results.blink));
    onlyBlinks(~h.results.blink) = nan;
    
    h.plotHandles.xPlot.YData = h.results.x;
    h.plotHandles.xBlinks.YData = h.results.x.*onlyBlinks;
    h.plotHandles.yPlot.YData = h.results.y;
    h.plotHandles.yBlinks.YData = h.results.y.*onlyBlinks;
    h.plotHandles.areaPlot.YData = h.results.area;
    h.plotHandles.areaBlinks.YData = h.results.area.*onlyBlinks;
    h.plotHandles.rhoPlot.YData = h.results.blinkRho;
    h.plotHandles.rhoBlinks.YData = h.results.blinkRho.*onlyBlinks;
    
    h.plotHandles.xCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.xCurrent.YData = [min(h.results.x) max(h.results.x)];
    h.plotHandles.yCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.yCurrent.YData = [min(h.results.y) max(h.results.y)];
    h.plotHandles.areaCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.areaCurrent.YData = [min(h.results.area) max(h.results.area)];
    h.plotHandles.rhoCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.rhoCurrent.YData = [0 1];
    
else
    % run this block if this is the first time the results are plotted
    h.plotHandles.figure = figure;
    set(h.plotHandles.figure, 'UserData', h);
    set(h.plotHandles.figure, 'WindowButtonDownFcn', @clickAction);
    % Do not delete the figure when closed, just make it invisible
    set(h.plotHandles.figure, 'CloseRequestFcn', 'set(gcf, ''Visible'', ''off'');');
    
    if isfield(h, 'CurrentFolder') && isfield(h, 'FileName')
        set(h.plotHandles.figure, 'Name',...
            sprintf('Results for %s', fullfile(h.CurrentFolder, h.FileName)));
    end
    
    % analyzed, but not blink frames - used for ylim
    nonBlinkIdx = find(h.analyzedFrames & ~h.results.blink);
    onlyBlinks = ones(size(h.results.blink));
    onlyBlinks(~h.results.blink) = nan;
    framesAxis = 1:h.vr.NumberOfFrames;
    
    h.plotHandles.xAxes = subplot(4, 1, 1);
    h.plotHandles.xPlot = plot(framesAxis, h.results.x, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.xBlinks = plot(framesAxis, h.results.x.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.xCurrent = plot([h.iFrame, h.iFrame], [min(h.results.x) max(h.results.x)], 'k:');
    hold off;
    ylabel('X_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.x(nonBlinkIdx)), max(h.results.x(nonBlinkIdx))]);
    title('Ctrl+Click to navigate to that frame in the GUI');
    
    h.plotHandles.yAxes = subplot(4, 1, 2);
    h.plotHandles.yPlot = plot(framesAxis, h.results.y, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.yBlinks = plot(framesAxis, h.results.y.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.yCurrent = plot([h.iFrame, h.iFrame], [min(h.results.y) max(h.results.y)], 'k:');
    hold off;
    ylabel('Y_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.y(nonBlinkIdx)), max(h.results.y(nonBlinkIdx))]);
    
    h.plotHandles.areaAxes = subplot(4, 1, 3);
    h.plotHandles.areaPlot = plot(framesAxis, h.results.area, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.areaBlinks = plot(framesAxis, h.results.area.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.areaCurrent = plot([h.iFrame, h.iFrame], [min(h.results.area) max(h.results.area)], 'k:');
    hold off;
    xlabel('Frame #');
    ylabel('Area [px^2]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.area(nonBlinkIdx)), max(h.results.area(nonBlinkIdx))]);
    
    h.plotHandles.rhoAxes = subplot(4, 1, 4);
    h.plotHandles.rhoPlot = plot(framesAxis, h.results.blinkRho, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.rhoBlinks = plot(framesAxis, h.results.blinkRho.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.rhoCurrent = plot([h.iFrame, h.iFrame], [0 1], 'k:');
    hold off;
    xlabel('Frame #');
    ylabel('blink \rho');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([0 1]);
    
    linkaxes([h.plotHandles.xAxes, h.plotHandles.yAxes,...
        h.plotHandles.areaAxes, h.plotHandles.rhoAxes], 'x');
end

