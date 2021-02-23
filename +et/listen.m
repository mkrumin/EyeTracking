function listen()

% this function will config the camera, start preview, and start UDP communication

% we need a couple of global variables (at least for alpha version)
global eyeUDP % this is the UDP object used to communicate with the 'mpep' computer
global eyeVid % this is the video object
global eyePP
global eyeLog

eyeLog = [];

eyePP = et.config;
usingWindowsDriver = isequal(eyePP.videoInput.adaptorName, 'winvideo');

% define the video object
eyeVid = videoinput(eyePP.videoInput.adaptorName, eyePP.videoInput.deviceID, eyePP.videoInput.format);

eyeVid.ReturnedColorspace = 'grayscale';
% we are acquiring one frame per trigger
eyeVid.FramesPerTrigger = eyePP.videoInput.FramesPerTrigger;
eyeVid.FramesAcquiredFcn = 'et.grabFrames(''no command'', clock);';
% eyeVid.StopFcn = 'et.grabFrames(''all'');';
eyeVid.FramesAcquiredFcnCount = 100;
eyeVid.LoggingMode = 'disk&memory';
% TriggerRepeat is zero based and is always one less than the number of triggers.
eyeVid.TriggerRepeat = Inf; % run forever

% we need the trigger to be 'immediate' to see the preview, I think
triggerconfig(eyeVid, 'immediate'); 


src = getselectedsource(eyeVid);
% disabling any garbage strobe signal before actually acquiring the data
set(src, eyePP.strobe.fieldName, eyePP.strobe.offValue);

% setting the rest of the properties of the video source
sourceProps = fields(eyePP.videoSource);
for iProp = 1:length(sourceProps)
    set(src, sourceProps{iProp}, eyePP.videoSource.(sourceProps{iProp})); 
end

preview(eyeVid);

%% Now setup the UDP communication


% The Remote Host IP doesn't really matter here, it is just a placeholder
% For bidirectional communication echo will be sent to the IP the command
% was received from
fakeIP = '1.1.1.1';
if isfield(eyePP.general, 'localUDPPort')
    eyeUDP = udp(fakeIP, 1103, 'LocalPort', eyePP.general.localUDPPort);
else
    eyeUDP = udp(fakeIP, 1103, 'LocalPort', 1001);
end
set(eyeUDP, 'DatagramReceivedFcn', 'et.eyeUDPCallback;');
fopen(eyeUDP);

