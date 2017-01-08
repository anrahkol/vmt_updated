function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 07-Jan-2017 18:46:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex]= uigetfile('*.txt','Select file');
data =dlmread([pathname, filename],' ');
set(handles.text15, 'String', filename);
handles.x = data(1:end,1);
handles.y = data(:,2);
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


xdft = fft(handles.y);    
       
% sampling frequency 
t_diff_vect = diff(handles.x);
DT = mean(t_diff_vect);
Fs = round(1/DT)

DF = Fs/length(handles.x);
freq = 0:DF:Fs/2;
xdft = xdft(1:length(xdft)/2+1);

axes(handles.axes4);
plot(freq,20*log10(abs(xdft)));
xlabel('Frequency (Hz)');
ylabel('Amplitude (db)');
title('RAW DATA FFT')
ylim([-40 80]);

dataOut = filtters(handles.y, Fs)

axes(handles.axes5);
xdft2 = fft(dataOut);
xdft2 = xdft2(1:length(xdft2)/2+1);
plot(freq,20*log10(abs(xdft2)));
xlabel('Frequency (Hz)');
ylabel('Amplitude (db)');    
title('FILTERED SIGNAL FFT')
ylim([-40 80]); 

 [locs, peak_diffs, pks] = peak_detect_and_diffs(dataOut,handles.x, Fs);
 length(locs)
 length(pks)
 axes(handles.axes6);
 plot(handles.x,dataOut,locs,pks,'o');
 %
 xlabel('Time (s)');
 ylabel('Amplitude (v)');
 title('PEAKS FOUND')
 
HR = 60./peak_diffs;

axes(handles.axes7);
plot(locs, HR);
xlabel('Time (s)');
ylabel('HR (bpm)');
title('HEART RATE')
ylim([40 220]);  

axes(handles.axes8);
plot(locs, 1000*peak_diffs);
xlabel('Time (s)');
ylabel('Time (ms)');
title('RR-INTERVAL SIGNAL')


axes(handles.axes9);
plot(1000*peak_diffs(1:end-1), 1000*peak_diffs(2:end),'.');
%end
xlabel('R-R(n) (ms)');
ylabel('R-R(n+1) (ms)');
title('POINCARE HRV')


%Arrhythmia
cat_tot(1:4)= [0,0,0,0];
RR_category = ones(1,(length(peak_diffs)));

[RR_category, cat_tot] = arrhythmia_detect(peak_diffs, RR_category, cat_tot)
axes(handles.axes10);



plot(locs, RR_category, 'o')

xlabel('Time (s)');
ylabel('RR category');
title('HEART BEAT CATEGORY')
ylim([0 5]);  

%yticks([1 2 3 4])
%yticklabels({'Normal','Premature ventricular contractions','Ventricular flutter / fibrillation','2° heart block'}) 

set(handles.text1, 'String', cat_tot(1));
set(handles.text2, 'String', cat_tot(2));
set(handles.text3, 'String', cat_tot(3));
set(handles.text4, 'String', cat_tot(4));
