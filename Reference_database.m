function varargout = Reference_database(varargin)
% REFERENCE_DATABASE MATLAB code for Reference_database.fig
%      REFERENCE_DATABASE, by itself, creates a new REFERENCE_DATABASE or raises the existing
%      singleton*.
%
%      H = REFERENCE_DATABASE returns the handle to a new REFERENCE_DATABASE or the handle to
%      the existing singleton*.
%
%      REFERENCE_DATABASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REFERENCE_DATABASE.M with the given input arguments.
%
%      REFERENCE_DATABASE('Property','Value',...) creates a new REFERENCE_DATABASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reference_database_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reference_database_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reference_database

% Last Modified by GUIDE v2.5 25-Mar-2018 02:08:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Reference_database_OpeningFcn, ...
    'gui_OutputFcn',  @Reference_database_OutputFcn, ...
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


% --- Executes just before Reference_database is made visible.
function Reference_database_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reference_database (see VARARGIN)

% Choose default command line output for Reference_database
handles.output = hObject;
handles.counter = 0;
handles.legend = {};
handles.ColumnName = [];
handles.min = 0;
handles.max = 0;
handles.fn1 = [];
handles.fn2 = [];
handles.allrefspec = [];
% handles.uitable1.Data = [];
% handles.uitable.ColumnName = [];

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
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)Reference_database('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save as');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)Reference_database('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));
%%
handles.initial_handles = handles;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Reference_database wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Reference_database_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb1.
function myopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.counter = handles.counter + 1;
handles.table1 = [];

if handles.counter == 1
    [filenames1,pathname1] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load file');
    if isequal([filenames1,pathname1],[0,0])
        return
    else
        
        refspec1_name = inputdlg('Name of reference spectra','What is the name of referennce spectra?');
        if isempty(refspec1_name)
            return
        else
            
            cd (pathname1);
            handles.fn1 = importdata(strcat (pathname1,filenames1));
            handles.fn1 = sortrows(handles.fn1,-1);
            handles.allrefspec = [handles.allrefspec,handles.fn1];
            
            refspec1_name = char(refspec1_name);
            handles.legend = {refspec1_name};
            
            min1 = min(handles.fn1(:,1));
            max1 = max(handles.fn1(:,1));
            if min1 < 700
                index1 = find (handles.fn1(:,1) < 700 );
                size_index1 = size(index1);
                handles.fn1 (index1(1,1):index1(size_index1(1,1),1),:) = [];
            end
            if max1 > 3999.74
                index2 = find (handles.fn1(:,1) > 3999.74 );
                size_index2 = size(index2);
                handles.fn1 (index2(1,1):index2(size_index2(1,1),1),:) = [];
            end
            
            handles.min1 = min (handles.fn1(:,1));
            handles.max1 = max (handles.fn1(:,1));
            
            axes(handles.axes1)
            plot(handles.fn1(:,1),handles.fn1(:,2))
            title ('Reference spectra');
            xlabel('Wavenumber(cm^-^1)');
            ylabel('Abs. int.');
            xlim ([handles.min1 handles.max1]);
            legend(handles.legend);
        end
        
    end
    
    handles.ColumnName = char('Wavenumber',refspec1_name);
    set (handles.uitable1,'Data',handles.fn1, 'ColumnName',handles.ColumnName);
    
    handles.allrefspec = handles.fn1;
    %%
else
    [filenames2,pathname2] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load file');
    if isequal([filenames2,pathname2] , [0,0])
        return
    else
        
        refspec2_name = inputdlg('Name of reference spectra','What is the name of referennce spectra?');
        if isempty(refspec2_name)
            return
        else
            
            cd (pathname2);
            handles.fn2 = importdata(strcat (pathname2,filenames2));
            handles.fn2 = sortrows(handles.fn2,-1);
            min2 = min(handles.fn2(:,1));
            max2 = max(handles.fn2(:,1));
            if min2 < 700
                index1 = find (handles.fn2(:,1) < 700 );
                size_index1 = size(index1);
                handles.fn2 (index1(1,1):index1(size_index1(1,1),1),:) = [];
            end
            if max2 > 3999.74
                index2 = find (handles.fn2(:,1) > 3999.74 );
                size_index2 = size(index2);
                handles.fn2 (index2(1,1):index2(size_index2(1,1),1),:) = [];
            end
            
            refspec2_name = char(refspec2_name);
            
            handles.legend = [handles.legend;refspec2_name];
            
            handles.ColumnName = char(handles.ColumnName,refspec2_name);
            handles.allrefspec = [handles.allrefspec,handles.fn2(:,2)];
            
            handles.min1 = min (handles.allrefspec(:,1));
            handles.max1 = max (handles.allrefspec(:,1));
            
            axes(handles.axes1)
            plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
            title ('Reference spectra');
            xlabel('Wavenumber(cm^-^1)');
            ylabel('Abs. int.');
            xlim ([handles.min1 handles.max1]);
            legend(handles.legend);
        end
    end
    
    set (handles.uitable1,'Data',handles.allrefspec, 'ColumnName',handles.ColumnName);
end

set (handles.popupmenu1,'String',handles.ColumnName);

guidata(hObject, handles);



% --------------------------------------------------------------------
function baselinecorrection_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter == 0
    uiwait(errordlg('You have not load any data file yet'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('Baseline correction can not be done on wavenumber'));
else
    minmax1 = inputdlg({'Minimum of wavenumber to look for baseline correction:','Maximum of wavenumber to look for baseline correction:'},'Baseline correction');
    
    if isequal(minmax1 , {})
        return
    else
        min1 = str2double(minmax1{1,1});
        max1 = str2double(minmax1{2,1});
        
        index1 = find(handles.uitable1.Data(:,1)> min1 & handles.uitable1.Data(:,1)< max1);
        sizeindex1 = size(index1);
        
        meandata = mean(handles.uitable1.Data(index1(sizeindex1(1,2),1):index1(sizeindex1(1,1),1),handles.popupmenu1.Value));
        handles.uitable1.Data(:,handles.popupmenu1.Value) = handles.uitable1.Data(:,handles.popupmenu1.Value)- meandata;
        
        axes(handles.axes1)
        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end));
        title ('Refspec subtraction');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim([handles.min1 handles.max1]);
        legend(handles.uitable1.ColumnName(2:end,:));
        
    end
