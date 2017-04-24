function h = openfile(hObject, eventdata, h)


[FileName,PathName,FilterIndex] = ...
    uigetfile('*.mj2', 'Open Video File...', h.CurrentFolder);

h.CurrentFolder = PathName;
h.FileName = FileName;

h.vr = VideoReader(fullfile(PathName, FileName));
frames = read(h.vr, [1 min(100, h.vr.NumberOfFrames)]);
frames = squeeze(frames);
cl = class(frames);
h.MaxSlider.Max = intmax(cl);
h.MaxSlider.Min = intmin(cl);
h.MaxSlider.Value = max(frames(:));
h.MinSlider.Max = intmax(cl);
h.MinSlider.Min = intmin(cl);
h.MinSlider.Value = min(frames(:));
h.ThresholdSlider.Max = intmax(cl);
h.ThresholdSlider.Min = intmin(cl);
h.ThresholdSlider.SliderStep = [1/(h.ThresholdSlider.Max - h.ThresholdSlider.Min), 0.1];

stdGauss = h.FilterSizeEdit.Value;
framesFilt = imgaussfilt(double(frames), stdGauss);
binEdgesIn = min(framesFilt(:))-0.5:max(framesFilt(:))+0.5;
[N, binEdges] = histcounts(framesFilt(:), binEdgesIn);
[pks,locs] = findpeaks(-N);
thresh = binEdges(locs(1)+1);
h.ThresholdSlider.Value = cast(thresh, cl);
h.ThresholdText.String = sprintf('%3.1f', h.ThresholdSlider.Value);

h.roi = [1 1 h.vr.Width h.vr.Height];

h.iFrame = 1;
h.CurrentFrame = frames(:,:,h.iFrame);
h.FrameSlider.Value = h.iFrame;
h.FrameSlider.Min = 1;
h.FrameSlider.Max = h.vr.NumberOfFrames;
h.FrameSlider.SliderStep = [10/h.vr.NumberOfFrames 0.01];
h.FineFrameSlider.Value = h.iFrame;
h.FineFrameSlider.Min = 1;
h.FineFrameSlider.Max = h.vr.NumberOfFrames;
h.FineFrameSlider.SliderStep = [1/h.vr.NumberOfFrames 0.01];

h.FrameText.String = sprintf('Frame %1.0f/%1.0f', h.iFrame, h.vr.NumberOfFrames);

h.RangeEdit.String = '1:end';
tmp = 1:h.vr.NumberOfFrames;
h.RangeEdit.Value = eval(sprintf('tmp(%s)', h.RangeEdit.String));

h.analyzedFrames = false(h.vr.NumberOfFrames, 1);
if h.OverwriteCheck.Value
    h.framesToAnalyze = h.RangeEdit.Value;
else
    h.framesToAnalyze = setdiff(h.RangeEdit.Value, find(h.analyzedFrames));
end

h.AnalysisStatusText.String = sprintf('1/%d\t xxx fps \thh:mm:ss  left', length(h.framesToAnalyze));

updateFigure(hObject, eventdata, h);
