function out = getSingleRes(results, iFrame)

out.x0 = results.x(iFrame);
out.y0 = results.y(iFrame);
out.area = results.area(iFrame);
out.aAxis = results.aAxis(iFrame);
out.bAxis = results.bAxis(iFrame);
out.theta = results.theta(iFrame);
out.goodFit = results.goodFit(iFrame);
out.blink = results.blink(iFrame);
out.blinkSoft = results.blinkSoft(iFrame);
out.blinkRho = results.blinkRho(iFrame);
out.gaussStd = results.gaussStd(iFrame);
out.threshold = results.threshold(iFrame);
out.roi = results.roi(iFrame);
out.equation = results.equation{iFrame};
out.xxEdge = results.xxContour{iFrame};
out.yyEdge = results.yyContour{iFrame};
out.xxEllipse = results.xxEllipse{iFrame};
out.yyEllipse = results.yyEllipse{iFrame};