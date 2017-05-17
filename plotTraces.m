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
    set(h.plotHandles.figure, 'UserData', h);

    mask = ones(size(h.results.blink));
    hideBlinks = getappdata(h.plotHandles.figure, 'hideBlinks');
    if hideBlinks
        % when user selects to hide the datapoints during the blinks
        mask(h.results.blink) = nan;
    end
    onlyBlinks = ones(size(h.results.blink));
    onlyBlinks(~h.results.blink) = nan;
    onlyBlinks = onlyBlinks.*mask;
    softBlinks = ones(size(h.results.blink));
    softBlinks(~(h.results.blink | h.results.blinkSoft)) = nan;
    softBlinks = softBlinks.*mask;
    
    h.plotHandles.xPlot.YData = h.results.x.*mask;
    h.plotHandles.xBlinks.YData = h.results.x.*onlyBlinks;
    h.plotHandles.xSoftBlinks.YData = h.results.x.*softBlinks;
    h.plotHandles.yPlot.YData = h.results.y.*mask;
    h.plotHandles.yBlinks.YData = h.results.y.*onlyBlinks;
    h.plotHandles.ySoftBlinks.YData = h.results.y.*softBlinks;
    h.plotHandles.areaPlot.YData = h.results.area.*mask;
    h.plotHandles.areaBlinks.YData = h.results.area.*onlyBlinks;
    h.plotHandles.areaSoftBlinks.YData = h.results.area.*softBlinks;
    h.plotHandles.rhoPlot.YData = h.results.blinkRho.*mask;
    h.plotHandles.rhoBlinks.YData = h.results.blinkRho.*onlyBlinks;
    h.plotHandles.rhoSoftBlinks.YData = h.results.blinkRho.*softBlinks;
    h.plotHandles.blinkPlot.XData = h.results.blinkMean;
    h.plotHandles.blinkPlot.YData = h.results.blinkRho;
    h.plotHandles.blinkBlinks.XData = h.results.blinkMean(h.results.blink);
    h.plotHandles.blinkBlinks.YData = h.results.blinkRho(h.results.blink);
    h.plotHandles.blinkSoftBlinks.XData = h.results.blinkMean(h.results.blinkSoft);
    h.plotHandles.blinkSoftBlinks.YData = h.results.blinkRho(h.results.blinkSoft);

    pos = h.blinkClassifier;
    pos = [pos; pos(1,:)];
    h.plotHandles.blinkClassifier.XData = pos(:,1);
    h.plotHandles.blinkClassifier.YData = pos(:,2);
    
    h.plotHandles.xCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.xCurrent.YData = [min(h.results.x) max(h.results.x)];
    h.plotHandles.yCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.yCurrent.YData = [min(h.results.y) max(h.results.y)];
    h.plotHandles.areaCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.areaCurrent.YData = [min(h.results.area) max(h.results.area)];
    h.plotHandles.rhoCurrent.XData = [h.iFrame, h.iFrame];
    h.plotHandles.rhoCurrent.YData = [0 1];
    h.plotHandles.blinkCurrent.XData = h.results.blinkMean(h.iFrame);
    h.plotHandles.blinkCurrent.YData = h.results.blinkRho(h.iFrame);
    
