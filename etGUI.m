function varargout = etGUI(varargin)
% ETGUI MATLAB code for etGUI.fig
%      ETGUI, by itself, creates a new ETGUI or raises the existing
%      singleton*.
%
%      H = ETGUI returns the handle to a new ETGUI or the handle to
%      the existing singleton*.
%
%      ETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ETGUI.M with the given input arguments.
%
%      ETGUI('Property','Value',...) creates a new ETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before etGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to etGUI_OpeningFcn via varargin.
%
%      *See GUI editPreferences on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help etGUI

% Last Modified by GUIDE v2.5 02-May-2017 13:51:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @etGUI_OpeningFcn, ...
    'gui_OutputFcn',  @etGUI_OutputFcn, ...
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


% --- Executes just before etGUI is made visible.
function etGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to etGUI (see VARARGIN)

% let's turn off these useless and annoying warnings off
warning('off', 'MATLAB:nargchk:deprecated')
set(hObject, 'CloseRequestFcn', @close_etGUI);
set(hObject, 'WindowKeyPressFcn', @processKeyPress);
hObject.Resize = 'on';

handles.Axes.Visible = 'off';
handles.OriginalRadio.Value = 1;
handles.FilterSizeEdit.Value = 2;
handles.FilterSizeEdit.String = '2';
handles.PlotPush.Enable = 'on';
handles.AutoPush.Enable = 'off';
handles.CenterCheck.Value = false;
handles.EdgeCheck.Value = false;
handles.EllipseCheck.Value = true;
handles.BlinkCheck.Value = true;
handles.ROICheck.Value = false;
handles.CropCheck.Value = false;
handles.fileSave.Enable = 'off';
handles.editPreferences.Enable = 'off';
handles.FilenameText.Position = handles.FilenameText.Position +...
    [-25 0 50 1];
handles.OverwriteCheck.String = 'Reanalyze and overwrite?';
handles = assignTooltips(handles);

pos = handles.PreviewToggle.Position;
tt = uicontrol(hObject, 'Style', 'Text');
tt.Units = 'characters';
tt.Position = pos + [-30 -2 10 1];
tt.String = 'Ctrl+S will overwrite the results for this frame';
tt.FontWeight = 'bold';

% handles.CurrentFolder = 'C:\DATA\';
handles.CurrentFolder = '\\zserver.cortexlab.net\Data\EyeCamera';

% Choose default command line output for etGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes etGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = etGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;

