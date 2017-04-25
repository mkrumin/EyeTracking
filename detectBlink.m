function [isBlink, rho] = detectBlink(frame, h)

isBlink = false;
xSpan = h.blinkRoi(1):sum(h.blinkRoi([1, 3]))-1;
ySpan = h.blinkRoi(2):sum(h.blinkRoi([2, 4]))-1;

fr = double(frame(ySpan, xSpan));
af = h.averageFrame(ySpan, xSpan);
fr = zscore(fr(:));
af = zscore(af(:));

rho = (af'*fr)/length(af);
if rho<h.BlinkRhoEdit.Value
    isBlink = true;
end