function params = config()


%% these are the default parameters for 'tisimaq_r2013' adaptor

% params.adaptorName = 'tisimaq_r2013';
% params.deviceID = 1;
% params.format = 'Y800 (640x480)';
%
% % we are acquiring one frame per trigger
% params.FramesPerTrigger = 1;
% % this might be useless (as we trigger each frame)
% params.FrameRate = 30;
% params.Exposure = pow2(ceil(log2(params.FrameRate))); % or you can define manually
% params.UseTriggered = false;
% params.TriggerPolarity = 'High';
% params.UseStrobe = true;
% params.StrobePolarity = 'High';
% params.StrobeMode = 'exposure';
%
% % params.VideoProfile = 'Archival';
% % params.VideoProfile = 'Motion JPEG AVI';
% % params.VideoQuality = 75;
% params.VideoProfile = 'Motion JPEG 2000';
% params.CompressionRatio = 5;

%%==========================================================================
%%==========================================================================
%%==========================================================================
%% default parameters can be overridden here

[~, rigName] = system('hostname');
rigName = rigName(1:end-1); % removing the Line Feed character

switch rigName
    case 'ZEPHYR'
        params.general.save2server = false;
        params.general.expEndDelay = 5;
        params.general.localUDPPort = 1003; % will override the default 1001
        params.general.liveviewOn = true;


        params.strobe.useStrobe = false;
        params.strobe.fieldName = 'Strobe1';
        params.strobe.onValue = 'On';
        params.strobe.offValue = 'Off';

        params.trigger.useTrigger = false;
        params.trigger.type = 'hardware';
        params.trigger.signal = 'risingEdge';
        params.trigger.source = 'externalTriggerMode1-Source0';
        
        params.videoInput.adaptorName = 'pointgrey';
        params.videoInput.deviceID = 1;
        params.videoInput.format = 'F7_Mono8_640x512_Mode1';
%         params.videoInput.format = 'F7_Mono8_1280x1024_Mode0';
        params.videoInput.FramesPerTrigger = 1;  % we are acquiring one frame per trigger
        params.videoInput.VideoProfile = 'Motion JPEG 2000'; % this one seems to be the best option
        params.videoInput.CompressionRatio = 5; % must be >1, 5 gives good video quality
% while keeping files to a reasonable size on my setup
        
        params.videoSource.Tag = 'bellyCam';
        params.videoSource.FrameRateMode = 'Manual';
        params.videoSource.FrameRate = 30;

        params.videoSource.Brightness = 0;
        params.videoSource.ExposureMode = 'Manual';
        params.videoSource.Exposure = 0;
        params.videoSource.GainMode = 'Manual';
        params.videoSource.Gain = 0;
        params.videoSource.GammaMode = 'Manual';
        params.videoSource.Gamma = 1;
        params.videoSource.SharpnessMode = 'Manual';
        params.videoSource.Sharpness = 0;
        params.videoSource.ShutterMode = 'Manual';
        params.videoSource.Shutter = 30;
        params.videoSource.Strobe1 = 'Off';
        params.videoSource.Strobe1Delay = 0;
        params.videoSource.Strobe1Duration = 1;
        params.videoSource.Strobe1Polarity = 'High';
        params.videoSource.TriggerDelayMode = 'Manual';
        params.videoSource.TriggerDelay = 0;
        params.videoSource.TriggerParameter = 1;        

        % other properties, which we either don't need to define, or they
        % are read-only
        
%         SerialNumber = 19462589
%         Strobe2 = Off
%         Strobe2Delay = 0
%         Strobe2Duration = 0
%         Strobe2Polarity = Low
%         Strobe3 = Off
%         Strobe3Delay = 0
%         Strobe3Duration = 0
%         Strobe3Polarity = Low
%         Temperature = 318.3
        
    case 'SOMEOTHERRIGNAME'
        % override parameters here
    otherwise
        warning('Rig specific parameters not applied, using defaults. Use CORRECT CASE host names in the switch-case structure in et.config().');
end
