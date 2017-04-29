function frames = readBatch(vr, idx)

idx = sort(idx); %just in case
frames = NaN(vr.Height, vr.Width, length(idx));
% find blocks of consecutive frames

% delta will be constant for consecutive frames, and will jump otherwise
delta = idx(:) - [1:length(idx)]';
blockIDs = unique(delta);
nBlocks = length(blockIDs);

for iBlock = 1:nBlocks
    frameIdx = find(delta==blockIDs(iBlock));
    tmp = read(vr, [idx(frameIdx(1)), idx(frameIdx(end))]);
    frames(:,:,frameIdx) = squeeze(tmp);
end
