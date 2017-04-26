function clickAction(src, callbackdata)

type = get(src, 'SelectionType');
handles = get(src, 'UserData');

switch type
    case 'alt'
%         disp('Ouch! I was Control-clicked');
        cp = get(gca, 'CurrentPoint');
        x = cp(1);
        nAvailableFrames = handles.vr.NumberOfFrames;
        iFrame = min(max(1, round(x)), nAvailableFrames);
        set(handles.FrameSlider, 'Value', iFrame);
        etGUI('FrameSlider_Callback', handles.FrameSlider, [], guidata(handles.figure1));
        % handles.figure1 is a handle of the main etGUI figure
    otherwise
%         disp('I was clicked')
end

