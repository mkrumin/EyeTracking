function [isBlink, rho] = detectBlinkBatch(frames, h)

nFrames = size(frames, 3);
isBlink = false(nFrames, 1);
rho = nan(nFrames, 1);

xSpan = h.blinkRoi(1):sum(h.blinkRoi([1, 3]))-1;
ySpan = h.blinkRoi(2):sum(h.blinkRoi([2, 4]))-1;

af = h.averageFrame(ySpan, xSpan);
af = zscore(af(:));
th = h.BlinkRhoEdit.Value;

fr = double(frames(ySpan, xSpan, :));
fr = reshape(fr, [], nFrames);
fr = zscore(fr);
    
rho = (af'*fr)/length(af);
isBlink = rho<th;
