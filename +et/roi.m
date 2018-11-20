function roi

global eyeVid

stoppreview(eyeVid);
eyeVid.ROIPosition = [0 0 eyeVid.VideoResolution];
hPreview = preview(eyeVid);
h = imrect(get(hPreview, 'Parent'));
pos = wait(h); % double click on rect to accept
stoppreview(eyeVid)
eyeVid.ROIPosition = pos;
set(h,'visible','off');
preview(eyeVid);
