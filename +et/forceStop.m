function forceStop()

global eyeLog

pars = et.config;

[~, hostName] = system('hostname');
hostName = hostName(1:end-1);
fU = udp(hostName, pars.general.localUDPPort);


[aName, series, expNum] = dat.expRefToMpep(eyeLog.ExpRef);
msg = sprintf('ExpEnd %s %d %d', aName, series, expNum);

fopen(fU);
fwrite(fU, msg);
fclose(fU);
delete(fU);
clear fU;