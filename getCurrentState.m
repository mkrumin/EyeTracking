function state = getCurrentState(h)

state.CurrentFolder = h.CurrentFolder;
state.FileName = h.FileName;
state.iFrame = h.iFrame;
state.roi = h.roi;
state.blinkRoi = h.blinkRoi;
state.blinkClassifier = h.blinkClassifier;
state.Threshold = h.ThresholdSlider.Value;
state.FilterSize = h.FilterSizeEdit.Value;
state.cMax = h.MaxSlider.Value;
state.cMin = h.MinSlider.Value;
state.showOriginal =
state.showFiltered =
state.showBW = 
state.showCenter
state.showEdge = 
state.showEllipse = 
state.showROI = 
state.showCropped = 

state.analyzedFrames = h.analyzedFrames;
