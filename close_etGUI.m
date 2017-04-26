function close_etGUI(src, callbackdata)

h = guidata(src);
% delete the plot figure from the memory
if isfield(h, 'plotHandles')
    delete(h.plotHandles.figure)
end
% delete the etGUI
delete(src)
