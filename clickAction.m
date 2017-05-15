function clickAction(src, callbackdata)

type = get(src, 'SelectionType');
handles = get(src, 'UserData');

switch type
    case 'alt'
%         disp('Ouch! I was Control-clicked');
        cp = get(gca, 'CurrentPoint');
        tag = get(gca, 'Tag');
        if isequal(tag, 'blinks')
            m = cp(1,1)/255;
            r = cp(1,2);
            d = (handles.results.blinkRho - r).^2 +... 
                (handles.results.blinkMean/255 - m).^2;
            [~, iFrame] = min(d);
        else
            x = cp(1);
            nAvailableFrames = handles.vr.NumberOfFrames;
            iFrame = min(max(1, round(x)), nAvailableFrames);
        end
        set(handles.FrameSlider, 'Value', iFrame);
        etGUI('FrameSlider_Callback', handles.FrameSlider, [], guidata(handles.figure1));
        etGUI('PlotPush_Callback', handles.PlotPush, [], guidata(handles.figure1));
        % handles.figure1 is a handle of the main etGUI figure
    otherwise
%         disp('I was clicked')
end

