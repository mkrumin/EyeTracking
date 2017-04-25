function h = fileSaveAs(hObject, eventdata, h)

results = h.results;
state = getCurrentState(h);
if isfield(h, 'CurrentResultsFileName')
    filename = fullfile(h.CurrentFolder, h.CurrentResultsFileName);
else
    [~, fn, ~] = fileparts(h.FileName);
    filename = fullfile(h.CurrentFolder, [fn, '_processed.mat']);
end
% uisave({'results', 'state'}, filename);

[FileName,PathName,~] = uiputfile('*.mat', 'Save File As...', filename);

if FileName == 0
    warning('File was not saved - provide a valid filename');
else
    save(fullfile(PathName, FileName), 'results', 'state');
    h.CurrentResultsFolder = PathName;
    h.CurrentResultsFileName = FileName;
end