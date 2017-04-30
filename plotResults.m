function plotResults(res, h, color)

hold on;
xShift = res.roi(1)-1;
yShift = res.roi(2)-1;
% make sure the xlim, ylim do not change
xlim(h.Axes, xlim(h.Axes));
ylim(h.Axes, ylim(h.Axes));

if h.CenterCheck.Value
    plot(h.Axes, res.x0+xShift, res.y0+yShift, 'o', 'Color', color);
end

if h.EdgeCheck.Value
    plot(h.Axes, res.xxEdge+xShift, res.yyEdge+yShift, '.', 'Color', color);
end

if h.EllipseCheck.Value
    % plot the ellipse
    plot(h.Axes, res.xxEllipse+xShift, res.yyEllipse+yShift, '-', 'Color', color);
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