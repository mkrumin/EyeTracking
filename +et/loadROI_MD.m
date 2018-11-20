function  loadROI

global eyeVid

[fn, ff] = uigetfile('C:\LocalExpData');
data = load(fullfile(ff, fn));

eyeVid

stoppreview(eyeVid); % et.listen started preview, we need to stop it to adjust ROI
eyeVid.ROIPosition = data.eyeLog.videoinputInfo.ROIPosition;
preview(eyeVid);





