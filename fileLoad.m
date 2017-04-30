function [h, errFlag] = fileLoad(hObject, eventdata, h)

errFlag = 0;
% uigetfile
if isfield(h, 'CurrentResultsFolder')
    [FileName, PathName, ~] = ...
        uigetfile('*.mat', 'Load Results File...', h.CurrentResultsFolder);
else
    [FileName, PathName, ~] = ...
        uigetfile('*.mat', 'Load Results File...', h.CurrentFolder);
end

if FileName ~= 0
    load(fullfile(PathName, FileName));
else
    warning('No file was selected');
    errFlag = -1;
    return;
end

if ~isfield(h, 'FileName')
    % there is no video file open yet. let' sopen the one correcponding to
    % the results file
    h = openfile(hObject, eventdata, h, fullfile(state.CurrentFolder, state.FileName));
end

% check that it matches currently open video file
if isequal(state.FileName, h.FileName) && ...
        length(state.analyzedFrames) == length(h.analyzedFrames)
    % if matches load the results and state
    h.results = results;
    h.analyzedFrames = state.analyzedFrames;
    h.roi = state.roi;
    h.blinkRoi = state.blinkRoi;
    h.BlinkRhoEdit.Value = state.blinkThreshold;
    h.BlinkRhoEdit.String = sprintf('%5.3f', state.blinkThreshold);
    h.ThresholdSlider.Value = state.Threshold;
    h.ThresholdText.String = sprintf('%3.1f', state.Threshold);
    h.FilterSizeEdit.Value = state.FilterSize;
    h.FilterSizeEdit.String = num2str(state.FilterSize);
    h.CurrentResultsFileName = FileName;
    h.CurrentResultsFolder = PathName;
    len = sum(h.analyzedFrames);
    h.ReplaySlider.Max = len;
    h.ReplaySlider.Min = min(1, len);
    [~, h.ReplaySlider.Value] = min(abs(find(h.analyzedFrames)-h.iFrame));
    h.ReplaySlider.SliderStep = [min(1, 1/len), min(1, 10/len)];
else
    % if doesn't match ask what to do
    str = 'Results file does not match currenlty open video file. You can either "Load parameters only" (e.g. threshold value, ROIs, FilterSize), or "Cancel" and open the correct video file first.';
    button = questdlg(str, ...
        'File Mismatch', ...
        'Load parameters only', 'Cancel', 'Cancel');
    switch button
        case 'Load parameters only'
            h.roi = state.roi;
            h.blinkRoi = state.blinkRoi;
            h.BlinkRhoEdit.Value = state.blinkThreshold;
            h.BlinkRhoEdit.String = sprintf('%5.3f', state.blinkThreshold);
            h.ThresholdSlider.Value = state.Threshold;
            h.ThresholdText.String = sprintf('%3.1f', state.Threshold);
            h.FilterSizeEdit.Value = state.FilterSize;
            h.FilterSizeEdit.String = num2str(state.FilterSize);
        case 'Cancel'
            % do nothing
        otherwise
            % do nothing
    end
    
end