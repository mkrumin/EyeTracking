function h = updateBlinks(h)

h.results.blink = inpolygon(h.results.blinkMean, ...
    h.results.blinkRho, h.blinkClassifier(:,1), h.blinkClassifier(:, 2));

% No. of frames (both causal and a-causal) around a 'hard blink' 
% to be automatically classified as a 'soft blink' 
nFrames = floor(0.1*h.vr.FrameRate);

h.results.blinkSoft = ...
    logical(conv(single(h.results.blink), ones(2*nFrames+1, 1), 'same'));
h.results.blinkSoft = h.results.blinkSoft & ~h.results.blink;