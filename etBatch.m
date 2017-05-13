function varargout = etBatch(varargin)

% This is a supplementary GUI for etGUI
% October 2014 - written by Michael Krumin

% ETBATCH MATLAB code for etBatch.fig
%      ETBATCH, by itself, creates a new ETBATCH or raises the existing
%      singleton*.
%
%      H = ETBATCH returns the handle to a new ETBATCH or the handle to
%      the existing singleton*.
%
%      ETBATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ETBATCH.M with the given input arguments.
%
%      ETBATCH('Property','Value',...) creates a new ETBATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before etBatch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to etBatch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help etBatch

% Last Modified by GUIDE v2.5 26-Apr-2017 19:22:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @etBatch_OpeningFcn, ...
    'gui_OutputFcn',  @etBatch_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before etBatch is made visible.
function etBatch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to etBatch (see VARARGIN)

% Choose default command line output for etBatch
handles.output = hObject;

% this is the structure with the eye-tracking and blink-detection
% parameters, such as filters, thresholds, ROIs etc.

handles.etGUI = varargin{1};
handles.state = 'idle';

disableAll(handles.etGUI);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes etBatch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = etBatch_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in filesListbox.
function filesListbox_Callback(hObject, eventdata, handles)
% hObject    handle to filesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filesListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filesListbox


% --- Executes during object creation, after setting all properties.
function filesListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filesListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% the following will allow multiple item selection (Max-Min>1)
set(hObject, 'Min', 0, 'Max', 2);

% --- Executes on button press in addfilesPushbutton.
function addfilesPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addfilesPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hh = guidata(handles.etGUI);

[FileName, PathName] = uigetfile({'*.mj2;*.mp4', 'Our cool et video files'}, 'Select video Files to analyse', hh.CurrentFolder, 'MultiSelect', 'on');
if iscell(FileName)
    for iFile = 1:length(FileName)
        fileList{iFile} = fullfile(PathName, FileName{iFile});
    end
elseif ~isequal(FileName, 0)
    fileList{1} = fullfile(PathName, FileName);
else
    % add nothing to the list
    return;
end

addFiles(hObject, fileList, handles)

% --- Executes on button press in addfolderPushbutton.
function addfolderPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addfolderPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hh = guidata(handles.etGUI);
folder_name = uigetdir(hh.CurrentFolder);

if isequal(folder_name, 0)
    % the user cancelled folder selection
    return;
end

files = subdir(fullfile(folder_name, '*.mj2'));
files = cat(1, files, subdir(fullfile(folder_name, '*.mp4')));
if ~isempty(files)
    addFiles(hObject, {files.name}, handles);
end

% --- Executes on button press in removePushbutton.
function removePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to removePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(handles.filesListbox, 'Value');

if isequal(val, 0)
    % the list is empty
    return;
end;

currentList = get(handles.filesListbox, 'String');
updatedList = setdiff(currentList, currentList(val), 'stable');

% Let's not let the GUI to crash when we delete the last file in the list
val = val(end); % if several items were selected
if val>length(updatedList)
    val = length(updatedList);
end
set(handles.filesListbox, 'Value', val);
set(handles.filesListbox, 'String', updatedList);

nFilesDiff = length(currentList) - length(updatedList);
if nFilesDiff ~= 0
    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {sprintf('%s   Removed %d file(s)', datestr(clock, '[HH:MM:SS]'), nFilesDiff)}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
end


% --- Executes on button press in startTogglebutton.
function startTogglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to startTogglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startTogglebutton

if ~get(hObject, 'Value')
    set(hObject, 'String', 'Start');
    if ~isequal(handles.state, 'idle')
        set(hObject, 'String', 'Stopping...');
        set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
            {[datestr(clock, '[HH:MM:SS]'), '   Abort requested...']}))
        if isequal(handles.state, 'pupilTracking')
            set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
                {'                   Be patient, will stop in a moment...'}))
            handles.state = 'interrupting';
            guidata(hObject, handles);
        end
        set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
        
%         set(hObject, 'TooltipString', 'Be patient, will stop after the current analysis step is complete');
        set(hObject, 'Enable', 'inactive');
        hh = guidata(handles.etGUI);
        hh.RunToggle.Value = 0;
        etGUI('RunToggle_Callback', hh.RunToggle, [], hh);
    else
        set(hObject, 'Enable', 'on');
        set(hObject, 'TooltipString', 'Are you sure?');
        set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
            {sprintf('%s   Stopped batch processing', datestr(clock, '[HH:MM:SS]'))}))
        set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
    end
    return;
end

set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), ...
    {sprintf('%s   Started batch processing...', datestr(clock, '[HH:MM:SS]'))}))
set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));

handles.state = 'pupilTracking';
guidata(hObject, handles);

set(hObject, 'String', 'Stop');
set(hObject, 'TooltipString', 'Be patient after clicking, will stop in a moment...');

set(handles.addfilesPushbutton, 'Enable', 'off');
set(handles.addfolderPushbutton, 'Enable', 'off');
set(handles.removePushbutton, 'Enable', 'off');
set(handles.sortPushbutton, 'Enable', 'off');

