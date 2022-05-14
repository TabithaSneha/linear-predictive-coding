function varargout = LPC(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LPC_OpeningFcn, ...
                   'gui_OutputFcn',  @LPC_OutputFcn, ...
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


% --- Executes just before LPC is made visible.
function LPC_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for LPC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LPC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LPC_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% *************************************************************************

% --- Executes on button press in 'Press to record for 'x' seconds'.
function pushbutton1_Callback(hObject, eventdata, handles)

% Records the input speech signal(audio).
disp('Start speaking')
handles.recObj = audiorecorder(44100, 16, 1);
recordblocking(handles.recObj, handles.rectime)
handles.y = getaudiodata(handles.recObj);
audiowrite('Original_Speech.wav', handles.y, 44100)
[handles.y, handles.Fs] = audioread('Original_Speech.wav');
handles.player = audioplayer(handles.y, handles.Fs);
disp('End speaking')
guidata(hObject, handles);


% --- Executes on entering values in 'x = '.
function edit1_Callback(hObject, eventdata, handles)
% Accepting the value of duration of record time(x)
handles.rectime = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in 'Play' after recording the speech signal.
function pushbutton2_Callback(hObject, eventdata, handles)
% Plays the recorded speech signal(audio).
plot(handles.y);
title(handles.axes1, 'Original Speech Signal')
xlabel(handles.axes1, 'Time')
ylabel(handles.axes1, 'Audio Signal')
play(handles.player)


% Executes on entering values in 'Length of Audio Segment in ms'.
function edit2_Callback(hObject, eventdata, handles)
% Accepting the length of audio segment
handles.seg = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Executes on entering values in 'Percentage of Overlap'.
function edit3_Callback(hObject, eventdata, handles)
% Accepting the value of percentage of overlap
handles.ol = str2double(get(hObject, 'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in 'Select Window' popupmenu.
function popupmenu1_Callback(hObject, eventdata, handles)
% 'Select Window' drop down menu.
contents = cellstr(get(hObject,'String'));
window_choice = contents(get(hObject,'Value'));
fs = 8000;

if (strcmp(window_choice,'Hanning'))
    handles.w = hann(floor(((handles.seg)/1000)*fs), 'periodic'); % using 30ms Hanning Window
    disp(window_choice);

elseif (strcmp(window_choice,'Hamming'))
    handles.w = hamming(floor(((handles.seg)/1000)*fs), 'periodic'); % using 30ms Hamming Window
    disp(window_choice);

elseif (strcmp(window_choice,'Bartlett'))
    handles.w = bartlett(floor(((handles.seg)/1000)*fs)); % using 30ms Bartlett Window
    disp(window_choice);

elseif (strcmp(window_choice,'Blackman'))
    handles.w = blackman(floor(((handles.seg)/1000)*fs), 'periodic'); % using 30ms Blackman Window
    disp(window_choice);

end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in 'Select Order of the filter'.
function popupmenu2_Callback(hObject, eventdata, handles)
% 'Order of the filter' drop down menu
contents = cellstr(get(hObject, 'String'));
order_choice = contents(get(hObject, 'Value'));
if (strcmp(order_choice, '12'))
    handles.p = 12;
    disp(order_choice)
elseif (strcmp(order_choice, '48'))
    handles.p = 48;
    disp(order_choice)
elseif (strcmp(order_choice, '72'))
    handles.p = 72;
    disp(order_choice)
elseif (strcmp(order_choice, '96'))
    handles.p = 96;
    disp(order_choice)
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in 'Start Encoding'.
function pushbutton3_Callback(hObject, eventdata, handles)
% Compressing/normalizing the audio file and Encoding/computing the filter coefficients of linear predictor filter.
[x, fs] = audioread('Original_Speech.wav');
x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalizing
x = resample(x, 8000, fs); % resampling to 8000 Hz
[handles.A, handles.G] = lpcEncode(x, handles.p, handles.w, handles.ol);
guidata(hObject, handles);
disp('Filter Coefficients:')
disp(handles.A) % displays the filer coeffecients


% --- Executes on button press in 'Calculate and Plot Pitch'.
function pushbutton4_Callback(hObject, eventdata, handles)
% Calculating the pitch of each segment of speech segment.
[x, fs] = audioread('Original_Speech.wav');
x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalizing
x = resample(x, 8000, fs);% resampling to 8000 Hz

[handles.ff, handles.pow] = lpcFindPitch(x, handles.w, 5, 0.125, -60, 0.5, handles.ol);

disp('Pitch:')
disp(handles.ff)
disp('Power:')
disp(handles.pow)

plot(handles.ff)
title(handles.axes1, 'Plot of Pitch')
xlabel(handles.axes1, 'Pitch')
ylabel(handles.axes1, 'Amplitude')
axes(handles.axes1);

guidata(hObject, handles);


% --- Executes on button press in 'Reconstructing the Signal'- 'Without Pitch'.
function pushbutton5_Callback(hObject, eventdata, handles)
% Decoding the Speech Signal without Pitch
handles.xhat = lpcDecode(handles.A, handles.G, handles.w);

% Playing the re-synthesized signal
handles.apLPC = audioplayer(handles.xhat, 8000);
disp('Reconstructed Signal without Pitch: ')
disp(handles.apLPC)

% Saving the output audio file
audiowrite('Output_Without_Pitch.wav', handles.xhat, handles.Fs);
guidata(hObject, handles);

% --- Executes on button press in 'Reconstructing the Signal'- 'With Pitch'.
function pushbutton6_Callback(hObject, eventdata, handles)
% Decoding the Speech Signal with Pitch
fs = 8000;
handles.xhat = lpcDecode(handles.A, handles.G, handles.w, 200/fs);

% Playing the re-synthesized signal
handles.apLPC = audioplayer(handles.xhat, fs);
disp('Reconstructed Signal with Pitch: ')
disp(handles.apLPC);

%Saving the output audio file
audiowrite('Output_With_Pitch.wav', handles.xhat, handles.Fs);
guidata(hObject, handles);

% --- Executes on button press in 'Play' near 'Without Pitch'.
function pushbutton7_Callback(hObject, eventdata, handles)
% Plotting the reconstructed speech signal
play(handles.apLPC);
plot(handles.xhat);
title(handles.axes1, 'Reconstructed Speech Without Pitch')
xlabel(handles.axes1, 'Time')
ylabel(handles.axes1, 'Audio Signal')
axes(handles.axes1);

 


% --- Executes on button press in 'Play' near 'With Pitch'.
function pushbutton8_Callback(hObject, eventdata, handles)
% Plotting the reconstructed speech signal
play(handles.apLPC); 
plot(handles.xhat);
title(handles.axes1, 'Reconstructed Speech With Pitch')
xlabel(handles.axes1, 'Time')
ylabel(handles.axes1, 'Audio Signal')
axes(handles.axes1);



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% Graph parameters
funcString = get(handles.edit1,'String');
funcHandle = str2func(['@(x)' funcString]);
x = linspace(0,4,100);
y = funcHandle(x);
plot(handles.axes1,x,y);
