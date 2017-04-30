function h = showCurrentFrame(hObject, eventdata, h)

replay = isequal(hObject.Tag, 'ReplayToggle');
replay = replay && h.analyzedFrames(h.iFrame);

axes(h.Axes);
if h.OriginalRadio.Value
    imagesc(h.CurrentFrame);
    caxis([h.MinSlider.Value h.MaxSlider.Value])
elseif h.FilteredRadio.Value
    if replay
        stdGauss = h.results.gaussStd(h.iFrame);
        imagesc(imgaussfilt(h.CurrentFrame, stdGauss));
    else
        imagesc(imgaussfilt(h.CurrentFrame, h.FilterSizeEdit.Value));
    end
    caxis([h.MinSlider.Value h.MaxSlider.Value])
elseif h.BWRadio.Value
    if replay
        stdGauss = h.results.gaussStd(h.iFrame);
        th = h.results.threshold(h.iFrame);
        imagesc(imgaussfilt(h.CurrentFrame, stdGauss)>th);
    else
        imagesc(imgaussfilt(h.CurrentFrame, h.FilterSizeEdit.Value)>h.ThresholdSlider.Value);
    end
else
    warning('all radios off')
    % do nothing
end

axis equal tight off
colormap(h.Axes, 'gray');

if h.ROICheck.Value
    hold on;
    rectangle('Position', h.roi, 'EdgeColor', [1 0.5 0], 'LineStyle', '--')
    rectangle('Position', h.blinkRoi, 'EdgeColor', [1 0.5 0], 'LineStyle', ':')
    if h.analyzedFrames(h.iFrame)
        rectangle('Position', h.results.roi(h.iFrame, :), 'EdgeColor', 'c', 'LineStyle', '--')
        rectangle('Position', h.results.blinkRoi(h.iFrame, :), 'EdgeColor', 'c', 'LineStyle', ':')
    end
    hold off;
end

if h.CropCheck.Value
    xlim([h.roi(1), h.roi(1)+h.roi(3)]);
    ylim([h.roi(2), h.roi(2)+h.roi(4)]);
end
    
