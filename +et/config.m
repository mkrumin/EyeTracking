function params = config()


params.adaptorName = 'winvideo';
params.deviceID = 1;
params.format = 'Y800_640x480';

params.FramesPerTrigger = 1;        % we are acquiring one frame per trigger
params.FrameRate = '30.0000';       % typical values {'3.7500', '7.5000', '15.0000', '30.0000', '60.0002'}
params.Exposure = -5;               % 2^x seconds, e.g. 2^(-5) == 1/32, which is good for 30 fps.
% If the exposure is too long for the required frame rate
% the imaging will be too slow
params.Gain = 1023;                 % 1023 is the maximum value

params.UseTriggered = false;        % not for winvideo driver
params.TriggerPolarity = 'High';    % not for winvideo driver
params.UseStrobe = false;           % not for winvideo driver
params.StrobePolarity = 'High';     % not for winvideo driver
params.StrobeMode = 'exposure';     % not for winvideo driver

% params.VideoProfile = 'Archival'; % this one is using lossless compression and results in huge files

% params.VideoProfile = 'Motion JPEG AVI'; % this one save all three RGB channels, so suboptimal in terms of space
% params.VideoQuality = 75;

params.VideoProfile = 'Motion JPEG 2000'; % this one seems to be the best option
params.CompressionRatio = 5; % must be >1, 5 gives good video quality
% while keeping files to a reasonable size on my setup

params.save2server = false; % if true, will automatically copy files to server at the end of the experiment.
% If false will only keep local copy.
% use false if time-gap between different experiments is critical, copying
% might take some time.
% IMPORTANT! DO NOT start a new experiment before the copying is over
% THE PARAMS.SAVEBY IS CURRENTLY NOT SUPPORTED, WILL SAVE BY EXPERIMENT
params.saveBy = 'experiment'; % one of {'experiment', 'repeat', 'stimulus'}
params.liveviewOn = true; % for fast frame rates together with larger number of pixels might be
% useful to switch liveview off to reduce load on the system

params.waitAfterExpEnd = 2; % number of seconds to wait after receiving EndExp command before stopping things.
% This allows time for the timeline computer to
% stop sending triggers so that you know you
% collected all the triggered frames.
% Not enabled by default.


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
    case 'ZQUAD'
        params.deviceID = 1;
        params.FrameRate = '30.0000';
        params.Exposure = -6;
        params.save2server = false;
        params.liveviewOn = true;
        params.waitAfterExpEnd = 5;
    case 'SOMEOTHERRIGNAME'
        % override parameters here
    case 'zi'
        params.deviceID = 2;
        params.save2server = true;
        %params.format = 'RGB24_640x480';
        %params.Exposure = 166; %[ms]?
        params.FrameRate = '60.0002'; %DS on 22/2/15
    case 'ZEYE2'
        
        %*** Here are the old params, revised by NS 2014-08-06
        %         params.deviceID = 3;
        %         params.FrameRate = '30.0000';
        %         params.Exposure = -5;
        %         params.save2server = false;
        %         params.liveviewOn = true;
        %*** old params end here
        
        params.adaptorName = 'tisimaq_r2013';
        params.deviceID = 1;
        params.format = 'Y800 (640x480)';
        params.FrameRate = '30.00'; % important that there are only two 0's after decimal
        %params.Exposure = pow2(ceil(log2(params.FrameRate))); % or you can define manually
        params.Exposure = 0.01;
        params.UseTriggered = true;
        params.UseStrobe = true;
        params.StrobePolarity = 'High';
        params.StrobeMode = 'exposure';
        
        params.waitAfterExpEnd = 5;
        params.save2server = true;
        
    case 'zeye'
        params.deviceID = 3;
        params.FrameRate = '30.0000';
        params.Exposure = -5;
        params.save2server = false;
        params.liveviewOn = true;
    case 'ZANKH'
        params.deviceID = 1;
        params.FrameRate = '30.0000';
        params.Exposure = -5;
        params.save2server = false;
        params.liveviewOn = true;
    case 'Zoo'
        params.deviceID = 1;
        params.FrameRate = '15.0000';
        params.format = 'RGB24_640x480';
        %         params.Exposure = -5;
        params.save2server = false;
        params.liveviewOn = true;
        params.Gain = 0;                 % 1023 is the maximum value
        
    case 'zlickblink'
%         params.deviceID = 3;
%         params.FrameRate = '30.0000';
%         params.Exposure = -5;
%         params.save2server = true;
%         params.liveviewOn = true;
%         params.adaptorName ='winvideo';
%         params.deviceID = 3;
%         params.format = 'Y800_640x480';
%         params.FrameRate = '30.0000';

%         params.adaptorName = 'tisimaq_r2013';
%         params.deviceID = 1;
%         params.format = 'Y800 (640x480)';
%         params.FrameRate = '30.00'; % important that there are only two 0's after decimal
% %         params.Exposure = pow2(ceil(log2(params.FrameRate))); % or you can define manually
%         params.Exposure = 0.01;
%         params.UseTriggered = false;
%         params.UseStrobe = true;
%         params.StrobePolarity = 'High';
%         params.StrobeMode = 'exposure';
%         params.waitAfterExpEnd = 2;
%         params.save2server = false;
    
        % older settings, commented out on 2017-06-07 MK AL
        params.adaptorName = 'tisimaq_r2013';
        params.deviceID = 1;
        params.format = 'Y800 (640x480)';
        params.FrameRate = '60.00'; % important that there are only two 0's after decimal
        %params.Exposure = pow2(ceil(log2(params.FrameRate))); % or you can define manually
        params.Exposure = 0.01;
        params.UseTriggered = true;
        params.UseStrobe = true;
        params.StrobePolarity = 'High';
        params.StrobeMode = 'exposure';
        
        params.waitAfterExpEnd = 2;
        params.save2server = true;
        
        
    case 'zugly'
        params.adaptorName = 'tisimaq_r2013';
        params.deviceID = 1;
        params.format = 'Y800 (640x480)';
        params.FrameRate = '60.00'; % important that there are only two 0's after decimal
        %params.Exposure = pow2(ceil(log2(params.FrameRate))); % or you can define manually
        params.Exposure = 0.01;
        params.UseTriggered = true;
        params.UseStrobe = true;
        params.StrobePolarity = 'High';
        params.StrobeMode = 'exposure';
        params.waitAfterExpEnd = 5;
        params.save2server = true;
        
    case 'ZCAMP3'
        params.adaptorName = 'ni';
        params.deviceID = 1;
        params.format = 'img0';

    case 'zimage'
        params.FrameRate = '30.0000';
        params.Exposure = -5;
        params.save2server = false;
        params.liveviewOn = true;
        params.waitAfterExpEnd = 5;
        params.Gain = 6;
        
    otherwise
        warning('Rig specific parameters not applied, using defaults. Use CORRECT CASE host names in the switch-case structure in et.config().');
end