else
    % run this block if this is the first time the results are plotted
    h.plotHandles.figure = figure;
    set(h.plotHandles.figure, 'WindowButtonDownFcn', @clickAction);
    set(h.plotHandles.figure, 'WindowKeyPressFcn', @plotKeyPress);
    hideBlinks = false;
    setappdata(h.plotHandles.figure, 'hideBlinks', hideBlinks);
    % Do not delete the figure when closed, just make it invisible
    set(h.plotHandles.figure, 'CloseRequestFcn', 'set(gcf, ''Visible'', ''off'');');
    
    if isfield(h, 'CurrentFolder') && isfield(h, 'FileName')
        set(h.plotHandles.figure, 'Name',...
            sprintf('Results for %s', fullfile(h.CurrentFolder, h.FileName)));
    end
    
    % analyzed, but not blink frames - used for ylim
    nonBlinkIdx = find(h.analyzedFrames & ~h.results.blink);
    mask = ones(size(h.results.blink));
    if hideBlinks
        % when user selects to hide the datapoints during the blinks
        mask(h.results.blink) = nan;
    end
    onlyBlinks = ones(size(h.results.blink));
    onlyBlinks(~h.results.blink) = nan;
    onlyBlinks = onlyBlinks.*mask;
    % for graphics reasons softBlinks will be soft and hard blinks together
    softBlinks = ones(size(h.results.blink));
    softBlinks(~(h.results.blink | h.results.blinkSoft)) = nan;
    softBlinks = softBlinks.*mask;
    framesAxis = 1:h.vr.NumberOfFrames;
    
    h.plotHandles.xAxes = subplot(4, 3, [1 2]);
    h.plotHandles.xPlot = plot(framesAxis, h.results.x.*mask, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.xSoftBlinks = plot(framesAxis, h.results.x.*softBlinks, 'g.-', 'LineWidth', 1);
    h.plotHandles.xBlinks = plot(framesAxis, h.results.x.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.xCurrent = plot([h.iFrame, h.iFrame], [min(h.results.x) max(h.results.x)], 'k:');
    hold off;
    ylabel('X_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.x(nonBlinkIdx)), max(h.results.x(nonBlinkIdx))]);
    title('Ctrl+Click to navigate to that frame in the GUI, Ctrl+B to toggle blinks');
    
    h.plotHandles.yAxes = subplot(4, 3, [4 5]);
    h.plotHandles.yPlot = plot(framesAxis, h.results.y.*mask, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.ySoftBlinks = plot(framesAxis, h.results.y.*softBlinks, 'g.-', 'LineWidth', 1);
    h.plotHandles.yBlinks = plot(framesAxis, h.results.y.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.yCurrent = plot([h.iFrame, h.iFrame], [min(h.results.y) max(h.results.y)], 'k:');
    hold off;
    ylabel('Y_{pos} [px]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.y(nonBlinkIdx)), max(h.results.y(nonBlinkIdx))]);
    
    h.plotHandles.areaAxes = subplot(4, 3, [7 8]);
    h.plotHandles.areaPlot = plot(framesAxis, h.results.area.*mask, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.areaSoftBlinks = plot(framesAxis, h.results.area.*softBlinks, 'g.-', 'LineWidth', 1);
    h.plotHandles.areaBlinks = plot(framesAxis, h.results.area.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.areaCurrent = plot([h.iFrame, h.iFrame], [min(h.results.area) max(h.results.area)], 'k:');
    hold off;
    ylabel('Area [px^2]');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([min(h.results.area(nonBlinkIdx)), max(h.results.area(nonBlinkIdx))]);
    
    h.plotHandles.rhoAxes = subplot(4, 3, [10 11]);
    h.plotHandles.rhoPlot = plot(framesAxis, h.results.blinkRho.*mask, 'b.-', 'MarkerSize', 4);
    hold on;
    h.plotHandles.rhoSoftBlinks = plot(framesAxis, h.results.blinkRho.*softBlinks, 'g.-', 'LineWidth', 1);
    h.plotHandles.rhoBlinks = plot(framesAxis, h.results.blinkRho.*onlyBlinks, 'r.-', 'LineWidth', 1);
    h.plotHandles.rhoCurrent = plot([h.iFrame, h.iFrame], [0 1], 'k:');
    hold off;
    xlabel('Frame #');
    ylabel('blink \rho');
    xlim([1, h.vr.NumberOfFrames]);
    ylim([0 1]);
    
    h.plotHandles.blinkAxes = subplot(4, 3, [9 12]);
    h.plotHandles.blinkPlot = plot(h.results.blinkMean, h.results.blinkRho, '.');
    hold on;
    h.plotHandles.blinkBlinks = plot(h.results.blinkMean(h.results.blink), ...
        h.results.blinkRho(h.results.blink), 'r.');
    h.plotHandles.blinkSoftBlinks = plot(h.results.blinkMean(h.results.blinkSoft), ...
        h.results.blinkRho(h.results.blinkSoft), 'g.');
    h.plotHandles.blinkCurrent = plot(h.results.blinkMean(h.iFrame), ...
        h.results.blinkRho(h.iFrame), 'ko');
    pos = h.blinkClassifier;
    pos = [pos; pos(1,:)];
    h.plotHandles.blinkClassifier = plot(pos(:,1), pos(:,2), 'k:');
    hold off;
    xlabel('mean');
    ylabel('\rho');
    xlim([0 255]);
    ylim([0 1]);
    title('use arrows to navigate frame-by-frame');
    h.plotHandles.blinkAxes.Tag = 'blinks';
    
    linkaxes([h.plotHandles.xAxes, h.plotHandles.yAxes,...
        h.plotHandles.areaAxes, h.plotHandles.rhoAxes], 'x');

    set(h.plotHandles.figure, 'UserData', h);
end


