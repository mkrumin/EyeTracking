%loading data

subject = 'MK009';
expDate = '2014-05-19';
exp = 857;

expref = dat.constructExpRef(subject, expDate, exp)

tmp = dat.expFilePath(expref, 'eyeTracking');
[eyeFolder, eyeFile, ~] = fileparts(tmp{2});
tmp = dat.expFilePath(expref, 'Timeline');
[tlFolder, tlFile, ~] = fileparts(tmp{2});

load(fullfile(tlFolder, tlFile)); % loading variable 'Timeline'
load(fullfile(eyeFolder, eyeFile)); % loading variable 'eyeLog'
vReader = VideoReader(fullfile(eyeFolder, [eyeFile, '.mj2']));
nFrames = vReader.NumberOfFrames;

% find the last ExpStart-ExpEnd pair
endInd = [];
startInd = [];
for iEvent = length(eyeLog.udpEvents):-1:1
    if isequal(eyeLog.udpEvents{iEvent}(2:7), 'ExpEnd')
        endInd = iEvent;
    end
    if isequal(eyeLog.udpEvents{iEvent}(2:9), 'ExpStart')
        startInd = iEvent;
        if endInd>startInd
            break
        end
    end
end

udpEvents = eyeLog.udpEvents(startInd:endInd);
udpEventTimes = eyeLog.udpEventTimes(startInd:endInd);

nEvents = length(udpEventTimes);
timeInSeconds = nan(nEvents, 1);
for iEvent=1:nEvents
    timeInSeconds(iEvent) = datenum(udpEventTimes{iEvent})*(24*60*60);
end
frameTimeInSeconds = nan(nFrames, 1);
for iFrame = 1:nFrames
    frameTimeInSeconds(iFrame) = datenum(eyeLog.TriggerData(iFrame).AbsTime)*(24*60*60);
end

realTime = Timeline.mpepUDPTimes(1:nEvents);

refTime = timeInSeconds(3);
timeInSeconds = timeInSeconds - timeInSeconds(3);
tlRefTime = realTime(3);
realTime = realTime - tlRefTime;
frameTimeInSeconds = frameTimeInSeconds - refTime;


figure
stem(timeInSeconds, ones(nEvents, 1), 'b');
hold on;
stem(realTime, ones(nEvents, 1), 'r:')

dd = diff(timeInSeconds-realTime);
plot(dd(3:end))

figure, plot(Timeline.rawDAQTimestamps - tlRefTime, Timeline.rawDAQData(:,2))