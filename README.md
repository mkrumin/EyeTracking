# EyeTracking
Eye-tracking related tools  

# How to get started
Run etGUI.m  
Read tooltips  
Play around  

# Layout

![capture](https://cloud.githubusercontent.com/assets/15018753/26278867/819797a0-3d9c-11e7-87c9-339923c0d83c.PNG)

# Typical workflow
- `File --> Open...` to open a video file. It will take a few seconds (as the code gathers some statistics).  
- Hit `Preview` button, and while the video is playng adjust the parameters until you are happy. The main parameter to adjust is the `Threshold` value, then the `ROI`. You can also set the `Blink ROI` - the portion of the image that will be used to detect blinks and the value of the blink detection threshold (less crucial, as can be changed post-hoc). Adjusting `Max` and `min` values only affects the visualisation, not the analysis.
- Navigate through the movie using the two sliders underneath the image, or using a `Goto Frame #` box.  
- Enter something like `1:100:end`(depending on the length of the video) into the `Frame Range` (don't forget to press return) box and hit `Run` to quickly analyze a small portion of the data.
- Use `Replay` and `Plot Results` functionality to verify that the current parameters work well for the data. Adjust if necessary.  
- If this is the only video of the session (with the same FOV of the camera) enter `1:end` as the `Frame Range` (if you want to analyze all the frames), tick `Reanalyze and overwrite?` to make sure you overwrite all the previous analysis, which might have been done with wrong parameters, and hit `Run`. After the analysis is finished you can again inspect the results using `Replay` and `Plot Results`, readjust the parameters, and re-run the analysis either on the whole dataset, or on a subset of frames by defining an appropriate `Frame Range` and ticking `Reanalyze and overwrite?`. Once you are happy with the traces, go to `File --> Save Results As..` and save the results in the location of your choice.
- If you have multiple videos with the same FOV, you can run analysis on these files in batch **(parameters currently set in the etGUI will be applied to all the files)**. Go to `File --> Run Batch ...`, this will open a new window where you will be able to create a list of files to analyze, and hit `Start`. All the files will be analyzed and the results saved. Note that the results will be saved in the same folder as each video file with `_processed` appended to the file name (and the extension changed from `.mj2` to `.mat`). You need to make sure you do not overwrite your valuable previous results, no warnings will be shown in the batch mode.

# Algorithm
**Pupil detection**  
The frame is cropped to the current ROI, filtered with the Gaussian filter and thresholded. An ellipse is fit to the edge of the detected 'hole' by solving `Ax^2+Bxy+Cy^2+Dx+Ey=1`. 'Concave' parts of the edge are not taken into account, making the fit robust against a typical *LED overlap* problem. Ellipse center, radii, rotation angle, and area are calculated from the estimated parameters A,B,C,D, and E. Currently, when more than a single 'hole' is detected within the ROI, the most central one is chosen as a pupil, which makes the selection of ROI critical for some datasets. Implementation of a smarter way to select the correct pupil candidate is *in the plans*.  
**Blink detection**  
The frame is cropped to the current `Blink ROI`. Correlation coefficient between the cropped frame and the corresponding crop of the average frame is calculated as well as the mean intensity of the crop. These two values are used to detect blinks. The classifier (a polygon) is shown in the results figure (`Plot Results` button). Although an initial guess is provided, the classifier should be adjusted manually for better results. In addition, classification of individual frames can be manually overridden.  
'Hard blinks' are those detected as blinks and are marked red in the results figure. 'Soft blinks' are frames within 100 ms from detected 'hard blinks' and are marked green. These two classes are separate in the final results structure, which allows the user to include/exclude these frames from further analysis independently.    

# Controls
**Main GUI**  
`Ctrl+S` - analyze current frame with current settings and overwrite the results  
Right-click the `Plot Results` button to reset the results figure  
**Results Figure**  
`Ctrl+Click` - Go to the frame  
`Ctrl+B` - Show/hide frames detected as blinks  
`B` - toggle blink status of the current frame - override the polygon classifier  
`R` - reset blink status of the current frame to match the polygon classifier  
`Ctrl+R` - reset blink status of all the frames  
`Ctrl+E` - edit the classification polygon  
`<--`, `-->` - navigate frame-by-frame  

# Reference Guide
- File-->Open ...
- File-->Save Results As ...
- File-->Load Project ...
- File-->Run Batch ...
- Preview
- Replay
- Run
- Plot Results
