function pars = loadPars()

p = dat.paths;
pars.initFolder = fullfile(p.mainRepository, 'PC041');
pars.localTempFileName = 'R:\Temp\tmp';
pars.batchSize = 2000;