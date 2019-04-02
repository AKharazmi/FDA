function varargout = Analyzer(varargin)
% ANALYZER MATLAB code for Analyzer.fig
%      ANALYZER, by itself, creates a new ANALYZER or raises the existing
%      singleton*.
%
%      H = ANALYZER returns the handle to a new ANALYZER or the handle to
%      the existing singleton*.
%
%      ANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYZER.M with the given input arguments.
%
%      ANALYZER('Property','Value',...) creates a new ANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analyzer

% Last Modified by GUIDE v2.5 26-Apr-2017 10:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analyzer_OpeningFcn, ...
                   'gui_OutputFcn',  @Analyzer_OutputFcn, ...
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


% --- Executes just before Analyzer is made visible.
function Analyzer_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analyzer (see VARARGIN)

% Choose default command line output for Analyzer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analyzer_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in interpolation.
function interpolation_Callback(hObject, ~, handles)
% hObject    handle to interpolation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myinterpolation;

guidata(hObject, handles);

% --- Executes on button press in builder.
function builder_Callback(hObject, ~, handles)
% hObject    handle to builder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

builder;

guidata(hObject, handles);

% --- Executes on button press in referencedatabase.
function referencedatabase_Callback(hObject, ~, handles)
% hObject    handle to referencedatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Reference_database;

guidata(hObject, handles);

% --- Executes on button press in photolysisanalyzer.
function photolysisanalyzer_Callback(hObject, ~, handles)
% hObject    handle to photolysisanalyzer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

photolysis_analyzer;
% job1 = batch ('photolysis_analyzer',4,{8,8},'Pool',1);
% job1.State
% wait(job1);
guidata(hObject, handles);


% --- Executes on button press in refspecanalyzer.
function refspecanalyzer_Callback(hObject, ~, handles)
% hObject    handle to refspecanalyzer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Ref_Analyzer;

guidata(hObject, handles);

% --- Executes on button press in beerlambert.
function beerlambert_Callback(hObject, ~, handles)
% hObject    handle to beerlambert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Beer_lambert;

guidata(hObject, handles);


% --- Executes on button press in nolaser.
function nolaser_Callback(hObject, ~, handles)
% hObject    handle to nolaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nolaser;

guidata(hObject, handles);
