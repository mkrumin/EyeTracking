function updateFigure(hObject, eventdata, h)

showCurrentFrame(hObject, eventdata, h);
h.FrameText.String = ...
    sprintf('Frame %1.0f/%1.0f', h.iFrame, h.vr.NumberOfFrames);
h.FrameSlider.Value = h.iFrame;
h.FineFrameSlider.Value = h.iFrame;
doAnalysis = h.CenterCheck.Value || h.EdgeCheck.Value || h.EllipseCheck.Value;
if doAnalysis
    params.gaussStd = h.FilterSizeEdit.Value;
    params.thresh = h.ThresholdSlider.Value;
    xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
    ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
    res = analyzeSingleFrame(h.CurrentFrame(ySpan, xSpan), params);
    plotResults(res, h);
end
if h.BlinkCheck.Value
    isBlink = detectBlink(h.CurrentFrame, h);
    if isBlink
        colormap(h.Axes, [0:1/63:1; zeros(1, 64); zeros(1, 64)]');
    end
end

drawnow limitrate;

