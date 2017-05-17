function h = runAnalysis(hObject, eventdata, h)

batchSize = 1000;
blinksOnly = h.BlinksOnlyCheck.Value;
fps = 0; % prevents an occasional weird bug when updating analysis status text
if hObject.Value
    % set h.framesToAnalyze (might not be set correctly)
    etGUI('OverwriteCheck_Callback',h.OverwriteCheck, eventdata, h);
    h = guidata(h.OverwriteCheck);
    nFramesToAnalyze = length(h.framesToAnalyze);
    iStart = 1:batchSize:nFramesToAnalyze;
    iEnd = min(iStart+batchSize-1, nFramesToAnalyze);
    nBatches = length(iStart);
    hObject.BackgroundColor = 'red';
    hObject.String= 'Stop';
    drawnow;
    tStart = tic;
    iBatch = 1;
    while hObject.Value && iBatch<=nBatches
        frameIdx = h.framesToAnalyze(iStart(iBatch):iEnd(iBatch));
        frames = readBatch(h.vr, frameIdx);
        
        if ~blinksOnly
            params.gaussStd = h.FilterSizeEdit.Value;
            params.thresh = h.ThresholdSlider.Value;
            xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
            ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
            res = analyzeBatch(frames(ySpan, xSpan, :), params);
            
            xShift = h.roi(1)-1;
            yShift = h.roi(2)-1;
            xShiftCell = repmat({xShift}, length(frameIdx), 1);
            yShiftCell = repmat({yShift}, length(frameIdx), 1);
            
            h.results.x(frameIdx) = res.x0+xShift;
            h.results.y(frameIdx) = res.y0+yShift;
            h.results.area(frameIdx) = res.area;
            h.results.aAxis(frameIdx) = res.a;
            h.results.bAxis(frameIdx) = res.b;
            h.results.theta(frameIdx) = res.theta;
            h.results.goodFit(frameIdx) = res.isEllipse;
            h.results.gaussStd(frameIdx) = params.gaussStd;
            h.results.threshold(frameIdx) = params.thresh;
            h.results.roi(frameIdx, :) = repmat(h.roi, length(frameIdx), 1);
            h.results.equation(frameIdx) = res.eq;
            h.results.xxContour(frameIdx) = cellfun(@plus, res.xxEdge, xShiftCell, 'UniformOutput', false);
            h.results.yyContour(frameIdx) = cellfun(@plus, res.yyEdge, yShiftCell, 'UniformOutput', false);
            h.results.xxEllipse(frameIdx) = cellfun(@plus, res.xxEllipse, xShiftCell, 'UniformOutput', false);
            h.results.yyEllipse(frameIdx) = cellfun(@plus, res.yyEllipse, yShiftCell, 'UniformOutput', false);
            h.analyzedFrames(frameIdx) = true;
        end
        
        [isBlink, blinkRho, blinkMean] = detectBlinkBatch(frames, h);
        h.results.blink(frameIdx) = isBlink;
        h.results.blinkRho(frameIdx) = blinkRho;
        h.results.blinkMean(frameIdx) = blinkMean;
        h.results.blinkRoi(frameIdx, :) = repmat(h.blinkRoi, length(frameIdx), 1);
        h = updateBlinks(h); % to update the soft blinks
        
        tNow = toc(tStart);
        fps = iBatch*batchSize/tNow;
        tLeft = (nFramesToAnalyze-iBatch*batchSize)/fps;
        h.AnalysisStatusText.String = ...
            sprintf('%d/%d\t %3.0f fps \t%s  left', ...
            iEnd(iBatch), nFramesToAnalyze, fps, ...
            char(duration(seconds(tLeft), 'Format', 'hh:mm:ss')));
        guidata(hObject, h);
        drawnow;
        
        iBatch = iBatch + 1;
    end
    if iBatch>1 % if there actually has been some analysis done
        h.AnalysisStatusText.String = ...
            sprintf('%d/%d\t %3.0f fps \t%s  left', ...
            iEnd(iBatch-1), nFramesToAnalyze, fps, ...
            char(duration(seconds(tLeft), 'Format', 'hh:mm:ss')));
    end
    h.framesToAnalyze = [];
    h.OverwriteCheck.Value = 0;
    hObject.Value = 0;
    hObject.BackgroundColor = [0.94 0.94 0.94];
    hObject.String= 'Run';
    drawnow;
else
    hObject.BackgroundColor = [0.94 0.94 0.94];
    hObject.String= 'Run';
    drawnow;
end

len = sum(h.analyzedFrames);
h.ReplaySlider.Max = len;
h.ReplaySlider.Min = min(1, len);
[~, h.ReplaySlider.Value] = min(abs(find(h.analyzedFrames)-h.iFrame));
h.ReplaySlider.SliderStep = [min(1, 1/len), min(1, 10/len)];
