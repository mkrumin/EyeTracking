function resetROI

global eyeVid

stoppreview(eyeVid);
eyeVid.ROIPosition = [0 0 eyeVid.VideoResolution];
preview(eyeVid);