end



guidata(hObject, handles);



% --- Executes on button press in pb2_save.
function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb2_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA).

[fileforsave,pathforsave] = uiputfile('References.txt','Save file name');
if isequal([fileforsave,pathforsave] ,[0,0])
    return
else
    fnname = fullfile (pathforsave,fileforsave);
    data = num2cell (handles.uitable1.Data);
    
    all = [(cellstr(handles.uitable1.ColumnName))';data];
    
    cell2csv(fnname,all);
end


guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb3_delete.
function pb3_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb3_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.popupmenu1.Value == 1
    errordlg('The wavenumber values can not be deleted but it can be replaced. Try the replace button!','File Error');
else
    handles.pb3_delete_value =  handles.popupmenu1.Value;
    handles.pb3_delete_String =  get(handles.popupmenu1,'String');
    size_pb3_delete_String = size(handles.pb3_delete_String);
    
    if size_pb3_delete_String(1,1) > 2
        handles.allrefspec (:,handles.pb3_delete_value) = [];
        handles.ColumnName (handles.pb3_delete_value,:) = [];
        
        handles.legend (handles.pb3_delete_value-1,:) = [];
        set (handles.popupmenu1,'Value',handles.pb3_delete_value-1);
        
        handles.table_all = array2table (handles.allrefspec);
        cell_handles.ColumnName = cellstr(handles.ColumnName);
        %         handles.table_all.Properties.VariableNames = cell_handles.ColumnName;
        
        set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
        set (handles.popupmenu1,'String',handles.ColumnName);
        set (handles.popupmenu1,'Value',handles.pb3_delete_value-1);
        
        handles.min1 = min (handles.allrefspec(:,1));
        handles.max1 = max (handles.allrefspec(:,1));
        
        axes(handles.axes1)
        plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
        title ('Reference spectra');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim ([handles.min1 handles.max1]);
        legend(handles.legend);
        
    elseif size_pb3_delete_String(1,1) == 2
        handles.allrefspec (:,handles.pb3_delete_value) = [];
        handles.ColumnName (handles.pb3_delete_value,:) = [];
        handles.legend (handles.pb3_delete_value-1,:) = [];
        
        handles.table_all = array2table (handles.allrefspec);
        cell_handles.ColumnName = cellstr(handles.ColumnName);
        handles.table_all.Properties.VariableNames = cell_handles.ColumnName;
        
        set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
        set (handles.popupmenu1,'String','Wavenumber');
        set (handles.popupmenu1,'Value',1);
        
        axes(handles.axes1)
        cla reset
        handles.legend = {};
        
    end
end

guidata(hObject, handles);


% --- Executes on button press in pb4_replace.
function pb4_replace_Callback(hObject, eventdata, handles)
% hObject    handle to pb4_replace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.pb4_replace_value =  get(handles.popupmenu1,'Value');

if handles.pb4_replace_value == 1
    errordlg('You should chose the spectrum of interest first')
else
    
    [filenames3,pathname3] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load file');
    if isequal([filenames3,pathname3],[0,0])
        return
    else
        handles.fnreplace = importdata(strcat (pathname3,filenames3));
        
        refspec2_name = inputdlg('Name of reference spectra','What is the name of referennce spectra?');
        min2 = min(handles.fnreplace(:,1));
        max2 = max(handles.fnreplace(:,1));
        if min2 < 700
            index1 = find (handles.fnreplace(:,1) < 700 );
            size_index1 = size(index1);
            handles.fnreplace (index1(1,1):index1(size_index1(1,1),1),:) = [];
        end
        if max2 > 3999.74
            index2 = find (handles.fnreplace(:,1) > 3999.74 );
            size_index2 = size(index2);
            handles.fnreplace (index2(1,1):index2(size_index2(1,1),1),:) = [];
        end
        
        handles.legend (handles.pb4_replace_value-1,:) = refspec2_name;
        handles.allrefspec (:,handles.pb4_replace_value) = handles.fnreplace(:,2);
        
        handles.ColumnName = cellstr(handles.ColumnName);
        handles.ColumnName (handles.pb4_replace_value,:) = refspec2_name;
        
        handles.ColumnName = char(handles.ColumnName);
        
        set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
        set (handles.popupmenu1,'String',handles.ColumnName);
        
        handles.min1 = min (handles.allrefspec(:,1));
        handles.max1 = max (handles.allrefspec(:,1));
        
        axes(handles.axes1)
        plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
        title ('Reference spectra');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim ([handles.min1 handles.max1]);
        legend(handles.legend);
    end
    
end

guidata(hObject, handles);

% --- Executes on button press in rename.
function rename_Callback(hObject, eventdata, handles)
% hObject    handle to rename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.popupmenu1.Value == 1)
    errordlg('You can not rename the wavenumber!')
