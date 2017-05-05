# EyeTracking
Eye-tracking related tools  

# How to get started
Run etGUI.m  
Read tooltips  
Play around  

# Layout

![etgui_capture](https://cloud.githubusercontent.com/assets/15018753/25728222/811dd0f6-3125-11e7-9350-0ec865a57587.PNG)

# Typical workflow
- `File --> Open...` to open a video file. It will take a few seconds (as the code gathers some statistics).  
- Hit `Preview` button, and while the video is playng adjust the parameters until you are happy. The main parameter to adjust is the `Threshold` value, then the `ROI`. You can also set the `Blink ROI` - the portion of the image that will be used to detect blinks and the value of the blink detection threshold (less crucial, as can be changed post-hoc). Adjusting `Max` and `min` values only affects the visualisation, not the analysis.
- Navigate through the movie using the two sliders underneath the image, or using a `Goto Frame #` box.  
- Enter something like `1:100:end`(depending on the length of the video) into the `Frame Range` (don't forget to press return) box and hit `Run` to quickly analyze a small portion of the data.
- Use `Replay` and `Plot Results` functionality to verify that the current parameters work well for the data. Adjust if necessary.  
- If this is the only video of the session (with the same FOV of the camera) enter `1:end` as the `Frame Range` (if you want to analyze all the frames), tick `Reanalyze and overwrite?` to make sure you overwrite all the previous analysis, which might have been done with wrong parameters, and hit `Run`. After the analysis is finished go to `File --> Save Results As..` and save the results in the location of your choice.
- If you have multiple videos with the same FOV, you can run analysis on these files in batch **(parameters currently set in the etGUI will be applied to all the files)**. Go to `File --> Run Batch ...`, this will open a new window where you will be able to create a list of files to analyze, and hit `Start`. All the files will be analyzed and the results saved. Note that the results will be saved in the same folder as each video file with `_processed` appended to the file name (and the extension changed from `.mj2` to `.mat`). You need to make sure you do not overwrite your valuable previous results, no warnings will be shown in the batch mode.

# Algorithm
**Pupil detection**  
The frame is cropped to the current ROI, filtered with the Gaussian filter and thresholded. An ellipse is fit to the edge of the detected 'hole' by solving `Ax^2+Bxy+Cy^2+Dx+Ey=1`. 'Concave' parts of the edge are not taken into account, making the fit robust against a typical *LED overlap* problem. Ellipse center, radii, rotation angle, and area are calculated from the estimated parameters A,B,C,D, and E. Currently, when more than a single 'hole' is detected within the ROI, the most central one is chosen as a pupil, which makes the selection of ROI critical for some datasets. Implementation of a smarter way to select the correct pupil candidate is *in the plans*.  
**Blink detection**  
The frame is cropped to the current `Blink ROI`. Correlation coefficient between the cropped frame and the corresponding crop of the average frame is calculated and thresholded, with lower values of the correlation coeffcient being indicative of blinks. It is usually a good idea to exclude the LED reflection and the pupil from the `Blink ROI`. Although an initial guess is provided, the threshold should be adjusted manually for better results.

# Reference Guide
- File-->Open ...
- File-->Save Results As ...
- File-->Load Project ...
- File-->Run Batch ...
- Preview
- Replay
- Run
- Plot Results
