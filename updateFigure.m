function updateFigure(hObject, eventdata, h)

showCurrentFrame(hObject, eventdata, h);
h.FrameText.String = ...
    sprintf('Frame %1.0f/%1.0f', h.iFrame, h.vr.NumberOfFrames);
h.FrameSlider.Value = h.iFrame;
h.FineFrameSlider.Value = h.iFrame;
[~, tmp] = min(abs(find(h.analyzedFrames)-h.iFrame));
len = length(find(h.analyzedFrames));
if isempty(tmp)
    h.ReplaySlider.Value = h.ReplaySlider.Min;
    h.ReplaySlider.SliderStep = [0.01, 0.1];
else
    h.ReplaySlider.Value = tmp;
    h.ReplaySlider.SliderStep = [min(1, 1/len), min(1, 10/len)];
end

doAnalysis = h.CenterCheck.Value || h.EdgeCheck.Value || h.EllipseCheck.Value;

plotBlink = h.BlinkCheck.Value;
if h.analyzedFrames(h.iFrame)
    res = getSingleRes(h.results, h.iFrame);
    % [x,y] in res are already roi-corrected, co for plotResults purposes:
    res.roi = [1 1 h.vr.Width h.vr.Height];
    plotResults(res, h, [0 1 1]);
    plotBlink = plotBlink && res.blink;
    text(max(xlim), max(ylim), 'Replay', ...
        'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Bottom',...
        'FontSize', 20, 'Color', [0 1 1]);
    h.replayStdText.String = sprintf('std: %s', num2str(h.results.gaussStd(h.iFrame)));
    h.replayThrText.String = sprintf('std: %3.1f', h.results.threshold(h.iFrame));
end
if doAnalysis
    params.gaussStd = h.FilterSizeEdit.Value;
    params.thresh = h.ThresholdSlider.Value;
    xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
    ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
    res = analyzeSingleFrame(h.CurrentFrame(ySpan, xSpan), params);
    res.roi = h.roi;
    plotResults(res, h, [1 0.5 0]);
end
if plotBlink
    plotBlink = plotBlink && detectBlink(h.CurrentFrame, h);
end
if plotBlink
    colormap(h.Axes, [0:1/63:1; zeros(1, 64); zeros(1, 64)]');
end
text(min(xlim), max(ylim), 'Preview', ...
    'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Bottom',...
    'FontSize', 20, 'Color', [1 0.5 0]);

drawnow limitrate;

