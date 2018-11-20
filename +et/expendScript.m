function expendScript
% this is the ExpEnd script

global eyeLog eyePP eyeVid eyeUDP vr receivedData
global folders fileStems expStarted udpLogfileID

% persistent folders fileStems expStarted udpLogfileID

if eyePP.waitAfterExpEnd>0
    fprintf('.done\n');
end

if eyePP.UseStrobe
    src = getselectedsource(eyeVid);
    src.Trigger = 'Disable';
    src.Strobe = 'Disable';
end

% stopping the acquisition
stop(eyeVid);
wait(eyeVid);

% re-starting the preview (if necessary)
if ~eyePP.liveviewOn
    preview(eyeVid);
end

% grabbing the last remaining frames and meta-data
if expStarted
    fid = et.grabFrames('all', clock);
    while eyeVid.FramesAvailable
        % we should not ever get here
        % finish grabbing all the frames from the buffer
        fid = et.grabFrames('all', clock);
    end
    fclose(fid); % closing the trigger log file
    fclose(udpLogfileID); % closing the UDP log file
    fprintf('Acquisition stopped\n');
end

% let's open the file to check how many frames were acquired
vr = VideoReader(fullfile(get(eyeVid.Disklogger, 'Path'), get(eyeVid.Disklogger, 'Filename')));
nFrames = vr.NumberOfFrames;
fprintf('FramesAcquired = %d, FramesLogged = %d\n', eyeVid.FramesAcquired, nFrames)%eyeVid.DiskLoggerFrameCount)
if (eyeVid.FramesAcquired~=nFrames)
    fprintf('\nNumber of frames do not match, most likely the last frame was not logged into the video file\n');
    fprintf('You might see a Matlab error message in a few seconds\n');
    fprintf('If this happens, then the best practice would be to run ''et.restart'' if I don''t do it myself\n\n');
else
    delete(vr);
end

% we will keep the file open, so that it will not get overwritten by
% mistake - this might result in an error message from Matlab

eyeLog.loggerInfo = eyeVid.DiskLogger;%get(eyeVid.Disklogger);
eyeLog.videoinputInfo = get(eyeVid);
eyeLog.videosourceInfo = get(getselectedsource(eyeVid));
eyeLog.paramsUsed = eyePP;


if expStarted % do this only if the experiment was actually running
    % saving the log file(s) locally
    iName = 1;
    save(fullfile(folders{iName}, fileStems{iName}), 'eyeLog');
    fprintf('Log file(s) saved locally\n');
    % sending an echo UDP to mpep
    fwrite(eyeUDP, receivedData);
    
    % save files to zserver
    if isfield(eyePP, 'save2server') && eyePP.save2server
        
        fprintf('Copying files to zserver...\nWait, do not start a new experiment\n');
        
        iName=2;
        switch eyePP.VideoProfile
            case 'Archival'
                source = [folders{1}, filesep, '*.mj2'];
            case 'Motion JPEG AVI'
                source = [folders{1}, filesep, '*.avi'];
            case 'Motion JPEG 2000'
                source = [folders{1}, filesep, '*.mj2'];
        end
        destination = [folders{iName}, filesep];
        
        [mkSuccess, message] = mkdir(destination);
        if mkSuccess
            fprintf('%s folder successfully created\n', destination);
        else
            error('There was a problem creating %s. %s\n', destination, message);
        end
        
        tic
        % copying the movie file(s) to the server
        [copySuccess, message, messageID]=copyfile(source, destination);
        if copySuccess
            fprintf('Movie file(s) successfully copied to %s\n', destination);
        else
            error('There was a problem copying movie file(s) to %s. %s\n', destination, message);
        end
        toc
        
        tic
        % saving the log file(s) to the server
        source = [folders{1}, filesep, [fileStems{1}, '*.mat']];
        [copySuccess, message, messageID]=copyfile(source, destination);
        if copySuccess
            fprintf('Log file(s) successfully copied to %s\n', destination);
        else
            error('There was a problem copying log file(s) to %s. %s\n', destination, message);
        end
        toc
    end
    
    fprintf('cleaning before the next acquisition\n');
    eyeVid.DiskLogger = [];
    eyeLog = [];
    expStarted = false;
    udpLogfileID = [];
    folders = [];
    fileStems = [];
    
    fprintf('Ready for new acquisition\n');
end

return;

% winvideo: Unexpected error logging to disk:
% Channel must be open before writing data.
% e = MException.last;

% MATLAB is not allowing to use lasterror() in a script, only command line
e = lasterror;
if ~isempty(e.message) && ...
        ~isempty(strfind(e.message, 'Unexpected error logging to disk:')) && ...
        ~isempty(strfind(e.message, 'Channel must be open before writing data.'))
%     MException.last('reset');
    lasterror('reset');
    fprintf('\nError detected, will restart the whole thing\n\n');
    et.restart;
end

