# EyeTracking
Eye-tracking related tools

# How to get started
Run etGUI.m  
Read tooltips  
Play around  

# Typical workflow
- `File --> Open...` to open a video file. It will take a few seconds (as the code gathers some statistics).  
- Hit `Preview` button, and while the video is playng adjust the parameters until you are happy. The main parameter to adjust is the `Threshold` value, then the `ROI`. You can also set the `Blink ROI` - the portion of the image that will be used to detect blinks and he value of the blink detection threshold (less crucial, as can be changed post-hoc). Adjusting `Max` and `min` values only affects the visualisation, not the analysis.
- Navigate through the movie  using the two sliders underneath the image, or using a `Goto Frame #` box.  
- Put something like `1:100:end`(depending on the length of the video) into the `Frame Range` box and hit `Run` to quickly analyze a small portion of the data.
- Use `Replay` and `Plot Results` functionality to verify that the current parameters work well for the data. Adjust if necessary.  
- If this is the only video of the session (with the same FOV of the camera) put `1:end` as the `Frame Range` (if you want to analyze all the frames), check `Overwrite results?` to make sure you overwrite all the previous analysis, which might have been done with wrong parameters, and hit `Run`. After the analysis is finished go to `File --> Save Results As..` and save the results in the location of your choice.
- If you have multiple videos with the same FOV, you can run analysis on these files in batch **(parameters currently set in the etGUI will be applied to all the files)**. Go to `File --> Run Batch ...`, this will open a new window where you will be able to create a list of files to analyze, and hit `Start`. All the files will be analyzed and the results saved. Note where the results files are saved (see the log window) - the location might depend on what you have done in the main etGUI previously. By default, the results will be saved in the same folder as each video file with `_processed` appended to the file name. However, if you have manually saved some of the results during the same session in etGUI (through `File --> Save Results As...`), all the results will be saved to the same folder (treating it as your preferred folder to save result files).
