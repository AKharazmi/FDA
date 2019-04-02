function varargout = myinterpolation(varargin)
% MYINTERPOLATION MATLAB code for myinterpolation.fig
%      MYINTERPOLATION, by itself, creates a new MYINTERPOLATION or raises the existing
%      singleton*.
%
%      H = MYINTERPOLATION returns the handle to a new MYINTERPOLATION or the handle to
%      the existing singleton*.
%
%      MYINTERPOLATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYINTERPOLATION.M with the given input arguments.
%
%      MYINTERPOLATION('Property','Value',...) creates a new MYINTERPOLATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myinterpolation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myinterpolation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myinterpolation

% Last Modified by GUIDE v2.5 18-Aug-2016 19:53:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myinterpolation_OpeningFcn, ...
                   'gui_OutputFcn',  @myinterpolation_OutputFcn, ...
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


% --- Executes just before myinterpolation is made visible.
function myinterpolation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myinterpolation (see VARARGIN)

% Choose default command line output for myinterpolation
handles.output = hObject;
%%
handles.counter1 = 0;
handles.counter2 = 0;
%%
all_gcf = findall(gcf);

Linking = findall(all_gcf,'ToolTipString','Link Plot');
set(Linking,'Visible','Off');

InsertColorbar = findall(all_gcf,'ToolTipString','Insert Colorbar');
set(InsertColorbar,'Visible','Off');
Brushing = findall(all_gcf,'ToolTipString','Brush/Select Data');
set(Brushing,'Visible','Off');
NewFigure = findall(all_gcf,'ToolTipString','New Figure');
set(NewFigure,'Visible','Off');
%%
myToolbar = findall(gcf,'tag','FigureToolBar');

FileOpen_callback = findall(myToolbar,'tag','Standard.FileOpen');
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)myinterpolation('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save as');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)myinterpolation('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));
%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myinterpolation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myinterpolation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function filefornewx_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to filefornewx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filenames2,pathname2] = uigetfile({'*.txt','text files';'*.dpt',...
    'dpt files';'*.m','Matlab files';'*.*','All files'},...
    'Load files for interpolation','MultiSelect', 'on');
if isequal([filenames2,pathname2] , [0,0])
        return
else
    handles.counter2 = handles.counter2 + 1;
    
    newxy = importdata (fullfile (pathname2,filenames2));
    handles.newx = newxy(:,1);
end


guidata(hObject, handles);


function myopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filenames1,pathname1] = uigetfile({'*.txt','text files';'*.dpt',...
    'dpt files';'*.m','Matlab files';'*.*','All files'},...
    'Load files for interpolation','MultiSelect', 'on');

handles.filenames1 = filenames1;
handles.pathname1 = pathname1;

if isequal([filenames1,pathname1] , [0,0])
        return
else
    handles.counter1 = handles.counter1 + 1;
    
    if ischar(filenames1)
        handles.filesforinterp = importdata(fullfile(pathname1,filenames1));
        fileforplot1 = handles.filesforinterp(:,2);
        
        axes(handles.axes1)
        plot(handles.filesforinterp(:,1),fileforplot1)
        title ('All files before interpolation');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.filenames1);
    else
        handles.sizefn1 = size(filenames1);
        numofloop = handles.sizefn1(1,2);
        handles.filesforinterp = cell(1,numofloop);
        fileforplot1 = [];
        
        for i = 1:numofloop
            handles.filesforinterp{i} = importdata(char(fullfile(pathname1,filenames1(1,i))));
            fileforplot1 = [fileforplot1,handles.filesforinterp{i}(:,2)];
        end
        
        axes(handles.axes1)
        plot(handles.filesforinterp{i}(:,1),fileforplot1)
        title ('All files before interpolation');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.filenames1);
    end

end

guidata(hObject, handles);


% --- Executes on button press in interp.
function interp_Callback(hObject, eventdata, handles)
% hObject    handle to interp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.counter1 == 0 || handles.counter2 == 0)
    uiwait(errordlg('You have to load first both file with the new x axes and files to be interpolated'));
else
    assignin('base','handles',handles)
    if ischar(handles.filenames1)
        fileforplot2 = interp1 (handles.filesforinterp(:,1),...
            handles.filesforinterp(:,2),handles.newx);%,'pchip'
        fileforplot2(isnan(fileforplot2)) = 0;
        
        handles.interpedfiles = [handles.newx,fileforplot2];
    else
        handles.interpedfiles = cell(1,handles.sizefn1(1,2));
        fileforplot2 = [];
        
        for i = 1:handles.sizefn1(1,2) 
            a = interp1 (handles.filesforinterp{i}(:,1),...
                handles.filesforinterp{i}(:,2),handles.newx);%,'pchip'
            fileforplot2 = [fileforplot2,a];
            a(isnan(a)) = 0; 
            
            b = [handles.newx,a];
            
            handles.interpedfiles{i} = b;
        end
    end
    
    axes(handles.axes2)
    plot(handles.newx,fileforplot2)
    title ('All files after interpolation');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    legend(handles.filenames1);
    
end

%pchip method seems to be good one 'pchip'
%pchip method is a Shape-preserving piecewise cubic interpolation. The interpolated value at 
%a query point is based on a shape-preserving piecewise cubic interpolation 
%of the values at neighboring grid points.

guidata(hObject, handles);


function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb2_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA).

mkdir(fullfile(handles.pathname1,'Interpolated files'));

if ischar(handles.filenames1)
    dlmwrite (fullfile(handles.pathname1,'Interpolated files',handles.filenames1),...
            handles.interpedfiles,'precision',10);
else
    waitbar1 = waitbar(0,'Please wait...');
    for i = 1:handles.sizefn1(1,2)
        dlmwrite (fullfile(handles.pathname1,'Interpolated files',handles.filenames1{i}),...
            handles.interpedfiles{i},'precision',10);
        waitbar(i / handles.sizefn1(1,2));
    end
    close(waitbar1);
end

guidata(hObject, handles);
