function [frameTimes tl_flag] = getFrameTimes(varargin)

% This function will return the frametimes of the eye-tracking movie
% The frame times will be aligned to the Timeline time axis
% If corresponding Timeline file does not exist, frame times will be
% relative only.
%
% different possible ways to call this function:
%
% frameTimes = getFrameTimes(animal, series, exp)
%              animal, series, experiment - as used in mpep 
%              (series and exp are numericals)
%              frameTimes - timestamps of frames in seconds, 
%              aligned to the Timeline time axis
% frameTimes = getFrameTimes() - will pop up a dialgo box to choose the
%              eyeTracking data or video file
% frameTimes = getFrameTimes(ExpRef)

% These ways of calling are not supported yet:
% frameTimes = getFrameTimes(eyeCameraFileName, timelineFileName)

% May 2014 - MK Created

if nargin == 3
    animal = varargin{1};
    series = varargin{2};
    exp = varargin{3};
    str = sprintf('ExpStart %s %d %d', animal, series, exp);
    info = dat.mpepMessageParse(str);
    
    fullNames = dat.expFilePath(info.expRef, 'eyetracking');
    % the second cell is the server location
    [eyeFolder ,eyeFileStem, ~] = fileparts(fullNames{2});
    % loading the eyeLog data
    warning off % there is always an annoying warning about a videoinput object
    load(fullfile(eyeFolder, eyeFileStem));
    warning on

    fullNames = dat.expFilePath(info.expRef, 'Timeline');
    % the second cell is the server location
    % loading the Timeline data
    load(fullNames{2});

elseif nargin == 2
    % the two arguments are the two filenames - eye and TL
elseif nargin == 1
    % ExpRef is supplied as an argument
    ExpRef = varargin{1};
    
    % loading the Eye-tracking data
    fullNames = dat.expFilePath(ExpRef, 'eyetracking');
    % the second cell is the server location
    try
        % first trying to load local data (if it exists)
        [eyeFolder ,eyeFileStem, ~] = fileparts(fullNames{1});
        warning off % there is always an annoying warning about a videoinput object
        load(fullfile(eyeFolder, eyeFileStem));
        warning on
    catch
        % if local loading fails - load from the server
        [eyeFolder ,eyeFileStem, ~] = fileparts(fullNames{2});
        warning off % there is always an annoying warning about a videoinput object
        load(fullfile(eyeFolder, eyeFileStem));
        warning on
    end
    % in any case eyeFolder should point to a server location at the end
    % (for the video file)
    [eyeFolder , ~, ~] = fileparts(fullNames{2});

    % loading the Timeline data
    fullNames = dat.expFilePath(ExpRef, 'Timeline');
    try
        % trying to load Timeline data from  a local location
        load(fullNames{1});
    catch
        % local loading failed, loading from the server (slower)
        load(fullNames{2});
    end
    
elseif nargin == 0
    % will open uigetfile(), so that user will be able to choose the video
    % file
    startPath = '\\zubjects.cortexlab.net\Subjects';
    [Filename, eyeFolder] = uigetfile('*.*', 'Choose an eye-tracking data file', startPath);
    [~, eyeFileStem, ~] = fileparts(Filename);
    % loading the eye data
    warning off % there is always an annoying warning about a videoinput object
    load(fullfile(eyeFolder, eyeFileStem));
    warning on
    
    % figuring out where the Timeline data sits
    und_idx = strfind(eyeFileStem, '_eye');
    expRef = eyeFileStem(1:und_idx(end)-1);
    fullNames = dat.expFilePath(expRef, 'Timeline');
    % the second cell is the server location
    % loading the Timeline data
    load(fullNames{2});

end
    
vReader = VideoReader(fullfile(eyeFolder, eyeLog.loggerInfo.Filename));
nFrames = vReader.NumberOfFrames;
fprintf('There are %d frames in the video file\n', nFrames);
fprintf('There are %d timestamps in the log file\n', length(eyeLog.TriggerData));

% find the last ExpStart-ExpEnd pair
endInd = [];
startInd = [];
for iEvent = length(eyeLog.udpEvents):-1:1
    if ~isempty(strfind(eyeLog.udpEvents{iEvent}, 'ExpEnd')) || ...
            ~isempty(strfind(eyeLog.udpEvents{iEvent}, 'ExpInterrupt'))
    %if ~isempty(strfind(eyeLog.udpEvents{iEvent}, 'ExpEnd')) ...
    %        || ~isempty(strfind(eyeLog.udpEvents{iEvent}, 'ExpInterrupt'))
        endInd = iEvent;
        break;
    end
end
for iEvent = (endInd-1):-1:1
    if strfind(eyeLog.udpEvents{iEvent}, 'ExpStart')
        startInd = iEvent;
        break;
    end
end

udpEvents = eyeLog.udpEvents(startInd:endInd);
udpEventTimes = eyeLog.udpEventTimes(startInd:endInd);

nEvents = length(udpEventTimes);

if exist('Timeline','var')
    tl_flag = 1;
else
    tl_flag = 0;
    warning('Timeline was not found!!!');
end

if  tl_flag && ~isequal(nEvents, Timeline.mpepUDPCount)
    warning('Number of UDP events logged by Timeline and by EyeCamera is different. Something must be wrong!');
end

% converting absolute times to times in seconds
eyeTimes = nan(nEvents, 1);
for iEvent=1:nEvents
    eyeTimes(iEvent) = datenum(udpEventTimes{iEvent})*(24*60*60);
end
frameTimes = nan(nFrames, 1);
for iFrame = 1:nFrames
    if iFrame<=length(eyeLog.TriggerData)
        frameTimes(iFrame) = datenum(eyeLog.TriggerData(iFrame).AbsTime)*(24*60*60);
    else
        frameTimes(iFrame)=NaN;
    end
end

if tl_flag
    tlTimes = Timeline.mpepUDPTimes(1:nEvents);
    nEvents2Discard = 1; % ExpStart has an arbitrary 0 time in Timeline
    idx = nEvents2Discard+1:nEvents-1; % ExpEnd might also misbehave in terms of relative timing
    timeDiff = median(eyeTimes(idx)) - median(tlTimes(idx));
    frameTimes = frameTimes - timeDiff;    
end

return;

%% =============some plotting for debugging purposes=========
eyeTimes = eyeTimes - timeDiff;

figure
stem(eyeTimes, ones(nEvents, 1), 'b');
hold on;
stem(tlTimes, ones(nEvents, 1), 'r:');
legend('eyeUDPs', 'tlUDPs');
xlabel('time [seconds]');
title('UDP messges Timing (aligned)');

figure
dd = diff(eyeTimes-tlTimes);
plot(dd(nEvents2Discard+1:end))
title('UDP timing jitter (eyeCamera - Timeline)');
xlabel('UDP message number');
ylabel('Time difference [sec]');

figure
hist(dd(nEvents2Discard+1:end), 20);
title('Time jitter histogram');
xlabel('Time difference [sec]');


