function [isBlink, rho, ave] = detectBlinkBatch(frames, h)

nFrames = size(frames, 3);

xSpan = h.blinkRoi(1):sum(h.blinkRoi([1, 3]))-1;
ySpan = h.blinkRoi(2):sum(h.blinkRoi([2, 4]))-1;

af = h.averageFrame(ySpan, xSpan);
af = zscore(af(:));

fr = double(frames(ySpan, xSpan, :));
fr = reshape(fr, [], nFrames);
ave = mean(fr, 1);
fr = zscore(fr);
    
rho = (af'*fr)/length(af);
pos = h.blinkClassifier;
isBlink = inpolygon(ave, rho, pos(:,1), pos(:, 2));
