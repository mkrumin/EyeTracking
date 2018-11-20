function listen()

% this function will config the camera, start preview, and start UDP communication

% we need a couple of global variables (at least for alpha version)
global eyeUDP % this is the UDP object used to communicate with the 'mpep' computer
global eyeVid % this is the video object
global eyePP
global eyeLog

eyeLog = [];

eyePP = et.config;
usingWindowsDriver = isequal(eyePP.adaptorName, 'winvideo');

% define the video object
eyeVid = videoinput(eyePP.adaptorName, eyePP.deviceID, eyePP.format);
src = getselectedsource(eyeVid);


% disabling any garbage signal before actually acquiring the data

if ~usingWindowsDriver
    src.Strobe = 'Disable';
end

% we are acquiring one frame per trigger
eyeVid.FramesPerTrigger = eyePP.FramesPerTrigger;
eyeVid.FramesAcquiredFcn = 'et.grabFrames(''no command'', clock);';
% eyeVid.StopFcn = 'et.grabFrames(''all'');';
eyeVid.FramesAcquiredFcnCount = 100;

% this might be useless (as we trigger each frame)
% src.FrameRate = p.FrameRate;

if usingWindowsDriver
    src.ExposureMode = 'manual';
    src.Exposure = eyePP.Exposure;
    try %% AS added as there is no Gain mode on my camera object
        src.GainMode = 'manual';
    catch
        display('There was a problem setting the gain mode of the camera');
    end
    src.Gain = eyePP.Gain;
    eyeVid.ReturnedColorspace = 'grayscale';
    try
        src.FrameRate = eyePP.FrameRate;
    catch
        str = sprintf('There was a problem setting the frame rate of %s', eyePP.FrameRate);
        warning(str);
        fprintf('Your camera supports the following frame rates: \n');
        set(getselectedsource(eyeVid), 'FrameRate')
        fprintf('All these are strings, e.g. set ''30.0000'' for 30 fps\n');
        warning('Please edit the et.config file and restart the eyetracker');
        error('et.listen() failed to set frame rate, check your configuration in et.config');
        
    end
        
else
    src.ExposureAuto = 'Off';
    src.Exposure = eyePP.Exposure;
    src.FrameRate = eyePP.FrameRate;
end

if ~usingWindowsDriver
    if eyePP.UseTriggered
        src.Trigger = 'Enable';
        src.TriggerPolarity = eyePP.TriggerPolarity;
    else
        src.Trigger = 'Disable';
    end
end

% now, after setting the triggering we can switch the strobe back on
if ~usingWindowsDriver
    if eyePP.UseStrobe
        src.StrobePolarity =  eyePP.StrobePolarity;
        src.StrobeMode = eyePP.StrobeMode;
        src.Strobe = 'Enable';
    else
        src.Strobe = 'Disable';
    end
end

eyeVid.LoggingMode = 'disk&memory';
% eyeVid.LoggingMode = 'disk';

% TriggerRepeat is zero based and is always one less than the number of triggers.
eyeVid.TriggerRepeat = Inf;

triggerconfig(eyeVid, 'immediate');

% to allow preview we need to disable the trigger (and we also don't want
% to get the strobe out during the preview)
if ~usingWindowsDriver
    src.Strobe = 'Disable';
    src.Trigger = 'Disable';
end

preview(eyeVid);

%% Now setup the UDP communication


% The Remote Host IP doesn't really matter here, it is just a placeholder
% For bidirectional communication echo will be sent to the IP the command
% was received from
fakeIP = '1.1.1.1';
eyeUDP = udp(fakeIP, 1103, 'LocalPort', 1001);
set(eyeUDP, 'DatagramReceivedFcn', 'et.eyeUDPCallback;');
fopen(eyeUDP);

