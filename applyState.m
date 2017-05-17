function hh = applyState(hh, state)

hh.CurrentFolder = state.CurrentFolder;
hh.FileName = state.FileName;
hh.roi = state.roi;
hh.blinkRoi = state.blinkRoi;
hh.blinkClassifier = state.blinkClassifier;
hh.ThresholdSlider.Value = state.Threshold;
hh.ThresholdText.String = sprintf('%3.1f', hh.ThresholdSlider.Value);
hh.FilterSizeEdit.Value = state.FilterSize;
hh.FilterSizeEdit.String = num2str(state.FilterSize);
hh.analyzedFrames = state.analyzedFrames;

% this code is to prevent some warnings
len = sum(hh.analyzedFrames);
hh.ReplaySlider.Max = max(1, len);
hh.ReplaySlider.Min = min(0, len);
[~, tmp] = min(abs(find(hh.analyzedFrames)-hh.iFrame));
if isempty(tmp)
    hh.ReplaySlider.Value = hh.ReplaySlider.Min;
    hh.ReplaySlider.SliderStep = [0.01, 0.1];
else
    hh.ReplaySlider.Value = tmp;
    hh.ReplaySlider.SliderStep = [min(1, 1/len), min(1, 10/len)];
end
