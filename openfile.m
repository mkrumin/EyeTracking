function [h, errFlag] = openfile(hObject, eventdata, h, providedFileName)

errFlag = 0;
if nargin < 4
    if exist(h.CurrentFolder, 'dir')
        [FileName, PathName, ~] = ...
            uigetfile('*.mj2', 'Open Video File...', fullfile(h.CurrentFolder, '*mj2'));
    else
        [FileName, PathName, ~] = ...
            uigetfile('*.mj2', 'Open Video File...', pwd);
    end
    
    if FileName==0
        warning('No file was selected');
        errFlag = -1;
        return;
    end
    
    [~, fn, fe] = fileparts(FileName);
else
    [PathName, fn, fe] = fileparts(providedFileName);
    FileName = [fn, fe];
end

h.CurrentFolder = PathName;
h.FileName = FileName;
fprintf('Creating a local temporary copy of the file ..')
copyfile(fullfile(PathName, FileName), [h.localTempFileName, fe]);
fprintf('. done\n');
h.vr = VideoReader([h.localTempFileName, fe]);
% h.vr = VideoReader(fullfile(PathName, FileName));
h.FilenameText.String = fullfile(PathName, FileName);
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
blinkMean = mean(flatFrames);
flatFrames = bsxfun(@minus, flatFrames, blinkMean);
blinkRho = (af'*flatFrames)/std(af)./std(flatFrames)/length(af);
rhoThr = mean(blinkRho) - 4*std(blinkRho);
meanThr = mean(blinkMean) + 3*std(blinkMean);
posRho = [rhoThr*[1 1 1], rhoThr/2, 0, 0, 0, rhoThr/2];
posMean = [meanThr, (meanThr + 255)/2, 255*[1 1 1], (meanThr + 255)/2, meanThr*[1 1]];
h.blinkClassifier = [posMean', posRho'];

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

% if results figure exists delete it, so that the next time all the axes
% are reset to the proper values related to the new dataset
if isfield(h, 'plotHandles')
    delete(h.plotHandles.figure);
    h = rmfield(h, 'plotHandles');
end

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
h.results.blinkManual = false(nFrames, 1);
h.results.blinkSoft = false(nFrames, 1);
h.results.blinkRho = NaN(nFrames, 1);
h.results.blinkMean = NaN(nFrames, 1);
h.results.gaussStd = NaN(nFrames, 1);
h.results.threshold = NaN(nFrames, 1);
h.results.roi = NaN(nFrames, 4);
h.results.blinkRoi = NaN(nFrames, 4);
h.results.equation = cell(nFrames, 1);
h.results.xxContour = cell(nFrames, 1);
h.results.yyContour = cell(nFrames, 1);
h.results.xxEllipse = cell(nFrames, 1);
h.results.yyEllipse = cell(nFrames, 1);

