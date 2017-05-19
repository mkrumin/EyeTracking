function res = autoAnalyzeFrame(src)

h = guidata(src);

params.gaussStd = h.FilterSizeEdit.Value;
params.thresh = h.ThresholdSlider.Value;
xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
% [isBlink, blinkRho, blinkMean] = detectBlink(h.CurrentFrame, h);

thStart = h.ThresholdSlider.Value;
thRange = 30;
thStep = 1;
thresholdVector = thStart + [-thRange:thStep:thRange];
for iTh = 1:length(thresholdVector)
    params.thresh = thresholdVector(iTh);
    res(iTh) = analyzeSingleFrame(h.CurrentFrame(ySpan, xSpan, :), params);
end

%%
r = sqrt([res.area]/pi);
x = [res.x0];
y = [res.y0];
dr =  gradient(smooth(r));
dx = gradient(x);
dy = gradient(y);
% exclude points with negative gradient (ellipse should grow with
% threshold)
idx = dr>0;
% exclude outliers
idx = idx & (abs(dr-median(dr(idx)) < 3*mad(dr(idx),1)));
% only take points connected to the current threshold value
idxStart = find(thresholdVector == thStart);
idxL = bwlabel(idx);
idx = (idxL == idxL(idxStart));

p = polyfit(thresholdVector(idx)', dr(idx), 2);
thV = thStart + [-thRange:0.1:thRange];
thMin = -p(2)/2/p(1);
yMin = p(1)*thMin^2 + p(2)*thMin + p(3);
if thMin>0 && thMin < 255
h.ThresholdSlider.Value = round(thMin);
etGUI('ThresholdSlider_Callback', h.ThresholdSlider, [], h);
end
return;
%%
figure
subplot(1, 2, 1);
plot(thresholdVector, r);
hold on;
plot(thresholdVector, x);
plot(thresholdVector, y);
legend('radius', 'x0', 'y0');

subplot(1, 2, 2);
% plot(thresholdVector(1:end-1), dr);
hold on;
% plot(thresholdVector(1:end-1), dx);
% plot(thresholdVector(1:end-1), dy);
% plot(thresholdVector(1:end-1), sqrt(dx.^2 + dy.^2 + dr.^2));
plot(thresholdVector, dr);
hold on;
plot(thV, p(1)*thV.^2 + p(2)*thV + p(3));
plot(thMin, yMin, 'ro')
plot(thresholdVector(idx), dr(idx), '.');

% plot(thresholdVector(2:end-1), diff(sqrt(dx.^2 + dy.^2 + dr.^2)));
legend('1st der', sprintf('thOpt = %3.1f', thMin));%, '2nd der');
% legend('radius', 'x0', 'y0');


%% 
return;

xShift = h.roi(1)-1;
yShift = h.roi(2)-1;

h.results.x(h.iFrame) = res.x0+xShift;
h.results.y(h.iFrame) = res.y0+yShift;
h.results.area(h.iFrame) = res.area;
h.results.aAxis(h.iFrame) = res.a;
h.results.bAxis(h.iFrame) = res.b;
h.results.theta(h.iFrame) = res.theta;
h.results.goodFit(h.iFrame) = res.isEllipse;
h.results.blink(h.iFrame) = isBlink;
h.results.blinkRho(h.iFrame) = blinkRho;
h.results.blinkMean(h.iFrame) = blinkMean;
h.results.gaussStd(h.iFrame) = params.gaussStd;
h.results.threshold(h.iFrame) = params.thresh;
h.results.roi(h.iFrame, :) = h.roi;
h.results.blinkRoi(h.iFrame, :) = h.blinkRoi;
h.results.equation{h.iFrame} = res.eq;
h.results.xxContour{h.iFrame} = res.xxEdge+xShift;
h.results.yyContour{h.iFrame} = res.yyEdge+yShift;
h.results.xxEllipse{h.iFrame} = res.xxEllipse+xShift;
h.results.yyEllipse{h.iFrame} = res.yyEllipse+yShift;
h.analyzedFrames(h.iFrame) = true;

h.figure1.Color = oldColor;
guidata(src, h);
updateFigure(src, [], h);
