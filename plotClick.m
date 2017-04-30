function plotClick(src, ~)

h = src.Parent;
if isequal(h.SelectionType, 'alt')
    % if the button was right-clicked delete the figure and its handles
    % this will cause the plots to start afresh
    handles = guidata(h);
    if isfield(handles, 'plotHandles')
        delete(handles.plotHandles.figure);
        handles = rmfield(handles, 'plotHandles');
        guidata(h, handles);
        etGUI('PlotPush_Callback', src, [], handles);
    end
end