else
    assignin('base','handles',handles);
    rename_refspecname = inputdlg('Rename the reference spectrum','What is the new name for referennce spectrum?');
    handles.legend(handles.popupmenu1.Value-1,1) = rename_refspecname;
    handles.ColumnName = ['Wavenumber';handles.legend];
    
    set (handles.uitable1,'ColumnName',handles.ColumnName);
    set (handles.popupmenu1,'String',handles.ColumnName);
    
    handles.min1 = min (handles.allrefspec(:,1));
    handles.max1 = max (handles.allrefspec(:,1));
    
    axes(handles.axes1)
    plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
    title ('Reference spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim ([handles.min1 handles.max1]);
    legend(handles.legend);
    
end


guidata(hObject, handles);


% --------------------------------------------------------------------
function load_existing_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_existing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.counter = 2;

[filenames11,pathname11] = uigetfile({'*.txt','text files';'*.dpt','dpt files';...
    '*.m','Matlab files';'*.*','All files'},'Load file');
if isequal([filenames11,pathname11] , [0,0])
    return
else
    handles.fnstructure = importdata(fullfile (pathname11,filenames11));
    handles.allrefspec = handles.fnstructure.data;
    
    handles.ColumnName = char(handles.fnstructure.textdata);
    handles.legend = (handles.fnstructure.textdata(:,2:end))';
    
    set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
    set (handles.popupmenu1,'String',handles.ColumnName);
    
    handles.min1 = min (handles.allrefspec(:,1));
    handles.max1 = max (handles.allrefspec(:,1));
    
    axes(handles.axes1)
    plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
    title ('Reference spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim ([handles.min1 handles.max1]);
    legend(handles.legend);
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function savefigure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure(1)
plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
title ('Reference spectra');
xlabel('Wavenumber(cm^-^1)');
ylabel('Abs. int.');
xlim ([handles.min1 handles.max1]);
legend(handles.legend);

[filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
    '*.jpg', 'JPEG files (*.jpg)';...
    '*.fig','Figures (*.fig)';...
    '*.*',  'All Files (*.*)'},...
    'Save as','All spectra');
if isequal ([filename, pathname],[0,0])
    return
else
    filepath = fullfile (pathname,filename);
    saveas(figure(1),filepath);
end


% --------------------------------------------------------------------
function sort_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rows = size(handles.allrefspec);
rows = rows(1,1);
size_file = size(handles.legend);
columns = size_file(1,1);
[~,index] = sortrows(lower(handles.legend));

sorted_spectra = [handles.allrefspec(:,1),zeros(rows,columns)];
sorted_legends = cell(columns,1);

for i = 1:columns
    sorted_spectra(:,i+1) = handles.allrefspec(:,index(i,1)+1);
    sorted_legends(i,1) = handles.legend(index(i,1),1);
end

handles.allrefspec = sorted_spectra;
handles.ColumnName = ['Wavenumber';sorted_legends];
handles.legend = sorted_legends;

set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
set (handles.popupmenu1,'String',handles.ColumnName);

handles.min1 = min (handles.allrefspec(:,1));
handles.max1 = max (handles.allrefspec(:,1));

axes(handles.axes1)
plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
title ('Reference spectra');
xlabel('Wavenumber(cm^-^1)');
ylabel('Abs. int.');
xlim ([handles.min1 handles.max1]);
legend(handles.legend);

guidata(hObject, handles);


% --------------------------------------------------------------------
function moveup_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to moveup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.popupmenu1.Value == 1 || handles.popupmenu1.Value == 2)
    errordlg('You can not change the wavenumber!')
