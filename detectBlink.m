function [isBlink, rho, ave] = detectBlink(frame, h)

isBlink = false;
xSpan = h.blinkRoi(1):sum(h.blinkRoi([1, 3]))-1;
ySpan = h.blinkRoi(2):sum(h.blinkRoi([2, 4]))-1;

fr = double(frame(ySpan, xSpan));
ave = mean(fr(:));
af = h.averageFrame(ySpan, xSpan);
fr = zscore(fr(:));
af = zscore(af(:));

rho = (af'*fr)/length(af);

if inpolygon(ave, rho, h.blinkClassifier(:,1), h.blinkClassifier(:,2))
    isBlink = true;
end