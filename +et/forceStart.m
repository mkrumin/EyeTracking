function forceStart(animalName)

if nargin < 1
    error('Please provide animal name to force start acquisition');
end
pars = et.config;

[~, hostName] = system('hostname');
hostName = hostName(1:end-1);
fU = udp(hostName, pars.general.localUDPPort);
% fU.LocalPort = 1103;
msg = sprintf('ExpStart %s %s %s', animalName, ...
    datestr(now, 'yyyymmdd'), datestr(now, 'HHMMSS'));

fopen(fU);
fwrite(fU, msg);
fclose(fU);
delete(fU);
clear fU;