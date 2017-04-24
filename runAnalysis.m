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

