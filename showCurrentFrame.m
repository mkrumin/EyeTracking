function h = showCurrentFrame(hObject, eventdata, h)

axes(h.Axes);
if h.OriginalRadio.Value
    imagesc(h.CurrentFrame);
    caxis([h.MinSlider.Value h.MaxSlider.Value])
elseif h.FilteredRadio.Value
    imagesc(imgaussfilt(h.CurrentFrame, h.FilterSizeEdit.Value));
    caxis([h.MinSlider.Value h.MaxSlider.Value])
elseif h.BWRadio.Value
    imagesc(imgaussfilt(h.CurrentFrame, h.FilterSizeEdit.Value)>h.ThresholdSlider.Value);
else
    warning('all radios off')
    % do nothing
end

axis equal tight off
colormap(h.Axes, 'gray');

if h.ROICheck.Value
    hold on;
    rectangle('Position', h.roi, 'EdgeColor', 'r', 'LineStyle', '--')
    rectangle('Position', h.blinkRoi, 'EdgeColor', 'y', 'LineStyle', '--')
    hold off;
end

if h.CropCheck.Value
    xlim([h.roi(1), h.roi(1)+h.roi(3)]);
    ylim([h.roi(2), h.roi(2)+h.roi(4)]);
end
    
