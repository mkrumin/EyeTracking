function  restart

global eyeVid

currentROI = eyeVid.ROIPosition
et.close;
% pause(3);
et.listen;
% now eyeVid should point to the new videoinput object
stoppreview(eyeVid); % et.listen started preview, we need to stop it to adjust ROI
eyeVid.ROIPosition = currentROI;
preview(eyeVid);





