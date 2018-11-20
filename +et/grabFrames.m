function fID = grabFrames(command, timestamp)

global eyeVid
global eyeLog
persistent fileID

if nargin>0
    switch command
        case 'clear'
            fprintf('GrabFrames called with the ''clear'' flag\n');
            clear fileID;
            fID = [];
            return
    end
end

% if nargin>1
% fprintf('Grabframes was called at     %s\n', datestr(timestamp, '  HH:MM:SS.FFF'));
% else
% fprintf('Grabframes was called without timestamp\n');
% end
% fprintf('Grabframes was executed at     %s\n', datestr(clock, 'HH:MM:SS.FFF'));

% if nargin>1 && etime(clock, timestamp)>0.001
% fprintf('Grabframes was called at %s\n', datestr(timestamp, '  HH:MM:SS.FFF'));
% fprintf('Grabframes was executed at %s\n\n', datestr(clock, 'HH:MM:SS.FFF'));
% end


% frAvail = eyeVid.FramesAvailable;
nFrames = min(eyeVid.FramesAcquiredFcnCount, eyeVid.FramesAvailable);
if nargin>0 && isequal(command, 'all')
    fprintf('GrabFrames called with the ''all'' flag\n');
    nFrames = eyeVid.FramesAvailable;
end
% nFrames = 1;

metadata = [];
if nFrames>0
    [~, Time, metadata] = getdata(eyeVid, nFrames);
    for iFrame = 1:nFrames
        metadata(iFrame).Time = Time(iFrame);
    end
end

if ~isfield(eyeLog, 'TriggerData')
    eyeLog.TriggerData = metadata;
    fileID = [];
else
    eyeLog.TriggerData = [eyeLog.TriggerData; metadata];
end


if isempty(fileID)
    pp = get(eyeVid.Disklogger, 'Path');
    [~, ff, ~] = fileparts(get(eyeVid.Disklogger, 'Filename'));
    filename = fullfile(pp, [ff, '_tmpFrameTimeLog.txt']);
    [fileID, errmsg] = fopen(filename, 'w');
        if ~isempty(errmsg)
            warning('Frame times log file couldn''t be created with the following message:');
            fprint('%s\n', errmsg);
        end
    fprintf(fileID, 'AbsTime\t\t\t\tFrameNumber\tRelativeFrame\tTriggerIndex\tTime\r\n');
end
for iEntry=1:length(metadata)
    s = metadata(iEntry);
    fprintf(fileID, '[%d,%d,%d,%d,%d,%.5f]\t%d\t\t%d\t\t%d\t\t%.5f\r\n', ...
        s.AbsTime, s.FrameNumber, s.RelativeFrame, s.TriggerIndex, s.Time);
end

fID = fileID;
% fprintf('Grabframes finished running at %s\n\n', datestr(clock, 'HH:MM:SS.FFF'));

end