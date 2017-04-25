function state = getCurrentState(h)

state.CurrentFolder = h.CurrentFolder;
state.FileName = h.FileName;
state.roi = h.roi;
state.blinkRoi = h.blinkRoi;
state.blinkThreshold = h.BlinkRhoEdit.Value;
state.Threshold = h.ThresholdSlider.Value;
state.FilterSize = h.FilterSizeEdit.Value;
state.analyzedFrames = h.analyzedFrames;
