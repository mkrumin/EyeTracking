function h = assignTooltips(h)

h.ReplaySlider.TooltipString = 'Navigate through analyzed frames';
h.BlinkRhoEdit.TooltipString = 'Current blink rho threshold (<=1)';
h.BlinkROIPush.TooltipString = 'Assign/change ROI used for blink detection';
h.ReplayToggle.TooltipString = 'Start/Stop replay of analyzed frames';
h.ThresholdText.TooltipString = 'Current threshold value';
h.FineFrameSlider.TooltipString = 'Navigate (with preview) through the movie frame-by-frame';
h.FilenameText.TooltipString = 'Current video file name';
h.ROIPush.TooltipString = 'Assign/change ROI for pupil detection';
h.GotoEdit.TooltipString = 'Enter a number and press Return';
h.PlotPush.TooltipString = sprintf('Plot traces (opens in a separate figure)\nRight-click to reset the figure');
h.PreviewToggle.TooltipString = 'Preview the analysis with current setting';
h.FilterSizeEdit.TooltipString = 'Std of the 2-D Gaussian filter';
h.ThresholdSlider.TooltipString = 'Adjust the threshold value used for pupil edge detection';
h.MinSlider.TooltipString = '[Graphics only] adjust the minimum of the colormap';
h.MaxSlider.TooltipString = '[Graphics only] adjust the maximum of the colormap';
h.FrameText.TooltipString = 'Current frame #';
h.AutoPush.TooltipString = 'Auto adjust the parameters (threshold, ROIs)';
h.FrameSlider.TooltipString = 'Current position in the movie';
h.AnalysisStatusText.TooltipString = 'Current status of the analysis';
h.OverwriteCheck.TooltipString = 'Do you want to overwrite results of already analyzed frames?';
h.RangeEdit.TooltipString = 'Which frames to analyze? Use MATLAB vector notation or ''frameRange'' global variable in your workspace';
h.RunToggle.TooltipString = 'Run/stop the analysis (no graphics)';
h.BlinksOnlyCheck.TooltipString = sprintf('Only analyze blinks and keep the pupil data intact\nRemember to UNtick before doing batch processing');
h.BlinkCheck.TooltipString = 'Show blinks during Preview/Replay';
h.CropCheck.TooltipString = 'Show only ROI portion of the image';
h.ROICheck.TooltipString = 'Show ROIs';
h.EllipseCheck.TooltipString = 'Show ellipse fit';
h.EdgeCheck.TooltipString = 'Show edge used for the ellipse fit';
h.CenterCheck.TooltipString = 'Show the center of the ellipse';
h.BWRadio.TooltipString = 'Show thresholded image used for analysis';
h.FilteredRadio.TooltipString = 'Show image filtered with 2-D Gaussian';
h.OriginalRadio.TooltipString = 'Show original image';