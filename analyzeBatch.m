function res = analyzeBatch(frames, parsIn)

gaussStd = parsIn.gaussStd;
th = parsIn.thresh;

nFrames = size(frames, 3);

ell = abc2ellipse(NaN(5, 1));
resTmp = repmat(ell, nFrames, 1);
edgeTmp = repmat(struct('xxEdge', NaN, 'yyEdge', NaN), nFrames, 1);

framesFiltered = imgaussfilt(frames, gaussStd);
bwAll = framesFiltered <= th; % here the pupil is white

parfor iFrame = 1:nFrames
    
    bw = bwAll(:,:,iFrame);
    ebw = edge(bw);
    chList = regionprops(bw, 'ConvexHull');
    convex = false(size(bw));
    for i = 1:length(chList)
        convex = convex | poly2mask(chList(i).ConvexHull(:, 1), chList(i).ConvexHull(:, 2),...
            size(convex, 1), size(convex, 2));
    end
    [convexLabeled, n] = bwlabel(convex, 8);
    % if we got more than one object, select the most central
    if n>1
        C = regionprops(convexLabeled, 'Centroid');
        delta = bsxfun(@minus, fliplr(size(bw)/2), cell2mat({C(:).Centroid}'));
        d2 = sum(delta.^2, 2);
        [~, iL] = min(d2);
        convexLabeled = convexLabeled==iL;
    end
    
    edgeConvexLabeled = edge(convexLabeled);
    % only take the edge points that are close to original edges
    edgeRes = ebw & imdilate(edgeConvexLabeled, ones(3));
    [yy, xx] = ind2sub(size(bw), find(edgeRes));
    nPoints = length(yy);
    
    if nPoints >= 5
        
        % now let's fit the ellipse
        % we are basically solving an equation for the quadratic curve in 2-D
        % of the form: Ax^2+Bxy+Cy^2+Dx+Ey=1
        X = [xx.^2, xx.*yy, yy.^2, xx, yy];
        params = pinv(X)*ones(nPoints, 1);
        
        % now iteratively remove some of the edge points which fall inside the ellipse, but
        % leave at least  minNPoints points
        minNPoints = 10;
        minPrctile = min(minNPoints/nPoints*100, 100);
        err = (X*params-1);%.^2;
        idx = err<prctile(err, max(80, minPrctile));
        nPoints = sum(idx);
        params = pinv(X(idx, :))*ones(nPoints, 1);
        
        err = (X*params-1);%.^2;
        idx = err<prctile(err, max(60, minPrctile));
        nPoints = sum(idx);
        params = pinv(X(idx, :))*ones(nPoints, 1);
        
        err = (X*params-1);%.^2;
        idx = err<prctile(err, max(40, minPrctile));
        nPoints = sum(idx);
        params = pinv(X(idx, :))*ones(nPoints, 1);
        
        ell = abc2ellipse(params);
        
    else
        % in case there were no contours detected at all (might happen during a
        % blink, for example) assign nans where applicable
        ell = abc2ellipse(NaN(5, 1));
    end
    
    resTmp(iFrame) = ell;
    edgeTmp(iFrame).xxEdge = xx;
    edgeTmp(iFrame).yyEdge = yy;

end %parfor

% rearranging the output
res = struct();
res.pars = cell2mat({resTmp(:).pars});
res.x0 = [resTmp(:).x0]';
res.y0 = [resTmp(:).y0]';
res.area = [resTmp(:).area]';
res.a = [resTmp(:).a]';
res.b = [resTmp(:).b]';
res.theta = [resTmp(:).theta]';
res.isEllipse = [resTmp(:).isEllipse]';
res.eq = {resTmp(:).eq}';
res.xxEdge = {edgeTmp(:).xxEdge}';
res.yyEdge = {edgeTmp(:).yyEdge}';
res.xxEllipse = {resTmp(:).xxEllipse}';
res.yyEllipse = {resTmp(:).yyEllipse}';