fileList = get(handles.filesListbox, 'String');
hh = guidata(handles.etGUI);
currentState = getCurrentState(hh);
for iFile = 1:length(fileList)
    if ~get(hObject, 'Value')
        set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
            {[datestr(clock, '[HH:MM:SS]'), '   Interrupted by user ...']}))
        set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
        set(hObject, 'String', 'Start');
        set(hObject, 'Enable', 'on');
        set(hObject, 'TooltipString', 'Are you sure?');
        break;
    end
    [~, filename, ext] = fileparts(fileList{iFile});
    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
        {[datestr(clock, '[HH:MM:SS]'), '   Opening  ', filename, ext, '...']}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
    hh = openfile(hh.fileOpen, [], guidata(handles.etGUI), fileList{iFile});
    currentState.analyzedFrames = hh.analyzedFrames; % this should be false for all the frames now
    currentState.CurrentFolder = hh.CurrentFolder;
    currentState.FileName = hh.FileName;
    hh = applyState(hh, currentState);
    updateFigure(hh.fileOpen, [], hh);
    guidata(hh.fileOpen, hh);
%     disableAll(handles.etGUI);
%     set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
%         {[datestr(clock, '[HH:MM:SS]'), '   Blink detection...']}))
%     set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
%     set(hh.blinkTogglebutton, 'Value', 1);
%     etGUI('blinkTogglebutton_Callback', hh.blinkTogglebutton, [], guidata(handles.etGUI));
%     disableAll(handles.etGUI);
%     if ~get(hObject, 'Value')
%         set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {[datestr(clock, '[HH:MM:SS]'), '   Interrupted by user ...']}))
%         set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
%         set(hObject, 'String', 'Start');
%         set(hObject, 'Enable', 'on');
%         set(hObject, 'TooltipString', 'Are you sure?');
%         break;
%     end
%     guidata(hObject, handles);

    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
        {[datestr(clock, '[HH:MM:SS]'), '   Tracking the pupil ...']}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
    hh.RangeEdit.Value = [1:hh.vr.NumberOfFrames];
    hh.OverwriteCheck.Value = true;
    set(hh.RunToggle, 'Value', 1);
    etGUI('RunToggle_Callback', hh.RunToggle, [], guidata(handles.etGUI));
    handles = guidata(hObject);
    if ~isequal(handles.state, 'interrupting')
        % do not save results if iterrupted
        set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
            {[datestr(clock, '[HH:MM:SS]'), '   Saving results ...']}))
        set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
        drawnow;
        etGUI('fileSave_Callback', hh.fileSave, [], guidata(handles.etGUI));
        hh = guidata(handles.etGUI);
        set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'),...
            {[datestr(clock, '[HH:MM:SS]'), sprintf('   Saved to %s', hh.lastFileSaved)]}));
        set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
    end
end

set(handles.addfilesPushbutton, 'Enable', 'on');
set(handles.addfolderPushbutton, 'Enable', 'on');
set(handles.removePushbutton, 'Enable', 'on');
set(handles.sortPushbutton, 'Enable', 'on');

set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {sprintf('%s   Stopped batch processing', datestr(clock, '[HH:MM:SS]'))}))
set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));

set(hObject, 'String', 'Start');
set(hObject, 'Enable', 'on');
set(hObject, 'Value', 0);
set(hObject, 'TooltipString', 'Are you sure?');

handles.state = 'idle';
guidata(hObject, handles);



% --- Executes on selection change in logListbox.
function logListbox_Callback(hObject, eventdata, handles)
% hObject    handle to logListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns logListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from logListbox


% --- Executes during object creation, after setting all properties.
function logListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function addFiles(hObject, fileList, handles)

currentList = get(handles.filesListbox, 'String');
if ~iscell(currentList)
    currentList = cell(currentList);
end

% if ~isequal(currentList{1}, '')
updatedList = union(currentList, fileList, 'stable');
% else
%     updatedList = fileList;
% end

set(handles.filesListbox, 'String', updatedList);

val = get(handles.filesListbox, 'Value');
if isequal(val, 0) && ~isempty(updatedList)
    set(handles.filesListbox, 'Value', 1);
end

nFilesDiff = length(updatedList) - length(currentList);
if nFilesDiff == 0
    % this might happen if all the files to add were already in the list
    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {sprintf('%s   No files were added', datestr(clock, '[HH:MM:SS]'), nFilesDiff)}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
else
    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {sprintf('%s   Added %d file(s)', datestr(clock, '[HH:MM:SS]'), nFilesDiff)}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
end




% --- Executes on button press in sortPushbutton.
function sortPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to sortPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentList = get(handles.filesListbox, 'String');
updatedList = union(currentList, currentList, 'sorted');
set(handles.filesListbox, 'String', updatedList);

if ~isequal(currentList, updatedList)
    set(handles.logListbox, 'String', cat(1, get(handles.logListbox, 'String'), {sprintf('%s   File list sorted', datestr(clock, '[HH:MM:SS]'))}))
    set(handles.logListbox, 'Value', length(get(handles.logListbox, 'String')));
end



% --- Executes when user attempts to close figure1.
function etBatch_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% handles.etGUI = varargin{1};

try
    enableAll(handles.etGUI);
catch
    % the other gui is probably already closed
end

delete(hObject);