% --- Executes on slider movement.
function FrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hObject.Value = round(hObject.Value);
handles.iFrame = hObject.Value;
handles.CurrentFrame = read(handles.vr, handles.iFrame);
updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in AutoPush.
function AutoPush_Callback(hObject, eventdata, handles)
% hObject    handle to AutoPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function MaxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to MaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hObject.Value = max(hObject.Value, handles.MinSlider.Value+1);
updateFigure(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function MaxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function MinSlider_Callback(hObject, eventdata, handles)
% hObject    handle to MinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hObject.Value = min(hObject.Value, handles.MaxSlider.Value-1);
updateFigure(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function MinSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function ThresholdSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.ThresholdText.String = sprintf('%3.1f', hObject.Value);
updateFigure(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function ThresholdSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in CenterCheck.
function CenterCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CenterCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CenterCheck

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in EdgeCheck.
function EdgeCheck_Callback(hObject, eventdata, handles)
% hObject    handle to EdgeCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EdgeCheck

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in EllipseCheck.
function EllipseCheck_Callback(hObject, eventdata, handles)
% hObject    handle to EllipseCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of EllipseCheck

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in ROICheck.
function ROICheck_Callback(hObject, eventdata, handles)
% hObject    handle to ROICheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROICheck

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in CropCheck.
function CropCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CropCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CropCheck

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in RunToggle.
function RunToggle_Callback(hObject, eventdata, handles)
% hObject    handle to RunToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAll(handles.figure1);
hObject.Enable = 'on';
handles.PlotPush.Enable = 'on';
handles = runAnalysis(hObject, eventdata, handles);
enableAll(handles.figure1);
updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

function FilterSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to FilterSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilterSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of FilterSizeEdit as a double

num = str2double(hObject.String);
if ~isnan(num)
    num = min(max(num, 0.1), 100);
    hObject.Value = num;
    hObject.String = num2str(hObject.Value);
else
    hObject.String = num2str(hObject.Value);
end

updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FilterSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilterSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PreviewToggle.
function PreviewToggle_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles;
if hObject.Value
    handles.ROIPush.Enable = 'off';
    handles.BlinkROIPush.Enable = 'off';
    handles.RunToggle.Enable = 'off';
    handles.AutoPush.Enable = 'off';
    handles.ReplayToggle.Enable = 'off';
    handles.ReplaySlider.Enable = 'off';
    hObject.String = 'Stop';
end
while (hObject.Value) && h.iFrame<h.vr.NumberOfFrames
    h.iFrame = h.iFrame + 1;
    h.CurrentFrame = read(h.vr, [h.iFrame, h.iFrame]);
    updateFigure(hObject, eventdata, h);
    guidata(hObject, h);
end
hObject.Value = 0;
hObject.String = 'Preview';
enableAll(handles.figure1);
guidata(hObject, h);

% --- Executes on button press in PlotPush.
function PlotPush_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = plotTraces(hObject, eventdata, handles);
guidata(hObject, handles);

function GotoEdit_Callback(hObject, eventdata, handles)
% hObject    handle to GotoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GotoEdit as text
%        str2double(get(hObject,'String')) returns contents of GotoEdit as a double

num = str2double(hObject.String);
if ~isnan(num)
    num = min(max(round(num), 1), handles.vr.NumberOfFrames);
    hObject.Value = num;
    hObject.String = num2str(hObject.Value);
else
    hObject.String = num2str(hObject.Value);
end

handles.iFrame = hObject.Value;
handles.CurrentFrame = read(handles.vr, handles.iFrame);
updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GotoEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GotoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ROIPush.
function ROIPush_Callback(hObject, eventdata, handles)
% hObject    handle to ROIPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAll(handles.figure1);
hRect = imrect(handles.Axes, handles.roi);
fcn = makeConstrainToRectFcn('imrect', [1 handles.vr.Width], [1 handles.vr.Height]);
setPositionConstraintFcn(hRect,fcn);
handles.roi = wait(hRect);
handles.roi = [ceil(handles.roi(1:2)), floor(handles.roi(3:4))];
handles.ROICheck.Value = 1;
enableAll(handles.figure1);

updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function fileOpen_Callback(hObject, eventdata, handles)
% hObject    handle to fileOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles, errFlag] = openfile(hObject, eventdata, handles);
if (errFlag == 0)
    updateFigure(hObject, eventdata, handles);
    guidata(hObject, handles);
else
    % do nothing,
    % errFlag == -1 ==> no file was selected to be opened
end

% --------------------------------------------------------------------
function fileSave_Callback(hObject, eventdata, handles)
% hObject    handle to fileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles;
results = h.results;
state = getCurrentState(h);
[~, fn, ~] = fileparts(h.FileName);
% the results are saved in the same folder as the video file
filename = fullfile(h.CurrentFolder, [fn, '_processed.mat']);
save(filename, 'results', 'state');
h.lastFileSaved = filename;
guidata(hObject, h);

% --------------------------------------------------------------------
function fileSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to fileSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = fileSaveAs(hObject, eventdata, handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function fileLoad_Callback(hObject, eventdata, handles)
% hObject    handle to fileLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles, errFlag] = fileLoad(hObject, eventdata, handles);
if errFlag == 0
    guidata(hObject, handles);
    updateFigure(hObject, eventdata, handles);
else
    % do nothing, something went wrong, most likely no file was selected
end

% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function editPreferences_Callback(hObject, eventdata, handles)
% hObject    handle to editPreferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on slider movement.
function FineFrameSlider_Callback(hObject, eventdata, handles)
% hObject    handle to FineFrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hObject.Value = round(hObject.Value);
handles.iFrame = hObject.Value;
handles.CurrentFrame = read(handles.vr, handles.iFrame);
updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FineFrameSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FineFrameSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in OriginalRadio.
function OriginalRadio_Callback(hObject, eventdata, handles)
% hObject    handle to OriginalRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OriginalRadio

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in FilteredRadio.
function FilteredRadio_Callback(hObject, eventdata, handles)
% hObject    handle to FilteredRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FilteredRadio

updateFigure(hObject, eventdata, handles);

% --- Executes on button press in BWRadio.
function BWRadio_Callback(hObject, eventdata, handles)
% hObject    handle to BWRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BWRadio

updateFigure(hObject, eventdata, handles);

function RangeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RangeEdit as text
%        str2double(get(hObject,'String')) returns contents of RangeEdit as a double

global frameRange
h = handles;
tmp = 1:h.vr.NumberOfFrames;
try
    h.RangeEdit.Value = eval(sprintf('tmp(%s)', h.RangeEdit.String));
    h.AnalysisStatusText.String = sprintf('1/%d\t xxx fps \thh:mm:ss  left', length(h.RangeEdit.Value));
    h.RangeEdit.BackgroundColor = 'green';
    pause(0.2);
    h.RangeEdit.BackgroundColor = 'white';
catch
    h.RangeEdit.BackgroundColor = 'red';
end

if h.OverwriteCheck.Value
    h.framesToAnalyze = h.RangeEdit.Value;
else
    h.framesToAnalyze = setdiff(h.RangeEdit.Value, find(h.analyzedFrames));
end

h.AnalysisStatusText.String = sprintf('1/%d\t xxx fps \thh:mm:ss  left', length(h.framesToAnalyze));

guidata(hObject, h);

% --- Executes during object creation, after setting all properties.
function RangeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RangeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in OverwriteCheck.
function OverwriteCheck_Callback(hObject, eventdata, handles)
% hObject    handle to OverwriteCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OverwriteCheck

h = handles;
if hObject.Value
    h.framesToAnalyze = h.RangeEdit.Value;
else
    h.framesToAnalyze = setdiff(h.RangeEdit.Value, find(h.analyzedFrames));
end

h.AnalysisStatusText.String = sprintf('1/%d\t xxx fps \thh:mm:ss  left', length(h.framesToAnalyze));

guidata(hObject, h);

% --- Executes on button press in ReplayToggle.
function ReplayToggle_Callback(hObject, eventdata, handles)
% hObject    handle to ReplayToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReplayToggle

h = handles;
if hObject.Value
    h.ROIPush.Enable = 'off';
    h.BlinkROIPush.Enable = 'off';
    h.RunToggle.Enable = 'off';
    h.AutoPush.Enable = 'off';
    h.PreviewToggle.Enable = 'off';
    h.FrameSlider.Enable = 'off';
    h.FineFrameSlider.Enable = 'off';
    hObject.BackgroundColor = 'green';
    hObject.String = 'Stop';
    drawnow;
end
framesToReplay = find(h.analyzedFrames);
% find a frame closest to the current one, which is analyzed
[~, iF] = min(abs(framesToReplay-h.iFrame));
while (hObject.Value) && ~isempty(iF) && iF<length(framesToReplay)
    iF = iF + 1;
    h.iFrame = framesToReplay(iF);
    h.CurrentFrame = read(h.vr, h.iFrame);
    updateFigure(hObject, eventdata, h);
    h.ReplaySlider.Value = iF;
    guidata(hObject, h);
end
hObject.Value = 0;
hObject.String = 'Replay';
hObject.BackgroundColor = [1 1 1]*0.94;
enableAll(h.figure1);
guidata(hObject, h);

% --- Executes on button press in BlinkROIPush.
function BlinkROIPush_Callback(hObject, eventdata, handles)
% hObject    handle to BlinkROIPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableAll(handles.figure1);
hRect = imrect(handles.Axes, handles.blinkRoi);
fcn = makeConstrainToRectFcn('imrect', [1 handles.vr.Width], [1 handles.vr.Height]);
setPositionConstraintFcn(hRect,fcn);
handles.blinkRoi = wait(hRect);
handles.blinkRoi = [ceil(handles.blinkRoi(1:2)), floor(handles.blinkRoi(3:4))];
handles.BlinkCheck.Value = 1;
enableAll(handles.figure1);

updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

function BlinkRhoEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BlinkRhoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlinkRhoEdit as text
%        str2double(get(hObject,'String')) returns contents of BlinkRhoEdit as a double

num = str2double(hObject.String);
if ~isnan(num)
    num = min(num, 1);
    hObject.Value = num;
    hObject.String = sprintf('%5.3f', hObject.Value);
    handles.results.blink(handles.analyzedFrames) = ...
        handles.results.blinkRho(handles.analyzedFrames)<num;
else
    hObject.String = sprintf('%5.3f', hObject.Value);
end

updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BlinkRhoEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlinkRhoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in BlinkCheck.
function BlinkCheck_Callback(hObject, eventdata, handles)
% hObject    handle to BlinkCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BlinkCheck

updateFigure(hObject, eventdata, handles);

% --- Executes on slider movement.
function ReplaySlider_Callback(hObject, eventdata, handles)
% hObject    handle to ReplaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

hObject.Value = round(hObject.Value);
idx = find(handles.analyzedFrames);
handles.iFrame = idx(hObject.Value);
handles.CurrentFrame = read(handles.vr, handles.iFrame);
% call udateFigure() as if from the ReplayToggle Callback
updateFigure(hObject, eventdata, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ReplaySlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReplaySlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --------------------------------------------------------------------
function runBatch_Callback(hObject, eventdata, handles)
% hObject    handle to runBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

etBatch(handles.figure1);

% --- Executes during object creation, after setting all properties.
function PlotPush_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'ButtonDownFcn', @plotClick);

% --- Executes on button press in BlinksOnlyCheck.
function BlinksOnlyCheck_Callback(hObject, eventdata, handles)
% hObject    handle to BlinksOnlyCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BlinksOnlyCheck
