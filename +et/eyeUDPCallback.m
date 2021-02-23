function eyeUDPCallback(command)

% fprintf('%s:%d\n', u.DatagramAddress, u.DatagramPort),
% u.RemoteHost=u.DatagramAddress;
% u.RemotePort=u.DatagramPort;
% disp('now reading data');

% fprintf('debugging mode: Entered et.eyeUDPCallback\n');

global folderName fileStem expStarted udpLogfileID receivedData
global eyeLog eyePP eyeVid eyeUDP

if isempty(expStarted)
    expStarted = false;
end

timestamp = clock;
timeStampStr = sprintf('[%s %s]', ...
    eyePP.videoSource.Tag, datestr(clock, 'HH:MM:SS.FFF'));

if nargin>0
    switch command
        case 'clear'
            clear folders fileStems expStarted udpLogfileID
            return
    end
end

ip=eyeUDP.DatagramAddress;
port=eyeUDP.DatagramPort;
% these are needed for proper echo
eyeUDP.RemoteHost=ip;
eyeUDP.RemotePort=port;
receivedData=fread(eyeUDP);
str=char(receivedData');
fprintf('%s Received ''%s'' from %s:%d\n', timeStampStr, str, ip, port);
if ~isfield(eyeLog, 'udpEventTimes')
    eyeLog.udpEventTimes{1, 1} = timestamp;
    eyeLog.udpEvents{1, 1} = sprintf('''%s'' from %s:%d\n', str, ip, port);
else
    eyeLog.udpEventTimes{end+1, 1} = timestamp;
    eyeLog.udpEvents{end+1, 1} = sprintf('''%s'' from %s:%d\n', str, ip, port);
end

info=dat.mpepMessageParse(str);

switch info.instruction
    case 'hello'
        char(receivedData')
        fwrite(eyeUDP, receivedData);
    case 'ExpStart'
        % clean garbage from the log structure
        eyeLog.udpEventTimes = eyeLog.udpEventTimes(end, :);
        eyeLog.udpEvents = eyeLog.udpEvents(end, :);

        % configure save filename and path
        
        eyeLog.ExpRef = info.expRef;
        folderName = dat.expPath(info.expRef, 'local', 'master');
        fileStem = sprintf('%s_%s', info.expRef, eyePP.videoSource.Tag);
        
        [mkSuccess, message] = mkdir(folderName);
        if mkSuccess
            fprintf('%s folder successfully created\n', folderName);
        else
            error('There was a problem creating %s. %s\n', folderName, message');
        end
        
        % this function will initialize the video object (arm the camera)
        % before the acquisition starts
        
        switch eyePP.videoInput.VideoProfile
            case 'Archival'
                diskLogger = VideoWriter(fullfile(folderName, [fileStem, '.mj2']), 'Archival');
                diskLogger.MJ2BitDepth = 8;
            case 'Motion JPEG AVI'
                diskLogger = VideoWriter(fullfile(folderName, [fileStem, '.avi']), 'Motion JPEG AVI');
                diskLogger.Quality = eyePP.videoInput.VideoQuality;
            case 'Motion JPEG 2000'
                diskLogger = VideoWriter(fullfile(folderName, [fileStem, '.mj2']), 'Motion JPEG 2000');
                diskLogger.MJ2BitDepth = 8;
                diskLogger.LosslessCompression = false;
                diskLogger.CompressionRatio = eyePP.videoInput.CompressionRatio;
        end
        
        if isnumeric(eyePP.videoSource.FrameRate)
            diskLogger.FrameRate = eyePP.videoSource.FrameRate;
        else
            diskLogger.FrameRate = str2num(eyePP.videoSource.FrameRate);
        end
        eyeVid.DiskLogger = diskLogger;
        
        src = getselectedsource(eyeVid);
        if eyePP.trigger.useTrigger
            % TODO - without modification this code will crash
            src.Trigger = 'Enable';
        end
        
        eyeLog.loggerInfo = get(eyeVid.Disklogger);
        eyeLog.videoinputInfo = get(eyeVid);
        eyeLog.videosourceInfo = get(src);
        eyeLog.paramsUsed = eyePP;
        save(fullfile(folderName, fileStem), 'eyeLog');
        
        
        if ~eyePP.general.liveviewOn
            stoppreview(eyeVid);
        end
        
        % this will start the camera. If in triggered mode it will wait for
        % triggers, if not (i.e. in live mode) it will start acquisition straightaway

        start(eyeVid);
        if eyePP.strobe.useStrobe
            set(src, eyePP.strobe.fieldName, eyePP.strobe.onValue);
        end
        
        expStarted = true;
        fwrite(eyeUDP, receivedData); % echo after completing required actions
        
    case {'ExpEnd', 'ExpInterrupt'}
        % stop acquiring the data
%         src = getselectedsource(eyeVid);
        
        if eyePP.general.expEndDelay>0
            fprintf('Waiting a bit after ExpEnd..')
        end

        expEndTimer = timer('StartDelay', eyePP.general.expEndDelay, 'ExecutionMode', 'singleShot', 'TimerFcn', 'et.expendScript;');
        start(expEndTimer);
        
        
    case 'alyx' % recieved Alyx instance
        fwrite(eyeUDP, receivedData);
    case 'BlockStart'
        fwrite(eyeUDP, receivedData);
    case 'BlockEnd'
        fwrite(eyeUDP, receivedData);
    case 'StimStart'
        fwrite(eyeUDP, receivedData);
    case 'StimEnd'
        % save log data after each stimulus even if saving continuous
        % video. This will be useful if the eyetracker crashes during the
        % experiment. The video is streaming onto disk automatically but the log
        % data is not.
        
        if expStarted && isfield(eyeLog, 'TriggerData')
            % do this only if the experiment was actually running and data
            % was already logged
            
            %             eyeLog.loggerInfo = get(eyeVid.Disklogger);
            %             eyeLog.videoinputInfo = get(eyeVid);
            %             eyeLog.videosourceInfo = get(getselectedsource(eyeVid));
            %             eyeLog.paramsUsed = eyePP;
%             iName = 1;
%             save(fullfile(folders{iName}, fileStems{iName}), 'eyeLog');
            len = length(eyeLog.TriggerData);
            nPoints = 150;
            startIndex = max(1, len-nPoints+1);
            fprintf('%0.5f fps for the last %d frames\n', ...
                1/mean(diff([eyeLog.TriggerData(startIndex:len).Time])), nPoints);
            fprintf('FramesAcquired: %d, FramesStillInBuffer: %d, FramesLogged2File: %d\n', ...
                eyeVid.FramesAcquired, eyeVid.FramesAvailable, eyeVid.DiskLoggerFrameCount)
        end
        fwrite(eyeUDP, receivedData);
    otherwise
        fprintf('Unknown instruction : %s', info.instruction);
        fwrite(eyeUDP, receivedData);
end

if isempty(udpLogfileID)
    filename = fullfile(folderName, [fileStem, '_tmpUDPLog.txt']);
    % important to open file to append data ('a' not 'w'), just in case
    [udpLogfileID, errmsg] = fopen(filename, 'a');
    if ~isempty(errmsg)
        warning('UDP log file couldn''t be created with the following message:');
        fprint('%s\n', errmsg);
    end
    fprintf(udpLogfileID, 'AbsTime\t\t\t\tUDP message received\r\n');
end
fprintf(udpLogfileID, '[%d,%02d,%02d,%02d,%02d,%06.3f]\t%s\r\n', ...
    eyeLog.udpEventTimes{end}, eyeLog.udpEvents{end});

% disp('now the addresses are:');
% fprintf('%s:%d\n', u.DatagramAddress, u.DatagramPort),
% fprintf('now sending %s to the remote host\n', char(data(:))');
% fprintf('%s\n', char(data(:))');
% fprintf

end
%===========================================================
%

