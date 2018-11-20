function close()

global eyeVid
global eyeUDP
global eyeLog
global eyePP
global expStarted udpLogfileID folders fileStems

expStarted = false;
udpLogfileID = [];
folders  = [];
fileStems = [];

if isequal(eyeVid.Running, 'on')
    stop(eyeVid);
    wait(eyeVid, 1);
    close(eyeVid.DiskLogger);
end

delete(eyeVid)
clear eyeVid;

if isequal(eyeUDP.Status, 'open')
    fclose(eyeUDP);
end

delete(eyeUDP);
clear eyeUDP

eyePP = [];
eyeLog = [];

clear eyePP
clear eyeLog

% clear the persistent variables to prevent data overwrite
% et.eyeUDPCallback('clear');
et.grabFrames('clear');


