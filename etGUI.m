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
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help etGUI

% Last Modified by GUIDE v2.5 24-Apr-2017 15:36:02

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

% lets' turn off these useless and annoying warnings off
warning('off', 'MATLAB:nargchk:deprecated')

handles.Axes.Visible = 'off';
handles.OriginalRadio.Value = 1;
handles.FilterSizeEdit.Value = 2; 
handles.FilterSizeEdit.String = '2'; 
handles.ViewPush.Enable = 'off';
handles.AutoPush.Enable = 'off';
handles.CenterCheck.Value = false;
handles.EdgeCheck.Value = false;
handles.EllipseCheck.Value = true;
handles.ROICheck.Value = false;
handles.CropCheck.Value = false;

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


% --- Executes on button press in RunPush.
function RunPush_Callback(hObject, eventdata, handles)
% hObject    handle to RunPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles;
hObject.BackgroundColor = 'red';
drawnow;
tStart = tic;
for i = 1:length(h.framesToAnalyze)
    iFrame = h.framesToAnalyze(i);
    frame = read(h.vr, [iFrame iFrame]);
    params.gaussStd = h.FilterSizeEdit.Value;
    params.thresh = h.ThresholdSlider.Value;
    xSpan = h.roi(1):sum(h.roi([1, 3]))-1;
    ySpan = h.roi(2):sum(h.roi([2, 4]))-1;
    res = analyzeSingleFrame(frame(ySpan, xSpan), params);
    if ~mod(i,100)
        tNow = toc(tStart);
        fps = i/tNow;
        tLeft = (length(h.framesToAnalyze)-i)/fps;
        h.AnalysisStatusText.String = ...
            sprintf('%d/%d\t %3.0f fps \t%s  left', ...
            i, length(h.framesToAnalyze), fps, ...
            duration(seconds(tLeft), 'Format', 'hh:mm:ss'));
        drawnow;
    end
end
hObject.BackgroundColor = [0.94 0.94 0.94];


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
guidata(hObject, h);

% --- Executes on button press in ViewPush.
function ViewPush_Callback(hObject, eventdata, handles)
% hObject    handle to ViewPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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

hRect = imrect(handles.Axes, handles.roi);
fcn = makeConstrainToRectFcn('imrect', [1 handles.vr.Width], [1 handles.vr.Height]);
setPositionConstraintFcn(hRect,fcn);
handles.roi = wait(hRect);
handles.roi = [ceil(handles.roi(1:2)), floor(handles.roi(3:4))];
handles.ROICheck.Value = 1;

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

handles = openfile(hObject, eventdata, handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function fileSave_Callback(hObject, eventdata, handles)
% hObject    handle to fileSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fileSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to fileSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fileLoad_Callback(hObject, eventdata, handles)
% hObject    handle to fileLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
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

% h.RangeEdit.String = '1:end';
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