% before installing the adaptor
imaqhwinfo

% if the tisimaq... is not in the list then register it
% usually the dll sits  here:
imaqregister('C:\Program Files (x86)\TIS IMAQ for MATLAB R2013b\x64\TISImaq_R2013.dll');
% you can also read the ImagingSourceReadme.txt

% now you need to restart Matlab

% after restarting you will see 'tisimaq_r2013' as one of the
% InstalledAdaptors.

imaqhwinfo

% alternatively you can use
% imaqtool
% to register by browsing to the dll above