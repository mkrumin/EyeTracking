function h = runAnalysis(hObject, eventdata, h)

if hObject.Value
    hObject.BackgroundColor = 'red';
    hObject.String= 'Stop';
    drawnow;
    tStart = tic;
    i = 1;
    while hObject.Value && i<=length(h.framesToAnalyze)
        iFrame = h.framesToAnalyze(i);
        frame = read(h.vr, [iFrame iFrame]);
        params.gaussStd = h.FilterSizeEdit.Value;
        params.thresh = h.ThresholdSlider.Value;
        xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
        ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
        res = analyzeSingleFrame(frame(ySpan, xSpan), params);
        h.results.x(iFrame) = res.x0;
        h.results.y(iFrame) = res.y0;
        h.results.area(iFrame) = res.area;
        h.results.aAxis(iFrame) = res.a;
        h.results.bAxis(iFrame) = res.b;
        h.results.theta(iFrame) = res.theta;
        h.results.goodFit(iFrame) = res.isEllipse;
%         h.results.blink = false;
        h.results.gaussStd(iFrame) = params.gaussStd;
        h.results.threshold(iFrame) = params.thresh;
        h.results.roi(iFrame, :) = h.roi;
        h.results.equation{iFrame} = res.eq;
        h.results.xxContour{iFrame} = res.xxEdge;
        h.results.yyContour{iFrame} = res.yyEdge;
        h.results.xxEllipse{iFrame} = res.xxEllipse;
        h.results.yyEllipse{iFrame} = res.yyEllipse;
        h.analyzedFrames(iFrame) = true;
        if ~mod(i,100)
            tNow = toc(tStart);
            fps = i/tNow;
            tLeft = (length(h.framesToAnalyze)-i)/fps;
            h.AnalysisStatusText.String = ...
                sprintf('%d/%d\t %3.0f fps \t%s  left', ...
                i, length(h.framesToAnalyze), fps, ...
                duration(seconds(tLeft), 'Format', 'hh:mm:ss'));
            drawnow;
        end
        i = i + 1;
    end
    if i>1 % if there actually has been some analysis done
        h.AnalysisStatusText.String = ...
            sprintf('%d/%d\t %3.0f fps \t%s  left', ...
            i-1, length(h.framesToAnalyze), fps, ...
            duration(seconds(tLeft), 'Format', 'hh:mm:ss'));
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

