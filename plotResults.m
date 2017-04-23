function plotResults(res, h)

hold on;
xShift = h.roi(1)-1;
yShift = h.roi(2)-1;
if h.CenterCheck.Value
    plot(h.Axes, res.x0+xShift, res.y0+yShift, 'ro');
end

if h.EdgeCheck.Value
    plot(h.Axes, res.xxEdge+xShift, res.yyEdge+yShift, 'c.');
end

if h.EllipseCheck.Value
    % plot the ellipse
    plot(h.Axes, res.xxEllipse+xShift, res.yyEllipse+yShift, 'g');
    % plot the cross
%     len = length(res.xxEllipse)-1;
%     xx = res.xxEllipse([1 1+round((len)/2)])+xShift;
%     yy = res.yyEllipse([1 1+round((len)/2)])+yShift;
%     plot(h.Axes, xx, yy, 'g');
%     xx = res.xxEllipse(round([1+len/4 1+3*len/4]))+xShift;
%     yy = res.yyEllipse(round([1+len/4 1+3*len/4]))+yShift;
%     plot(h.Axes, xx, yy, 'g');
end
hold off