function h = updateBlinks(h)

h.results.blink = inpolygon(h.results.blinkMean, ...
    h.results.blinkRho, h.blinkClassifier(:,1), h.blinkClassifier(:, 2));