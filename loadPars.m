function pars = loadPars()

p = dat.paths;
pars.initFolder = fullfile(p.mainRepository, 'PC041');
pars.localTempFileName = 'R:\Temp\tmp'; % it is safer to first copy the file locally, and then open it
% it is also faster if the local copy is on fast SSD, or even on virtual RAM drive
pars.batchSize = 2048;
% Because the videos are compressed it takes a lot of CPU power to load the
% frames, and it becomes a bottleneck. This can be improved if loading
% frames on independent cores, but must not be used on HDDs or when reading
% directly from the server
pars.useMulticoreForReading = true; % only use with local temp copy, and only on SSD/RAM
pars.framesPerCore2Read = 64; % used if useMulticoreForReading == true