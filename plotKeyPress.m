function plotKeyPress(src, event)

if isequal(event.Modifier, {'control'}) && isequal(event.Key, 'b')
    h = src.UserData;
    % toggle the hideBlinks flag
    hideBlinks = getappdata(src, 'hideBlinks');
    setappdata(src, 'hideBlinks', ~hideBlinks);
    % replot the figure
    plotTraces([], [], h);
end

if isequal(event.Modifier, {'control'}) && isequal(event.Key, 'e')
    h = src.UserData;
    % edit the polygon - click the 'Blink Classifier' button
    etGUI('BlinkClassifierPush_Callback', h.BlinkClassifierPush, [], h);
end

if isequal(event.Key, 'leftarrow')
        handles = get(src, 'UserData');
        iFrame = max(1, handles.iFrame-1);
        set(handles.FrameSlider, 'Value', iFrame);
        etGUI('FrameSlider_Callback', handles.FrameSlider, [], guidata(handles.figure1));
        etGUI('PlotPush_Callback', handles.PlotPush, [], guidata(handles.figure1));

end
if isequal(event.Key, 'rightarrow')
        handles = get(src, 'UserData');
        iFrame = min(handles.FrameSlider.Max, handles.iFrame+1);
        set(handles.FrameSlider, 'Value', iFrame);
        etGUI('FrameSlider_Callback', handles.FrameSlider, [], guidata(handles.figure1));
        etGUI('PlotPush_Callback', handles.PlotPush, [], guidata(handles.figure1));
end