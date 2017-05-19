function processKeyPress(src, event)

if isequal(event.Modifier, {'control'}) && isequal(event.Key, 'a')
    res = autoAnalyzeFrame(src);
end

if isequal(event.Modifier, {'control'}) && isequal(event.Key, 's')
    h = guidata(src);
    oldColor = h.figure1.Color;
    h.figure1.Color = [1 0.5 0.5];
    
    drawnow;
    
    params.gaussStd = h.FilterSizeEdit.Value;
    params.thresh = h.ThresholdSlider.Value;
    xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
    ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
    res = analyzeSingleFrame(h.CurrentFrame(ySpan, xSpan, :), params);
    [isBlink, blinkRho, blinkMean] = detectBlink(h.CurrentFrame, h);
    
    xShift = h.roi(1)-1;
    yShift = h.roi(2)-1;
    
    h.results.x(h.iFrame) = res.x0+xShift;
    h.results.y(h.iFrame) = res.y0+yShift;
    h.results.area(h.iFrame) = res.area;
    h.results.aAxis(h.iFrame) = res.a;
    h.results.bAxis(h.iFrame) = res.b;
    h.results.theta(h.iFrame) = res.theta;
    h.results.goodFit(h.iFrame) = res.isEllipse;
    h.results.blink(h.iFrame) = isBlink;
    h.results.blinkRho(h.iFrame) = blinkRho;
    h.results.blinkMean(h.iFrame) = blinkMean;
    h.results.gaussStd(h.iFrame) = params.gaussStd;
    h.results.threshold(h.iFrame) = params.thresh;
    h.results.roi(h.iFrame, :) = h.roi;
    h.results.blinkRoi(h.iFrame, :) = h.blinkRoi;
    h.results.equation{h.iFrame} = res.eq;
    h.results.xxContour{h.iFrame} = res.xxEdge+xShift;
    h.results.yyContour{h.iFrame} = res.yyEdge+yShift;
    h.results.xxEllipse{h.iFrame} = res.xxEllipse+xShift;
    h.results.yyEllipse{h.iFrame} = res.yyEllipse+yShift;
    h.analyzedFrames(h.iFrame) = true;
    
    h.figure1.Color = oldColor;
    guidata(src, h);
    updateFigure(src, [], h);
    
end
