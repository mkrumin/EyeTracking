function plotKeyPress(src, event)

if isequal(event.Modifier, {'control'}) && isequal(event.Key, 'b')
    h = src.UserData;
    % toggle the hideBlinks flag
    hideBlinks = getappdata(src, 'hideBlinks');
    setappdata(src, 'hideBlinks', ~hideBlinks);
    % replot the figure
    plotTraces([], [], h);
end
