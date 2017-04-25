function h = openfile(hObject, eventdata, h)

[FileName, PathName, ~] = ...
    uigetfile('*.mj2', 'Open Video File...', h.CurrentFolder);

h.CurrentFolder = PathName;
h.FileName = FileName;

h.vr = VideoReader(fullfile(PathName, FileName));
h.FilenameText.String = FileName;
nFramesToRead = 500; % this is the maximum, given that the movie is long enough
singleFrame = read(h.vr, 1);
[nr, nc] = size(singleFrame);
cl = class(singleFrame);
framesToRead = unique(round(linspace(1, h.vr.NumberOfFrames, nFramesToRead)));
frames = zeros(nr, nc, length(framesToRead), cl);
for iFrame = 1:length(framesToRead)
    frames(:,:,iFrame) = read(h.vr, framesToRead(iFrame));
end

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

h.averageFrame = double(mean(frames, 3));
af = h.averageFrame(:);
af = af - mean(af);
flatFrames = double(reshape(frames, [], size(frames, 3)));
flatFrames = flatFrames - mean(flatFrames);
blinkRho = (af'*flatFrames)/std(af)./std(flatFrames)/length(af);
h.BlinkRhoEdit.Value = mean(blinkRho)-4*std(blinkRho);
h.BlinkRhoEdit.String = sprintf('%5.3f', h.BlinkRhoEdit.Value);

h.roi = [1 1 h.vr.Width h.vr.Height];
h.blinkRoi = h.roi;

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
h.ReplaySlider.Max = 1;
h.ReplaySlider.Min = 0;
h.ReplaySlider.Value = 0;
h.ReplaySlider.SliderStep = [1, 1];


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

nFrames = h.vr.NumberOfFrames;
h.results = struct([]);
h.results(1).x = NaN(nFrames, 1);
h.results.y = NaN(nFrames, 1);
h.results.area = NaN(nFrames, 1);
h.results.aAxis = NaN(nFrames, 1);
h.results.bAxis = NaN(nFrames, 1);
h.results.theta = NaN(nFrames, 1);
h.results.goodFit = false(nFrames, 1);
h.results.blink = false(nFrames, 1);
h.results.blinkRho = NaN(nFrames, 1);
h.results.gaussStd = NaN(nFrames, 1);
h.results.threshold = NaN(nFrames, 1);
h.results.roi = NaN(nFrames, 4);
h.results.equation = cell(nFrames, 1);
h.results.xxContour = cell(nFrames, 1);
h.results.yyContour = cell(nFrames, 1);
h.results.xxEllipse = cell(nFrames, 1);
h.results.yyEllipse = cell(nFrames, 1);

updateFigure(hObject, eventdata, h);
