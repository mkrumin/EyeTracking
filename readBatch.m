function frames = readBatch(vr, indices)

indices = sort(indices); %just in case
nFrames = length(indices);
% frames = zeros(vr.Height, vr.Width, nFrames, 'uint8');
% find blocks of consecutive frames

pars = loadPars;

% Because the videos are compressed it takes a lot of CPU power to load the
% frames, and it becomes a bottleneck. This can be improved if loading
% frames on independent cores, but must not be used on HDDs or when reading
% directly from the server
useMulticore = pars.useMulticoreForReading;

if useMulticore
    partSize = pars.framesPerCore2Read;
    nParts = ceil(nFrames/partSize);
    startInd = round(linspace(1, nFrames+1, nParts+1));
    for iPart = 1:nParts
        ind2read{iPart} = indices(startInd(iPart):(startInd(iPart+1)-1));
    end
    parfor iPart = 1:nParts
        tmp{iPart} = ...
            readFrames(vr, ind2read{iPart});
    end
    frames = cell2mat(reshape(tmp, 1, 1, nParts));
else
    frames = readFrames(vr, indices);
end

end

function data = readFrames(vr, idx)
    
    data = zeros(vr.Height, vr.Width, length(idx), 'uint8');

    % delta will be constant for consecutive frames, and will jump otherwise
    delta = idx(:) - [1:length(idx)]';
    blockIDs = unique(delta);
    nBlocks = length(blockIDs);
    
    for iBlock = 1:nBlocks
        frameIdx = find(delta==blockIDs(iBlock));
        tmp = read(vr, [idx(frameIdx(1)), idx(frameIdx(end))]);
        data(:,:,frameIdx) = squeeze(tmp);
    end

end
