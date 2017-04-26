function updateFigure(hObject, eventdata, h)

showCurrentFrame(hObject, eventdata, h);
h.FrameText.String = ...
    sprintf('Frame %1.0f/%1.0f', h.iFrame, h.vr.NumberOfFrames);
h.FrameSlider.Value = h.iFrame;
h.FineFrameSlider.Value = h.iFrame;
[~, h.ReplaySlider.Value] = min(abs(find(h.analyzedFrames)-h.iFrame));

doAnalysis = h.CenterCheck.Value || h.EdgeCheck.Value || h.EllipseCheck.Value;
if isequal(hObject.Tag, 'ReplayToggle')
    res = getSingleRes(h.results, h.iFrame);
    % [x,y] in res are already roi-corrected, co for plotResults purposes:
    res.roi = [1 1 h.vr.Width h.vr.Height];
    plotResults(res, h);
    if res.blink
        colormap(h.Axes, [0:1/63:1; zeros(1, 64); zeros(1, 64)]');
    end
else
    if doAnalysis
        params.gaussStd = h.FilterSizeEdit.Value;
        params.thresh = h.ThresholdSlider.Value;
        xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
        ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
        res = analyzeSingleFrame(h.CurrentFrame(ySpan, xSpan), params);
        res.roi = h.roi;
        plotResults(res, h);
    end
    if h.BlinkCheck.Value
        isBlink = detectBlink(h.CurrentFrame, h);
        if isBlink
            colormap(h.Axes, [0:1/63:1; zeros(1, 64); zeros(1, 64)]');
        end
    end
end

drawnow limitrate;