else
    
    moveup_spectrum = handles.allrefspec(:,handles.popupmenu1.Value);
    movedown_spectrum = handles.allrefspec(:,handles.popupmenu1.Value-1);
    
    handles.allrefspec(:,handles.popupmenu1.Value-1) = moveup_spectrum;
    handles.allrefspec(:,handles.popupmenu1.Value) = movedown_spectrum;
    
    moveup_legend = handles.legend(handles.popupmenu1.Value-1,1);
    movedown_legend = handles.legend(handles.popupmenu1.Value-2,1);
    
    handles.legend(handles.popupmenu1.Value-2,1) = moveup_legend;
    handles.legend(handles.popupmenu1.Value-1,1) = movedown_legend;
    
    handles.ColumnName = ['Wavenumber';handles.legend];
    
    set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
    set (handles.popupmenu1,'String',handles.ColumnName);
    
    handles.min1 = min (handles.allrefspec(:,1));
    handles.max1 = max (handles.allrefspec(:,1));
    
    axes(handles.axes1)
    plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
    title ('Reference spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim ([handles.min1 handles.max1]);
    legend(handles.legend);
    
    handles.popupmenu1.Value = handles.popupmenu1.Value - 1;
    
end


guidata(hObject, handles);


% --------------------------------------------------------------------
function movedown_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to movedown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

size_file = size(handles.allrefspec);

if (handles.popupmenu1.Value == 1)
    errordlg('You can not change the wavenumber!')
elseif (handles.popupmenu1.Value == size_file(1,2))
    errordlg('This is the last spectrum!')
else
    
    movedown_spectrum = handles.allrefspec(:,handles.popupmenu1.Value);
    moveup_spectrum = handles.allrefspec(:,handles.popupmenu1.Value+1);
    
    handles.allrefspec(:,handles.popupmenu1.Value+1) = movedown_spectrum;
    handles.allrefspec(:,handles.popupmenu1.Value) = moveup_spectrum;
    
    movedown_legend = handles.legend(handles.popupmenu1.Value-1,1);
    moveup_legend = handles.legend(handles.popupmenu1.Value,1);
    
    handles.legend(handles.popupmenu1.Value,1) = movedown_legend;
    handles.legend(handles.popupmenu1.Value-1,1) = moveup_legend;
    
    handles.ColumnName = ['Wavenumber';handles.legend];
    
    set (handles.uitable1,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
    set (handles.popupmenu1,'String',handles.ColumnName);
    
    handles.min1 = min (handles.allrefspec(:,1));
    handles.max1 = max (handles.allrefspec(:,1));
    
    axes(handles.axes1)
    plot(handles.allrefspec(:,1),handles.allrefspec(:,2:end))
    title ('Reference spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim ([handles.min1 handles.max1]);
    legend(handles.legend);
    
    handles.popupmenu1.Value = handles.popupmenu1.Value + 1;
    
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function reset_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = handles.initial_handles;
handles.initial_handles = handles;

cla (handles.axes1,'reset');
set (handles.popupmenu1,'String','Pop-up menu');
set (handles.popupmenu1,'Value',1);
handles.uitable1.ColumnName = [];
handles.uitable1.Data = [];



guidata(hObject, handles);



