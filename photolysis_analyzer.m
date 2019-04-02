function varargout = photolysis_analyzer(varargin)
% PHOTOLYSIS_ANALYZER MATLAB code for photolysis_analyzer.fig
%      PHOTOLYSIS_ANALYZER, by itself, creates a new PHOTOLYSIS_ANALYZER or raises the existing
%      singleton*.
%
%      H = PHOTOLYSIS_ANALYZER returns the handle to a new PHOTOLYSIS_ANALYZER or the handle to
%      the existing singleton*.
%
%      PHOTOLYSIS_ANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTOLYSIS_ANALYZER.M with the given input arguments.
%
%      PHOTOLYSIS_ANALYZER('Property','Value',...) creates a new PHOTOLYSIS_ANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before photolysis_analyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to photolysis_analyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help photolysis_analyzer
% Last Modified by GUIDE v2.5 18-Jan-2018 12:43:46
% Begin initialization code - DO NOT EDIT

gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @photolysis_analyzer_OpeningFcn, ...
    'gui_OutputFcn',  @photolysis_analyzer_OutputFcn, ...
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


% --- Executes just before photolysis_analyzer is made visible.
function photolysis_analyzer_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to photolysis_analyzer (see VARARGIN)
% Choose default command line output for photolysis_analyzer

handles.popupmenu1.Value = 1;

handles.output = hObject;
handles.counter_edit11 = 0;
handles.counter_edit22 = 0;
handles.counter_edit33 = 0;
handles.counter_edit44 = 0;
handles.counter_edit55 = 0;
handles.counter_edit66 = 0;
handles.counter_edit77 = 0;
handles.counter_edit88 = 0;
handles.counter_edit99 = 0;
handles.counter_edit1010 = 0;
handles.counter_edit1111 = 0;
handles.counter_edit1212 = 0;
handles.counter_edit1313 = 0;
handles.counter_edit1414 = 0;
handles.counter_edit1515 = 0;
handles.counter_edit1616 = 0;
handles.counter_edit1717 = 0;
handles.counter_edit1818 = 0;
%%
handles.counter1 = 0;
handles.counter2 = 0;
handles.counter3 = 0;
handles.counter4 = 0;

%%
all_gcf = findall(gcf);

Linking = findall(all_gcf,'ToolTipString','Link Plot');
set(Linking,'Visible','Off');

InsertColorbar = findall(all_gcf,'ToolTipString','Insert Colorbar');
set(InsertColorbar,'Visible','Off');
Brushing = findall(all_gcf,'ToolTipString','Brush/Select Data');
set(Brushing,'Visible','Off');
% NewFigure = findall(all_gcf,'ToolTipString','New Figure');
% set(NewFigure,'Visible','Off');
%%
myToolbar = findall(gcf,'tag','FigureToolBar');

FileOpen_callback = findall(myToolbar,'tag','Standard.FileOpen');
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)photolysis_analyzer('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save as');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)photolysis_analyzer('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));

NewFigure_callback = findall(myToolbar,'tag','Standard.NewFigure');
set(NewFigure_callback, 'ClickedCallback','New Figure','TooltipString','New Figure');
set(NewFigure_callback, 'ClickedCallback',@(hObject,eventdata)photolysis_analyzer('new_ClickedCallback',hObject,eventdata,guidata(hObject)));

guidata(hObject, handles);

% UIWAIT makes photolysis_analyzer wait for user response (see UIRESUME)
% uiwait(handles.figuguide re1);


% --- Outputs from this function are returnedf to the command line.
function varargout = photolysis_analyzer_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function myopen_ClickedCallback(hObject, ~, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.counter1 = handles.counter1+1;
[filenames1,pathname1] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load file','baseline corrected allfinal text file.txt');
if isequal([filenames1,pathname1] , [0,0])
    return
else
    cd (pathname1);
    set(handles.figure1, 'Name', pathname1);
    
    handles.fn = importdata(fullfile (pathname1,filenames1));
    
    columnname = handles.fn.colheaders;
    %     size_columnname = size(columnname);
    columnname= strtrim (columnname);
    %     for i = 1:size_columnname(1,2)
    %         columnname (1,i) = strtrim (columnname(1,i));
    %     end
    
    handles.data = handles.fn.data;
    handles.data = sortrows(handles.data,-1);
    
    handles.min1 = min(handles.data(:,1));
    handles.max1 = max(handles.data(:,1));
    if handles.min1 < 700
        index1 = find (handles.data(:,1) < 700 );
        size_index1 = size(index1);
        handles.data (index1(1,1):index1(size_index1(1,1),1),:) = [];
    end
    if handles.max1 > 3999.74
        index2 = find (handles.data(:,1) > 3999.74 );
        size_index2 = size(index2);
        handles.data (index2(1,1):index2(size_index2(1,1),1),:) = [];
    end
    handles.x1 = handles.data(:,1);
    
    handles.minx = handles.min1;
    handles.maxx = handles.max1;
    handles.miny = min(min(handles.data(:,2:end)));
    handles.maxy = max(max(handles.data(:,2:end)));
    
    handles.xlim1 = [handles.minx handles.maxx];
    handles.ylim1 = [handles.miny handles.maxy];
end

handles.uitable2.Data = handles.data;
handles.size_uitable2 = size(handles.uitable2.Data);
set(handles.uitable2,'ColumnEditable',true(1,handles.size_uitable2(1,2)));
handles.uitable2.ColumnName = ['Wavenumber',columnname(1,2:end)];

handles.laserspectra = handles.uitable2.Data(:,2:end);
handles.spectra_sectioned = struct('section0',handles.uitable2.Data);% keep the first uitable2 data into sectiono of struture.

handles.popupmenu2.String = '700-4000 (cm^-1)';
handles.popupmenu2.Value = 1;

size_uitable2 = size(handles.uitable2.Data);
handles.mysparse1 = zeros(size_uitable2(1,1),size_uitable2(1,2)-1);
handles.allrefsubtracted.section0 = handles.mysparse1;
handles.sumofscaledrefspec.section0 = handles.mysparse1;

handles.mysparse2 = zeros(handles.size_uitable2(1,2)-1,18);
handles.uitable4_Data.section0 = handles.mysparse2;% this table hosts all scales
handles.uitable4.Data = handles.mysparse2;
handles.uitable4.ColumnName = cell(18,1);
handles.uitable4.RowName = columnname(1,2:end);

handles.popupmenu1.String = ['All spectra',columnname(1,2:end)];
handles.popupmenu1.Value = 1;
handles.popupmenu2.Value = 1;

plot(handles.x1,handles.laserspectra)
title ('All photolysis spectra');
xlabel('Wavenumber(cm^-^1)');
ylabel('Abs. int.');
xlim ([handles.min1 handles.max1]);
legend(handles.popupmenu1.String(2:end,1));

% sizefn2 = size(handles.uitable2.Data(:,1));
% handles.zerofn2 = zeros(sizefn2);%zeros

guidata(hObject, handles);


% --------------------------------------------------------------------
function new_ClickedCallback(hObject, ~, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

photolysis_analyzer;

guidata(hObject, handles);


% --- Executes on button press in setaxeslimits.
function setaxeslimits_Callback(hObject, ~, handles)
% hObject    handle to setaxeslimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dcm_obj = datacursormode;

handles.xlim1 = dcm_obj.Figure.CurrentAxes.XLim;
handles.ylim1 = dcm_obj.Figure.CurrentAxes.YLim;

handles.axes2.XLim = handles.xlim1;
handles.axes2.YLim = handles.ylim1;
handles.axes3.XLim = handles.xlim1;
handles.axes3.YLim = handles.ylim1;

guidata(hObject, handles);


% --- Executes on button press in resetaxeslimits.
function resetaxeslimits_Callback(hObject, ~, handles)
% hObject    handle to resetaxeslimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.xlim1 = [handles.minx handles.maxx];
handles.ylim1 = [handles.miny handles.maxy];

handles.axes2.XLim = handles.xlim1;
handles.axes2.YLim = handles.ylim1;
handles.axes3.XLim = handles.xlim1;
handles.axes3.YLim = handles.ylim1;


guidata(hObject, handles);


% --------------------------------------------------------------------
function refspec_ClickedCallback(hObject, ~, handles)
% hObject    handle to refspec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    errordlg('You should first load photolysis spectra file');
else
    handles.counter2 = handles.counter2+1;
    
    [filenames2,pathname2] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load references file');
    if isequal([filenames2,pathname2] , [0,0])
        return
    else
        handles.fnstructure = importdata(strcat (pathname2,filenames2));
        
        handles.min2 = min(handles.fnstructure.data(:,1));
        handles.max2 = max(handles.fnstructure.data(:,1));
        if handles.min2 < 700
            index1 = find (handles.fnstructure.data(:,1) < 700 );
            size_index1 = size(index1);
            handles.fnstructure.data (index1(1,1):index1(size_index1(1,1),1),:) = [];
        end
        if handles.max2 > 3999.74
            index2 = find (handles.fnstructure.data > 3999.74 );
            size_index2 = size(index2);
            handles.fnstructure.data (index2(1,1):index2(size_index2(1,1),1),:) = [];
        end
        
        checkdimension = handles.x1 - handles.fnstructure.data(:,1);
        checkdimension = any(checkdimension(:));
        switch checkdimension
            case 0
                handles.ColumnName = handles.fnstructure.textdata;
                handles.legend = (handles.fnstructure.textdata(:,2:end));
                
                set (handles.uitable3,'Data',handles.fnstructure.data);
                handles.uitable3.ColumnName = handles.fnstructure.textdata;
                size_uitable3 = size(handles.uitable3.Data);
                set(handles.uitable3,'ColumnEditable',true(1,size_uitable3(1,2)));
            otherwise
                uiwait(errordlg('The photolysis wavenumber is not consitent with reference spectra wavenumber.'));
        end
        
        handles.spectra_sectioned_refspec.section0 = handles.uitable3.Data; % keep uitable3 into the section0 of handles.refspec_sectioned structure
        
        size_refspec = size(handles.uitable3.Data);
        handles.zero_refspec = zeros(size_refspec(1,1),1);%zeros
        
        handles.refsubtracted = handles.zero_refspec;
        
        for i = 1:18
            handles.(strcat('refspec',num2str(i))) = handles.zero_refspec;
            handles.(strcat('scale',num2str(i))) = 0;
        end
    end
    %%
end


guidata(hObject, handles);


function devide_ClickedCallback(hObject, ~, handles)
% hObject    handle to devide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter2 == 0
    errordlg('You should first load both photolysis and reference spectra files');
else
    
    wavenumbercutoff = menu('Load existing section cut off file or input new one','Load exsiting file of sections cut off',...
        'Input the new sections cut off');
    if (isempty(wavenumbercutoff) || ~any(wavenumbercutoff))
        return
        %% load existing section cut off text file and doing further analysis
    elseif wavenumbercutoff == 1
        [filename,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select sections cut off file');
        
        if isequal([filename,pathname],[0,0])
            return
        else
            wavenumbercutoff_data = importdata (fullfile(pathname,filename));
            
            size_wavenumbercutoff = size(wavenumbercutoff_data);
            handles.numofsections = size_wavenumbercutoff(1,1)/2;
            
            cutoff = cell(1,handles.numofsections*2);
            i = 1;
            ii = 1;
            while i < handles.numofsections*2+1
                pstr = num2str(ii);
                cutoff{i} = strcat('Minimum of the region', pstr);
                cutoff{i+1} = strcat('Maximum of the region', pstr);
                i = i + 2;
                ii = ii + 1;
            end
            handles.sectionslist = inputdlg(cutoff,'Regions Min and Max',1,(cellstr(num2str(wavenumbercutoff_data)))');
        end
        
        %% Input a new wavenumber cut off save as text file and doing further analysis
    elseif wavenumbercutoff == 2
        
        handles.numofsections = str2double (inputdlg('Input the number sections to devide x axis'));
        
        if isempty (handles.numofsections)
            return
        else
            cutoff = cell(1,handles.numofsections*2);
            i = 1;
            ii = 1;
            while i < handles.numofsections*2+1
                pstr = num2str(ii);
                cutoff{i} = strcat('Minimum of the region', pstr);
                cutoff{i+1} = strcat('Maximum of the region', pstr);
                i = i + 2;
                ii = ii + 1;
            end
            handles.sectionslist = inputdlg(cutoff,'Sections Min and Max');
            [filename_sectionslist,path_sectionslist] = uiputfile({'*.txt','txt-file (*.txt)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save as','sections cut off for analysis');
            
            if isequal ([filename_sectionslist,path_sectionslist],[0,0])
                return
            else
                dlmwrite (fullfile (path_sectionslist,filename_sectionslist),str2double(handles.sectionslist));
            end
        end
        %% end of second else if
        
    end
end

%% Deviding the spectra according to the requested wavenumber regions.
if (isempty(wavenumbercutoff) || ~any(wavenumbercutoff))
    return
else
    if ~isempty(handles.sectionslist)
        
        j = 1;
        waitbar1 = waitbar(0,'Please wait...');
        i = 1;
        handles.popupmenu2_string = [];
        
        while i < handles.numofsections*2+1
            sectiondata = handles.spectra_sectioned.section0;
            sectiondata_refspec = handles.spectra_sectioned_refspec.section0;
            
            index1 = find (sectiondata(:,1) < str2double(handles.sectionslist(i,1)));
            if ~isempty(index1)
                size_index1 = size(index1);
                sectiondata (index1(1,1):index1(size_index1(1,1),1),:) = [];
                sectiondata_refspec (index1(1,1):index1(size_index1(1,1),1),:) = [];
            end
            
            index2 = find (sectiondata > str2double(handles.sectionslist(i+1,1)));
            if ~isempty(index2)
                size_index2 = size(index2);
                sectiondata (index2(1,1):index2(size_index2(1,1),1),:) = [];
                sectiondata_refspec (index2(1,1):index2(size_index2(1,1),1),:) = [];
            end
            
            handles.spectra_sectioned.(strcat('section',num2str(j))) = sectiondata;
            handles.spectra_sectioned_refspec.(strcat('section',num2str(j))) = sectiondata_refspec;
            
            size_uitable2 = size(sectiondata);
            mysparse1 = zeros(size_uitable2(1,1),size_uitable2(1,2)-1);
            
            handles.allrefsubtracted.(strcat('section',num2str(j))) = mysparse1;%zeros
            handles.sumofscaledrefspec.(strcat('section',num2str(j))) = mysparse1;%zeros
            
            handles.uitable4_Data.(strcat('section',num2str(j))) = handles.mysparse2;
            
            handles.popupmenu2_string = [handles.popupmenu2_string;...
                strcat(handles.sectionslist(i,1),'-',handles.sectionslist(i+1,1),...
                ' (cm^-1)')];
            
            waitbar(i / handles.numofsections);
            i = i + 2;
            j = j+1;
        end
        close(waitbar1);
        
        handles.popupmenu2_string = ['whole wavenumber 700-4000 (cm^-1)';handles.popupmenu2_string];
        handles.popupmenu2.String = handles.popupmenu2_string;
    end
end
    

guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, ~, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
if (isempty(handles.editt1.String) && isempty(handles.editt2.String) && ...
        isempty(handles.editt3.String) && isempty(handles.editt4.String) && ...
        isempty(handles.editt5.String) &&  isempty(handles.editt6.String) && ...
        isempty(handles.editt7.String) &&  isempty(handles.editt8.String) && ...
        isempty(handles.editt9.String) &&  isempty(handles.editt10.String) && ...
        isempty(handles.editt11.String) &&  isempty(handles.editt12.String) && ...
        isempty(handles.editt13.String) &&  isempty(handles.editt14.String) && ...
        isempty(handles.editt15.String) &&  isempty(handles.editt16.String) && ...
        isempty(handles.editt17.String) &&  isempty(handles.editt18.String))
    
    (errordlg('You have not indentified any refrence spectra yet'));
    handles.popupmenu1.Value = 1;
else
    j = handles.popupmenu2.Value - 1;
    if handles.popupmenu1.Value > 1
        
        [ handles ] = photolysis_analyzer_updater(handles,'update2',1);
        
        handles.laserspectra = handles.uitable2.Data(:,handles.popupmenu1.Value);
        
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j)))(:,handles.popupmenu1.Value-1))
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.popupmenu1.String(handles.popupmenu1.Value,1));
        xlim (handles.xlim1);
        
    else
        handles.laserspectra = handles.uitable2.Data(:,2:end);
        
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))))
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.popupmenu1.String(2:end,1));
        xlim (handles.xlim1);
    end
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, ~, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
j = handles.popupmenu2.Value - 1;
handles.uitable2.Data = handles.spectra_sectioned.(strcat('section',num2str(j)));

set(handles.uitable2,'ColumnEditable',true(1,handles.size_uitable2(1,2)));
handles.uitable3.Data = handles.spectra_sectioned_refspec.(strcat('section',num2str(j)));
size_uitable3 = size(handles.uitable3.Data);
set(handles.uitable3,'ColumnEditable',true(1,size_uitable3(1,2)));

handles.x1 = handles.uitable2.Data(:,1);
handles.min1 = min(handles.x1);
handles.max1 = max(handles.x1);

handles.laserspectra = handles.uitable2.Data(:,2:end);
handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));

size_refspec = size(handles.uitable3.Data);
handles.zero_refspec = zeros(size_refspec(1,1),1);%zeros

for i = 1:18
    if isempty(handles.(strcat('editt',num2str(i))).String)
        handles.(strcat('refspec',num2str(i))) = handles.zero_refspec;
    else
        [index_x,index_y] = find(strcmpi(handles.uitable3.ColumnName,...
            strtrim(handles.(strcat('editt',num2str(i))).String)));
        if isempty([index_x,index_y])
            errordlg('Refrence spectra could not be found');
        else
            handles.(strcat('refspec',num2str(i))) = handles.uitable3.Data(:,index_x);
            handles.(strcat('chk',num2str(i))).String = ...
                handles.(strcat('editt',num2str(i))).String;
            handles.(strcat('chk',num2str(i))).Value = 1;
        end
    end
end

if handles.popupmenu1.Value > 1
    [ handles ] = photolysis_analyzer_updater( handles,'update2',1);

    
    handles.laserspectra = handles.uitable2.Data(:,handles.popupmenu1.Value);
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    axes(handles.axes2)
    plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j)))(:,handles.popupmenu1.Value-1))
    title ('All refspec subtracted');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    legend(handles.popupmenu1.String(handles.popupmenu1.Value,1));
    xlim ([handles.min1 handles.max1]);
    
else
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    axes(handles.axes2)
    plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))))
    title ('All refspec subtracted');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    legend(handles.popupmenu1.String(2:end,1));
    xlim ([handles.min1 handles.max1]);
end

[ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
[ handles ] = photolysis_analyzer_updater( handles,'plot3',1);


guidata(hObject, handles);



function editt1_Callback(hObject, ~, handles)
% hObject    handle to editt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt1 as text
%        str2double(get(hObject,'String')) returns contents of editt1 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',1);
    
end

guidata(hObject, handles);


function edit1_Callback(hObject, ~, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit11 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',1);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',1);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto1.
function pbauto1_Callback(hObject, ~, handles)
% hObject    handle to pbauto1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit11 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',1);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',1);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',1);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',1);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt2_Callback(hObject, ~, handles)
% hObject    handle to editt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt2 as text
%        str2double(get(hObject,'String')) returns contents of editt2 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',2);
end

guidata(hObject, handles);


function edit2_Callback(hObject, ~, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit22 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',2);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',2);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',2);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto2.
function pbauto2_Callback(hObject, ~, handles)
% hObject    handle to pbauto2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit22 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',2);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',2);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',2);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',2);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',2);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt3_Callback(hObject, ~, handles)
% hObject    handle to editt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt3 as text
%        str2double(get(hObject,'String')) returns contents of editt3 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',3);
    
end

guidata(hObject, handles);


function edit3_Callback(hObject, ~, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit33 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',3);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',3);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',3);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto3.
function pbauto3_Callback(hObject, ~, handles)
% hObject    handle to pbauto3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit33 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',3);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',3);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',3);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',3);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',3);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);




function editt4_Callback(hObject, ~, handles)
% hObject    handle to editt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of editt4 as text
%        str2double(get(hObject,'String')) returns contents of editt4 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',4);
end


guidata(hObject, handles);


function edit4_Callback(hObject, ~, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit44 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',4);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',4);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',4);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto4.
function pbauto4_Callback(hObject, ~, handles)
% hObject    handle to pbauto4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit44 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',4);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',4);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',4);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',4);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',4);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt5_Callback(hObject, ~, handles)
% hObject    handle to editt5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt5 as text
%        str2double(get(hObject,'String')) returns contents of editt5 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',5);
end

guidata(hObject, handles);


function edit5_Callback(hObject, ~, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit55 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',5);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',5);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',5);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto5.
function pbauto5_Callback(hObject, ~, handles)
% hObject    handle to pbauto5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit55 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',5);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',5);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',5);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',5);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',5);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);



function editt6_Callback(hObject, ~, handles)
% hObject    handle to editt6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt6 as text
%        str2double(get(hObject,'String')) returns contents of editt6 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',6);
end

guidata(hObject, handles);


function edit6_Callback(hObject, ~, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit66 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',6);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',6);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',6);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto6.
function pbauto6_Callback(hObject, ~, handles)
% hObject    handle to pbauto6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit66 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',6);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',6);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',6);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',6);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',6);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);




function editt7_Callback(hObject, ~, handles)
% hObject    handle to editt7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt7 as text
%        str2double(get(hObject,'String')) returns contents of editt7 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',7);
    
end

guidata(hObject, handles);


function edit7_Callback(hObject, ~, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit77 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',7);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',7);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',7);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto7.
function pbauto7_Callback(hObject, ~, handles)
% hObject    handle to pbauto7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit77 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',7);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',7);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',7);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',7);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',7);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);




function editt8_Callback(hObject, ~, handles)
% hObject    handle to editt8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt8 as text
%        str2double(get(hObject,'String')) returns contents of editt8 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',8);
end

guidata(hObject, handles);


function edit8_Callback(hObject, ~, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit88 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',8);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',8);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',8);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto8.
function pbauto8_Callback(hObject, ~, handles)
% hObject    handle to pbauto8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit88 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',8);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',8);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',8);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',8);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',8);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt9_Callback(hObject, ~, handles)
% hObject    handle to editt9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt9 as text
%        str2double(get(hObject,'String')) returns contents of editt9 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',9);
end

guidata(hObject, handles);


function edit9_Callback(hObject, ~, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit99 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',9);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',9);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',9);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto9.
function pbauto9_Callback(hObject, ~, handles)
% hObject    handle to pbauto9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit99 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',9);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',9);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',9);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',9);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',9);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt10_Callback(hObject, ~, handles)
% hObject    handle to editt10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt10 as text
%        str2double(get(hObject,'String')) returns contents of editt10 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',10);
end

guidata(hObject, handles);


function edit10_Callback(hObject, ~, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1010 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',10);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',10);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',10);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto10.
function pbauto10_Callback(hObject, ~, handles)
% hObject    handle to pbauto10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1010 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',10);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',10);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',10);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',10);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',10);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt11_Callback(hObject, ~, handles)
% hObject    handle to editt11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt11 as text
%        str2double(get(hObject,'String')) returns contents of editt11 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',11);
end


guidata(hObject, handles);


function edit11_Callback(hObject, ~, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1111 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',11);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',11);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',11);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto11.
function pbauto11_Callback(hObject, ~, handles)
% hObject    handle to pbauto11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1111 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',11);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',11);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',11);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',11);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',11);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt12_Callback(hObject, ~, handles)
% hObject    handle to editt12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt12 as text
%        str2double(get(hObject,'String')) returns contents of editt12 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',12);
    
end

guidata(hObject, handles);


function edit12_Callback(hObject, ~, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1212 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',12);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',12);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',12);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);


% --- Executes on button press in pbauto12.
function pbauto12_Callback(hObject, ~, handles)
% hObject    handle to pbauto12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1212 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',12);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',12);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',12);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',12);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',12);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt13_Callback(hObject, ~, handles)
% hObject    handle to editt13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt13 as text
%        str2double(get(hObject,'String')) returns contents of editt13 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',13);
    
end

guidata(hObject, handles);


function edit13_Callback(hObject, ~, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1313 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',13);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',13);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',13);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto13.
function pbauto13_Callback(hObject, ~, handles)
% hObject    handle to pbauto13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1313 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',13);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',13);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',13);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',13);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',13);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt14_Callback(hObject, ~, handles)
% hObject    handle to editt14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt14 as text
%        str2double(get(hObject,'String')) returns contents of editt14 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',14);
end

guidata(hObject, handles);


function edit14_Callback(hObject, ~, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1414 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',14);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',14);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',14);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto14.
function pbauto14_Callback(hObject, ~, handles)
% hObject    handle to pbauto14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1414 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',14);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',14);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',14);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',14);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',14);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt15_Callback(hObject, ~, handles)
% hObject    handle to editt15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt15 as text
%        str2double(get(hObject,'String')) returns contents of editt15 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',15);
end

guidata(hObject, handles);


function edit15_Callback(hObject, ~, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1515 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',15);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',15);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',15);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto15.
function pbauto15_Callback(hObject, ~, handles)
% hObject    handle to pbauto15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1515 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',15);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',15);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',15);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',15);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',15);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt16_Callback(hObject, ~, handles)
% hObject    handle to editt16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt16 as text
%        str2double(get(hObject,'String')) returns contents of editt16 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',16);
end

guidata(hObject, handles);


function edit16_Callback(hObject, ~, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1616 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',16);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',16);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',16);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto16.
function pbauto16_Callback(hObject, ~, handles)
% hObject    handle to pbauto16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1616 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',16);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',16);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',16);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',16);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',16);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt17_Callback(hObject, ~, handles)
% hObject    handle to editt17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt17 as text
%        str2double(get(hObject,'String')) returns contents of editt17 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',17);
    
end

guidata(hObject, handles);


function edit17_Callback(hObject, ~, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1717 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',17);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',17);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',17);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto17.
function pbauto17_Callback(hObject, ~, handles)
% hObject    handle to pbauto17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1717 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',17);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',17);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',17);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',17);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',17);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




function editt18_Callback(hObject, ~, handles)
% hObject    handle to editt18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editt18 as text
%        str2double(get(hObject,'String')) returns contents of editt18 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update4',18);
end

guidata(hObject, handles);


function edit18_Callback(hObject, ~, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1818 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'update3',18);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',18);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',18);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);


% --- Executes on button press in pbauto18.
function pbauto18_Callback(hObject, ~, handles)
% hObject    handle to pbauto18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.counter2 == 0
    uiwait(errordlg('You should first load both photolysis and reference spectra files'));
elseif handles.popupmenu1.Value == 1
    uiwait(errordlg('You should first choose the spectrum of interest'));
elseif handles.counter_edit1818 == 0
    uiwait(errordlg('You should indentify the reference spectra first.'));
else
    [ handles ] = photolysis_analyzer_updater( handles,'fig1',1,'numofspec',18);
    [ handles ] = photolysis_analyzer_updater( handles,'pbauto',18);
    
    [ handles ] = photolysis_analyzer_updater( handles,'update3',18);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',18);
    
    j = handles.popupmenu2.Value - 1;
    handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1,'numofspec',18);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    
end

guidata(hObject, handles);



% --- Executes on button press in pb_facoeffs.
function pb_facoeffs_Callback(hObject, ~, handles)
% hObject    handle to pb_facoeffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% size1 = size (handles.x1);
% zero1 = zeros(size1);
% handles.refspec3 = zero1;
handles.counter3 = handles.counter3 + 1;

if handles.counter1 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter2 == 0
    errordlg('You should first load both photolysis and reference spectra files');
else
    sizefn2 = size(handles.uitable2.Data(:,1));
    handles.zerofn2 = zeros(sizefn2);%zeros
    
    handles.refsubtracted = handles.zerofn2;
    refspecforplot_data = handles.zerofn2;
    refspecforplot_legend = cell(18,1);
    for k = 1:18
        refspecforplot_data(:,k) = handles.(strcat('refspec',num2str(k)));
        
        refspecforplot_legend(k,1) = cellstr(handles.(strcat('editt',num2str(k))).String);     
    end
    figure(2)
    plot(handles.x1,refspecforplot_data,handles.x1,handles.laserspectra)
    legend(refspecforplot_legend);

    uiwait(msgbox('Find the wavenumber limits and then press enter','GUIDE'));
    
    minmax = inputdlg({'Minimum','Maximum'},'Wavenumber max and min for reference spectra subtraction',[1 20;1 20]);
    if ~isempty(minmax)
        
        j = handles.popupmenu2.Value - 1;
        
        handles.laserspectra_forfitting = handles.laserspectra;
        
        for k = 1:18
            if handles.(strcat('chk',num2str(k))).Value == 0
                handles.(strcat('refspecfit',num2str(k))) = handles.zerofn2;
            else
                handles.(strcat('refspecfit',num2str(k))) = handles.(strcat('refspec',num2str(k)));
            end
        end
        
        allrefspec = [handles.refspecfit1,handles.refspecfit2,...
            handles.refspecfit3,handles.refspecfit4,handles.refspecfit5,...
            handles.refspecfit6,handles.refspecfit7,handles.refspecfit8,...
            handles.refspecfit9,handles.refspecfit10,handles.refspecfit11,...
            handles.refspecfit12,handles.refspecfit13,handles.refspecfit14,...
            handles.refspecfit15,handles.refspecfit16,handles.refspecfit17,...
            handles.refspecfit18];
        
        min1 = str2double(minmax(1,1));
        max1 = str2double(minmax(2,1));
        
        index1 = find (handles.x1 < min1 );
        if isempty(index1) == 0
            size_index1 = size(index1);
            allrefspec (index1(1,1):index1(size_index1(1,1),1),:) = [];
            handles.laserspectra_forfitting(index1(1,1):index1(size_index1(1,1),1),:) = [];
        end
        
        index2 = find (handles.x1 > max1 );
        if isempty(index2) == 0
            size_index2 = size(index2);
            allrefspec (index2(1,1):index2(size_index2(1,1),1),:) = [];
            handles.laserspectra_forfitting(index2(1,1):index2(size_index2(1,1),1),:) = [];
        end
        
        handles.uitable1_Data = zeros((handles.size_uitable2(1,2) - 1),36);
        
        lb = [-0.5;0;0;0;0;0;0;0;0;...
            0;0;0;0;0;0;0;0;0];
        ub = [0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;...
            0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5;0.5];
        %             options = optimoptions('fmincon','FinDiffType','central','TolX',1e-30);
        
        %% start fitting
        if handles.popupmenu1.Value > 1
            
            laserspectra = handles.laserspectra_forfitting;
            %% Linear fittings
            [coeffs_linear,~,~,~,output_linear,~] = lsqlin (allrefspec,laserspectra,[],[],[],[],lb,ub);
            %                 [coeffs_linear2,resnorm2,residual2,exitflag2,output2,lambda2] = lsqnonneg(allrefspec,laserspectra);
            %% nonlinear fitting
            [coeffs_nonlinear,~,~,output_nonlinear,~,~,~] = fmincon(@(c) sqrError2(c,laserspectra,...
                allrefspec),...
                [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]...
                ,[],[],[],[],lb,ub,[]);%,options
            %coeffs_nonlinear,fval,exitflag,output_nonlinear,lambda,grad,hessian]
            
            i = handles.popupmenu1.Value - 1;
            
            handles.(strcat('spectra',num2str(i))).message_output_linear.(strcat('section',num2str(j))) = output_linear.message;
            handles.(strcat('spectra',num2str(i))).message_output_nonlinear.(strcat('section',num2str(j))) = output_nonlinear.message;
            
            n = 1;
            for k = 1:18
                handles.uitable1_Data(i,n) = coeffs_linear(k);
                handles.uitable1_Data(i,n+1) = coeffs_nonlinear(k);
                n = n + 2;
            end
            
        else
            numofloop = handles.size_uitable2(1,2) - 1;
            
            waitbar1 = waitbar(0,'Please wait...');
            for i = 1:numofloop
                %% Linear fittings
                laserspectra = handles.laserspectra_forfitting(:,i);
                
                [coeffs_linear,~,~,~,output_linear,~] = lsqlin (allrefspec,laserspectra,[],[],[],[],lb,ub);
                %                 [coeffs_linear2,resnorm2,residual2,exitflag2,output2,lambda2] = lsqnonneg(allrefspec,laserspectra);
                %% nonlinear fitting
                [coeffs_nonlinear,~,~,output_nonlinear,~,~,~] = fmincon(@(c) sqrError2(c,laserspectra,...
                    allrefspec),...
                    [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]...
                    ,[],[],[],[],lb,ub,[]);%,options
                %% output message
                handles.(strcat('spectra',num2str(i))).message_output_linear.(strcat('section',num2str(j))) = output_linear.message;
                handles.(strcat('spectra',num2str(i))).message_output_nonlinear.(strcat('section',num2str(j))) = output_nonlinear.message;
                
                n = 1;
                for k = 1:18
                    handles.uitable1_Data(i,n) = coeffs_linear(k);
                    handles.uitable1_Data(i,n+1) = coeffs_nonlinear(k);
                    n = n + 2;
                end
                %%
                waitbar(i / (handles.size_uitable2(1,2) - 1));
            end
            close(waitbar1);
        end
        
    end
    %% column name of uitable1
    handles.uitable1_ColumnName = cell(1,36);
    
    n = 1;
    for m = 1:18
        if handles.(strcat('chk',num2str(m))).Value == 1
            handles.uitable1_ColumnName{n} = strcat((handles.(strcat('editt',num2str(m))).String),'-linear');
            handles.uitable1_ColumnName{n+1} = strcat((handles.(strcat('editt',num2str(m))).String),'-nonlinear');
        end
        n = n + 2;
    end
    %%
    set (handles.uitable1,'Data',handles.uitable1_Data,...
        'ColumnName',handles.uitable1_ColumnName,...
        'RowName',handles.uitable2.ColumnName(2:end,1));
end

guidata(hObject, handles);



% --- Executes on button press in pb_setlinear.
function pb_setlinear_Callback(hObject, ~, handles)
% hObject    handle to pb_setlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.counter3 == 0
    errordlg('You should find the coefficients first');
else
    [ handles ] = photolysis_analyzer_updater( handles,'setlinnonlin',1);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',1);
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end
guidata(hObject, handles);




% --- Executes on button press in pb_setnonlinear.
function pb_setnonlinear_Callback(hObject, ~, handles)
% hObject    handle to pb_setnonlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter3 == 0
    errordlg('You should find the coefficients first');
else
    [ handles ] = photolysis_analyzer_updater( handles,'setlinnonlin',2);
    [ handles ] = photolysis_analyzer_updater( handles,'update1',1);
    
    [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot2',1);
    [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
end

guidata(hObject, handles);




% --------------------------------------------------------------------
function pb_loadexistingscales_ClickedCallback(hObject, ~, handles)
% hObject    handle to pb_loadexistingscales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter2 == 0
    errordlg('You should first load both photolysis and reference spectra files');
else
    [filenames2,pathname2] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load exsiting scale factor file','Coefficients.txt');
    if isequal([filenames2,pathname2] , [0,0])
        return
    else
        j = handles.popupmenu2.Value - 1;
        allscales = importdata(strcat (pathname2,filenames2));
        handles.uitable4_Data.(strcat('section',num2str(j))) = allscales.data;
        handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
        
        size_allscales_textdata = size (allscales.textdata(1,2:end));
        for i = 1:size_allscales_textdata(1,2)
            %                     handles.uitable4.ColumnName{i} = allscales.textdata{1,i+1};
            handles.(strcat('editt',num2str(i))).String = allscales.textdata{1,i+1};
            [ handles ] = photolysis_analyzer_updater( handles,'update4',i);
        end
        
        [ handles ] = photolysis_analyzer_updater( handles,'update1',1);
        
        [ handles ] = photolysis_analyzer_updater( handles,'plot1',1);
        
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))))
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.popupmenu1.String(2:end,1));
        xlim ([handles.min1 handles.max1]);
        
        [ handles ] = photolysis_analyzer_updater( handles,'plot3',1);
    end
end


guidata(hObject, handles);



% --------------------------------------------------------------------
function pb_loadsimulatedspectra_ClickedCallback(hObject, ~, handles)
% hObject    handle to pb_loadsimulatedspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter2 == 0
    errordlg('You should first load both photolysis and reference spectra files');
else
    handles.counter4 = handles.counter4 + 1;
    
    handles.wavenumber_simulated = [800;800.750187546887;801.500375093774;802.250562640660;803.000750187547;803.750937734434;804.501125281321;805.251312828207;806.001500375094;806.751687921981;807.501875468868;808.252063015754;809.002250562641;809.752438109528;810.502625656415;811.252813203302;812.003000750188;812.753188297075;813.503375843962;814.253563390849;815.003750937735;815.753938484622;816.504126031509;817.254313578396;818.004501125282;818.754688672169;819.504876219056;820.255063765943;821.005251312829;821.755438859716;822.505626406603;823.255813953490;824.006001500376;824.756189047263;825.506376594150;826.256564141037;827.006751687924;827.756939234810;828.507126781697;829.257314328584;830.007501875471;830.757689422357;831.507876969244;832.258064516131;833.008252063018;833.758439609904;834.508627156791;835.258814703678;836.009002250565;836.759189797451;837.509377344338;838.259564891225;839.009752438112;839.759939984999;840.510127531885;841.260315078772;842.010502625659;842.760690172546;843.510877719432;844.261065266319;845.011252813206;845.761440360093;846.511627906979;847.261815453866;848.012003000753;848.762190547640;849.512378094526;850.262565641413;851.012753188300;851.762940735187;852.513128282074;853.263315828960;854.013503375847;854.763690922734;855.513878469621;856.264066016507;857.014253563394;857.764441110281;858.514628657168;859.264816204054;860.015003750941;860.765191297828;861.515378844715;862.265566391601;863.015753938488;863.765941485375;864.516129032262;865.266316579149;866.016504126035;866.766691672922;867.516879219809;868.267066766696;869.017254313582;869.767441860469;870.517629407356;871.267816954243;872.018004501129;872.768192048016;873.518379594903;874.268567141790;875.018754688676;875.768942235563;876.519129782450;877.269317329337;878.019504876223;878.769692423110;879.519879969997;880.270067516884;881.020255063771;881.770442610657;882.520630157544;883.270817704431;884.021005251318;884.771192798204;885.521380345091;886.271567891978;887.021755438865;887.771942985751;888.522130532638;889.272318079525;890.022505626412;890.772693173298;891.522880720185;892.273068267072;893.023255813959;893.773443360846;894.523630907732;895.273818454619;896.024006001506;896.774193548393;897.524381095279;898.274568642166;899.024756189053;899.774943735940;900.525131282826;901.275318829713;902.025506376600;902.775693923487;903.525881470373;904.276069017260;905.026256564147;905.776444111034;906.526631657921;907.276819204807;908.027006751694;908.777194298581;909.527381845468;910.277569392354;911.027756939241;911.777944486128;912.528132033015;913.278319579901;914.028507126788;914.778694673675;915.528882220562;916.279069767448;917.029257314335;917.779444861222;918.529632408109;919.279819954995;920.030007501882;920.780195048769;921.530382595656;922.280570142543;923.030757689429;923.780945236316;924.531132783203;925.281320330090;926.031507876976;926.781695423863;927.531882970750;928.282070517637;929.032258064523;929.782445611410;930.532633158297;931.282820705184;932.033008252070;932.783195798957;933.533383345844;934.283570892731;935.033758439618;935.783945986504;936.534133533391;937.284321080278;938.034508627165;938.784696174051;939.534883720938;940.285071267825;941.035258814712;941.785446361598;942.535633908485;943.285821455372;944.036009002259;944.786196549145;945.536384096032;946.286571642919;947.036759189806;947.786946736693;948.537134283579;949.287321830466;950.037509377353;950.787696924240;951.537884471126;952.288072018013;953.038259564900;953.788447111787;954.538634658673;955.288822205560;956.039009752447;956.789197299334;957.539384846220;958.289572393107;959.039759939994;959.789947486881;960.540135033768;961.290322580654;962.040510127541;962.790697674428;963.540885221315;964.291072768201;965.041260315088;965.791447861975;966.541635408862;967.291822955748;968.042010502635;968.792198049522;969.542385596409;970.292573143295;971.042760690182;971.792948237069;972.543135783956;973.293323330842;974.043510877729;974.793698424616;975.543885971503;976.294073518390;977.044261065276;977.794448612163;978.544636159050;979.294823705937;980.045011252823;980.795198799710;981.545386346597;982.295573893484;983.045761440370;983.795948987257;984.546136534144;985.296324081031;986.046511627917;986.796699174804;987.546886721691;988.297074268578;989.047261815465;989.797449362351;990.547636909238;991.297824456125;992.048012003012;992.798199549898;993.548387096785;994.298574643672;995.048762190559;995.798949737445;996.549137284332;997.299324831219;998.049512378106;998.799699924992;999.549887471879;1000.30007501877;1001.05026256565;1001.80045011254;1002.55063765943;1003.30082520631;1004.05101275320;1004.80120030009;1005.55138784697;1006.30157539386;1007.05176294075;1007.80195048763;1008.55213803452;1009.30232558141;1010.05251312829;1010.80270067518;1011.55288822207;1012.30307576895;1013.05326331584;1013.80345086273;1014.55363840961;1015.30382595650;1016.05401350339;1016.80420105027;1017.55438859716;1018.30457614405;1019.05476369094;1019.80495123782;1020.55513878471;1021.30532633160;1022.05551387848;1022.80570142537;1023.55588897226;1024.30607651914;1025.05626406603;1025.80645161292;1026.55663915980;1027.30682670669;1028.05701425358;1028.80720180046;1029.55738934735;1030.30757689424;1031.05776444112;1031.80795198801;1032.55813953490;1033.30832708178;1034.05851462867;1034.80870217556;1035.55888972244;1036.30907726933;1037.05926481622;1037.80945236310;1038.55963990999;1039.30982745688;1040.06001500376;1040.81020255065;1041.56039009754;1042.31057764442;1043.06076519131;1043.81095273820;1044.56114028509;1045.31132783197;1046.06151537886;1046.81170292575;1047.56189047263;1048.31207801952;1049.06226556641;1049.81245311329;1050.56264066018;1051.31282820707;1052.06301575395;1052.81320330084;1053.56339084773;1054.31357839461;1055.06376594150;1055.81395348839;1056.56414103527;1057.31432858216;1058.06451612905;1058.81470367593;1059.56489122282;1060.31507876971;1061.06526631659;1061.81545386348;1062.56564141037;1063.31582895725;1064.06601650414;1064.81620405103;1065.56639159791;1066.31657914480;1067.06676669169;1067.81695423857;1068.56714178546;1069.31732933235;1070.06751687924;1070.81770442612;1071.56789197301;1072.31807951990;1073.06826706678;1073.81845461367;1074.56864216056;1075.31882970744;1076.06901725433;1076.81920480122;1077.56939234810;1078.31957989499;1079.06976744188;1079.81995498876;1080.57014253565;1081.32033008254;1082.07051762942;1082.82070517631;1083.57089272320;1084.32108027008;1085.07126781697;1085.82145536386;1086.57164291074;1087.32183045763;1088.07201800452;1088.82220555140;1089.57239309829;1090.32258064518;1091.07276819206;1091.82295573895;1092.57314328584;1093.32333083272;1094.07351837961;1094.82370592650;1095.57389347339;1096.32408102027;1097.07426856716;1097.82445611405;1098.57464366093;1099.32483120782;1100.07501875471;1100.82520630159;1101.57539384848;1102.32558139537;1103.07576894225;1103.82595648914;1104.57614403603;1105.32633158291;1106.07651912980;1106.82670667669;1107.57689422357;1108.32708177046;1109.07726931735;1109.82745686423;1110.57764441112;1111.32783195801;1112.07801950489;1112.82820705178;1113.57839459867;1114.32858214555;1115.07876969244;1115.82895723933;1116.57914478621;1117.32933233310;1118.07951987999;1118.82970742687;1119.57989497376;1120.33008252065;1121.08027006754;1121.83045761442;1122.58064516131;1123.33083270820;1124.08102025508;1124.83120780197;1125.58139534886;1126.33158289574;1127.08177044263;1127.83195798952;1128.58214553640;1129.33233308329;1130.08252063018;1130.83270817706;1131.58289572395;1132.33308327084;1133.08327081772;1133.83345836461;1134.58364591150;1135.33383345838;1136.08402100527;1136.83420855216;1137.58439609904;1138.33458364593;1139.08477119282;1139.83495873970;1140.58514628659;1141.33533383348;1142.08552138036;1142.83570892725;1143.58589647414;1144.33608402102;1145.08627156791;1145.83645911480;1146.58664666168;1147.33683420857;1148.08702175546;1148.83720930235;1149.58739684923;1150.33758439612;1151.08777194301;1151.83795948989;1152.58814703678;1153.33833458367;1154.08852213055;1154.83870967744;1155.58889722433;1156.33908477121;1157.08927231810;1157.83945986499;1158.58964741187;1159.33983495876;1160.09002250565;1160.84021005253;1161.59039759942;1162.34058514631;1163.09077269319;1163.84096024008;1164.59114778697;1165.34133533385;1166.09152288074;1166.84171042763;1167.59189797451;1168.34208552140;1169.09227306829;1169.84246061517;1170.59264816206;1171.34283570895;1172.09302325583;1172.84321080272;1173.59339834961;1174.34358589650;1175.09377344338;1175.84396099027;1176.59414853716;1177.34433608404;1178.09452363093;1178.84471117782;1179.59489872470;1180.34508627159;1181.09527381848;1181.84546136536;1182.59564891225;1183.34583645914;1184.09602400602;1184.84621155291;1185.59639909980;1186.34658664668;1187.09677419357;1187.84696174046;1188.59714928734;1189.34733683423;1190.09752438112;1190.84771192800;1191.59789947489;1192.34808702178;1193.09827456866;1193.84846211555;1194.59864966244;1195.34883720932;1196.09902475621;1196.84921230310;1197.59939984998;1198.34958739687;1199.09977494376;1199.84996249065;1200.60015003753;1201.35033758442;1202.10052513131;1202.85071267819;1203.60090022508;1204.35108777197;1205.10127531885;1205.85146286574;1206.60165041263;1207.35183795951;1208.10202550640;1208.85221305329;1209.60240060017;1210.35258814706;1211.10277569395;1211.85296324083;1212.60315078772;1213.35333833461;1214.10352588149;1214.85371342838;1215.60390097527;1216.35408852215;1217.10427606904;1217.85446361593;1218.60465116281;1219.35483870970;1220.10502625659;1220.85521380347;1221.60540135036;1222.35558889725;1223.10577644413;1223.85596399102;1224.60615153791;1225.35633908480;1226.10652663168;1226.85671417857;1227.60690172546;1228.35708927234;1229.10727681923;1229.85746436612;1230.60765191300;1231.35783945989;1232.10802700678;1232.85821455366;1233.60840210055;1234.35858964744;1235.10877719432;1235.85896474121;1236.60915228810;1237.35933983498;1238.10952738187;1238.85971492876;1239.60990247564;1240.36009002253;1241.11027756942;1241.86046511630;1242.61065266319;1243.36084021008;1244.11102775696;1244.86121530385;1245.61140285074;1246.36159039762;1247.11177794451;1247.86196549140;1248.61215303828;1249.36234058517;1250.11252813206;1250.86271567895;1251.61290322583;1252.36309077272;1253.11327831961;1253.86346586649;1254.61365341338;1255.36384096027;1256.11402850715;1256.86421605404;1257.61440360093;1258.36459114781;1259.11477869470;1259.86496624159;1260.61515378847;1261.36534133536;1262.11552888225;1262.86571642913;1263.61590397602;1264.36609152291;1265.11627906979;1265.86646661668;1266.61665416357;1267.36684171045;1268.11702925734;1268.86721680423;1269.61740435111;1270.36759189800;1271.11777944489;1271.86796699177;1272.61815453866;1273.36834208555;1274.11852963243;1274.86871717932;1275.61890472621;1276.36909227310;1277.11927981998;1277.86946736687;1278.61965491376;1279.36984246064;1280.12003000753;1280.87021755442;1281.62040510130;1282.37059264819;1283.12078019508;1283.87096774196;1284.62115528885;1285.37134283574;1286.12153038262;1286.87171792951;1287.62190547640;1288.37209302328;1289.12228057017;1289.87246811706;1290.62265566394;1291.37284321083;1292.12303075772;1292.87321830460;1293.62340585149;1294.37359339838;1295.12378094526;1295.87396849215;1296.62415603904;1297.37434358592;1298.12453113281;1298.87471867970;1299.62490622658;1300.37509377347;1301.12528132036;1301.87546886725;1302.62565641413;1303.37584396102;1304.12603150791;1304.87621905479;1305.62640660168;1306.37659414857;1307.12678169545;1307.87696924234;1308.62715678923;1309.37734433611;1310.12753188300;1310.87771942989;1311.62790697677;1312.37809452366;1313.12828207055;1313.87846961743;1314.62865716432;1315.37884471121;1316.12903225809;1316.87921980498;1317.62940735187;1318.37959489875;1319.12978244564;1319.87996999253;1320.63015753941;1321.38034508630;1322.13053263319;1322.88072018007;1323.63090772696;1324.38109527385;1325.13128282073;1325.88147036762;1326.63165791451;1327.38184546140;1328.13203300828;1328.88222055517;1329.63240810206;1330.38259564894;1331.13278319583;1331.88297074272;1332.63315828960;1333.38334583649;1334.13353338338;1334.88372093026;1335.63390847715;1336.38409602404;1337.13428357092;1337.88447111781;1338.63465866470;1339.38484621158;1340.13503375847;1340.88522130536;1341.63540885224;1342.38559639913;1343.13578394602;1343.88597149290;1344.63615903979;1345.38634658668;1346.13653413356;1346.88672168045;1347.63690922734;1348.38709677422;1349.13728432111;1349.88747186800;1350.63765941488;1351.38784696177;1352.13803450866;1352.88822205555;1353.63840960243;1354.38859714932;1355.13878469621;1355.88897224309;1356.63915978998;1357.38934733687;1358.13953488375;1358.88972243064;1359.63990997753;1360.39009752441;1361.14028507130;1361.89047261819;1362.64066016507;1363.39084771196;1364.14103525885;1364.89122280573;1365.64141035262;1366.39159789951;1367.14178544639;1367.89197299328;1368.64216054017;1369.39234808705;1370.14253563394;1370.89272318083;1371.64291072771;1372.39309827460;1373.14328582149;1373.89347336837;1374.64366091526;1375.39384846215;1376.14403600903;1376.89422355592;1377.64441110281;1378.39459864970;1379.14478619658;1379.89497374347;1380.64516129036;1381.39534883724;1382.14553638413;1382.89572393102;1383.64591147790;1384.39609902479;1385.14628657168;1385.89647411856;1386.64666166545;1387.39684921234;1388.14703675922;1388.89722430611;1389.64741185300;1390.39759939988;1391.14778694677;1391.89797449366;1392.64816204054;1393.39834958743;1394.14853713432;1394.89872468120;1395.64891222809;1396.39909977498;1397.14928732186;1397.89947486875;1398.64966241564;1399.39984996252;1400.15003750941;1400.90022505630;1401.65041260318;1402.40060015007;1403.15078769696;1403.90097524384;1404.65116279073;1405.40135033762;1406.15153788451;1406.90172543139;1407.65191297828;1408.40210052517;1409.15228807205;1409.90247561894;1410.65266316583;1411.40285071271;1412.15303825960;1412.90322580649;1413.65341335337;1414.40360090026;1415.15378844715;1415.90397599403;1416.65416354092;1417.40435108781;1418.15453863469;1418.90472618158;1419.65491372847;1420.40510127535;1421.15528882224;1421.90547636913;1422.65566391601;1423.40585146290;1424.15603900979;1424.90622655667;1425.65641410356;1426.40660165045;1427.15678919733;1427.90697674422;1428.65716429111;1429.40735183799;1430.15753938488;1430.90772693177;1431.65791447866;1432.40810202554;1433.15828957243;1433.90847711932;1434.65866466620;1435.40885221309;1436.15903975998;1436.90922730686;1437.65941485375;1438.40960240064;1439.15978994752;1439.90997749441;1440.66016504130;1441.41035258818;1442.16054013507;1442.91072768196;1443.66091522884;1444.41110277573;1445.16129032262;1445.91147786950;1446.66166541639;1447.41185296328;1448.16204051016;1448.91222805705;1449.66241560394;1450.41260315082;1451.16279069771;1451.91297824460;1452.66316579148;1453.41335333837;1454.16354088526;1454.91372843214;1455.66391597903;1456.41410352592;1457.16429107281;1457.91447861969;1458.66466616658;1459.41485371347;1460.16504126035;1460.91522880724;1461.66541635413;1462.41560390101;1463.16579144790;1463.91597899479;1464.66616654167;1465.41635408856;1466.16654163545;1466.91672918233;1467.66691672922;1468.41710427611;1469.16729182299;1469.91747936988;1470.66766691677;1471.41785446365;1472.16804201054;1472.91822955743;1473.66841710431;1474.41860465120;1475.16879219809;1475.91897974497;1476.66916729186;1477.41935483875;1478.16954238563;1478.91972993252;1479.66991747941;1480.42010502629;1481.17029257318;1481.92048012007;1482.67066766696;1483.42085521384;1484.17104276073;1484.92123030762;1485.67141785450;1486.42160540139;1487.17179294828;1487.92198049516;1488.67216804205;1489.42235558894;1490.17254313582;1490.92273068271;1491.67291822960;1492.42310577648;1493.17329332337;1493.92348087026;1494.67366841714;1495.42385596403;1496.17404351092;1496.92423105780;1497.67441860469;1498.42460615158;1499.17479369846;1499.92498124535;1500.67516879224;1501.42535633912;1502.17554388601;1502.92573143290;1503.67591897978;1504.42610652667;1505.17629407356;1505.92648162044;1506.67666916733;1507.42685671422;1508.17704426111;1508.92723180799;1509.67741935488;1510.42760690177;1511.17779444865;1511.92798199554;1512.67816954243;1513.42835708931;1514.17854463620;1514.92873218309;1515.67891972997;1516.42910727686;1517.17929482375;1517.92948237063;1518.67966991752;1519.42985746441;1520.18004501129;1520.93023255818;1521.68042010507;1522.43060765195;1523.18079519884;1523.93098274573;1524.68117029261;1525.43135783950;1526.18154538639;1526.93173293327;1527.68192048016;1528.43210802705;1529.18229557393;1529.93248312082;1530.68267066771;1531.43285821459;1532.18304576148;1532.93323330837;1533.68342085526;1534.43360840214;1535.18379594903;1535.93398349592;1536.68417104280;1537.43435858969;1538.18454613658;1538.93473368346;1539.68492123035;1540.43510877724;1541.18529632412;1541.93548387101;1542.68567141790;1543.43585896478;1544.18604651167;1544.93623405856;1545.68642160544;1546.43660915233;1547.18679669922;1547.93698424610;1548.68717179299;1549.43735933988;1550.18754688676;1550.93773443365;1551.68792198054;1552.43810952742;1553.18829707431;1553.93848462120;1554.68867216808;1555.43885971497;1556.18904726186;1556.93923480874;1557.68942235563;1558.43960990252;1559.18979744941;1559.93998499629;1560.69017254318;1561.44036009007;1562.19054763695;1562.94073518384;1563.69092273073;1564.44111027761;1565.19129782450;1565.94148537139;1566.69167291827;1567.44186046516;1568.19204801205;1568.94223555893;1569.69242310582;1570.44261065271;1571.19279819959;1571.94298574648;1572.69317329337;1573.44336084025;1574.19354838714;1574.94373593403;1575.69392348091;1576.44411102780;1577.19429857469;1577.94448612157;1578.69467366846;1579.44486121535;1580.19504876223;1580.94523630912;1581.69542385601;1582.44561140289;1583.19579894978;1583.94598649667;1584.69617404356;1585.44636159044;1586.19654913733;1586.94673668422;1587.69692423110;1588.44711177799;1589.19729932488;1589.94748687176;1590.69767441865;1591.44786196554;1592.19804951242;1592.94823705931;1593.69842460620;1594.44861215308;1595.19879969997;1595.94898724686;1596.69917479374;1597.44936234063;1598.19954988752;1598.94973743440;1599.69992498129;1600.45011252818;1601.20030007506;1601.95048762195;1602.70067516884;1603.45086271572;1604.20105026261;1604.95123780950;1605.70142535638;1606.45161290327;1607.20180045016;1607.95198799704;1608.70217554393;1609.45236309082;1610.20255063771;1610.95273818459;1611.70292573148;1612.45311327837;1613.20330082525;1613.95348837214;1614.70367591903;1615.45386346591;1616.20405101280;1616.95423855969;1617.70442610657;1618.45461365346;1619.20480120035;1619.95498874723;1620.70517629412;1621.45536384101;1622.20555138789;1622.95573893478;1623.70592648167;1624.45611402855;1625.20630157544;1625.95648912233;1626.70667666921;1627.45686421610;1628.20705176299;1628.95723930987;1629.70742685676;1630.45761440365;1631.20780195053;1631.95798949742;1632.70817704431;1633.45836459119;1634.20855213808;1634.95873968497;1635.70892723186;1636.45911477874;1637.20930232563;1637.95948987252;1638.70967741940;1639.45986496629;1640.21005251318;1640.96024006006;1641.71042760695;1642.46061515384;1643.21080270072;1643.96099024761;1644.71117779450;1645.46136534138;1646.21155288827;1646.96174043516;1647.71192798204;1648.46211552893;1649.21230307582;1649.96249062270;1650.71267816959;1651.46286571648;1652.21305326336;1652.96324081025;1653.71342835714;1654.46361590402;1655.21380345091;1655.96399099780;1656.71417854468;1657.46436609157;1658.21455363846;1658.96474118534;1659.71492873223;1660.46511627912;1661.21530382600;1661.96549137289;1662.71567891978;1663.46586646667;1664.21605401355;1664.96624156044;1665.71642910733;1666.46661665421;1667.21680420110;1667.96699174799;1668.71717929487;1669.46736684176;1670.21755438865;1670.96774193553;1671.71792948242;1672.46811702931;1673.21830457619;1673.96849212308;1674.71867966997;1675.46886721685;1676.21905476374;1676.96924231063;1677.71942985751;1678.46961740440;1679.21980495129;1679.96999249817;1680.72018004506;1681.47036759195;1682.22055513883;1682.97074268572;1683.72093023261;1684.47111777949;1685.22130532638;1685.97149287327;1686.72168042015;1687.47186796704;1688.22205551393;1688.97224306082;1689.72243060770;1690.47261815459;1691.22280570148;1691.97299324836;1692.72318079525;1693.47336834214;1694.22355588902;1694.97374343591;1695.72393098280;1696.47411852968;1697.22430607657;1697.97449362346;1698.72468117034;1699.47486871723;1700.22505626412;1700.97524381100;1701.72543135789;1702.47561890478;1703.22580645166;1703.97599399855;1704.72618154544;1705.47636909232;1706.22655663921;1706.97674418610;1707.72693173298;1708.47711927987;1709.22730682676;1709.97749437364;1710.72768192053;1711.47786946742;1712.22805701430;1712.97824456119;1713.72843210808;1714.47861965497;1715.22880720185;1715.97899474874;1716.72918229563;1717.47936984251;1718.22955738940;1718.97974493629;1719.72993248317;1720.48012003006;1721.23030757695;1721.98049512383;1722.73068267072;1723.48087021761;1724.23105776449;1724.98124531138;1725.73143285827;1726.48162040515;1727.23180795204;1727.98199549893;1728.73218304581;1729.48237059270;1730.23255813959;1730.98274568647;1731.73293323336;1732.48312078025;1733.23330832713;1733.98349587402;1734.73368342091;1735.48387096779;1736.23405851468;1736.98424606157;1737.73443360845;1738.48462115534;1739.23480870223;1739.98499624912;1740.73518379600;1741.48537134289;1742.23555888978;1742.98574643666;1743.73593398355;1744.48612153044;1745.23630907732;1745.98649662421;1746.73668417110;1747.48687171798;1748.23705926487;1748.98724681176;1749.73743435864;1750.48762190553;1751.23780945242;1751.98799699930;1752.73818454619;1753.48837209308;1754.23855963996;1754.98874718685;1755.73893473374;1756.48912228062;1757.23930982751;1757.98949737440;1758.73968492128;1759.48987246817;1760.24006001506;1760.99024756194;1761.74043510883;1762.49062265572;1763.24081020260;1763.99099774949;1764.74118529638;1765.49137284327;1766.24156039015;1766.99174793704;1767.74193548393;1768.49212303081;1769.24231057770;1769.99249812459;1770.74268567147;1771.49287321836;1772.24306076525;1772.99324831213;1773.74343585902;1774.49362340591;1775.24381095279;1775.99399849968;1776.74418604657;1777.49437359345;1778.24456114034;1778.99474868723;1779.74493623411;1780.49512378100;1781.24531132789;1781.99549887477;1782.74568642166;1783.49587396855;1784.24606151543;1784.99624906232;1785.74643660921;1786.49662415609;1787.24681170298;1787.99699924987;1788.74718679675;1789.49737434364;1790.24756189053;1790.99774943742;1791.74793698430;1792.49812453119;1793.24831207808;1793.99849962496;1794.74868717185;1795.49887471874;1796.24906226562;1796.99924981251;1797.74943735940;1798.49962490628;1799.24981245317;1800.00000000006;1800.75018754694;1801.50037509383;1802.25056264072;1803.00075018760;1803.75093773449;1804.50112528138;1805.25131282826;1806.00150037515;1806.75168792204;1807.50187546892;1808.25206301581;1809.00225056270;1809.75243810958;1810.50262565647;1811.25281320336;1812.00300075024;1812.75318829713;1813.50337584402;1814.25356339090;1815.00375093779;1815.75393848468;1816.50412603157;1817.25431357845;1818.00450112534;1818.75468867223;1819.50487621911;1820.25506376600;1821.00525131289;1821.75543885977;1822.50562640666;1823.25581395355;1824.00600150043;1824.75618904732;1825.50637659421;1826.25656414109;1827.00675168798;1827.75693923487;1828.50712678175;1829.25731432864;1830.00750187553;1830.75768942241;1831.50787696930;1832.25806451619;1833.00825206307;1833.75843960996;1834.50862715685;1835.25881470373;1836.00900225062;1836.75918979751;1837.50937734439;1838.25956489128;1839.00975243817;1839.75993998505;1840.51012753194;1841.26031507883;1842.01050262572;1842.76069017260;1843.51087771949;1844.26106526638;1845.01125281326;1845.76144036015;1846.51162790704;1847.26181545392;1848.01200300081;1848.76219054770;1849.51237809458;1850.26256564147;1851.01275318836;1851.76294073524;1852.51312828213;1853.26331582902;1854.01350337590;1854.76369092279;1855.51387846968;1856.26406601656;1857.01425356345;1857.76444111034;1858.51462865722;1859.26481620411;1860.01500375100;1860.76519129788;1861.51537884477;1862.26556639166;1863.01575393854;1863.76594148543;1864.51612903232;1865.26631657920;1866.01650412609;1866.76669167298;1867.51687921987;1868.26706676675;1869.01725431364;1869.76744186053;1870.51762940741;1871.26781695430;1872.01800450119;1872.76819204807;1873.51837959496;1874.26856714185;1875.01875468873;1875.76894223562;1876.51912978251;1877.26931732939;1878.01950487628;1878.76969242317;1879.51987997005;1880.27006751694;1881.02025506383;1881.77044261071;1882.52063015760;1883.27081770449;1884.02100525137;1884.77119279826;1885.52138034515;1886.27156789203;1887.02175543892;1887.77194298581;1888.52213053269;1889.27231807958;1890.02250562647;1890.77269317335;1891.52288072024;1892.27306826713;1893.02325581401;1893.77344336090;1894.52363090779;1895.27381845468;1896.02400600156;1896.77419354845;1897.52438109534;1898.27456864222;1899.02475618911;1899.77494373600;1900.52513128288;1901.27531882977;1902.02550637666;1902.77569392354;1903.52588147043;1904.27606901732;1905.02625656420;1905.77644411109;1906.52663165798;1907.27681920486;1908.02700675175;1908.77719429864;1909.52738184552;1910.27756939241;1911.02775693930;1911.77794448618;1912.52813203307;1913.27831957996;1914.02850712684;1914.77869467373;1915.52888222062;1916.27906976750;1917.02925731439;1917.77944486128;1918.52963240816;1919.27981995505;1920.03000750194;1920.78019504883;1921.53038259571;1922.28057014260;1923.03075768949;1923.78094523637;1924.53113278326;1925.28132033015;1926.03150787703;1926.78169542392;1927.53188297081;1928.28207051769;1929.03225806458;1929.78244561147;1930.53263315835;1931.28282070524;1932.03300825213;1932.78319579901;1933.53338334590;1934.28357089279;1935.03375843967;1935.78394598656;1936.53413353345;1937.28432108033;1938.03450862722;1938.78469617411;1939.53488372099;1940.28507126788;1941.03525881477;1941.78544636165;1942.53563390854;1943.28582145543;1944.03600900231;1944.78619654920;1945.53638409609;1946.28657164298;1947.03675918986;1947.78694673675;1948.53713428364;1949.28732183052;1950.03750937741;1950.78769692430;1951.53788447118;1952.28807201807;1953.03825956496;1953.78844711184;1954.53863465873;1955.28882220562;1956.03900975250;1956.78919729939;1957.53938484628;1958.28957239316;1959.03975994005;1959.78994748694;1960.54013503382;1961.29032258071;1962.04051012760;1962.79069767448;1963.54088522137;1964.29107276826;1965.04126031514;1965.79144786203;1966.54163540892;1967.29182295580;1968.04201050269;1968.79219804958;1969.54238559646;1970.29257314335;1971.04276069024;1971.79294823713;1972.54313578401;1973.29332333090;1974.04351087779;1974.79369842467;1975.54388597156;1976.29407351845;1977.04426106533;1977.79444861222;1978.54463615911;1979.29482370599;1980.04501125288;1980.79519879977;1981.54538634665;1982.29557389354;1983.04576144043;1983.79594898731;1984.54613653420;1985.29632408109;1986.04651162797;1986.79669917486;1987.54688672175;1988.29707426863;1989.04726181552;1989.79744936241;1990.54763690929;1991.29782445618;1992.04801200307;1992.79819954995;1993.54838709684;1994.29857464373;1995.04876219061;1995.79894973750;1996.54913728439;1997.29932483128;1998.04951237816;1998.79969992505;1999.54988747194;2000.30007501882;2001.05026256571;2001.80045011260;2002.55063765948;2003.30082520637;2004.05101275326;2004.80120030014;2005.55138784703;2006.30157539392;2007.05176294080;2007.80195048769;2008.55213803458;2009.30232558146;2010.05251312835;2010.80270067524;2011.55288822212;2012.30307576901;2013.05326331590;2013.80345086278;2014.55363840967;2015.30382595656;2016.05401350344;2016.80420105033;2017.55438859722;2018.30457614410;2019.05476369099;2019.80495123788;2020.55513878476;2021.30532633165;2022.05551387854;2022.80570142543;2023.55588897231;2024.30607651920;2025.05626406609;2025.80645161297;2026.55663915986;2027.30682670675;2028.05701425363;2028.80720180052;2029.55738934741;2030.30757689429;2031.05776444118;2031.80795198807;2032.55813953495;2033.30832708184;2034.05851462873;2034.80870217561;2035.55888972250;2036.30907726939;2037.05926481627;2037.80945236316;2038.55963991005;2039.30982745693;2040.06001500382;2040.81020255071;2041.56039009759;2042.31057764448;2043.06076519137;2043.81095273825;2044.56114028514;2045.31132783203;2046.06151537891;2046.81170292580;2047.56189047269;2048.31207801958;2049.06226556646;2049.81245311335;2050.56264066023;2051.31282820712;2052.06301575401;2052.81320330089;2053.56339084778;2054.31357839467;2055.06376594155;2055.81395348844;2056.56414103533;2057.31432858221;2058.06451612910;2058.81470367599;2059.56489122287;2060.31507876976;2061.06526631665;2061.81545386353;2062.56564141042;2063.31582895731;2064.06601650419;2064.81620405108;2065.56639159797;2066.31657914485;2067.06676669174;2067.81695423863;2068.56714178551;2069.31732933240;2070.06751687928;2070.81770442617;2071.56789197306;2072.31807951994;2073.06826706683;2073.81845461372;2074.56864216060;2075.31882970749;2076.06901725438;2076.81920480126;2077.56939234815;2078.31957989504;2079.06976744192;2079.81995498881;2080.57014253570;2081.32033008258;2082.07051762947;2082.82070517636;2083.57089272324;2084.32108027013;2085.07126781702;2085.82145536390;2086.57164291079;2087.32183045768;2088.07201800456;2088.82220555145;2089.57239309833;2090.32258064522;2091.07276819211;2091.82295573899;2092.57314328588;2093.32333083277;2094.07351837965;2094.82370592654;2095.57389347343;2096.32408102031;2097.07426856720;2097.82445611409;2098.57464366097;2099.32483120786;2100.07501875475;2100.82520630163;2101.57539384852;2102.32558139541;2103.07576894229;2103.82595648918;2104.57614403607;2105.32633158295;2106.07651912984;2106.82670667673;2107.57689422361;2108.32708177050;2109.07726931738;2109.82745686427;2110.57764441116;2111.32783195804;2112.07801950493;2112.82820705182;2113.57839459870;2114.32858214559;2115.07876969248;2115.82895723936;2116.57914478625;2117.32933233314;2118.07951988002;2118.82970742691;2119.57989497380;2120.33008252068;2121.08027006757;2121.83045761446;2122.58064516134;2123.33083270823;2124.08102025512;2124.83120780200;2125.58139534889;2126.33158289577;2127.08177044266;2127.83195798955;2128.58214553643;2129.33233308332;2130.08252063021;2130.83270817709;2131.58289572398;2132.33308327087;2133.08327081775;2133.83345836464;2134.58364591153;2135.33383345841;2136.08402100530;2136.83420855219;2137.58439609907;2138.33458364596;2139.08477119285;2139.83495873973;2140.58514628662;2141.33533383351;2142.08552138039;2142.83570892728;2143.58589647417;2144.33608402105;2145.08627156794;2145.83645911482;2146.58664666171;2147.33683420860;2148.08702175548;2148.83720930237;2149.58739684926;2150.33758439614;2151.08777194303;2151.83795948992;2152.58814703680;2153.33833458369;2154.08852213058;2154.83870967746;2155.58889722435;2156.33908477124;2157.08927231812;2157.83945986501;2158.58964741190;2159.33983495878;2160.09002250567;2160.84021005256;2161.59039759944;2162.34058514633;2163.09077269322;2163.84096024010;2164.59114778699;2165.34133533387;2166.09152288076;2166.84171042765;2167.59189797453;2168.34208552142;2169.09227306831;2169.84246061519;2170.59264816208;2171.34283570897;2172.09302325585;2172.84321080274;2173.59339834963;2174.34358589651;2175.09377344340;2175.84396099029;2176.59414853717;2177.34433608406;2178.09452363095;2178.84471117783;2179.59489872472;2180.34508627161;2181.09527381849;2181.84546136538;2182.59564891227;2183.34583645915;2184.09602400604;2184.84621155292;2185.59639909981;2186.34658664670;2187.09677419358;2187.84696174047;2188.59714928736;2189.34733683424;2190.09752438113;2190.84771192802;2191.59789947490;2192.34808702179;2193.09827456868;2193.84846211556;2194.59864966245;2195.34883720934;2196.09902475622;2196.84921230311;2197.59939985000;2198.34958739688;2199.09977494377;2199.84996249066;2200.60015003754;2201.35033758443;2202.10052513132;2202.85071267820;2203.60090022509;2204.35108777197;2205.10127531886;2205.85146286575;2206.60165041263;2207.35183795952;2208.10202550641;2208.85221305329;2209.60240060018;2210.35258814707;2211.10277569395;2211.85296324084;2212.60315078773;2213.35333833461;2214.10352588150;2214.85371342839;2215.60390097527;2216.35408852216;2217.10427606905;2217.85446361593;2218.60465116282;2219.35483870971;2220.10502625659;2220.85521380348;2221.60540135037;2222.35558889725;2223.10577644414;2223.85596399102;2224.60615153791;2225.35633908480;2226.10652663168;2226.85671417857;2227.60690172546;2228.35708927234;2229.10727681923;2229.85746436612;2230.60765191300;2231.35783945989;2232.10802700678;2232.85821455366;2233.60840210055;2234.35858964744;2235.10877719432;2235.85896474121;2236.60915228810;2237.35933983498;2238.10952738187;2238.85971492876;2239.60990247564;2240.36009002253;2241.11027756942;2241.86046511630;2242.61065266319;2243.36084021007;2244.11102775696;2244.86121530385;2245.61140285073;2246.36159039762;2247.11177794451;2247.86196549139;2248.61215303828;2249.36234058517;2250.11252813205;2250.86271567894;2251.61290322583;2252.36309077271;2253.11327831960;2253.86346586649;2254.61365341337;2255.36384096026;2256.11402850715;2256.86421605403;2257.61440360092;2258.36459114781;2259.11477869469;2259.86496624158;2260.61515378847;2261.36534133535;2262.11552888224;2262.86571642912;2263.61590397601;2264.36609152290;2265.11627906978;2265.86646661667;2266.61665416356;2267.36684171044;2268.11702925733;2268.86721680422;2269.61740435110;2270.36759189799;2271.11777944488;2271.86796699176;2272.61815453865;2273.36834208554;2274.11852963242;2274.86871717931;2275.61890472620;2276.36909227308;2277.11927981997;2277.86946736686;2278.61965491374;2279.36984246063;2280.12003000751;2280.87021755440;2281.62040510129;2282.37059264817;2283.12078019506;2283.87096774195;2284.62115528883;2285.37134283572;2286.12153038261;2286.87171792949;2287.62190547638;2288.37209302327;2289.12228057015;2289.87246811704;2290.62265566393;2291.37284321081;2292.12303075770;2292.87321830459;2293.62340585147;2294.37359339836;2295.12378094525;2295.87396849213;2296.62415603902;2297.37434358591;2298.12453113279;2298.87471867968;2299.62490622656;2300.37509377345;2301.12528132034;2301.87546886722;2302.62565641411;2303.37584396100;2304.12603150788;2304.87621905477;2305.62640660166;2306.37659414854;2307.12678169543;2307.87696924232;2308.62715678920;2309.37734433609;2310.12753188298;2310.87771942986;2311.62790697675;2312.37809452364;2313.12828207052;2313.87846961741;2314.62865716430;2315.37884471118;2316.12903225807;2316.87921980496;2317.62940735184;2318.37959489873;2319.12978244561;2319.87996999250;2320.63015753939;2321.38034508627;2322.13053263316;2322.88072018005;2323.63090772693;2324.38109527382;2325.13128282071;2325.88147036759;2326.63165791448;2327.38184546137;2328.13203300825;2328.88222055514;2329.63240810203;2330.38259564891;2331.13278319580;2331.88297074269;2332.63315828957;2333.38334583646;2334.13353338335;2334.88372093023;2335.63390847712;2336.38409602401;2337.13428357089;2337.88447111778;2338.63465866466;2339.38484621155;2340.13503375844;2340.88522130532;2341.63540885221;2342.38559639910;2343.13578394598;2343.88597149287;2344.63615903976;2345.38634658664;2346.13653413353;2346.88672168042;2347.63690922730;2348.38709677419;2349.13728432108;2349.88747186796;2350.63765941485;2351.38784696174;2352.13803450862;2352.88822205551;2353.63840960240;2354.38859714928;2355.13878469617;2355.88897224306;2356.63915978994;2357.38934733683;2358.13953488371;2358.88972243060;2359.63990997749;2360.39009752437;2361.14028507126;2361.89047261815;2362.64066016503;2363.39084771192;2364.14103525881;2364.89122280569;2365.64141035258;2366.39159789947;2367.14178544635;2367.89197299324;2368.64216054013;2369.39234808701;2370.14253563390;2370.89272318079;2371.64291072767;2372.39309827456;2373.14328582145;2373.89347336833;2374.64366091522;2375.39384846211;2376.14403600899;2376.89422355588;2377.64441110276;2378.39459864965;2379.14478619654;2379.89497374342;2380.64516129031;2381.39534883720;2382.14553638408;2382.89572393097;2383.64591147786;2384.39609902474;2385.14628657163;2385.89647411852;2386.64666166540;2387.39684921229;2388.14703675918;2388.89722430606;2389.64741185295;2390.39759939984;2391.14778694672;2391.89797449361;2392.64816204050;2393.39834958738;2394.14853713427;2394.89872468116;2395.64891222804;2396.39909977493;2397.14928732181;2397.89947486870;2398.64966241559;2399.39984996247;2400.15003750936;2400.90022505625;2401.65041260313;2402.40060015002;2403.15078769691;2403.90097524379;2404.65116279068;2405.40135033757;2406.15153788445;2406.90172543134;2407.65191297823;2408.40210052511;2409.15228807200;2409.90247561889;2410.65266316577;2411.40285071266;2412.15303825955;2412.90322580643;2413.65341335332;2414.40360090020;2415.15378844709;2415.90397599398;2416.65416354086;2417.40435108775;2418.15453863464;2418.90472618152;2419.65491372841;2420.40510127530;2421.15528882218;2421.90547636907;2422.65566391596;2423.40585146284;2424.15603900973;2424.90622655662;2425.65641410350;2426.40660165039;2427.15678919728;2427.90697674416;2428.65716429105;2429.40735183794;2430.15753938482;2430.90772693171;2431.65791447860;2432.40810202548;2433.15828957237;2433.90847711925;2434.65866466614;2435.40885221303;2436.15903975991;2436.90922730680;2437.65941485369;2438.40960240057;2439.15978994746;2439.90997749435;2440.66016504123;2441.41035258812;2442.16054013501;2442.91072768189;2443.66091522878;2444.41110277567;2445.16129032255;2445.91147786944;2446.66166541633;2447.41185296321;2448.16204051010;2448.91222805699;2449.66241560387;2450.41260315076;2451.16279069765;2451.91297824453;2452.66316579142;2453.41335333830;2454.16354088519;2454.91372843208;2455.66391597896;2456.41410352585;2457.16429107274;2457.91447861962;2458.66466616651;2459.41485371340;2460.16504126028;2460.91522880717;2461.66541635406;2462.41560390094;2463.16579144783;2463.91597899472;2464.66616654160;2465.41635408849;2466.16654163538;2466.91672918226;2467.66691672915;2468.41710427604;2469.16729182292;2469.91747936981;2470.66766691670;2471.41785446358;2472.16804201047;2472.91822955735;2473.66841710424;2474.41860465113;2475.16879219801;2475.91897974490;2476.66916729179;2477.41935483867;2478.16954238556;2478.91972993245;2479.66991747933;2480.42010502622;2481.17029257311;2481.92048011999;2482.67066766688;2483.42085521377;2484.17104276065;2484.92123030754;2485.67141785443;2486.42160540131;2487.17179294820;2487.92198049509;2488.67216804197;2489.42235558886;2490.17254313575;2490.92273068263;2491.67291822952;2492.42310577640;2493.17329332329;2493.92348087018;2494.67366841706;2495.42385596395;2496.17404351084;2496.92423105772;2497.67441860461;2498.42460615150;2499.17479369838;2499.92498124527;2500.67516879216;2501.42535633904;2502.17554388593;2502.92573143282;2503.67591897970;2504.42610652659;2505.17629407348;2505.92648162036;2506.67666916725;2507.42685671414;2508.17704426102;2508.92723180791;2509.67741935480;2510.42760690168;2511.17779444857;2511.92798199545;2512.67816954234;2513.42835708923;2514.17854463611;2514.92873218300;2515.67891972989;2516.42910727677;2517.17929482366;2517.92948237055;2518.67966991743;2519.42985746432;2520.18004501121;2520.93023255809;2521.68042010498;2522.43060765187;2523.18079519875;2523.93098274564;2524.68117029253;2525.43135783941;2526.18154538630;2526.93173293319;2527.68192048007;2528.43210802696;2529.18229557385;2529.93248312073;2530.68267066762;2531.43285821450;2532.18304576139;2532.93323330828;2533.68342085516;2534.43360840205;2535.18379594894;2535.93398349582;2536.68417104271;2537.43435858960;2538.18454613648;2538.93473368337;2539.68492123026;2540.43510877714;2541.18529632403;2541.93548387092;2542.68567141780;2543.43585896469;2544.18604651158;2544.93623405846;2545.68642160535;2546.43660915224;2547.18679669912;2547.93698424601;2548.68717179290;2549.43735933978;2550.18754688667;2550.93773443355;2551.68792198044;2552.43810952733;2553.18829707421;2553.93848462110;2554.68867216799;2555.43885971487;2556.18904726176;2556.93923480865;2557.68942235553;2558.43960990242;2559.18979744931;2559.93998499619;2560.69017254308;2561.44036008997;2562.19054763685;2562.94073518374;2563.69092273063;2564.44111027751;2565.19129782440;2565.94148537129;2566.69167291817;2567.44186046506;2568.19204801194;2568.94223555883;2569.69242310572;2570.44261065260;2571.19279819949;2571.94298574638;2572.69317329326;2573.44336084015;2574.19354838704;2574.94373593392;2575.69392348081;2576.44411102770;2577.19429857458;2577.94448612147;2578.69467366836;2579.44486121524;2580.19504876213;2580.94523630902;2581.69542385590;2582.44561140279;2583.19579894968;2583.94598649656;2584.69617404345;2585.44636159034;2586.19654913722;2586.94673668411;2587.69692423099;2588.44711177788;2589.19729932477;2589.94748687165;2590.69767441854;2591.44786196543;2592.19804951231;2592.94823705920;2593.69842460609;2594.44861215297;2595.19879969986;2595.94898724675;2596.69917479363;2597.44936234052;2598.19954988741;2598.94973743429;2599.69992498118;2600.45011252807;2601.20030007495;2601.95048762184;2602.70067516873;2603.45086271561;2604.20105026250;2604.95123780939;2605.70142535627;2606.45161290316;2607.20180045004;2607.95198799693;2608.70217554382;2609.45236309070;2610.20255063759;2610.95273818448;2611.70292573136;2612.45311327825;2613.20330082514;2613.95348837202;2614.70367591891;2615.45386346580;2616.20405101268;2616.95423855957;2617.70442610646;2618.45461365334;2619.20480120023;2619.95498874712;2620.70517629400;2621.45536384089;2622.20555138778;2622.95573893466;2623.70592648155;2624.45611402844;2625.20630157532;2625.95648912221;2626.70667666909;2627.45686421598;2628.20705176287;2628.95723930975;2629.70742685664;2630.45761440353;2631.20780195041;2631.95798949730;2632.70817704419;2633.45836459107;2634.20855213796;2634.95873968485;2635.70892723173;2636.45911477862;2637.20930232551;2637.95948987239;2638.70967741928;2639.45986496617;2640.21005251305;2640.96024005994;2641.71042760683;2642.46061515371;2643.21080270060;2643.96099024749;2644.71117779437;2645.46136534126;2646.21155288814;2646.96174043503;2647.71192798192;2648.46211552880;2649.21230307569;2649.96249062258;2650.71267816946;2651.46286571635;2652.21305326324;2652.96324081012;2653.71342835701;2654.46361590390;2655.21380345078;2655.96399099767;2656.71417854456;2657.46436609144;2658.21455363833;2658.96474118522;2659.71492873210;2660.46511627899;2661.21530382588;2661.96549137276;2662.71567891965;2663.46586646654;2664.21605401342;2664.96624156031;2665.71642910719;2666.46661665408;2667.21680420097;2667.96699174785;2668.71717929474;2669.46736684163;2670.21755438851;2670.96774193540;2671.71792948229;2672.46811702917;2673.21830457606;2673.96849212295;2674.71867966983;2675.46886721672;2676.21905476361;2676.96924231049;2677.71942985738;2678.46961740427;2679.21980495115;2679.96999249804;2680.72018004493;2681.47036759181;2682.22055513870;2682.97074268559;2683.72093023247;2684.47111777936;2685.22130532624;2685.97149287313;2686.72168042002;2687.47186796690;2688.22205551379;2688.97224306068;2689.72243060756;2690.47261815445;2691.22280570134;2691.97299324822;2692.72318079511;2693.47336834200;2694.22355588888;2694.97374343577;2695.72393098266;2696.47411852954;2697.22430607643;2697.97449362332;2698.72468117020;2699.47486871709;2700.22505626398;2700.97524381086;2701.72543135775;2702.47561890463;2703.22580645152;2703.97599399841;2704.72618154529;2705.47636909218;2706.22655663907;2706.97674418595;2707.72693173284;2708.47711927973;2709.22730682661;2709.97749437350;2710.72768192039;2711.47786946727;2712.22805701416;2712.97824456105;2713.72843210793;2714.47861965482;2715.22880720171;2715.97899474859;2716.72918229548;2717.47936984237;2718.22955738925;2718.97974493614;2719.72993248303;2720.48012002991;2721.23030757680;2721.98049512368;2722.73068267057;2723.48087021746;2724.23105776434;2724.98124531123;2725.73143285812;2726.48162040500;2727.23180795189;2727.98199549878;2728.73218304566;2729.48237059255;2730.23255813944;2730.98274568632;2731.73293323321;2732.48312078010;2733.23330832698;2733.98349587387;2734.73368342076;2735.48387096764;2736.23405851453;2736.98424606142;2737.73443360830;2738.48462115519;2739.23480870208;2739.98499624896;2740.73518379585;2741.48537134273;2742.23555888962;2742.98574643651;2743.73593398339;2744.48612153028;2745.23630907717;2745.98649662405;2746.73668417094;2747.48687171783;2748.23705926471;2748.98724681160;2749.73743435849;2750.48762190537;2751.23780945226;2751.98799699915;2752.73818454603;2753.48837209292;2754.23855963981;2754.98874718669;2755.73893473358;2756.48912228047;2757.23930982735;2757.98949737424;2758.73968492113;2759.48987246801;2760.24006001490;2760.99024756178;2761.74043510867;2762.49062265556;2763.24081020244;2763.99099774933;2764.74118529622;2765.49137284310;2766.24156038999;2766.99174793688;2767.74193548376;2768.49212303065;2769.24231057754;2769.99249812442;2770.74268567131;2771.49287321820;2772.24306076508;2772.99324831197;2773.74343585886;2774.49362340574;2775.24381095263;2775.99399849952;2776.74418604640;2777.49437359329;2778.24456114018;2778.99474868706;2779.74493623395;2780.49512378083;2781.24531132772;2781.99549887461;2782.74568642149;2783.49587396838;2784.24606151527;2784.99624906215;2785.74643660904;2786.49662415593;2787.24681170281;2787.99699924970;2788.74718679659;2789.49737434347;2790.24756189036;2790.99774943725;2791.74793698413;2792.49812453102;2793.24831207791;2793.99849962479;2794.74868717168;2795.49887471857;2796.24906226545;2796.99924981234;2797.74943735923;2798.49962490611;2799.24981245300;2799.99999999988;2800.75018754677;2801.50037509366;2802.25056264054;2803.00075018743;2803.75093773432;2804.50112528120;2805.25131282809;2806.00150037498;2806.75168792186;2807.50187546875;2808.25206301564;2809.00225056252;2809.75243810941;2810.50262565630;2811.25281320318;2812.00300075007;2812.75318829696;2813.50337584384;2814.25356339073;2815.00375093762;2815.75393848450;2816.50412603139;2817.25431357828;2818.00450112516;2818.75468867205;2819.50487621893;2820.25506376582;2821.00525131271;2821.75543885959;2822.50562640648;2823.25581395337;2824.00600150025;2824.75618904714;2825.50637659403;2826.25656414091;2827.00675168780;2827.75693923469;2828.50712678157;2829.25731432846;2830.00750187535;2830.75768942223;2831.50787696912;2832.25806451601;2833.00825206289;2833.75843960978;2834.50862715667;2835.25881470355;2836.00900225044;2836.75918979733;2837.50937734421;2838.25956489110;2839.00975243798;2839.75993998487;2840.51012753176;2841.26031507864;2842.01050262553;2842.76069017242;2843.51087771930;2844.26106526619;2845.01125281308;2845.76144035996;2846.51162790685;2847.26181545374;2848.01200300062;2848.76219054751;2849.51237809440;2850.26256564128;2851.01275318817;2851.76294073506;2852.51312828194;2853.26331582883;2854.01350337572;2854.76369092260;2855.51387846949;2856.26406601637;2857.01425356326;2857.76444111015;2858.51462865703;2859.26481620392;2860.01500375081;2860.76519129769;2861.51537884458;2862.26556639147;2863.01575393835;2863.76594148524;2864.51612903213;2865.26631657901;2866.01650412590;2866.76669167279;2867.51687921967;2868.26706676656;2869.01725431345;2869.76744186033;2870.51762940722;2871.26781695411;2872.01800450099;2872.76819204788;2873.51837959477;2874.26856714165;2875.01875468854;2875.76894223542;2876.51912978231;2877.26931732920;2878.01950487608;2878.76969242297;2879.51987996986;2880.27006751674;2881.02025506363;2881.77044261052;2882.52063015740;2883.27081770429;2884.02100525118;2884.77119279806;2885.52138034495;2886.27156789184;2887.02175543872;2887.77194298561;2888.52213053250;2889.27231807938;2890.02250562627;2890.77269317316;2891.52288072004;2892.27306826693;2893.02325581382;2893.77344336070;2894.52363090759;2895.27381845447;2896.02400600136;2896.77419354825;2897.52438109513;2898.27456864202;2899.02475618891;2899.77494373579;2900.52513128268;2901.27531882957;2902.02550637645;2902.77569392334;2903.52588147023;2904.27606901711;2905.02625656400;2905.77644411089;2906.52663165777;2907.27681920466;2908.02700675155;2908.77719429843;2909.52738184532;2910.27756939221;2911.02775693909;2911.77794448598;2912.52813203287;2913.27831957975;2914.02850712664;2914.77869467352;2915.52888222041;2916.27906976730;2917.02925731418;2917.77944486107;2918.52963240796;2919.27981995484;2920.03000750173;2920.78019504862;2921.53038259550;2922.28057014239;2923.03075768928;2923.78094523616;2924.53113278305;2925.28132032994;2926.03150787682;2926.78169542371;2927.53188297060;2928.28207051748;2929.03225806437;2929.78244561126;2930.53263315814;2931.28282070503;2932.03300825192;2932.78319579880;2933.53338334569;2934.28357089257;2935.03375843946;2935.78394598635;2936.53413353323;2937.28432108012;2938.03450862701;2938.78469617389;2939.53488372078;2940.28507126767;2941.03525881455;2941.78544636144;2942.53563390833;2943.28582145521;2944.03600900210;2944.78619654899;2945.53638409587;2946.28657164276;2947.03675918965;2947.78694673653;2948.53713428342;2949.28732183031;2950.03750937719;2950.78769692408;2951.53788447097;2952.28807201785;2953.03825956474;2953.78844711162;2954.53863465851;2955.28882220540;2956.03900975228;2956.78919729917;2957.53938484606;2958.28957239294;2959.03975993983;2959.78994748672;2960.54013503360;2961.29032258049;2962.04051012738;2962.79069767426;2963.54088522115;2964.29107276804;2965.04126031492;2965.79144786181;2966.54163540870;2967.29182295558;2968.04201050247;2968.79219804936;2969.54238559624;2970.29257314313;2971.04276069002;2971.79294823690;2972.54313578379;2973.29332333067;2974.04351087756;2974.79369842445;2975.54388597133;2976.29407351822;2977.04426106511;2977.79444861199;2978.54463615888;2979.29482370577;2980.04501125265;2980.79519879954;2981.54538634643;2982.29557389331;2983.04576144020;2983.79594898709;2984.54613653397;2985.29632408086;2986.04651162775;2986.79669917463;2987.54688672152;2988.29707426841;2989.04726181529;2989.79744936218;2990.54763690906;2991.29782445595;2992.04801200284;2992.79819954972;2993.54838709661;2994.29857464350;2995.04876219038;2995.79894973727;2996.54913728416;2997.29932483104;2998.04951237793;2998.79969992482;2999.54988747170;3000.30007501859;3001.05026256548;3001.80045011236;3002.55063765925;3003.30082520614;3004.05101275302;3004.80120029991;3005.55138784680;3006.30157539368;3007.05176294057;3007.80195048746;3008.55213803434;3009.30232558123;3010.05251312811;3010.80270067500;3011.55288822189;3012.30307576877;3013.05326331566;3013.80345086255;3014.55363840943;3015.30382595632;3016.05401350321;3016.80420105009;3017.55438859698;3018.30457614387;3019.05476369075;3019.80495123764;3020.55513878453;3021.30532633141;3022.05551387830;3022.80570142519;3023.55588897207;3024.30607651896;3025.05626406585;3025.80645161273;3026.55663915962;3027.30682670651;3028.05701425339;3028.80720180028;3029.55738934716;3030.30757689405;3031.05776444094;3031.80795198782;3032.55813953471;3033.30832708160;3034.05851462848;3034.80870217537;3035.55888972226;3036.30907726914;3037.05926481603;3037.80945236292;3038.55963990980;3039.30982745669;3040.06001500358;3040.81020255046;3041.56039009735;3042.31057764424;3043.06076519112;3043.81095273801;3044.56114028490;3045.31132783178;3046.06151537867;3046.81170292556;3047.56189047244;3048.31207801933;3049.06226556621;3049.81245311310;3050.56264065999;3051.31282820687;3052.06301575376;3052.81320330065;3053.56339084753;3054.31357839442;3055.06376594131;3055.81395348819;3056.56414103508;3057.31432858197;3058.06451612885;3058.81470367574;3059.56489122263;3060.31507876951;3061.06526631640;3061.81545386329;3062.56564141017;3063.31582895706;3064.06601650395;3064.81620405083;3065.56639159772;3066.31657914461;3067.06676669149;3067.81695423838;3068.56714178526;3069.31732933215;3070.06751687904;3070.81770442592;3071.56789197281;3072.31807951970;3073.06826706658;3073.81845461347;3074.56864216036;3075.31882970724;3076.06901725413;3076.81920480102;3077.56939234790;3078.31957989479;3079.06976744168;3079.81995498856;3080.57014253545;3081.32033008234;3082.07051762922;3082.82070517611;3083.57089272300;3084.32108026988;3085.07126781677;3085.82145536366;3086.57164291054;3087.32183045743;3088.07201800431;3088.82220555120;3089.57239309809;3090.32258064497;3091.07276819186;3091.82295573875;3092.57314328563;3093.32333083252;3094.07351837941;3094.82370592629;3095.57389347318;3096.32408102007;3097.07426856695;3097.82445611384;3098.57464366073;3099.32483120761;3100.07501875450;3100.82520630139;3101.57539384827;3102.32558139516;3103.07576894205;3103.82595648893;3104.57614403582;3105.32633158271;3106.07651912959;3106.82670667648;3107.57689422336;3108.32708177025;3109.07726931714;3109.82745686402;3110.57764441091;3111.32783195780;3112.07801950468;3112.82820705157;3113.57839459846;3114.32858214534;3115.07876969223;3115.82895723912;3116.57914478600;3117.32933233289;3118.07951987978;3118.82970742666;3119.57989497355;3120.33008252044;3121.08027006732;3121.83045761421;3122.58064516110;3123.33083270798;3124.08102025487;3124.83120780175;3125.58139534864;3126.33158289553;3127.08177044241;3127.83195798930;3128.58214553619;3129.33233308307;3130.08252062996;3130.83270817685;3131.58289572373;3132.33308327062;3133.08327081751;3133.83345836439;3134.58364591128;3135.33383345817;3136.08402100505;3136.83420855194;3137.58439609883;3138.33458364571;3139.08477119260;3139.83495873949;3140.58514628637;3141.33533383326;3142.08552138015;3142.83570892703;3143.58589647392;3144.33608402080;3145.08627156769;3145.83645911458;3146.58664666146;3147.33683420835;3148.08702175524;3148.83720930212;3149.58739684901;3150.33758439590;3151.08777194278;3151.83795948967;3152.58814703656;3153.33833458344;3154.08852213033;3154.83870967722;3155.58889722410;3156.33908477099;3157.08927231788;3157.83945986476;3158.58964741165;3159.33983495854;3160.09002250542;3160.84021005231;3161.59039759920;3162.34058514608;3163.09077269297;3163.84096023985;3164.59114778674;3165.34133533363;3166.09152288051;3166.84171042740;3167.59189797429;3168.34208552117;3169.09227306806;3169.84246061495;3170.59264816183;3171.34283570872;3172.09302325561;3172.84321080249;3173.59339834938;3174.34358589627;3175.09377344315;3175.84396099004;3176.59414853693;3177.34433608381;3178.09452363070;3178.84471117759;3179.59489872447;3180.34508627136;3181.09527381825;3181.84546136513;3182.59564891202;3183.34583645890;3184.09602400579;3184.84621155268;3185.59639909956;3186.34658664645;3187.09677419334;3187.84696174022;3188.59714928711;3189.34733683400;3190.09752438088;3190.84771192777;3191.59789947466;3192.34808702154;3193.09827456843;3193.84846211532;3194.59864966220;3195.34883720909;3196.09902475598;3196.84921230286;3197.59939984975;3198.34958739664;3199.09977494352;3199.84996249041;3200.60015003730;3201.35033758418;3202.10052513107;3202.85071267795;3203.60090022484;3204.35108777173;3205.10127531861;3205.85146286550;3206.60165041239;3207.35183795927;3208.10202550616;3208.85221305305;3209.60240059993;3210.35258814682;3211.10277569371;3211.85296324059;3212.60315078748;3213.35333833437;3214.10352588125;3214.85371342814;3215.60390097503;3216.35408852191;3217.10427606880;3217.85446361569;3218.60465116257;3219.35483870946;3220.10502625635;3220.85521380323;3221.60540135012;3222.35558889700;3223.10577644389;3223.85596399078;3224.60615153766;3225.35633908455;3226.10652663144;3226.85671417832;3227.60690172521;3228.35708927210;3229.10727681898;3229.85746436587;3230.60765191276;3231.35783945964;3232.10802700653;3232.85821455342;3233.60840210030;3234.35858964719;3235.10877719408;3235.85896474096;3236.60915228785;3237.35933983474;3238.10952738162;3238.85971492851;3239.60990247540;3240.36009002228;3241.11027756917;3241.86046511605;3242.61065266294;3243.36084020983;3244.11102775671;3244.86121530360;3245.61140285049;3246.36159039737;3247.11177794426;3247.86196549115;3248.61215303803;3249.36234058492;3250.11252813181;3250.86271567869;3251.61290322558;3252.36309077247;3253.11327831935;3253.86346586624;3254.61365341313;3255.36384096001;3256.11402850690;3256.86421605379;3257.61440360067;3258.36459114756;3259.11477869445;3259.86496624133;3260.61515378822;3261.36534133510;3262.11552888199;3262.86571642888;3263.61590397576;3264.36609152265;3265.11627906954;3265.86646661642;3266.61665416331;3267.36684171020;3268.11702925708;3268.86721680397;3269.61740435086;3270.36759189774;3271.11777944463;3271.86796699152;3272.61815453840;3273.36834208529;3274.11852963218;3274.86871717906;3275.61890472595;3276.36909227284;3277.11927981972;3277.86946736661;3278.61965491349;3279.36984246038;3280.12003000727;3280.87021755415;3281.62040510104;3282.37059264793;3283.12078019481;3283.87096774170;3284.62115528859;3285.37134283547;3286.12153038236;3286.87171792925;3287.62190547613;3288.37209302302;3289.12228056991;3289.87246811679;3290.62265566368;3291.37284321057;3292.12303075745;3292.87321830434;3293.62340585123;3294.37359339811;3295.12378094500;3295.87396849189;3296.62415603877;3297.37434358566;3298.12453113254;3298.87471867943;3299.62490622632;3300.37509377320;3301.12528132009;3301.87546886698;3302.62565641386;3303.37584396075;3304.12603150764;3304.87621905452;3305.62640660141;3306.37659414830;3307.12678169518;3307.87696924207;3308.62715678896;3309.37734433584;3310.12753188273;3310.87771942962;3311.62790697650;3312.37809452339;3313.12828207028;3313.87846961716;3314.62865716405;3315.37884471094;3316.12903225782;3316.87921980471;3317.62940735159;3318.37959489848;3319.12978244537;3319.87996999225;3320.63015753914;3321.38034508603;3322.13053263291;3322.88072017980;3323.63090772669;3324.38109527357;3325.13128282046;3325.88147036735;3326.63165791423;3327.38184546112;3328.13203300801;3328.88222055489;3329.63240810178;3330.38259564867;3331.13278319555;3331.88297074244;3332.63315828933;3333.38334583621;3334.13353338310;3334.88372092999;3335.63390847687;3336.38409602376;3337.13428357064;3337.88447111753;3338.63465866442;3339.38484621130;3340.13503375819;3340.88522130508;3341.63540885196;3342.38559639885;3343.13578394574;3343.88597149262;3344.63615903951;3345.38634658640;3346.13653413328;3346.88672168017;3347.63690922706;3348.38709677394;3349.13728432083;3349.88747186772;3350.63765941460;3351.38784696149;3352.13803450838;3352.88822205526;3353.63840960215;3354.38859714904;3355.13878469592;3355.88897224281;3356.63915978969;3357.38934733658;3358.13953488347;3358.88972243035;3359.63990997724;3360.39009752413;3361.14028507101;3361.89047261790;3362.64066016479;3363.39084771167;3364.14103525856;3364.89122280545;3365.64141035233;3366.39159789922;3367.14178544611;3367.89197299299;3368.64216053988;3369.39234808677;3370.14253563365;3370.89272318054;3371.64291072743;3372.39309827431;3373.14328582120;3373.89347336809;3374.64366091497;3375.39384846186;3376.14403600874;3376.89422355563;3377.64441110252;3378.39459864940;3379.14478619629;3379.89497374318;3380.64516129006;3381.39534883695;3382.14553638384;3382.89572393072;3383.64591147761;3384.39609902450;3385.14628657138;3385.89647411827;3386.64666166516;3387.39684921204;3388.14703675893;3388.89722430582;3389.64741185270;3390.39759939959;3391.14778694648;3391.89797449336;3392.64816204025;3393.39834958714;3394.14853713402;3394.89872468091;3395.64891222779;3396.39909977468;3397.14928732157;3397.89947486845;3398.64966241534;3399.39984996223;3400.15003750911;3400.90022505600;3401.65041260289;3402.40060014977;3403.15078769666;3403.90097524355;3404.65116279043;3405.40135033732;3406.15153788421;3406.90172543109;3407.65191297798;3408.40210052487;3409.15228807175;3409.90247561864;3410.65266316553;3411.40285071241;3412.15303825930;3412.90322580618;3413.65341335307;3414.40360089996;3415.15378844684;3415.90397599373;3416.65416354062;3417.40435108750;3418.15453863439;3418.90472618128;3419.65491372816;3420.40510127505;3421.15528882194;3421.90547636882;3422.65566391571;3423.40585146260;3424.15603900948;3424.90622655637;3425.65641410326;3426.40660165014;3427.15678919703;3427.90697674392;3428.65716429080;3429.40735183769;3430.15753938458;3430.90772693146;3431.65791447835;3432.40810202523;3433.15828957212;3433.90847711901;3434.65866466589;3435.40885221278;3436.15903975967;3436.90922730655;3437.65941485344;3438.40960240033;3439.15978994721;3439.90997749410;3440.66016504099;3441.41035258787;3442.16054013476;3442.91072768165;3443.66091522853;3444.41110277542;3445.16129032231;3445.91147786919;3446.66166541608;3447.41185296297;3448.16204050985;3448.91222805674;3449.66241560363;3450.41260315051;3451.16279069740;3451.91297824428;3452.66316579117;3453.41335333806;3454.16354088494;3454.91372843183;3455.66391597872;3456.41410352560;3457.16429107249;3457.91447861938;3458.66466616626;3459.41485371315;3460.16504126004;3460.91522880692;3461.66541635381;3462.41560390070;3463.16579144758;3463.91597899447;3464.66616654136;3465.41635408824;3466.16654163513;3466.91672918202;3467.66691672890;3468.41710427579;3469.16729182268;3469.91747936956;3470.66766691645;3471.41785446333;3472.16804201022;3472.91822955711;3473.66841710399;3474.41860465088;3475.16879219777;3475.91897974465;3476.66916729154;3477.41935483843;3478.16954238531;3478.91972993220;3479.66991747909;3480.42010502597;3481.17029257286;3481.92048011975;3482.67066766663;3483.42085521352;3484.17104276041;3484.92123030729;3485.67141785418;3486.42160540107;3487.17179294795;3487.92198049484;3488.67216804173;3489.42235558861;3490.17254313550;3490.92273068238;3491.67291822927;3492.42310577616;3493.17329332304;3493.92348086993;3494.67366841682;3495.42385596370;3496.17404351059;3496.92423105748;3497.67441860436;3498.42460615125;3499.17479369814;3499.92498124502;3500.67516879191;3501.42535633880;3502.17554388568;3502.92573143257;3503.67591897946;3504.42610652634;3505.17629407323;3505.92648162012;3506.67666916700;3507.42685671389;3508.17704426078;3508.92723180766;3509.67741935455;3510.42760690143;3511.17779444832;3511.92798199521;3512.67816954209;3513.42835708898;3514.17854463587;3514.92873218275;3515.67891972964;3516.42910727653;3517.17929482341;3517.92948237030;3518.67966991719;3519.42985746407;3520.18004501096;3520.93023255785;3521.68042010473;3522.43060765162;3523.18079519851;3523.93098274539;3524.68117029228;3525.43135783917;3526.18154538605;3526.93173293294;3527.68192047983;3528.43210802671;3529.18229557360;3529.93248312048;3530.68267066737;3531.43285821426;3532.18304576114;3532.93323330803;3533.68342085492;3534.43360840180;3535.18379594869;3535.93398349558;3536.68417104246;3537.43435858935;3538.18454613624;3538.93473368312;3539.68492123001;3540.43510877690;3541.18529632378;3541.93548387067;3542.68567141756;3543.43585896444;3544.18604651133;3544.93623405822;3545.68642160510;3546.43660915199;3547.18679669888;3547.93698424576;3548.68717179265;3549.43735933953;3550.18754688642;3550.93773443331;3551.68792198019;3552.43810952708;3553.18829707397;3553.93848462085;3554.68867216774;3555.43885971463;3556.18904726151;3556.93923480840;3557.68942235529;3558.43960990217;3559.18979744906;3559.93998499595;3560.69017254283;3561.44036008972;3562.19054763661;3562.94073518349;3563.69092273038;3564.44111027727;3565.19129782415;3565.94148537104;3566.69167291792;3567.44186046481;3568.19204801170;3568.94223555858;3569.69242310547;3570.44261065236;3571.19279819924;3571.94298574613;3572.69317329302;3573.44336083990;3574.19354838679;3574.94373593368;3575.69392348056;3576.44411102745;3577.19429857434;3577.94448612122;3578.69467366811;3579.44486121500;3580.19504876188;3580.94523630877;3581.69542385566;3582.44561140254;3583.19579894943;3583.94598649632;3584.69617404320;3585.44636159009;3586.19654913697;3586.94673668386;3587.69692423075;3588.44711177763;3589.19729932452;3589.94748687141;3590.69767441829;3591.44786196518;3592.19804951207;3592.94823705895;3593.69842460584;3594.44861215273;3595.19879969961;3595.94898724650;3596.69917479339;3597.44936234027;3598.19954988716;3598.94973743405;3599.69992498093;3600.45011252782;3601.20030007471;3601.95048762159;3602.70067516848;3603.45086271537;3604.20105026225;3604.95123780914;3605.70142535602;3606.45161290291;3607.20180044980;3607.95198799668;3608.70217554357;3609.45236309046;3610.20255063734;3610.95273818423;3611.70292573112;3612.45311327800;3613.20330082489;3613.95348837178;3614.70367591866;3615.45386346555;3616.20405101244;3616.95423855932;3617.70442610621;3618.45461365310;3619.20480119998;3619.95498874687;3620.70517629376;3621.45536384064;3622.20555138753;3622.95573893442;3623.70592648130;3624.45611402819;3625.20630157507;3625.95648912196;3626.70667666885;3627.45686421573;3628.20705176262;3628.95723930951;3629.70742685639;3630.45761440328;3631.20780195017;3631.95798949705;3632.70817704394;3633.45836459083;3634.20855213771;3634.95873968460;3635.70892723149;3636.45911477837;3637.20930232526;3637.95948987215;3638.70967741903;3639.45986496592;3640.21005251281;3640.96024005969;3641.71042760658;3642.46061515347;3643.21080270035;3643.96099024724;3644.71117779412;3645.46136534101;3646.21155288790;3646.96174043478;3647.71192798167;3648.46211552856;3649.21230307544;3649.96249062233;3650.71267816922;3651.46286571610;3652.21305326299;3652.96324080988;3653.71342835676;3654.46361590365;3655.21380345054;3655.96399099742;3656.71417854431;3657.46436609120;3658.21455363808;3658.96474118497;3659.71492873186;3660.46511627874;3661.21530382563;3661.96549137252;3662.71567891940;3663.46586646629;3664.21605401317;3664.96624156006;3665.71642910695;3666.46661665383;3667.21680420072;3667.96699174761;3668.71717929449;3669.46736684138;3670.21755438827;3670.96774193515;3671.71792948204;3672.46811702893;3673.21830457581;3673.96849212270;3674.71867966959;3675.46886721647;3676.21905476336;3676.96924231025;3677.71942985713;3678.46961740402;3679.21980495091;3679.96999249779;3680.72018004468;3681.47036759157;3682.22055513845;3682.97074268534;3683.72093023222;3684.47111777911;3685.22130532600;3685.97149287288;3686.72168041977;3687.47186796666;3688.22205551354;3688.97224306043;3689.72243060732;3690.47261815420;3691.22280570109;3691.97299324798;3692.72318079486;3693.47336834175;3694.22355588864;3694.97374343552;3695.72393098241;3696.47411852930;3697.22430607618;3697.97449362307;3698.72468116996;3699.47486871684;3700.22505626373;3700.97524381061;3701.72543135750;3702.47561890439;3703.22580645127;3703.97599399816;3704.72618154505;3705.47636909193;3706.22655663882;3706.97674418571;3707.72693173259;3708.47711927948;3709.22730682637;3709.97749437325;3710.72768192014;3711.47786946703;3712.22805701391;3712.97824456080;3713.72843210769;3714.47861965457;3715.22880720146;3715.97899474835;3716.72918229523;3717.47936984212;3718.22955738901;3718.97974493589;3719.72993248278;3720.48012002966;3721.23030757655;3721.98049512344;3722.73068267032;3723.48087021721;3724.23105776410;3724.98124531098;3725.73143285787;3726.48162040476;3727.23180795164;3727.98199549853;3728.73218304542;3729.48237059230;3730.23255813919;3730.98274568608;3731.73293323296;3732.48312077985;3733.23330832674;3733.98349587362;3734.73368342051;3735.48387096740;3736.23405851428;3736.98424606117;3737.73443360806;3738.48462115494;3739.23480870183;3739.98499624871;3740.73518379560;3741.48537134249;3742.23555888937;3742.98574643626;3743.73593398315;3744.48612153003;3745.23630907692;3745.98649662381;3746.73668417069;3747.48687171758;3748.23705926447;3748.98724681135;3749.73743435824;3750.48762190513;3751.23780945201;3751.98799699890;3752.73818454579;3753.48837209267;3754.23855963956;3754.98874718645;3755.73893473333;3756.48912228022;3757.23930982711;3757.98949737399;3758.73968492088;3759.48987246776;3760.24006001465;3760.99024756154;3761.74043510842;3762.49062265531;3763.24081020220;3763.99099774908;3764.74118529597;3765.49137284286;3766.24156038974;3766.99174793663;3767.74193548352;3768.49212303040;3769.24231057729;3769.99249812418;3770.74268567106;3771.49287321795;3772.24306076484;3772.99324831172;3773.74343585861;3774.49362340550;3775.24381095238;3775.99399849927;3776.74418604616;3777.49437359304;3778.24456113993;3778.99474868681;3779.74493623370;3780.49512378059;3781.24531132747;3781.99549887436;3782.74568642125;3783.49587396813;3784.24606151502;3784.99624906191;3785.74643660879;3786.49662415568;3787.24681170257;3787.99699924945;3788.74718679634;3789.49737434323;3790.24756189011;3790.99774943700;3791.74793698389;3792.49812453077;3793.24831207766;3793.99849962455;3794.74868717143;3795.49887471832;3796.24906226521;3796.99924981209;3797.74943735898;3798.49962490586;3799.24981245275;3799.99999999964];
    handles.data_simulated = [6.33116280325204e-07;7.49258900227246e-07;8.37567193427380e-07;9.23357878975320e-07;1.05045614709580e-06;1.19593677074213e-06;1.33888737702340e-06;1.53268678480718e-06;1.77086318010824e-06;1.96220947371230e-06;2.15734744113670e-06;2.51881270079170e-06;2.95472995189560e-06;3.25412106155263e-06;3.59917855932005e-06;4.19209378862648e-06;4.75916254957236e-06;5.13807219933367e-06;5.77907017121296e-06;6.81184925765582e-06;7.57025810923823e-06;7.91691580039741e-06;8.87732162171375e-06;1.08265050863598e-05;1.23737193224551e-05;1.25640537191916e-05;1.32140938813918e-05;1.60721247376730e-05;1.93535111868962e-05;2.08042324602451e-05;2.18506922640462e-05;2.45816978158558e-05;2.81094996798474e-05;3.06660535986539e-05;3.34261230513731e-05;3.91392217609171e-05;4.53960000084048e-05;4.76884697671615e-05;4.87177658546206e-05;5.44332805933246e-05;6.31289662589070e-05;6.97780759014463e-05;7.63585658054304e-05;8.76584906714176e-05;9.98776667243175e-05;0.000107187462027123;0.000113214851849494;0.000124114572106228;0.000138202594278359;0.000150947779113828;0.000163263849951757;0.000178971282082031;0.000198709756024965;0.000219611858560530;0.000241480496568294;0.000265164521006908;0.000291526521858171;0.000321883150987860;0.000355628728274407;0.000383367882616838;0.000408429927582206;0.000445917668924131;0.000488482237093839;0.000516353588447747;0.000546426025059444;0.000609977599687306;0.000677675299421479;0.000718283029136773;0.000768995990749822;0.000859837689104589;0.000945640101758559;0.00100015353294244;0.00107621725439902;0.00119945959774078;0.00128731109705664;0.00131350644293051;0.00141580169325689;0.00161049471589433;0.00173342274437672;0.00173983171569429;0.00183369336150770;0.00210114329714540;0.00231758310928626;0.00240202163619518;0.00259889188870552;0.00285943566913763;0.00292603352799288;0.00295895168081978;0.00324086883123891;0.00358741342724864;0.00371172298531371;0.00387831852817979;0.00434633243989334;0.00474978341327222;0.00483399742808406;0.00506396110779675;0.00547408941547724;0.00557628802030842;0.00570918962804932;0.00641235537607089;0.00721710302898473;0.00748688348927344;0.00772528752311102;0.00801348478372076;0.00786418408560500;0.00798834792260749;0.00907886440862154;0.0102580882603077;0.0106815194206528;0.0112323329717992;0.0118211806821338;0.0114675700722372;0.0112859032436224;0.0124673225629878;0.0137099882567309;0.0139896804807069;0.0149671598251407;0.0160562111877902;0.0152737209475774;0.0148827425883834;0.0168260218268960;0.0185238374615753;0.0185799985121487;0.0197697346918515;0.0211850106588654;0.0201710218045897;0.0200142343777508;0.0220902342308068;0.0226514753752880;0.0219035340040002;0.0238125570538534;0.0262355766596815;0.0258341269291601;0.0267409846181731;0.0284201175645529;0.0263830280364422;0.0252648903359549;0.0287138662122864;0.0320726060082574;0.0347205446480148;0.0436154198444125;0.0574820860397982;0.0688650421451648;0.0791897959412669;0.0871668243442827;0.0881109169703597;0.0886492711504315;0.0933757719288394;0.0960939043798026;0.0933889253250090;0.0898863887668973;0.0877275144157370;0.0835759093538245;0.0769816095047623;0.0713948194744487;0.0681529346069759;0.0672814227484391;0.0665331323302114;0.0600162100154699;0.0481856370717861;0.0410598196200954;0.0449103843755818;0.0575187362166256;0.0728231871265248;0.0851904479081230;0.0938992383441372;0.100285319408407;0.104216099758239;0.105830263190898;0.106750096684520;0.105228862070526;0.100357200473274;0.0946785108093441;0.0846010095370082;0.0685303520100897;0.0536450312540299;0.0428910586911541;0.0353702652073918;0.0331240117715071;0.0328775168270826;0.0309142033468662;0.0309068446200568;0.0317855720186706;0.0300490563815266;0.0293834341052392;0.0298693022777291;0.0284406970358539;0.0278776848886742;0.0282145338926315;0.0267891700464782;0.0257565133334477;0.0255283091255332;0.0244472947454205;0.0237782892139870;0.0234260829283497;0.0224491584608815;0.0215391393589701;0.0206027681486376;0.0198465863630247;0.0191401854855651;0.0177305441243837;0.0169010240486892;0.0165655405562688;0.0153731897518334;0.0146107507692666;0.0144930214013653;0.0137510797596740;0.0130941107905028;0.0126166754831261;0.0115608195370905;0.0107808442260924;0.0105373518006058;0.0101148274384264;0.00964616214237899;0.00916394145991728;0.00852418376545007;0.00783070372892031;0.00716151426780279;0.00674456229397542;0.00646928094657774;0.00605574957121101;0.00560728361021100;0.00523215561565864;0.00493474476163980;0.00460556089495400;0.00416256494555653;0.00381791785163579;0.00356352903269745;0.00327737456574008;0.00304574150145624;0.00282234145550619;0.00256769304359942;0.00236338737775534;0.00217060018598611;0.00197231654317218;0.00180378823500212;0.00163858656212955;0.00148161010199407;0.00133708407179227;0.00120882470476313;0.00110124776345193;0.000997144034603777;0.000895733105184084;0.000797548273526598;0.000712940708877183;0.000644754641639654;0.000579961203129069;0.000524643415730862;0.000474319826536133;0.000419696986233083;0.000367905839079934;0.000317757545621231;0.000273744148529310;0.000242668154911645;0.000216807840202112;0.000195278891081481;0.000177325184444687;0.000154123131002739;0.000129955245011267;0.000111755418244818;9.83398392652525e-05;8.80946692238061e-05;7.78538760233537e-05;6.69564944670558e-05;5.79020927809611e-05;5.11380753495080e-05;4.60535176928156e-05;4.18519578965807e-05;3.80934002205769e-05;3.52361693470397e-05;3.30730470171024e-05;3.07089386697344e-05;2.89152568319464e-05;2.90230294576375e-05;3.00541150614225e-05;3.10540852365345e-05;3.21241052139348e-05;3.33165487962436e-05;3.58356074283188e-05;3.99760568213047e-05;4.38503246173839e-05;4.69051090259402e-05;5.09910778427201e-05;5.73111031890624e-05;6.47741549624915e-05;7.15034335958417e-05;7.76943879247493e-05;8.52114554858277e-05;9.49754524720653e-05;0.000106210404477416;0.000116631341713902;0.000126557385400340;0.000140693965258490;0.000157850553844106;0.000172532934938383;0.000188873684719911;0.000207564909757552;0.000223724504549089;0.000245212529724249;0.000272658190759382;0.000296102593174417;0.000321102328940516;0.000351340269931508;0.000378203765422871;0.000409029112108282;0.000450520866747242;0.000490226592754638;0.000523983341173203;0.000563693908886780;0.000615474286666716;0.000660878504864754;0.000700086102602058;0.000764030132154206;0.000823958114398883;0.000858716792744575;0.000928464203121149;0.00101353451779492;0.00106078202262965;0.00113196758087242;0.00122981585841522;0.00128584418268948;0.00136009773557799;0.00146170793988601;0.00151842031936316;0.00161175981033815;0.00173780324458592;0.00179920796538583;0.00190190258647770;0.00204059996225789;0.00210379010819911;0.00221599184373607;0.00236929932384255;0.00242990085084090;0.00254756860574469;0.00271861391450876;0.00279012691051162;0.00296193719996606;0.00322672603466860;0.00336642691552513;0.00353685244526773;0.00382111181933692;0.00394908035768384;0.00406832493800116;0.00444309952686773;0.00476428426124131;0.00499595872971286;0.00547098135602397;0.00586937863463094;0.00601682231945149;0.00643960913980470;0.00691238549240067;0.00712073792353242;0.00781763033757144;0.00899243818883511;0.00987663578168304;0.0116068703116099;0.0151938533903129;0.0238799200637879;0.0493702818629752;0.104077449588451;0.179324164867223;0.248847981111780;0.298511907244580;0.330688800256724;0.352767278358408;0.368492970931857;0.376972235652433;0.377784325555534;0.370797975524597;0.354592700562635;0.326931015836229;0.287471020429409;0.239480817131182;0.189948959541433;0.155520740795541;0.173254543134900;0.271074826206987;0.375654602898642;0.377057722779969;0.313661345461593;0.284271504206473;0.312219453798307;0.376051495539604;0.459868169589467;0.563094124667286;0.688907788459453;0.848165929701286;1.07114942512439;1.38991655268554;1.77413711274779;2.10566730181478;2.28906143160806;2.34473314861240;2.34885873880450;2.34227836227655;2.32417432871042;2.29848825599507;2.26961516816345;2.20507722627017;2.08870900792618;1.95797177414631;1.85952011828259;1.80058506349963;1.74695347127683;1.66305964163507;1.51373288815659;1.25273999678223;0.983343478554297;0.959219055738255;1.22971724447780;1.61871481484220;1.97623425883331;2.24808294400438;2.44082459734157;2.57605336720346;2.65278202678918;2.65042397224048;2.54964069482311;2.36097656620955;2.11451887746813;1.81218205394203;1.41907760645396;0.938519688410376;0.490920849009467;0.212295556237890;0.0963048169290009;0.0569742592804686;0.0410783349057140;0.0320615231089336;0.0260578943530395;0.0217657780569455;0.0183745102013340;0.0158857180340672;0.0139680262754475;0.0123094146881427;0.0107487874897407;0.00936566218566643;0.00811044144443317;0.00685337569693562;0.00569864004127332;0.00477471021459542;0.00394269420448989;0.00316459519732883;0.00252470997553880;0.00200018088427263;0.00150197297971762;0.00108272327423084;0.000840923387167903;0.000779673020943881;0.000721903503544779;0.000679961912546955;0.000650976903468668;0.000614356793834593;0.000575607827963358;0.000536271244553880;0.000488831147277464;0.000447662478878080;0.000426163169247444;0.000410751703505720;0.000381701653036455;0.000345915317090116;0.000315798761086887;0.000294812232656311;0.000280600264643529;0.000260492179232191;0.000236129052737889;0.000217916533859629;0.000206824722454482;0.000194682837962308;0.000179141759722612;0.000164596439810241;0.000152067073011206;0.000140482284870552;0.000131287437104723;0.000125986941314082;0.000119596882226482;0.000108486497376124;9.91496581610236e-05;9.52488372252883e-05;9.17684353612472e-05;8.60952407064762e-05;8.20458088550061e-05;8.06137143413978e-05;7.77364654242336e-05;7.31814680481887e-05;6.99206053314268e-05;6.90815834799807e-05;6.98053499789950e-05;7.06598265339561e-05;7.10671007918906e-05;7.08414409328513e-05;7.09017666710482e-05;7.20779568314411e-05;7.41874133579996e-05;7.77859861980904e-05;8.27617704809418e-05;8.55975912277574e-05;8.53508221637776e-05;8.79140371851201e-05;9.58444827796332e-05;0.000103682341150513;0.000109091210480780;0.000117680588475792;0.000125982252661944;0.000125594546473274;0.000124650536671806;0.000135480243372755;0.000151467915734544;0.000161308241005776;0.000174795307016558;0.000190934724330319;0.000193455537284658;0.000194799037693152;0.000214382391483917;0.000235236066609686;0.000239323926112279;0.000249370521373930;0.000268986276419128;0.000273580850120427;0.000279468899378269;0.000309216934246595;0.000338988217681682;0.000349746532888978;0.000372980399545056;0.000404326196247379;0.000408060952600324;0.000417360732567001;0.000448310726928207;0.000459026882770636;0.000462102986196278;0.000508186855899808;0.000559380983731100;0.000571706683331283;0.000610773881352876;0.000672172312511578;0.000683200127909405;0.000724265151812074;0.000867491509248113;0.000997780142144708;0.00107154721312653;0.00120694744375163;0.00137394177833192;0.00147810532269394;0.00162456444127730;0.00181302560127757;0.00191492673193258;0.00205474735137734;0.00237332644449136;0.00274248936836256;0.00310154678502133;0.00369261121900367;0.00459440663973693;0.00580448838714921;0.00806211605404663;0.0125812266268093;0.0221653968844940;0.0431503552700138;0.0823825969336620;0.135769095136548;0.186137708073439;0.222119664132891;0.245450205698361;0.260513140591180;0.270161127976082;0.273891393517002;0.270434557974506;0.260960938383370;0.246912211095407;0.229368514788331;0.209366186852122;0.190876690597827;0.181970020014883;0.191872949721680;0.221245903101772;0.243735549559133;0.215861585050995;0.145600741702907;0.0997866557800124;0.107729845443899;0.147647825275518;0.195094256805018;0.237155430550711;0.270233159203561;0.294575039240861;0.310290380537978;0.316882438596697;0.313371014153271;0.300180824173492;0.279791878841913;0.250341435446718;0.204771821719089;0.141687114784828;0.0772242341934402;0.0340189348477177;0.0151419610453809;0.00881572080385351;0.00640147066603388;0.00510382503258555;0.00432536639383163;0.00373857659343164;0.00322044803203065;0.00291372044689909;0.00266630064116855;0.00241223743478019;0.00223543435905486;0.00207934654663161;0.00187384717523674;0.00170800369540517;0.00157265174314113;0.00141311809441452;0.00129111720398457;0.00118470841574024;0.00106157215382062;0.000969919581041358;0.000895395985675051;0.000813411209080255;0.000754464671712705;0.000721793150910297;0.000691116044055016;0.000671884395773961;0.000640633787978934;0.000613067240893842;0.000593420850077814;0.000552970191606596;0.000526320443919850;0.000519394624850692;0.000492408726060915;0.000471436315974764;0.000466511023244767;0.000444064066452906;0.000418644916410066;0.000402596652415751;0.000380130480820505;0.000362782744427176;0.000353688636834584;0.000352594527031181;0.000365410086975959;0.000392979587830060;0.000424356420167401;0.000453883146317678;0.000484151966567437;0.000525577320773109;0.000573439629298474;0.000623067938250745;0.000689170959895291;0.000773672564826048;0.000861967819020609;0.000950087105151290;0.00105213127192244;0.00117627513630135;0.00132910256953804;0.00153706770905963;0.00187640512040657;0.00227565966062737;0.00286251511661907;0.00389532964414108;0.00642245862663293;0.0142102610421639;0.0339393987271437;0.0666361839641594;0.101485966219549;0.127481440384237;0.143489962454182;0.153622709839512;0.160022709766007;0.162519053562938;0.161385734891613;0.156884778115558;0.147896082899051;0.133444186618803;0.114000959005956;0.0913138689315335;0.0692442684046921;0.0561632001698808;0.0684282588162459;0.114139018004407;0.153868198636595;0.141692744340258;0.104833488508735;0.0872555020116558;0.0924945983113273;0.107978093695127;0.125148421031296;0.140414276535457;0.152582767258937;0.160806102718906;0.164491861271276;0.164130070622518;0.160656962448838;0.153882944214403;0.142342925094078;0.122613731220784;0.0912344742437933;0.0544015652393424;0.0265686707943086;0.0127478300894394;0.00745175220642935;0.00558696512562566;0.00483161688011080;0.00423644926044342;0.00385985579598260;0.00384748646910257;0.00400067536971771;0.00400243558156907;0.00406026635211419;0.00417904661081023;0.00419314112401960;0.00438943159212630;0.00466441930145520;0.00470667183916225;0.00491276180755394;0.00545291520467302;0.00582332037734716;0.00655000453907753;0.00777873028694462;0.0101372313269234;0.0178790686180265;0.0387874470709236;0.0759297188237132;0.118312026882558;0.151114313499309;0.171638328412851;0.184626383737326;0.193553224355128;0.198661421884328;0.198276895988669;0.192269036450963;0.181555511901823;0.165890667869606;0.145290763006698;0.121308138935598;0.0973700733321299;0.0827604472625985;0.100562629332658;0.163575294707511;0.206183129593670;0.163202288729347;0.100860049529045;0.0844882945111955;0.100703084492509;0.126598857027273;0.152989886337295;0.175583122949159;0.191962184743197;0.202569375474556;0.208795587758906;0.210530596898374;0.206813612094741;0.197851178121039;0.183625629183902;0.160290920336419;0.122322965456617;0.0752328805952294;0.0379505788336376;0.0200863922818998;0.0144253553575594;0.0119271535599040;0.0103808807106741;0.0106079224522043;0.0111812260459273;0.0102411253904727;0.00958689515838194;0.0104077927782928;0.0110602680536206;0.0104332460451613;0.00990464730330722;0.0105534300427076;0.0113716216405021;0.0109584969151422;0.0105114421635401;0.0116891362738313;0.0129281225753901;0.0123816807436034;0.0122052765966952;0.0145733928310856;0.0176864070289532;0.0195589968013737;0.0216164538625319;0.0236402562483478;0.0236634189086839;0.0232844629264294;0.0245219373182117;0.0257753434537015;0.0253632428120225;0.0245790716146918;0.0242543093979805;0.0235964037015835;0.0223926522967391;0.0211358416037486;0.0197728922536076;0.0177269132786322;0.0155134375176478;0.0138702529611938;0.0128878110784871;0.0129887491045189;0.0146389393032876;0.0175201938146969;0.0207096318534566;0.0233703676896586;0.0252596476476845;0.0265314490654820;0.0272106201080283;0.0273099111291899;0.0274713907483324;0.0273322707253338;0.0261958866508170;0.0246610220768651;0.0226578420880321;0.0204114969263417;0.0178669783112336;0.0148502364532389;0.0131042766895630;0.0127320491463773;0.0127091568613250;0.0128617665459739;0.0128234833154440;0.0127684898589528;0.0127097930597143;0.0127243605609711;0.0128829934807405;0.0131143277977552;0.0133635157476479;0.0134219782251079;0.0134811199719610;0.0135941468120728;0.0137884940570546;0.0138963767700815;0.0138853972419714;0.0139870042366907;0.0142132836412511;0.0143622712801131;0.0143603968695667;0.0144740766403387;0.0149601565183303;0.0153588778350106;0.0153557654266286;0.0155367996593123;0.0160294475051949;0.0166126767159524;0.0169999655654073;0.0169555973632632;0.0172748328872245;0.0178180492829193;0.0178316404359026;0.0186323694551164;0.0199405717982106;0.0201907427425423;0.0205627864415869;0.0213644905020435;0.0218840728703089;0.0224829950531378;0.0228377262468351;0.0235246090723842;0.0245039075409042;0.0245112090213756;0.0252991034423294;0.0268679319737009;0.0268479298507190;0.0272801381922523;0.0283864394524630;0.0278993816315551;0.0286942981554610;0.0302833509624231;0.0293386618067759;0.0296431507772531;0.0314809315117796;0.0310798082971791;0.0326341140018717;0.0374939009492146;0.0417848619324904;0.0481612382062727;0.0558005159849235;0.0591507303538178;0.0615254435449833;0.0648537015590166;0.0649153434921364;0.0637837848059970;0.0632304329765031;0.0610104013422580;0.0577493188574144;0.0538359305226189;0.0474195533498061;0.0386369055320371;0.0311300955403081;0.0276272609684980;0.0286133542852772;0.0324898646812576;0.0369686686309198;0.0413518473096187;0.0454082568224035;0.0485725628481678;0.0526603823047815;0.0578812169422586;0.0601913424012715;0.0600996960743427;0.0625514911714507;0.0648729409750945;0.0611147144045504;0.0561764586241462;0.0573021853857682;0.0590539220513371;0.0542326473828739;0.0488258076095287;0.0443439350060685;0.0363556112528273;0.0309091318507101;0.0314755143291304;0.0315014301689560;0.0291557910946646;0.0298699974825679;0.0314649559895279;0.0288030801204299;0.0268834311973800;0.0279690418857759;0.0269635002740708;0.0244898895023074;0.0251267705745817;0.0264595586715861;0.0245992347367023;0.0232732523903084;0.0238384836905164;0.0224417008369157;0.0201237093315691;0.0205134345423626;0.0214493139142862;0.0195854028480526;0.0178711361237777;0.0181887919056581;0.0178709189256697;0.0164627305784173;0.0161867972854565;0.0163157233822464;0.0147683728479088;0.0133017541501694;0.0136408566880783;0.0140580199572903;0.0131830699652989;0.0122588046708017;0.0117458407330894;0.0108681767066391;0.0101439320430906;0.0101908413348844;0.0100901438633656;0.00908991533551250;0.00827669971263280;0.00830484387305280;0.00824962979417701;0.00762649003216340;0.00717118814988584;0.00697726499925888;0.00649238055994160;0.00593713494471094;0.00578865662595920;0.00565734175760562;0.00512671565512955;0.00466408918829666;0.00457110175918130;0.00445847964551877;0.00402583949725038;0.00364603208570557;0.00364048813666528;0.00364040139000707;0.00327926319305523;0.00292380778852231;0.00287189895747828;0.00279112348711990;0.00247721491792161;0.00222558279551306;0.00221176711671544;0.00216454369196432;0.00194300029675122;0.00176055239459968;0.00171258877418674;0.00161741656477055;0.00141714176510321;0.00128781238711286;0.00128294149757691;0.00124265863033805;0.00111058633565817;0.000995487770796088;0.000937732408693722;0.000879378135545120;0.000805526720742893;0.000754883947595427;0.000729902400687987;0.000676697309117793;0.000587105867635858;0.000529812333900673;0.000519271543987389;0.000497188906390714;0.000441149213036048;0.000389035561847513;0.000365363763958274;0.000347881332842363;0.000315946958567405;0.000281910115366919;0.000261791273429079;0.000248190076946737;0.000228268887780031;0.000205556492438837;0.000190047445080756;0.000177696923717778;0.000160760809143415;0.000144380548750802;0.000133481730316590;0.000122473464231015;0.000110134364217256;0.000102886263834744;9.76195299383242e-05;8.74846082525750e-05;7.48231686136616e-05;6.79979059619873e-05;6.54788541997758e-05;5.90333021388149e-05;4.99074817043877e-05;4.58813519145930e-05;4.65160471812996e-05;4.37567386206445e-05;3.63021354410218e-05;3.06510536040222e-05;2.92853596053022e-05;2.81952552951141e-05;2.46707306195974e-05;2.10945609370296e-05;1.99924471887653e-05;1.99517534888310e-05;1.81613399032319e-05;1.51277811306489e-05;1.33563785153723e-05;1.30963638803949e-05;1.24748173842170e-05;1.10192787585813e-05;9.80544791937961e-06;9.41452486356192e-06;9.10014823289751e-06;8.28265258064274e-06;7.58863566939748e-06;7.41350469266557e-06;7.48147273503688e-06;7.30544539653843e-06;6.77106960727032e-06;6.48906739496897e-06;6.80971920380866e-06;7.37662232991432e-06;7.49244668728020e-06;7.13743112850271e-06;7.05847975127828e-06;7.54525824770587e-06;8.42045462652940e-06;9.19577556498695e-06;9.38600518455103e-06;9.28369221845384e-06;1.00016606207063e-05;1.19325800839424e-05;1.35678281902057e-05;1.37336294873035e-05;1.34349274513532e-05;1.45608459685769e-05;1.73578707496397e-05;1.98098555614218e-05;2.02913772984462e-05;2.01986368786886e-05;2.21281585665811e-05;2.56481317749893e-05;2.82333116134896e-05;2.89321661105746e-05;2.98117530128625e-05;3.36398495786028e-05;3.92270847736832e-05;4.28654353859914e-05;4.41851506678198e-05;4.65538590652572e-05;5.14187264815114e-05;5.73539402890830e-05;6.16287980339395e-05;6.26671397836355e-05;6.50008935807938e-05;7.36182069524209e-05;8.49731278576451e-05;9.17843824523902e-05;9.37894963842216e-05;9.92912461332254e-05;0.000111028256394662;0.000123431662930412;0.000129855369281957;0.000130961605457835;0.000136931331857159;0.000156943605470892;0.000180917696751841;0.000187584345514844;0.000185357875373872;0.000199700140377312;0.000232354713592136;0.000254515042742159;0.000253966776511223;0.000260750431879697;0.000299528827341663;0.000342292847565724;0.000348673006027700;0.000344432087456532;0.000380203489845786;0.000434228336887247;0.000452344522882089;0.000450210568740098;0.000481296151516160;0.000549153377388109;0.000595275598170520;0.000595688735496661;0.000607403980330732;0.000684075517487202;0.000765223358348920;0.000771066288364531;0.000766436242258513;0.000853093373301167;0.000980340619136592;0.00101579138392859;0.00100766580524897;0.00108645787440934;0.00120999803018353;0.00123848619447673;0.00123775741385134;0.00135022509761559;0.00150125652124513;0.00152976560479680;0.00153524588820231;0.00167387127162210;0.00184444223057927;0.00188409884593519;0.00192699912378033;0.00213031284259733;0.00229243114314296;0.00224536951019212;0.00225439974206419;0.00253726806936168;0.00281891028395559;0.00282466774529369;0.00283089443389472;0.00313411448381713;0.00339407830125584;0.00328448608588387;0.00329839674018632;0.00378989925118532;0.00419283003009339;0.00406991958143548;0.00407747752773344;0.00467882817988966;0.00520905973295330;0.00524732487552000;0.00554511068817478;0.00644253630432119;0.00718422598132888;0.00759530256256525;0.00860182183612244;0.00998918720603571;0.0108542772442102;0.0118871966208005;0.0142618112844587;0.0171327517069327;0.0194667690730992;0.0226902029600518;0.0278334374356609;0.0338557411390543;0.0411058367035328;0.0521735275675148;0.0676103370192606;0.0872704638508037;0.114487816977870;0.153234297211948;0.208259312757875;0.290675543499496;0.415352595682650;0.583406815830280;0.766106069374668;0.922163575617997;1.02678234855113;1.08772734746745;1.13168005440266;1.16825867229246;1.18672692731410;1.17735049522271;1.14735438677375;1.10771832934623;1.06516762689013;1.02233151226349;0.977047988671487;0.926973136385973;0.877601151008641;0.832535762758615;0.758162681270607;0.626519218391516;0.513829874744394;0.538208210756182;0.697506129639919;0.897514471357400;1.07487327660619;1.21871043423974;1.32679486112472;1.38588375834869;1.39641512955904;1.37521455745838;1.31852219486401;1.21538788993374;1.07777474878251;0.896497432365431;0.655674384486757;0.396694531232977;0.196380074988547;0.0895500899311962;0.0490530403477346;0.0350047881552248;0.0282667057075228;0.0244062000792025;0.0217092067051833;0.0195682220098448;0.0179939338223219;0.0165311984215129;0.0154818815781472;0.0146793225167954;0.0135065163258968;0.0125182052212698;0.0118358715395716;0.0111526996728583;0.0103647943632584;0.00940883054586949;0.00874109256319264;0.00824670229518370;0.00775812569562798;0.00732104315094158;0.00670498253049508;0.00615472637601721;0.00586793438296296;0.00564403984495860;0.00540998671530721;0.00512252622555222;0.00485977746005326;0.00460332047323569;0.00431951433960439;0.00410172141343509;0.00394187653226672;0.00373699248054823;0.00345543828019051;0.00319519690373844;0.00299068710538745;0.00280965867919020;0.00260702305233249;0.00241773484310632;0.00225288985369075;0.00208395249091114;0.00191996664971250;0.00176701306495169;0.00162912825792267;0.00150389339236731;0.00137984856338576;0.00125558565894024;0.00112995650173357;0.00101927096284877;0.000929003217640085;0.000835630654924053;0.000741725512597658;0.000668232364507239;0.000603036306013149;0.000531927026466336;0.000465960078736245;0.000411165535497997;0.000364565364795438;0.000323052467879125;0.000282263587144904;0.000245361993968507;0.000213332595617659;0.000184432823847560;0.000157533529613381;0.000134397512401290;0.000114105809384455;9.55488090717168e-05;7.97829794827071e-05;6.72872544228822e-05;5.70805250339199e-05;4.81765976095435e-05;3.95366521299561e-05;3.15734633950441e-05;2.56352821877075e-05;2.12907888707098e-05;1.74289364015341e-05;1.40315922529654e-05;1.11534503293914e-05;8.84735432993344e-06;7.13424993739705e-06;5.81883388389106e-06;4.74221399289945e-06;3.82784675986833e-06;3.01172989089267e-06;2.40516977392427e-06;2.06868545119976e-06;1.90236857339000e-06;1.66552406377142e-06;1.32464949022673e-06;1.05400113691324e-06;9.55289849623639e-07;9.41461912652834e-07;9.31382649107794e-07;8.53473852420264e-07;7.12716271608261e-07;6.17721313309193e-07;6.26842177142206e-07;6.64042707705201e-07;6.15321154157700e-07;4.89251480071505e-07;4.08779830088736e-07;4.16997825383351e-07;4.58510586435260e-07;4.60285169004004e-07;3.90161119926435e-07;3.09700927742588e-07;2.84830055297540e-07;3.05545249332855e-07;3.24403829703790e-07;3.01839290295193e-07;2.45050290350830e-07;2.09583479796050e-07;2.14238368821822e-07;2.29136578146357e-07;2.21777602383389e-07;1.85257813436282e-07;1.52757229348517e-07;1.47720556971455e-07;1.56727185115816e-07;1.56893316044958e-07;1.37937459702640e-07;1.14917932283350e-07;1.07168894879897e-07;1.12753129035724e-07;1.14373926351089e-07;9.91374292592608e-08;7.82523853190307e-08;7.06313564025559e-08;7.56734520242712e-08;7.90135535419023e-08;7.11055005343538e-08;5.71075971983944e-08;4.88607777368299e-08;4.93660000210962e-08;5.25630437274621e-08;4.97001755423533e-08;4.01362764232217e-08;3.38445505668998e-08;3.42792671878056e-08;3.56779695073776e-08;3.34101847480366e-08;2.77440856669195e-08;2.30678280035663e-08;2.25473552324489e-08;2.38590657557621e-08;2.28146539835018e-08;1.91938833125319e-08;1.61324581688494e-08;1.55841269189628e-08;1.60021954865133e-08;1.48233758999916e-08;1.21728585855187e-08;1.02998196885779e-08;1.00789641713796e-08;1.02895774341597e-08;9.70829560112732e-09;8.33836531655387e-09;7.08374413302804e-09;6.56589646535304e-09;6.52339837660316e-09;6.05535889393298e-09;4.92540361181303e-09;4.17739383278384e-09;4.29245050894380e-09;4.50444496407737e-09;4.02406612899389e-09;3.11344353709838e-09;2.61033617179486e-09;2.62652894904620e-09;2.63050337163109e-09;2.29934455925417e-09;1.89697184248293e-09;1.75188854194858e-09;1.74854578886764e-09;1.63967798305712e-09;1.36677605783895e-09;1.10185564915757e-09;1.01165836829988e-09;1.01898822531795e-09;9.69246852191700e-10;8.40977661676182e-10;7.44067667205790e-10;7.11082562145078e-10;6.57532059352865e-10;5.41344510117996e-10;4.14702109261188e-10;3.63331694027870e-10;3.80580615514671e-10;3.94683524400734e-10;3.62482731570359e-10;3.02575995612652e-10;2.59426935057135e-10;2.36380311633277e-10;1.99229747656765e-10;1.49857624126508e-10;1.30996761959786e-10;1.46223644887617e-10;1.57638594827591e-10;1.41677709204831e-10;1.09019036087309e-10;8.57820091751735e-11;7.83237032711115e-11;6.99504938710874e-11;5.69559762948621e-11;5.37560000241389e-11;6.17704182005259e-11;6.49068558567442e-11;5.26686465718164e-11;3.40845339593448e-11;2.41103440396495e-11;2.36602478909878e-11;2.40967598707193e-11;2.29898702931416e-11;2.42301352376645e-11;2.74176399137398e-11;2.58167787666864e-11;1.74149747408970e-11;9.86472445913860e-12;7.77803471139803e-12;8.54499063088170e-12;9.40922744976710e-12;1.04870063070573e-11;1.19765245022360e-11;1.16777612330285e-11;8.21406472351123e-12;4.46696239549718e-12;3.03460841277681e-12;3.37970634148461e-12;4.18656180828867e-12;5.01030412249648e-12;5.71913604037144e-12;5.52037363176231e-12;3.99472592994520e-12;2.18041845183525e-12;1.21617016488299e-12;1.17855448483963e-12;1.63294109654850e-12;2.27986205892847e-12;2.90802338981690e-12;3.03179778104945e-12;2.28337399468957e-12;1.24443932596198e-12;6.29149542350394e-13;5.18061478342607e-13;6.98432534886883e-13;1.00228161685497e-12;1.29195395735360e-12;1.37808452692237e-12;1.10941915037336e-12;6.74650410907949e-13;4.02815842526209e-13;3.58107576639589e-13;4.23134200909778e-13;5.36819195843824e-13;6.66195029029640e-13;6.95542348698396e-13;5.39720741688292e-13;3.02365368680546e-13;1.50032633384675e-13;1.19880296566218e-13;1.67761379051416e-13;2.63888095276776e-13;3.68135498344035e-13;3.99348940946958e-13;3.10163468053797e-13;1.69684288436846e-13;7.67968923018660e-14;5.18851864981461e-14;6.85721624177970e-14;1.05403190411662e-13;1.44057137922431e-13;1.59996974787734e-13;1.36333403565779e-13;9.41011440997370e-14;6.65842804234889e-14;5.46171626813466e-14;4.88498672921896e-14;5.35692946063093e-14;6.73189809842997e-14;7.11643624476846e-14;5.30577643619079e-14;2.86807472011055e-14;1.58487424659290e-14;1.58233639736571e-14;2.45311147606074e-14;3.73685783048371e-14;4.57079843501033e-14;4.12633871273099e-14;2.66635525597332e-14;1.28067080547194e-14;5.81028452534577e-15;4.49031605969770e-15;6.59024622375092e-15;1.08503547585597e-14;1.49512991700490e-14;1.58628807725041e-14;1.38995665324711e-14;1.18725900381743e-14;9.64001589476317e-15;6.42609494970384e-15;4.36058990405327e-15;4.47579561834297e-15;5.04208950311950e-15;4.35710563875972e-15;2.80742748951934e-15;1.90387014306376e-15;2.21720014301665e-15;3.42986868882959e-15;4.90210047258434e-15;5.62016276562781e-15;4.75623616131471e-15;2.85912424564502e-15;1.27881302138462e-15;5.36877972909061e-16;3.38820822942766e-16;4.02226122159442e-16;6.68195309975056e-16;1.12661420729471e-15;1.64613890311018e-15;2.05588194148661e-15;2.19927195396278e-15;1.82759847324249e-15;1.06730200213154e-15;4.75017922447774e-16;2.58940158409734e-16;2.22776972886934e-16;2.06269307885330e-16;2.00070792523492e-16;2.71340097947960e-16;4.60840448004996e-16;7.46378436812502e-16;9.98048132326189e-16;9.64197786482688e-16;6.10067878040409e-16;2.59015824928422e-16;9.55847558824108e-17;4.80004420110321e-17;3.99843041930467e-17;5.27714907094925e-17;9.35892702924750e-17;1.82616137192733e-16;3.31271209708809e-16;4.72031510615063e-16;4.60240889306507e-16;2.85388875453999e-16;1.16881472398195e-16;4.18854662348834e-17;2.15457395864282e-17;1.72622287974008e-17;1.99053944877180e-17;3.39034117482109e-17;6.97698458935730e-17;1.34478315990954e-16;2.06725449963839e-16;2.19267110446590e-16;1.45227173908720e-16;6.16957422173840e-17;2.16048756596233e-17;9.92545914848624e-18;7.14098854375995e-18;7.91293937538725e-18;1.31986908203828e-17;2.70717833108845e-17;5.28769144429666e-17;8.25715152175937e-17;9.29779421054924e-17;7.15751106560138e-17;3.75899144350365e-17;1.51380427284171e-17;7.05248650794849e-18;5.06720119318100e-18;4.49412970683113e-18;5.49669446483148e-18;1.03491861549651e-17;2.09299037178049e-17;3.41553019839856e-17;3.97159520382828e-17;3.13270903180569e-17;1.67785973779066e-17;6.65919952358774e-18;2.78841183315641e-18;1.93521504036644e-18;2.01402606100846e-18;2.56170650762058e-18;4.22585409929231e-18;8.00867278819464e-18;1.35546359847197e-17;1.67178453023876e-17;1.35279351781950e-17;7.14059672563560e-18;2.76800544031427e-18;1.17213774383494e-18;8.30729050057613e-19;7.91858533921734e-19;9.38531557489719e-19;1.67208303399223e-18;3.44389609516970e-18;5.78373973508472e-18;6.84798163623834e-18;5.43355443937310e-18;2.89092463846569e-18;1.14419224009843e-18;4.88516134062313e-19;3.44541682603726e-19;3.28031756553971e-19;3.47076385637403e-19;5.40849447004644e-19;1.11417892527377e-18;1.96914649035712e-18;2.48557634950701e-18;2.18330620193227e-18;1.43724383277492e-18;8.49383436081173e-19;5.35795828882163e-19;3.46549406926454e-19;2.27779512530624e-19;1.76694051528101e-19;2.25296534329122e-19;4.43466535334892e-19;7.81551755706075e-19;9.09786682490950e-19;6.35415553067896e-19;2.94783533824804e-19;1.68401979294708e-19;2.17349438159453e-19;3.17336320132240e-19;3.66336167389479e-19;3.42744544075958e-19;2.82029247985490e-19;2.56053746206574e-19;2.92918469668568e-19;2.94412065680236e-19;1.95410526598343e-19;8.70116771973959e-20;3.98390770126940e-20;3.52576317959953e-20;4.17551019332940e-20;4.93911273710875e-20;7.93925195760277e-20;1.57345780477867e-19;2.58267185997185e-19;3.09072092320180e-19;2.62704144687451e-19;1.52064922014127e-19;6.19735552068185e-20;2.49054263569378e-20;1.79479112738689e-20;1.72687610742256e-20;1.39013530067668e-20;1.10574421001131e-20;1.44540472244122e-20;2.73697543266363e-20;5.16704594724962e-20;8.86583351318863e-20;1.29133227744222e-19;1.51056680546379e-19;1.34998135565339e-19;8.43508481701923e-20;3.64449763276696e-20;1.36170132111239e-20;6.84305596496142e-21;5.79187113043657e-21;6.89270413268171e-21;7.76660802995906e-21;7.22048628239262e-21;8.12447567093129e-21;1.61988408901721e-20;3.64200856865938e-20;6.45805159404001e-20;8.65393498132307e-20;8.45422142601949e-20;5.41978014126557e-20;2.27349868607999e-20;8.41005109027746e-21;4.44550814890940e-21;3.08536015636314e-21;2.34828335424477e-21;2.18111590031778e-21;2.57546768579055e-21;3.80090457879436e-21;7.77217892948249e-21;1.72913637018795e-20;3.12297990023957e-20;4.32846510402363e-20;4.60007403065609e-20;3.52006026823482e-20;1.85250723638689e-20;7.22548803692766e-21;2.88194831685413e-21;1.67517877485803e-21;1.28609233608627e-21;1.19787718017967e-21;1.32898039419433e-21;1.80577983989219e-21;3.59573309606746e-21;8.02865963376795e-21;1.49928263799569e-20;2.24442644863787e-20;2.59204575597353e-20;2.07262938851202e-20;1.09649771788678e-20;4.19429768308551e-21;1.59852587451508e-21;8.71376009228670e-22;6.35125459862380e-22;5.51411239938318e-22;5.81777547869669e-22;8.15753037564069e-22;1.64386422514929e-21;3.62960894229926e-21;6.72833329503936e-21;1.02691442090500e-20;1.29130513499711e-20;1.18975175812774e-20;7.19561803108874e-21;2.90811152186865e-21;1.02460763555858e-21;4.83348294218121e-22;3.23182390859973e-22;2.69199676008824e-22;2.74607478205951e-22;3.72829563911984e-22;7.39509571160032e-22;1.63338371284104e-21;3.10292961505884e-21;4.94667802267122e-21;6.48979599348038e-21;6.14658233072626e-21;3.77282050904216e-21;1.52944958356257e-21;5.29110520011508e-22;2.42511647218819e-22;1.60475514774044e-22;1.32199129888477e-22;1.31084621330945e-22;1.68882780674295e-22;3.19489604854809e-22;7.00216034195888e-22;1.34998845434475e-21;2.23620052339485e-21;3.04957891980680e-21;2.96165695072525e-21;1.85055441320000e-21;7.80853094863415e-22;3.07920029025440e-22;1.62780087523413e-22;1.03341454914368e-22;7.45537198306041e-23;6.84843266865764e-23;8.21740862439669e-23;1.39431274111308e-22;2.90635893593283e-22;5.65702574567694e-22;9.75689940189855e-22;1.38437972970149e-21;1.37621122938590e-21;8.63259104711061e-22;3.51049206191738e-22;1.22327143996574e-22;6.12683171884375e-23;4.89525220612508e-23;4.79036488912991e-23;4.74647916011875e-23;4.83216538161473e-23;6.90445753589606e-23;1.35116455475564e-22;2.69893744875401e-22;4.80835665620608e-22;6.45061031131151e-22;5.68541424432585e-22;3.19180152411722e-22;1.23707723667300e-22;4.39733862509195e-23;2.13843703102127e-23;1.48844884021530e-23;1.31998313640158e-23;1.48955936092246e-23;2.08518123599890e-23;3.38355763218722e-23;6.04220991879520e-23;1.12906635892431e-22;1.96001205215330e-22;2.60853647358716e-22;2.32273902139058e-22;1.33477163292187e-22;5.45036911716566e-23;2.22643293419277e-23;1.22353771258533e-23;7.90925878415072e-24;5.95362827586189e-24;5.86143538302242e-24;6.97870387218914e-24;1.06025210124670e-23;2.22209488198950e-23;5.14059675507331e-23;9.68652824536034e-23;1.18297892081615e-22;8.38233704515549e-23;3.55343168096934e-23;1.15677159918153e-23;4.68536421314063e-24;2.81691971022028e-24;2.14258624085992e-24;1.95796017558961e-24;2.30652911477416e-24;3.60830141787906e-24;6.24054234599790e-24;1.02219826939911e-23;1.85335734552821e-23;3.31585223217274e-23;4.07758543127457e-23;2.99362296751967e-23;1.45083130291259e-23;6.74302335923120e-24;3.87293358376799e-24;2.22999858881038e-24;1.22591980325163e-24;7.99115062957926e-25;7.05848806571158e-25;8.77775108538117e-25;1.48545209719120e-24;2.88735630479949e-24;6.23519961180800e-24;1.11702537520925e-23;1.30127486348690e-23;9.08294852206748e-24;4.29842643242684e-24;2.27482967292616e-24;1.90883130513026e-24;1.90392981152105e-24;1.85471429427199e-24;1.54621432121952e-24;1.06988177440150e-24;7.17185872280936e-25;6.60186706444791e-25;1.06480919175793e-24;2.23393452172113e-24;3.59600346112259e-24;3.66671244113111e-24;2.28102174369805e-24;9.24330254486379e-25;3.26219876270624e-25;1.62469403463380e-25;1.32154276170950e-25;1.75685614278653e-25;3.50672258393349e-25;7.07426955080005e-25;1.06509916630210e-24;1.10083343106834e-24;9.50542382584513e-25;1.07464007387390e-24;1.23453370028007e-24;9.27437947572346e-25;4.36847206724154e-25;1.60802553006178e-25;6.80210206761107e-26;4.10066709982409e-26;3.11441293336063e-26;2.64940356796856e-26;2.55757252551698e-26;3.13271797778877e-26;5.45747762257831e-26;1.24257671521151e-25;2.74037822867099e-25;4.46809317043477e-25;4.74428944471746e-25;3.34434637939886e-25;2.18617781745588e-25;2.03366308983625e-25;1.86588957105334e-25;1.19659181576420e-25;6.15487190541669e-26;4.73238659011910e-26;4.82510292623755e-26;3.64858519817862e-26;2.22255585020104e-26;2.22263895227035e-26;3.82368645622186e-26;5.34027191303699e-26;5.95579977738345e-26;7.66991012079597e-26;1.01494016597381e-25;9.69002272641791e-26;5.96482854542315e-26;2.59540945583676e-26;1.28147100529465e-26;1.42007886732082e-26;2.78025631659259e-26;5.23422142164498e-26;7.10757274403796e-26;6.43296584790564e-26;4.22378210316956e-26;2.80614956433013e-26;2.22935600063543e-26;1.52871806049072e-26;9.65718271434361e-27;1.20259982837093e-26;2.41938753357196e-26;3.76429358350433e-26;3.71126236736404e-26;2.26273413109839e-26;9.23092882446715e-27;3.44209400339471e-27;1.84353016784636e-27;1.52828976702805e-27;1.74032619606231e-27;2.93952501432960e-27;7.04167351814031e-27;1.63284395419882e-26;2.71574378317988e-26;2.87359838621516e-26;1.89760834514331e-26;9.98717438478077e-27;9.40890357483770e-27;1.39516793299467e-26;1.70689429962710e-26;1.48309102746417e-26;8.71649939592838e-27;3.59755478890812e-27;1.36857402446913e-27;6.98034982834430e-28;4.84445179482459e-28;3.98748133344064e-28;3.58078146727687e-28;3.60855079658997e-28;4.45084908303706e-28;7.32539624185118e-28;1.74887556673314e-27;4.70182817659233e-27;9.77985596755488e-27;1.29445705684182e-26;1.12072686893202e-26;8.40068744683966e-27;6.78183538710392e-27;4.85925948655269e-27;2.57804140143171e-27;1.05820683312898e-27;4.60451391519667e-28;2.92382760521691e-28;2.34224212903927e-28;1.94874631706132e-28;1.53235448658017e-28;1.27596554242555e-28;1.21608649085319e-28;1.31912986275981e-28;1.73405011188575e-28;3.27523162854688e-28;8.66189810381250e-28;2.19802366892105e-27;4.07564389839198e-27;5.10407003828782e-27;4.27587985040526e-27;2.51432315488361e-27;1.39830882241022e-27;1.07731161949289e-27;8.23640192997078e-28;4.81724604572537e-28;2.35127937107138e-28;1.27808714554896e-28;9.90822189482028e-29;9.34960041483972e-29;8.36621093448862e-29;7.54976387104866e-29;9.38313038900953e-29;1.77833723133082e-28;3.40928944109995e-28;4.49072677985854e-28;3.99416834019663e-28;4.27045164738717e-28;8.21016774044953e-28;1.43983725487131e-27;1.62174011228607e-27;1.10038746422740e-27;5.19986279452303e-28;3.30622068039376e-28;4.01658440056094e-28;5.85128184957973e-28;7.80115835863565e-28;7.59694018374367e-28;4.99728289211423e-28;2.54945732751226e-28;1.71387148348249e-28;2.07487056937213e-28;2.38249245917777e-28;1.83856033020614e-28;1.09118794252890e-28;8.31902764831512e-29;1.05334258153018e-28;2.02809599231187e-28;4.50093926908131e-28;7.51070906129934e-28;8.02432307491133e-28;5.85626057640804e-28;4.32955734207359e-28;4.10319455050674e-28;3.37695621316845e-28;2.41400882678404e-28;3.00607586317961e-28;7.64514051359384e-28;1.78577031275502e-27;2.63575660133776e-27;2.32887270100694e-27;1.32734655536349e-27;6.52749641317511e-28;5.07732850833986e-28;5.56105579463323e-28;5.38283981483944e-28;5.63472866748226e-28;8.57910359269763e-28;1.18601334945483e-27;1.10375138577008e-27;7.33197868308308e-28;4.21886852425418e-28;2.59415927030547e-28;2.48674750014150e-28;4.57614654833388e-28;8.95313582981311e-28;1.16911988427024e-27;9.44908355189867e-28;6.55464722877379e-28;9.19445556671753e-28;2.44131636997194e-27;5.72202339776218e-27;8.57325833217685e-27;7.88922111611564e-27;5.11142760705524e-27;3.71371347575888e-27;4.37406554521610e-27;5.11686348915205e-27;4.19598699557480e-27;2.44681912108182e-27;1.35226746492738e-27;9.47138130364302e-28;6.83920940000443e-28;4.67427195247534e-28;3.86101861097252e-28;4.20816113876684e-28;6.46306878581625e-28;1.44853879753086e-27;3.01908922526526e-27;4.10114842035365e-27;3.47468492477888e-27;2.70860779718640e-27;4.10048003666265e-27;1.03801905920618e-26;2.37737926835677e-26;3.67546831422609e-26;3.69860305334635e-26;2.64234580028930e-26;1.57067050371938e-26;9.25160582952253e-27;5.40819507259477e-27;2.89447305111676e-27;1.62503662780258e-27;1.19003617871095e-27;1.11794816637733e-27;1.18862426115024e-27;1.26799224725041e-27;1.51898296993110e-27;2.48219955024000e-27;5.55111232287449e-27;1.19990747924807e-26;1.93210956166268e-26;2.50976611540471e-26;3.05011772994990e-26;3.72417315855387e-26;4.75265986041513e-26;6.20378863386983e-26;8.35413254061424e-26;9.83910928258173e-26;8.52994994276368e-26;6.24769083845941e-26;4.77995197644393e-26;3.22191004022791e-26;1.69131240456789e-26;8.87276284140865e-27;6.98586464452047e-27;9.81565222754415e-27;2.18950630736311e-26;4.69743488329848e-26;6.74573150510229e-26;6.35134323492689e-26;5.19422345655473e-26;6.17839207879495e-26;1.01664790463906e-25;1.47781667303842e-25;1.61127175146940e-25;1.69123399308913e-25;2.32703436248740e-25;3.00231901318223e-25;3.01311611112637e-25;2.88818627567918e-25;2.67989981277366e-25;2.10584885502551e-25;1.82307176588992e-25;2.33499557697642e-25;2.85949447005976e-25;2.44762473613100e-25;1.62055242516296e-25;1.09048020053979e-25;9.52094673292508e-26;1.18887024227287e-25;2.13266478870261e-25;5.23658924533326e-25;1.19471445041278e-24;1.77262892394622e-24;1.58748102554975e-24;9.45243817431244e-25;4.87033116092161e-25;3.11798246438459e-25;3.68384265898536e-25;6.72957900923302e-25;1.04734229941874e-24;1.23946101310165e-24;1.25308417274345e-24;1.09894275193972e-24;8.16211283995784e-25;5.81391337148128e-25;5.33769304965077e-25;9.15485548320650e-25;2.50241563255187e-24;5.73550194542331e-24;8.07456230861766e-24;6.74629857792857e-24;3.83625284804804e-24;2.00658186631156e-24;1.54320041598048e-24;2.15064789468434e-24;2.98696002723498e-24;3.02193399000244e-24;2.56740604146339e-24;2.31942226776141e-24;1.94524612087432e-24;1.51023550947335e-24;1.57020884913699e-24;3.04143871203904e-24;8.41373115695115e-24;1.98569911734717e-23;3.10919172568013e-23;3.05544817782402e-23;1.94593668254066e-23;9.51942799298531e-24;6.55933558575734e-24;8.60962562596147e-24;1.09757205624186e-23;1.04527389687034e-23;8.47987887659777e-24;7.31611271427276e-24;6.42703567945959e-24;4.81407315579653e-24;3.97877663048075e-24;5.24474989179078e-24;1.19575030416865e-23;3.53785513068647e-23;8.34916853702456e-23;1.21048910401624e-22;1.02502768569549e-22;5.50024780009412e-23;2.74206390114774e-23;2.66505564673388e-23;3.52475383437574e-23;3.78941070685758e-23;3.51008799974692e-23;3.19839556605053e-23;2.65760081135543e-23;1.82756941778665e-23;1.22863583292550e-23;1.17467212510088e-23;1.76333191495456e-23;4.18872430243367e-23;1.27311968587783e-22;3.00961686106147e-22;4.25220307852733e-22;3.44403069857892e-22;1.82370534608824e-22;1.02347711243516e-22;9.27662942482096e-23;9.12705651759229e-23;8.64302343177629e-23;8.91149314761069e-23;8.73227040959412e-23;7.57030765757168e-23;6.29410076981089e-23;5.87649713964473e-23;6.92674041751425e-23;1.23104542870742e-22;3.04756128188826e-22;7.11213533839713e-22;1.16408035518953e-21;1.21316653492256e-21;8.25106070537648e-22;4.48446259097132e-22;3.00477131702856e-22;2.60713422467221e-22;2.46695553502946e-22;2.58569347330228e-22;2.53333809757586e-22;2.23698032712457e-22;2.31804804877479e-22;2.63700982737022e-22;2.57917871311528e-22;2.57632796471178e-22;4.30368571005727e-22;1.17220234242570e-21;2.73605832748942e-21;3.93386763327810e-21;3.36366662645455e-21;2.00444489896174e-21;1.17150872357297e-21;8.44105729814854e-22;8.31577620044969e-22;1.08892059242605e-21;1.24246568121358e-21;9.68594085704717e-22;5.61282685648275e-22;3.43879948307781e-22;3.23789658186889e-22;4.31165213497809e-22;8.29877834575960e-22;2.23539673051057e-21;5.55177623510001e-21;9.52270682589606e-21;1.06291621332798e-20;8.37063258311584e-21;5.87458494098251e-21;4.44865045280688e-21;3.43535722271538e-21;2.82893229474858e-21;2.43502512712140e-21;1.77149950969386e-21;1.07457814239929e-21;7.23704520448225e-22;6.74436763878547e-22;8.31995696644644e-22;1.31759788070504e-21;3.03981606407498e-21;9.01789163393359e-21;2.19351886002485e-20;3.40232017491695e-20;3.28481597269909e-20;2.16663255857833e-20;1.16302177529943e-20;7.01530528207563e-21;6.27216528347639e-21;6.03712997218676e-21;4.57504396569646e-21;2.92896112391320e-21;2.55189801940221e-21;4.25135859504709e-21;9.07809798132029e-21;1.56215612324762e-20;1.96176752536067e-20;2.36095869013446e-20;3.93257613550349e-20;6.61800976514474e-20;7.92504314243581e-20;6.33737450434640e-20;3.71120324799438e-20;2.16894709149345e-20;1.83766284820068e-20;1.89365752668929e-20;2.12809914997185e-20;3.08457882562525e-20;4.24381739429895e-20;4.10958023199667e-20;2.82074721738529e-20;1.76341779924404e-20;1.47770377797748e-20;2.07720550739073e-20;5.00201142231907e-20;1.18761399550716e-19;1.89677656156748e-19;1.92877888280140e-19;1.38702852653333e-19;9.98323051997171e-20;1.12146249291495e-19;1.40338276951139e-19;1.29779346989558e-19;8.54536563105143e-20;4.77064616673253e-20;3.00680590535270e-20;2.16013892070773e-20;1.80750687363142e-20;2.07874399365032e-20;3.49923103125139e-20;8.59405908269931e-20;2.25123629783557e-19;4.58640191507389e-19;6.53810563601659e-19;6.50289152415657e-19;4.78098318975732e-19;3.01949375019956e-19;1.98617846652401e-19;1.34825181615940e-19;8.25817421514195e-20;4.98984101755460e-20;4.03459852931605e-20;4.38993305350616e-20;6.17743832451426e-20;1.27281596218084e-19;2.99581863534305e-19;5.81640219429171e-19;9.05928734771096e-19;1.25647300432074e-18;1.46233402710530e-18;1.25366114663397e-18;8.33979066973907e-19;5.38448160214953e-19;3.80361503322913e-19;2.61561766894313e-19;1.73816559898766e-19;1.55212685098746e-19;2.67561286868254e-19;6.14089128759194e-19;1.12470207141490e-18;1.41901394620552e-18;1.28265472720584e-18;1.03535029535053e-18;1.09918385629344e-18;1.66233064096832e-18;2.44481607008803e-18;2.68749189962698e-18;2.20174534746528e-18;1.57456252301379e-18;1.20852841805987e-18;1.26517060331801e-18;2.00419009393548e-18;3.06161084578851e-18;3.34488666484814e-18;2.63217152346855e-18;1.76403153453614e-18;1.20392633573679e-18;8.17972043727213e-19;6.57242250205485e-19;9.85240132338122e-19;2.31931643470406e-18;5.02464339485981e-18;7.61627757344552e-18;8.38946495350804e-18;8.75073860384234e-18;9.27006511509557e-18;8.05083039952169e-18;5.56295559455887e-18;3.78054895485668e-18;2.89315004911314e-18;2.45706354471364e-18;2.82908011914169e-18;3.51558635073774e-18;3.29562023691460e-18;2.62756546449245e-18;3.27247989835918e-18;7.59501895294955e-18;1.72453182930816e-17;2.70078607551975e-17;2.86607537337042e-17;2.44492833420627e-17;2.07714093265413e-17;1.70731363340119e-17;1.13315615312840e-17;5.96266835695205e-18;3.30608035557329e-18;3.10662410417935e-18;4.85371150950615e-18;8.90662921049748e-18;1.78587527700167e-17;3.36618490621826e-17;4.91850870555688e-17;5.37213462905434e-17;5.00091848140338e-17;4.75451388987101e-17;4.50205807371815e-17;3.95854097648308e-17;3.63796072000203e-17;3.47513825725165e-17;3.34944611798270e-17;4.33125412686330e-17;6.42912252310569e-17;8.11160689795470e-17;8.59937381340758e-17;7.86451200563163e-17;6.67158194981601e-17;6.59010190745955e-17;8.51148425785894e-17;1.14235874827946e-16;1.45587529225824e-16;1.84633548921872e-16;2.05093267336499e-16;1.72954318195617e-16;1.17237951590335e-16;8.67417518886698e-17;1.01855108668583e-16;1.53375856662217e-16;2.32831263681537e-16;3.62000073143704e-16;4.97606039005916e-16;5.19614549659502e-16;4.08859834179975e-16;2.57215646909354e-16;1.45580582069654e-16;1.01537560753804e-16;1.23475509845881e-16;2.27899061992843e-16;4.75744497972280e-16;9.48580146967517e-16;1.46944541016907e-15;1.57717744163056e-15;1.19702141390385e-15;7.26833388737326e-16;4.20753447212887e-16;2.71127539221740e-16;2.38152574889858e-16;3.40739675821623e-16;7.26008393735688e-16;1.66161131817602e-15;2.92356692853496e-15;3.48149693647366e-15;2.88185795551740e-15;1.93374674274255e-15;1.35197861759804e-15;1.15860476488579e-15;1.12819817224393e-15;1.15887604022823e-15;1.58134885395305e-15;3.27404665163870e-15;6.28836979211789e-15;8.20254480353331e-15;6.86746682171067e-15;3.97490172285816e-15;2.11573529909458e-15;1.77099752505612e-15;2.27695500685413e-15;3.17408529905921e-15;4.94412235931962e-15;8.69876309805469e-15;1.41781207023416e-14;1.79488689477100e-14;1.61521207718900e-14;1.02959716950356e-14;5.23626788937402e-15;3.24352361397653e-15;3.87907503396402e-15;6.44959898528537e-15;1.14463735822601e-14;1.96571739624306e-14;3.01987346218784e-14;3.78290187547003e-14;3.50487065909287e-14;2.35275652470690e-14;1.29208823223588e-14;8.34202680334364e-15;8.80892017672077e-15;1.35587560898120e-14;2.39689334051100e-14;3.83055161182325e-14;5.47586815986952e-14;7.19226883875738e-14;7.73108846659251e-14;6.17354051026798e-14;3.84687197104361e-14;2.42665720043778e-14;2.27544044058358e-14;3.28802707280183e-14;5.12325371142278e-14;6.74653501676310e-14;8.42353113372021e-14;1.19508445521361e-13;1.56420928414268e-13;1.51689715008567e-13;1.11880435864470e-13;7.42440217274607e-14;6.18918293460707e-14;8.41251786351169e-14;1.21970359406642e-13;1.42750769416332e-13;1.63383276599358e-13;2.29703306040435e-13;3.06927203562040e-13;3.06066320213633e-13;2.37389236976448e-13;1.72513348376649e-13;1.55134519417217e-13;2.01917801148429e-13;2.64174135787831e-13;2.80941598543764e-13;3.02536490782259e-13;4.18638838926656e-13;5.82250032483149e-13;6.32752134637457e-13;5.34481493343894e-13;4.06209115310072e-13;3.79279444607100e-13;4.94853195144158e-13;6.11514429575515e-13;5.91178308294651e-13;5.62459208442927e-13;7.48783930545063e-13;1.11163916994869e-12;1.35397997412828e-12;1.29377671695393e-12;1.04068397204960e-12;8.69306738908680e-13;9.01480848412839e-13;1.00331493559690e-12;1.07248848846190e-12;1.25451221482852e-12;1.75110812506388e-12;2.32460983007405e-12;2.54528465321137e-12;2.37026532960128e-12;2.10320283808650e-12;2.18041016299116e-12;2.59546409880194e-12;2.80714628407135e-12;2.52321159840043e-12;2.12395564806396e-12;2.50170433369480e-12;4.04826493344833e-12;5.80188279391684e-12;6.38937565571731e-12;5.76366184441645e-12;4.87112576321614e-12;4.33783080678271e-12;4.44489822443467e-12;5.26322452068414e-12;6.34872956301100e-12;7.52046853669972e-12;9.11380284596987e-12;1.03367828646071e-11;1.03063794098685e-11;1.04155987191164e-11;1.18422114028622e-11;1.32622758642704e-11;1.31083065750180e-11;1.13045976954785e-11;9.35606697188461e-12;1.08445304499032e-11;1.79620504601013e-11;2.61752544716349e-11;2.88632068219117e-11;2.65372322162615e-11;2.27858703197185e-11;2.01422173575808e-11;2.20456716541509e-11;2.77656906426197e-11;3.19910738831524e-11;3.41820300886566e-11;3.66161362651281e-11;3.87788662480425e-11;4.20251894591062e-11;5.06210416275414e-11;6.11335488151160e-11;6.46497672128623e-11;6.05079332420170e-11;5.18337203529922e-11;4.42204146789449e-11;5.27944318159867e-11;8.22154916262963e-11;1.12349351653609e-10;1.23654941151806e-10;1.17219731604587e-10;1.03590601103511e-10;9.79465704131021e-11;1.13975172256276e-10;1.38927883223109e-10;1.49593583205384e-10;1.50276410006873e-10;1.55624592430958e-10;1.73447927877235e-10;2.12301869126177e-10;2.58903578370617e-10;2.76871589544296e-10;2.62839959730194e-10;2.41912121975484e-10;2.21779593983901e-10;2.17029583200368e-10;2.69458058451050e-10;3.72946811027616e-10;4.64840797050275e-10;5.01090657611214e-10;4.75243696125638e-10;4.26405121118528e-10;4.44508986955656e-10;5.46540859873375e-10;6.36822505445332e-10;6.60848599284242e-10;6.41607251368919e-10;6.40716147557706e-10;7.43919033508101e-10;9.22625703032348e-10;1.04653627156279e-09;1.07014074722770e-09;1.05663362953285e-09;1.04297740054684e-09;1.04731792062173e-09;1.15460552521637e-09;1.37000094171952e-09;1.59976632208384e-09;1.78701881964240e-09;1.82786896713363e-09;1.69241120793409e-09;1.64946857552670e-09;1.86755154265326e-09;2.17511432999216e-09;2.39082487356974e-09;2.50760509812836e-09;2.57091932439402e-09;2.70999992850389e-09;3.10691770537422e-09;3.58793120915353e-09;3.88173089757140e-09;4.03695679421304e-09;4.02634008472987e-09;3.89854448592278e-09;4.14956038325282e-09;4.75446784434525e-09;5.24076585269337e-09;5.71200029155592e-09;6.36091730232474e-09;6.77689088116484e-09;6.88294320057808e-09;7.26300868980788e-09;7.87388580815370e-09;8.53178303227617e-09;9.33927017487377e-09;9.69606544105427e-09;9.64230062036959e-09;1.06499698686684e-08;1.25127260132392e-08;1.38607043834859e-08;1.48252109233495e-08;1.51593738281461e-08;1.44092682103744e-08;1.46611745196763e-08;1.67817461551010e-08;1.88388254961191e-08;2.06300739871780e-08;2.36295097689113e-08;2.63046402145084e-08;2.67854081209830e-08;2.79165856566919e-08;3.13826534428453e-08;3.56018600615036e-08;4.02015044950453e-08;4.31344698871939e-08;4.34000046238612e-08;4.69497178961237e-08;5.50628591915138e-08;6.20748431925278e-08;6.77406020638698e-08;7.52552251067970e-08;8.22335467073988e-08;8.80219367113468e-08;9.82794023415449e-08;1.10639099483728e-07;1.22249413240697e-07;1.40702867513495e-07;1.60574481453659e-07;1.71836974919010e-07;1.89851435486694e-07;2.22417805707725e-07;2.53034122245048e-07;2.81343915409831e-07;3.15023282248023e-07;3.37895238720593e-07;3.55157447119533e-07;4.04359641207162e-07;4.79297043558272e-07;5.37318396045373e-07;5.93891038696689e-07;6.77310285516539e-07;7.59908674905018e-07;8.41468531644771e-07;9.59287035561882e-07;1.11004949622577e-06;1.26013522190635e-06;1.39839656697034e-06;1.52716652741214e-06;1.66456463327171e-06;1.84943192237806e-06;2.08420424321333e-06;2.35886890914218e-06;2.69511392200271e-06;3.00833817051701e-06;3.23334569772259e-06;3.55293475115061e-06;4.02561106441464e-06;4.50816523470434e-06;5.07070717635026e-06;5.75440465663514e-06;6.31623937803357e-06;6.81678445562488e-06;7.64351642252810e-06;8.52125842907452e-06;9.22477249658941e-06;1.03612936034744e-05;1.17078477377048e-05;1.25549816771353e-05;1.35796466323793e-05;1.53753646882058e-05;1.70462544240069e-05;1.83015401611145e-05;2.01588213085511e-05;2.24041439364489e-05;2.41952696733698e-05;2.65804678931360e-05;2.97112143871091e-05;3.23483222600439e-05;3.53132698548127e-05;3.90597524767277e-05;4.25418777984089e-05;4.62755931826460e-05;5.00634001671194e-05;5.30712563534188e-05;5.66713176642222e-05;6.23303781581389e-05;6.89972422415492e-05;7.53786836378305e-05;8.27932045989634e-05;9.00568092797135e-05;9.69295370471490e-05;0.000107505957563475;0.000117191092608884;0.000122445635333975;0.000132623614324037;0.000145003648829776;0.000149782520399518;0.000156306142157398;0.000173110097474306;0.000191683713589209;0.000207264065720902;0.000228443118193871;0.000249104363114342;0.000263222086920612;0.000286202948667543;0.000308043680418920;0.000316430557312009;0.000344126122489705;0.000388156153423943;0.000412718140763480;0.000438472372620850;0.000476524287009465;0.000494693533374848;0.000509222919662494;0.000562333924611764;0.000636987065164820;0.000686240546138289;0.000730658484259213;0.000786391321044597;0.000841580294020986;0.000962517528146582;0.00111927283857445;0.00126642345273322;0.00148255539156831;0.00173036643596084;0.00194220828287724;0.00221361590877671;0.00254298305150131;0.00281766796775785;0.00311910289546933;0.00356269998036202;0.00405188958051600;0.00448546860819850;0.00501363168592512;0.00565498225710112;0.00634683958535300;0.00728921700112192;0.00875931937617848;0.0101935196422597;0.0124157439292627;0.0163808804140551;0.0255072899025909;0.0529164584379875;0.122585060459332;0.238754827003518;0.361756944068098;0.451863644837095;0.507591914179903;0.543360541006437;0.565730064457189;0.572745962663460;0.562962088747939;0.540084145397574;0.506480954534113;0.460337191700099;0.401675159190194;0.335100184177253;0.271998010859557;0.242550547329710;0.311169398327213;0.492520432974436;0.593286035739462;0.461415560849981;0.292910012711724;0.256534081212926;0.309077287464233;0.386123978095459;0.460930511015312;0.523803950424491;0.571950192853187;0.604107703845089;0.619747638379733;0.620677739349286;0.609999423043465;0.586264222637099;0.543233050443363;0.470261252374690;0.355017017759672;0.219953640520348;0.121741642659667;0.0791799943877115;0.0659617103703334;0.0604812610672749;0.0588658649167252;0.0613804643862326;0.0655369407130963;0.0671350513341218;0.0687354456253524;0.0714934910164715;0.0709178640397857;0.0702317589550886;0.0761650904145915;0.0816623319719635;0.0802423641548586;0.0825455935568559;0.0902856121280903;0.0935414809977907;0.0961644837610264;0.100725507227052;0.0977136690277084;0.0937249695068527;0.103490030194961;0.114668963124335;0.113538898932873;0.117703048247293;0.125303104587312;0.120760781058433;0.122521581870934;0.129788153124802;0.119690844104572;0.111113993406829;0.131516204102301;0.161372916696796;0.177453458771189;0.203124429648955;0.238814935000390;0.261089258963233;0.287919852927673;0.315029770524509;0.314673217283255;0.309896546989092;0.320491438195741;0.324679690139915;0.311366318350162;0.296131973651986;0.283267377023745;0.261680764160603;0.239616465744066;0.232294711407546;0.227627851759091;0.213281212210855;0.201259657061649;0.193057927283682;0.183018035004470;0.182250921851661;0.201143871367216;0.236193649187612;0.274208278122497;0.304438520268606;0.329407349526972;0.344481121794744;0.344837710685381;0.344731448524339;0.348810312005858;0.336611296326512;0.309281067625380;0.289190449100139;0.265162476802927;0.225420115642106;0.195771009976045;0.176609841133509;0.153072371701726;0.146323384581642;0.150442323567353;0.140755872656544;0.137834724494759;0.143267218288236;0.135474760563456;0.131816091217105;0.135162064133986;0.127392677025472;0.123213799872588;0.124706363973135;0.116051930124160;0.110269569773023;0.111879938762035;0.106703230212263;0.101142174389318;0.101140831734407;0.0975478737360425;0.0927895801143141;0.0913138348463378;0.0872094917111019;0.0825264581229255;0.0805632973981186;0.0767775157773800;0.0730086467694504;0.0713053072160085;0.0678992683805273;0.0644003705239144;0.0626477133780275;0.0601679208040910;0.0570481135014017;0.0542997988728091;0.0514410250263192;0.0477195889776627;0.0435558221765611;0.0408362513099561;0.0386431472035878;0.0358037053110957;0.0342542458551307;0.0334633871210583;0.0312685186402117;0.0292407681397483;0.0280129452902541;0.0259360986759118;0.0238294467827153;0.0225901909448190;0.0212645241694035;0.0196173125296495;0.0180793931077617;0.0169340303800351;0.0159046521113071;0.0146247254494706;0.0134514395910304;0.0125070473909067;0.0115663606446347;0.0107759735403362;0.0101533231213676;0.00948712809257798;0.00873566987848655;0.00796238794987054;0.00731490202440828;0.00680553364023107;0.00637817563865380;0.00605162445674928;0.00574633049226679;0.00541372647034362;0.00509027356793235;0.00479452461288073;0.00455264352707298;0.00433007306506790;0.00414853302983096;0.00408526736965466;0.00404895002656572;0.00399874515588838;0.00402371797687780;0.00403245244214640;0.00393368217262633;0.00392052834921877;0.00411590401688542;0.00431599541577765;0.00440254578906785;0.00462406269309871;0.00487869960202765;0.00494194401176825;0.00518181379474395;0.00552609681771039;0.00548477209891828;0.00548383415265263;0.00609619329617108;0.00676835600360844;0.00696764360237384;0.00738970725390127;0.00803701929535050;0.00824475719832939;0.00859707155980463;0.00914984815162267;0.00905913246210996;0.00902614309990360;0.0100932949354035;0.0113175211811852;0.0116338852577158;0.0121897934233135;0.0131119154841614;0.0134609659848287;0.0142184239205238;0.0149564355159286;0.0142616526725060;0.0139385165607207;0.0156776939417721;0.0174284783407058;0.0176811228689540;0.0187721353159853;0.0202683533955279;0.0203050604474184;0.0213666290592628;0.0228385327913206;0.0220788632448406;0.0222274479941571;0.0239795615256060;0.0235909455261196;0.0225839543151315;0.0249253752874397;0.0275132283351173;0.0269272252966679;0.0278712109347756;0.0299779378492305;0.0291288049880621;0.0297831371034133;0.0316388731723967;0.0298502164213914;0.0305231187981019;0.0393697396291824;0.0506169221344084;0.0590746401950079;0.0680730165872838;0.0754519751028361;0.0767274651256537;0.0788561564507567;0.0826408837730133;0.0813996411084331;0.0781986929484611;0.0762280482893933;0.0728150843600744;0.0672046345669978;0.0609861505398369;0.0549505951602389;0.0504973303076587;0.0509118774498762;0.0537341191891820;0.0509561401032558;0.0428503131729540;0.0392799272871857;0.0443414197659271;0.0538182915690689;0.0631544253679826;0.0711693646337743;0.0775714694673670;0.0818044505162030;0.0846091403545042;0.0879693501634820;0.0884960679453513;0.0838929522987273;0.0813270395195390;0.0793343348565980;0.0705583149182155;0.0598754905372057;0.0497213067134641;0.0384064986820200;0.0324794940545424;0.0326701845612801;0.0314816088321221;0.0292287231841165;0.0304920052946748;0.0318243040795379;0.0299155988151394;0.0297494775167238;0.0310081059611480;0.0293952623428300;0.0287488610810887;0.0294256319592789;0.0274431694350637;0.0261226544173632;0.0262147664486384;0.0245119711561591;0.0235495035448942;0.0239029581176480;0.0227433823537666;0.0217289040774934;0.0213812219152198;0.0198875463655745;0.0189531806469922;0.0188171419134762;0.0177127443312330;0.0169880963572090;0.0167606019328643;0.0155850356377728;0.0147637665300371;0.0144518437529848;0.0134190525335473;0.0127146226805363;0.0124527251067038;0.0114957978057535;0.0107562623134858;0.0105935152934453;0.00994479734434139;0.00924256584133281;0.00886992822601994;0.00824780369318066;0.00772720420425366;0.00746451638932869;0.00692121510065754;0.00637592012490134;0.00610176695622527;0.00574121419479903;0.00531054624232687;0.00497685178766899;0.00463969778791435;0.00434967350579887;0.00409916506689072;0.00378687755218053;0.00352256011760761;0.00330313205615796;0.00301264457598042;0.00274527457055592;0.00252955810224161;0.00230824163091768;0.00213836040583258;0.00198915514437820;0.00180298847384304;0.00165042481627683;0.00153022039857056;0.00138385047363346;0.00125740074005486;0.00116412767211442;0.00105153359838296;0.000950309433655872;0.000884571033788152;0.000806629218762149;0.000721184217958255;0.000659929396439759;0.000611064656734469;0.000563598817917050;0.000513644548002948;0.000450775491416787;0.000385578510690975;0.000338584480374023;0.000304580615887439;0.000269765242847092;0.000240307848669385;0.000219195345473699;0.000197031810705917;0.000177136246550278;0.000162403525600292;0.000144135494251677;0.000123026791650612;0.000106073872051287;9.27419287630449e-05;8.09760049227003e-05;7.14797940340797e-05;6.41955114581985e-05;5.79793725549073e-05;5.16591905022159e-05;4.44383032475270e-05;3.70706888549326e-05;3.13234044742727e-05;2.76475481910885e-05;2.44989549959164e-05;2.14327150814349e-05;1.90570442955622e-05;1.65024630102490e-05;1.35849047505679e-05;1.14703402044426e-05;9.98048233584152e-06;8.54855091375895e-06;7.44558093275402e-06;6.45485741247576e-06;5.33655745067366e-06;4.48652224913909e-06;3.92416037144153e-06;3.35202227786628e-06;2.78065748330047e-06;2.30421181501090e-06;1.93220573157552e-06;1.65527400986660e-06;1.40427050613152e-06;1.15240514336219e-06;9.41469525474482e-07;7.82400795507438e-07;6.57612127391126e-07;5.59302491748839e-07;4.73537278771014e-07;3.95502055502340e-07;3.29937838509285e-07;2.76775938593408e-07;2.27037363288782e-07;1.83677608963655e-07;1.52037605438012e-07;1.24678407191342e-07;9.82750985417518e-08;8.24694542346230e-08;7.34882438640503e-08;6.31710236271344e-08;5.31832333547453e-08;4.41490851781816e-08;3.84104842340842e-08;3.54731855762384e-08;2.91821561405198e-08;2.24895876296865e-08;1.95109010991386e-08;1.84971889099127e-08;1.81148849419191e-08;1.72588117755160e-08;1.53394315571988e-08;1.42594333274220e-08;1.36827007453545e-08;1.09748161415695e-08;8.14416453645830e-09;7.69395837094700e-09;8.86435559135145e-09;1.02093851853039e-08;1.04801347403155e-08;9.13659483954359e-09;7.43443473968832e-09;7.18802335800964e-09;7.23589747103842e-09;6.09208131620057e-09;5.05246818531723e-09;5.17841686994470e-09;6.03475407726821e-09;6.66221616536688e-09;6.17139468771043e-09;5.05158300376453e-09;4.68481448174440e-09;4.73565531596194e-09;3.95317128401495e-09;3.05955295278973e-09;2.95803530232418e-09;3.38094398029108e-09;3.89334709510464e-09;4.13809516107511e-09;3.88988049107867e-09;3.46048174058209e-09;3.05952140035594e-09;2.37177065680660e-09;1.78410923354348e-09;1.72679216281732e-09;2.01270163490376e-09;2.41087630391198e-09;2.69646774184807e-09;2.51337776842742e-09;1.96208193134255e-09;1.68161766131949e-09;1.62293144219372e-09;1.37393600158836e-09;1.15513830990838e-09;1.20530749060868e-09;1.41141789154893e-09;1.59744473360898e-09;1.60012759378903e-09;1.39312490021635e-09;1.19682374682555e-09;1.08138336195700e-09;8.74419461004432e-10;6.96582046298742e-10;7.04579445378948e-10;8.32772580522070e-10;9.84824223231060e-10;1.06278837589145e-09;9.82829543892942e-10;8.15588262149373e-10;6.65826743284343e-10;4.98328713833001e-10;3.82275412671674e-10;3.96730780316775e-10;5.01720623155878e-10;6.40298738331757e-10;7.21025520761731e-10;6.53253915175079e-10;5.05932594150557e-10;3.88612294991587e-10;2.85749211940969e-10;2.17239419517071e-10;2.26891540128773e-10;2.96029133795175e-10;3.77954466899405e-10;4.20805502368193e-10;3.87162311972960e-10;2.97644270534925e-10;2.32135437012521e-10;2.06259431507973e-10;1.72527708000474e-10;1.52993316698356e-10;1.74551131354586e-10;2.14710624539287e-10;2.48425486503389e-10;2.50782677285440e-10;2.11113038907257e-10;1.61693001490912e-10;1.28507300906068e-10;9.86042392480531e-11;8.12000649253814e-11;9.01192552845060e-11;1.15973277026774e-10;1.45221082260256e-10;1.61101144185758e-10;1.46274683932487e-10;1.10149108297375e-10;7.83027096394747e-11;5.41620293367903e-11;4.19471199227895e-11;4.67482061379178e-11;6.22478230158064e-11;8.08952231269065e-11;9.39874337596184e-11;8.99210570898620e-11;6.90820328826366e-11;4.91740428638712e-11;3.81987763599201e-11;3.02281517108655e-11;2.74268232779742e-11;3.32121825451464e-11;4.41281691141051e-11;5.44698625245935e-11;5.69285143083429e-11;4.76441385456763e-11;3.38116414413628e-11;2.37860969544815e-11;1.68808451500681e-11;1.39544314390655e-11;1.67269957322864e-11;2.32578972265163e-11;3.07868079309376e-11;3.52581037711044e-11;3.20054788313369e-11;2.27640348537590e-11;1.45251834566493e-11;9.34969688048569e-12;7.53485945379363e-12;9.36524018340512e-12;1.33878834523561e-11;1.79997263953282e-11;2.08546143199259e-11;1.89408377463183e-11;1.32257354926430e-11;8.07473424774020e-12;4.86160050178162e-12;3.52866965723136e-12;4.21577408908628e-12;6.35096956876518e-12;9.14262951516451e-12;1.14197831258602e-11;1.14963319486618e-11;9.02700867618891e-12;5.71869337447321e-12;3.13478723536103e-12;1.88349254871725e-12;1.95028914648408e-12;2.95953774235949e-12;4.50999318417170e-12;6.06485629282708e-12;6.65234240726369e-12;5.58686505427165e-12;3.66817309894058e-12;2.20721701757825e-12;1.37935541129651e-12;1.12660641340856e-12;1.56377656051826e-12;2.48505699921722e-12;3.42317245146118e-12;3.78239323100902e-12;3.18149137097096e-12;2.06676547213125e-12;1.21830473620296e-12;7.53862714733254e-13;5.76427891626730e-13;7.10370604050986e-13;1.12279060145830e-12;1.69335005155657e-12;2.11960208000649e-12;1.98411624676863e-12;1.33476546939190e-12;7.38631221040633e-13;4.41848075326751e-13;3.52778205951971e-13;3.91022876700871e-13;5.44913815696560e-13;8.12639081272985e-13;1.08592909772609e-12;1.14449335445373e-12;9.03119928381050e-13;5.54462143274511e-13;3.23815384887897e-13;2.90681167435042e-13;3.84199835098392e-13;4.85820529760185e-13;5.76419233805800e-13;6.60199102867216e-13;6.57303224783850e-13;5.21381498245651e-13;3.34647472450765e-13;2.02168672912046e-13;1.99604085342486e-13;3.61045300642639e-13;5.83663516778926e-13;6.88687666291343e-13;6.54668722176031e-13;5.53558003421534e-13;4.20571485945039e-13;3.04689575041715e-13;2.45771821787789e-13;2.53842364745900e-13;4.12769723651344e-13;7.34982133172273e-13;9.98099982156863e-13;1.01389459694964e-12;8.44698305685539e-13;6.02897697295819e-13;4.00175408830905e-13;3.37906181862733e-13;3.65696424484458e-13;4.41600427253421e-13;7.53511733094860e-13;1.36689976175455e-12;1.87934493056202e-12;1.86758695318404e-12;1.42403539974679e-12;9.09287756629693e-13;5.99914438716251e-13;5.81567801973496e-13;6.80789778370781e-13;8.12648001770112e-13;1.35619446577626e-12;2.45874607394227e-12;3.39294722767944e-12;3.39130841716503e-12;2.63156535237853e-12;1.75616528318242e-12;1.22948340268884e-12;1.22110487185754e-12;1.44852895878368e-12;1.83693919212580e-12;3.11592323194065e-12;5.14652888480516e-12;6.31472367190230e-12;5.79821681904378e-12;4.32160511471326e-12;2.86388472061316e-12;2.09024289229664e-12;2.25141874221676e-12;2.75570674750640e-12;3.40210486270896e-12;5.57263164525330e-12;9.13301901990635e-12;1.12683245236135e-11;1.05102118979325e-11;8.03729138479981e-12;5.53779299547174e-12;4.21030114804510e-12;4.56537750102702e-12;5.57978775837800e-12;7.05524604614722e-12;1.15993519187082e-11;1.79659435258602e-11;2.04007940343982e-11;1.77600382239302e-11;1.31544622491531e-11;9.08840920673998e-12;7.23913538744992e-12;8.35475797868722e-12;1.03971327146447e-11;1.27679501653928e-11;2.02755200121366e-11;3.11651822221586e-11;3.56098751181355e-11;3.15322765619800e-11;2.44486616637791e-11;1.96189039319457e-11;1.94485646421902e-11;2.01643620300743e-11;1.88850112562817e-11;2.37468099133817e-11;3.95204954905354e-11;5.53137686686336e-11;5.85996958016356e-11;5.05104688047641e-11;3.93964441115545e-11;3.27287318393896e-11;3.42012280857447e-11;3.68713025825827e-11;3.63395301050166e-11;4.66888159604487e-11;7.06578422006897e-11;8.99393217225150e-11;9.38641662478898e-11;8.39162760779841e-11;6.78138844318423e-11;5.82185685980953e-11;6.28250345065449e-11;6.89920015520584e-11;6.80163948149168e-11;8.64906310727800e-11;1.31271561844474e-10;1.64334601603132e-10;1.62165002964224e-10;1.36795214154966e-10;1.09228155185887e-10;9.74760367450004e-11;1.10498950115450e-10;1.24356203150572e-10;1.26614340818149e-10;1.66816302099351e-10;2.45325043480997e-10;2.86720764342850e-10;2.66988429408119e-10;2.18265439241443e-10;1.71379686413948e-10;1.54660479673529e-10;1.87211309751268e-10;2.30986899883095e-10;2.52833366983310e-10;3.04216682117656e-10;3.91242158047914e-10;4.44009155670260e-10;4.27353575657307e-10;3.73664093751454e-10;3.49807720153383e-10;3.91951618889932e-10;4.15596690628138e-10;3.52221451075972e-10;3.44207169254333e-10;4.97087201271702e-10;6.88419710522830e-10;7.59302278645721e-10;7.02723279919735e-10;6.04590136300481e-10;5.66496114800673e-10;6.42942762212079e-10;6.97997862423472e-10;6.32217896670188e-10;6.88393769419594e-10;9.67985354349455e-10;1.20561772239875e-09;1.21832882296371e-09;1.06794339649006e-09;9.04860949909111e-10;8.87916085946431e-10;1.08848261215350e-09;1.24219658709780e-09;1.17170186472931e-09;1.29786178770138e-09;1.73292693307132e-09;2.00435597109007e-09;1.93579279388071e-09;1.68961596625529e-09;1.44414333469520e-09;1.43528130815467e-09;1.80981095946054e-09;2.16516202650801e-09;2.19672291045037e-09;2.41820007532095e-09;2.86989572401584e-09;3.07665335308609e-09;2.99226133242837e-09;2.78572668287267e-09;2.81164069318260e-09;3.37668249831224e-09;3.75637259022736e-09;3.25391629368387e-09;2.93605871956729e-09;3.70843839155916e-09;4.79554086202266e-09;5.24105206775658e-09;5.05619339226625e-09;4.73307630991310e-09;4.95806755765004e-09;6.18586993072768e-09;7.15218939437674e-09;6.60254703008833e-09;6.35869434696771e-09;8.24568402673216e-09;1.10233105169153e-08;1.23599924163526e-08;1.14994721405243e-08;1.12437761936779e-08;1.43354472850479e-08;1.88387521064774e-08;2.03051529263131e-08;2.13698076369267e-08;2.73636599005117e-08;3.35253323232597e-08;3.48037712181673e-08;3.97255144990708e-08;5.06800944068919e-08;5.52944668859215e-08;5.53209567511106e-08;7.15772604923952e-08;9.89377419576543e-08;1.08868362655397e-07;1.10539777786258e-07;1.37843034966137e-07;1.78708747760208e-07;1.95428255785669e-07;2.04571990657538e-07;2.53608031954640e-07;3.20685447197089e-07;3.51123684965414e-07;3.80005595451646e-07;4.77911716791302e-07;6.05349708755115e-07;6.95765565520131e-07;7.66452683692999e-07;8.62003848156402e-07;9.98519126149654e-07;1.18181281324349e-06;1.39682747101055e-06;1.62362033306706e-06;1.84412743953619e-06;2.06490685306603e-06;2.34070220492304e-06;2.72084977109850e-06;3.19131858996143e-06;3.64503021526092e-06;4.11945272951407e-06;4.86396763738757e-06;5.86222043773408e-06;6.67254847096343e-06;7.29863834905642e-06;8.33227016011815e-06;9.63994670183447e-06;1.06431108423481e-05;1.18004973597999e-05;1.36781416107701e-05;1.56142069264318e-05;1.72421303546587e-05;1.97536029286693e-05;2.35906492528326e-05;2.68276787713037e-05;2.89637601605807e-05;3.27418463658752e-05;3.85007546328847e-05;4.28308636996409e-05;4.62976271710215e-05;5.30094729800841e-05;6.15860343974629e-05;6.77445787421441e-05;7.37257101991259e-05;8.40492236171701e-05;9.58110363513417e-05;0.000105227284313418;0.000115796159836068;0.000131867202179715;0.000151142400297270;0.000167660139255384;0.000180693878832092;0.000198188010785901;0.000220350291777673;0.000241121844330062;0.000267465855307101;0.000308101996804460;0.000350941697664673;0.000382516852825949;0.000417543192269855;0.000462917185334657;0.000493322677829982;0.000512584796155600;0.000570089154350985;0.000668283411890120;0.000746459984738404;0.000806223099454440;0.000892850455756440;0.000981495007003696;0.00105130873248373;0.00115568829959603;0.00130297795664899;0.00141463613716690;0.00149836524590421;0.00159383560480120;0.00168344976725009;0.00179313554297745;0.00197989044295064;0.00223635702169810;0.00248087037966327;0.00270783430715292;0.00292304069366705;0.00313633693385906;0.00343366159664283;0.00370771592572885;0.00383165899924298;0.00404635378179327;0.00451633106625495;0.00496869023081210;0.00527358991310434;0.00574414951643979;0.00618397055350849;0.00620979440560365;0.00640464143524585;0.00723695351078211;0.00804044618279924;0.00839283998980696;0.00905911669258178;0.00986595413255579;0.0101305394083220;0.0106723375242808;0.0115344477234942;0.0116124123156612;0.0116226255864263;0.0129967471203931;0.0147818920151109;0.0154104610740188;0.0161116211363010;0.0173397292925098;0.0179955125797815;0.0190331293099144;0.0201905902190303;0.0197423931019780;0.0194958448485568;0.0218176808905092;0.0245218990353079;0.0252850848534946;0.0266967862496981;0.0286108382138283;0.0288360647782908;0.0302176655436402;0.0319178554026308;0.0302791012175929;0.0294754188300511;0.0334946225215647;0.0374772067504639;0.0379171589483534;0.0400636543007306;0.0429476107362270;0.0422464112330378;0.0438285330214581;0.0466358908061950;0.0436276842146684;0.0416354074096537;0.0468914163463836;0.0512838109295719;0.0503839393340943;0.0531648337157987;0.0575105633441448;0.0561048281668058;0.0581791214610441;0.0641843925503352;0.0680399220682366;0.0832893521283084;0.114844019489594;0.150051644006484;0.186521901316462;0.224635602165645;0.252598442965484;0.263791217673979;0.271998934708587;0.278052362932017;0.270765498598806;0.257339674993869;0.244846137806233;0.228613250232631;0.207330906331422;0.185268524121009;0.169272991905265;0.170684583538720;0.194498603445169;0.212410193528181;0.187842127100108;0.139740955280205;0.118213132994408;0.135320204012420;0.170726082183443;0.206483360972075;0.237499979751960;0.262596887843990;0.279599600875625;0.289571287369789;0.297259867320986;0.296921613962185;0.283942010792088;0.270377172901806;0.251631658156864;0.213087382079580;0.165508337319061;0.120984770855748;0.0856358392591736;0.0709244941159082;0.0684569952803157;0.0627399268497994;0.0610545197143306;0.0629272199087455;0.0575650465872872;0.0532648462916637;0.0555839950218835;0.0552751995379039;0.0518184479065268;0.0521767046623316;0.0526859754790317;0.0489359912611059;0.0478768556540677;0.0490678741538669;0.0463184373186729;0.0446805764241397;0.0450511809600242;0.0422479609080388;0.0401126595624322;0.0398632383214268;0.0374668521744068;0.0357031069278903;0.0353632112289446;0.0332741594964523;0.0316266046762836;0.0307122962435584;0.0283783985492491;0.0270817310334933;0.0267896431926584;0.0251323273403463;0.0239106279703221;0.0232596086104180;0.0213956442753928;0.0200926298847376;0.0197156844617035;0.0183485005712551;0.0170737466607381;0.0165172413331739;0.0153386001564153;0.0143296489150889;0.0138958275793645;0.0128943155569815;0.0119116326143514;0.0114059200640114;0.0105757061205307;0.00973899791302032;0.00926359838199936;0.00863956144792384;0.00802466855703908;0.00765079434431848;0.00715107014870180;0.00656506870197426;0.00606723665350510;0.00554534192853954;0.00504979120548685;0.00465325983741615;0.00430403914225993;0.00394675852903958;0.00355475063274449;0.00324256433558438;0.00301985010007433;0.00275657617027598;0.00249645921160145;0.00229686293377407;0.00209972848625767;0.00190964962029942;0.00176726471702683;0.00164315559457313;0.00150043500217071;0.00134952432157651;0.00119357518180655;0.00104259876187996;0.000928970606504849;0.000847295119776784;0.000763761070880957;0.000684744447363438;0.000626860491140148;0.000572381283172970;0.000510744837991827;0.000455012758180907;0.000401471266918781;0.000346291471337660;0.000302866506416716;0.000270536325307080;0.000241013443664710;0.000216649403758066;0.000195263051589904;0.000170775527480579;0.000146237454572016;0.000126673713297258;0.000111030137488066;9.79006621199749e-05;8.67247363730795e-05;7.61210265222930e-05;6.55862887787170e-05;5.61677016775812e-05;4.85253398713605e-05;4.20722229949866e-05;3.66694322662973e-05;3.19954346029169e-05;2.72851628643178e-05;2.32701250611784e-05;2.04022365381075e-05;1.76763026559656e-05;1.49218847530057e-05;1.25057182622077e-05;1.03885363088868e-05;8.88550643105778e-06;7.68628395108752e-06;6.30168726128758e-06;5.21260608496041e-06;4.58424856227465e-06;3.94238428831834e-06;3.24755700810068e-06;2.68541434945668e-06;2.24154953909346e-06;1.91058431563815e-06;1.65288477687082e-06;1.37594631489480e-06;1.11261038794740e-06;9.14032592431798e-07;7.55974844990835e-07;6.29789805035108e-07;5.31247041938495e-07;4.33966672274873e-07;3.48468277001601e-07;2.97127517995225e-07;2.50773795621128e-07;2.01604112346083e-07;1.69743620846704e-07;1.46586235799436e-07;1.24943568709288e-07;1.09387517158138e-07;9.35559371036115e-08;7.74571568111807e-08;6.88983193927859e-08;6.03799424741402e-08;4.80521218625144e-08;3.97197109678115e-08;3.70837528025590e-08;3.73401419608639e-08;3.67920039804809e-08;3.24974096515020e-08;2.72491056388321e-08;2.63953408417669e-08;2.71327171762701e-08;2.30323963173019e-08;1.79069131312542e-08;1.65420591318189e-08;1.81057564625575e-08;2.05167829607602e-08;2.11234446231219e-08;1.89738435478818e-08;1.71408775543688e-08;1.61196505664071e-08;1.30897548188085e-08;1.00608073683432e-08;9.45067438372032e-09;1.03873837793978e-08;1.18801863712284e-08;1.30590705780878e-08;1.23741904900736e-08;1.02420128385546e-08;9.21374591865961e-09;8.77362747155467e-09;7.32234104541265e-09;6.14734937066606e-09;6.28066334684834e-09;7.22375968834005e-09;8.15106769704565e-09;7.93391178038303e-09;6.55631639620815e-09;5.75125239717714e-09;5.60463632432195e-09;4.75043528590701e-09;3.83167186806997e-09;3.75023498741997e-09;4.27356327640399e-09;4.96476290405629e-09;5.16822372684936e-09;4.56605088233309e-09;3.89685365525319e-09;3.45359057234079e-09;2.71027135341219e-09;2.08738478260084e-09;2.08711277555787e-09;2.51774086034231e-09;3.09141344230264e-09;3.39546632069220e-09;3.07593144642383e-09;2.49022455023402e-09;2.05712793969101e-09;1.60792217567006e-09;1.25161330105088e-09;1.23629049867852e-09;1.49163538943512e-09;1.81823841534747e-09;1.98313236894748e-09;1.82485267536136e-09;1.44985113899479e-09;1.21001362443639e-09;1.12624081994356e-09;9.51934269003463e-10;8.26680340812490e-10;9.02221137218752e-10;1.06508784215692e-09;1.19116930125324e-09;1.17925512581100e-09;1.00501468199730e-09;8.20241921263749e-10;7.04804047844522e-10;5.63088159006279e-10;4.56509603429092e-10;4.74911166623568e-10;5.78723826607126e-10;7.02319979315172e-10;7.68556893451115e-10;7.04397126679939e-10;5.55762879278139e-10;4.22575659497984e-10;3.05340906734892e-10;2.37788132678964e-10;2.55771898660220e-10;3.25223473085184e-10;4.05271720499023e-10;4.56603641098507e-10;4.33092851294992e-10;3.42872080200810e-10];
    
    j = handles.popupmenu2.Value - 1;
    
    if handles.popupmenu1.Value == 1
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))),handles.wavenumber_simulated,handles.data_simulated)
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend([handles.popupmenu1.String(2:end,1);'Simulated 1propenol spectrum']);
        xlim ([handles.min1 handles.max1]);
    else
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j)))(:,handles.popupmenu1.Value-1),handles.wavenumber_simulated,handles.data_simulated)
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend([handles.popupmenu1.String(handles.popupmenu1.Value,1);'Simulated 1propenol spectrum']);
        xlim ([handles.min1 handles.max1]);
    end
end


guidata(hObject, handles);



function edit_simulatedspectra_Callback(hObject, ~, handles)
% hObject    handle to edit_simulatedspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simulatedspectra as text
%        str2double(get(hObject,'String')) returns contents of edit_simulatedspectra as a double

if handles.counter1 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter2 == 0
    errordlg('You should first load both photolysis and reference spectra files');
elseif handles.counter4 == 0
    errordlg('You have not load the simulated spectra yet');
else
    handles.scaleforsimulatedspectra = str2double(get(handles.edit_simulatedspectra,'String'));
    
    j = handles.popupmenu2.Value - 1;
    
    if handles.popupmenu1.Value == 1
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))),...
            handles.wavenumber_simulated,handles.data_simulated*handles.scaleforsimulatedspectra)
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend([handles.popupmenu1.String(2:end,1);'Simulated 1propenol spectrum']);
        xlim ([handles.min1 handles.max1]);
    else
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j)))(:,handles.popupmenu1.Value-1),...
            handles.wavenumber_simulated,handles.data_simulated*handles.scaleforsimulatedspectra)
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend([handles.popupmenu1.String(handles.popupmenu1.Value,1);'Simulated 1propenol spectrum']);
        xlim ([handles.min1 handles.max1]);
    end
    
end


guidata(hObject, handles);



% --- Executes on button press in all.
function all_Callback(hObject, ~, handles)
% hObject    handle to all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all

if handles.counter1 == 0
    return
elseif handles.counter2 == 0
    return
else
    
    if handles.all.Value == 1
        size_uitable4 = size(handles.uitable4.Data);
        x = (1:size_uitable4(1,1))';
        axes(handles.axes1)
        plot(x,handles.uitable4.Data,'o')
        legend(handles.uitable4.ColumnName)
    elseif (handles.all.Value ~= 1 && handles.popupmenu1.Value > 1)
        x = handles.popupmenu1.Value - 1;
        axes(handles.axes1)
        plot(x,handles.uitable4.Data(x,:),'o')
        legend(handles.uitable4.ColumnName)
    end
end

guidata(hObject, handles);



% --- Executes on button press in pb_savecoeffs.
function mysave_ClickedCallback(hObject, ~, handles)
% hObject    handle to pb_savecoeffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savemenu = menu('Save options','Save reference subtracted Spectra',...
    'Save sum of scaled reference spectra','Save Coeficients','Save All');
if isempty(savemenu)
    return
else
    j = handles.popupmenu2.Value - 1;
    columnname = ['Wavenumber';handles.popupmenu1.String(2:end,1)]';%Horizontal
    rowname = ['spectra name/refspec name';handles.popupmenu1.String(2:end,1)];%Vertical
    refspecsname = handles.uitable4.ColumnName;%Vertical
    
    allrefsubtracted_tosave = num2cell([handles.uitable2.Data(:,1),handles.allrefsubtracted.(strcat('section',num2str(j)))]);
    allrefsubtracted_tosave = [columnname;allrefsubtracted_tosave];
    
    %     allrefsubtracted_tosave = ([handles.uitable2.Data(:,1),handles.allrefsubtracted.(strcat('section',num2str(j)))]);
    %     allrefsubtracted_tosave = [columnname;allrefsubtracted_tosave];
    sumofscaledrefspec_tosave= num2cell([handles.uitable2.Data(:,1),handles.sumofscaledrefspec.(strcat('section',num2str(j)))]);
    sumofscaledrefspec_tosave = [columnname;sumofscaledrefspec_tosave];
    
    uitable4_Data_tosave = num2cell(handles.uitable4_Data.(strcat('section',num2str(j))));
    uitable4_Data_tosave = [rowname,[refspecsname';uitable4_Data_tosave]];
    
    switch savemenu
        case 1
            [fileforrefsubtracted,pathforrefsubtracted] = ...
                uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save all references subtracted file','All reference subtracted');
            
            if isequal([fileforrefsubtracted,pathforrefsubtracted] ,[0,0])
                return
            else
                savefnname1 = fullfile (pathforrefsubtracted,fileforrefsubtracted);
                cell2csv(savefnname1,allrefsubtracted_tosave);
            end
            
        case 2
            [fileforsavesumofscaled,pathforsaveallscales] = ...
                uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save all sum of scaled spectra file','Sum of scaled reference spectra');
            
            if isequal([fileforsavesumofscaled,pathforsaveallscales] ,[0,0])
                return
            else
                savefnname2 = fullfile (pathforsaveallscales,fileforsavesumofscaled);
                cell2csv(savefnname2,sumofscaledrefspec_tosave);
            end
            
        case 3
            [fileforsavescales,pathforsavescales] = ...
                uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save all scale factors','Coefficients');
            
            if isequal([fileforsavescales,pathforsavescales] ,[0,0])
                return
            else
                savefnname3 = fullfile (pathforsavescales,fileforsavescales);
                cell2csv(savefnname3,uitable4_Data_tosave);
            end
            
        case 4
            [fileforsaveall,pathforsaveall] = ...
                uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save all information','all');
            
            if isequal([fileforsaveall,pathforsaveall] ,[0,0])
                return
            else
                savefnname1 = fullfile (pathforsaveall,strcat('All reference subtracted','_',fileforsaveall));
                savefnname2 = fullfile (pathforsaveall,strcat('Sum of scaled reference spectra','_',fileforsaveall));
                savefnname3 = fullfile (pathforsaveall,strcat('Coefficients','_',fileforsaveall));
                
                f = waitbar(0,'Files are being saved, please wait...');
                cell2csv(savefnname1,allrefsubtracted_tosave);
                waitbar(1/3);
                cell2csv(savefnname2,sumofscaledrefspec_tosave);
                waitbar(2/3);
                cell2csv(savefnname3,uitable4_Data_tosave);
                waitbar(3/3);
                close (f)
                
            end
    end
end


guidata(hObject, handles);



%% chk all
% --- Executes on button press in chk1.
function chk1_Callback(hObject, ~, handles)
% hObject    handle to chk1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk1
guidata(hObject, handles);

% --- Executes on button press in chk2.
function chk2_Callback(hObject, ~, handles)
% hObject    handle to chk2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk2
guidata(hObject, handles);

% --- Executes on button press in chk3.
function chk3_Callback(hObject, ~, handles)
% hObject    handle to chk3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk3
guidata(hObject, handles);

% --- Executes on button press in chk4.
function chk4_Callback(hObject, ~, handles)
% hObject    handle to chk4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk4
guidata(hObject, handles);

% --- Executes on button press in chk5.
function chk5_Callback(hObject, ~, handles)
% hObject    handle to chk5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk5
guidata(hObject, handles);

% --- Executes on button press in chk6.
function chk6_Callback(hObject, ~, handles)
% hObject    handle to chk6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk6
guidata(hObject, handles);

% --- Executes on button press in chk7.
function chk7_Callback(hObject, ~, handles)
% hObject    handle to chk7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk7
guidata(hObject, handles);

% --- Executes on button press in chk9.
function chk8_Callback(hObject, ~, handles)
% hObject    handle to chk9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk9
guidata(hObject, handles);

% --- Executes on button press in chk8.
function chk9_Callback(hObject, ~, handles)
% hObject    handle to chk8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk8
guidata(hObject, handles);

% --- Executes on button press in chk9.
function chk10_Callback(hObject, ~, handles)
% hObject    handle to chk9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk9
guidata(hObject, handles);

% --- Executes on button press in chk11.
function chk11_Callback(hObject, ~, handles)
% hObject    handle to chk11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk11
guidata(hObject, handles);

% --- Executes on button press in chk12.
function chk12_Callback(hObject, ~, handles)
% hObject    handle to chk12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk12
guidata(hObject, handles);

% --- Executes on button press in chk13.
function chk13_Callback(hObject, ~, handles)
% hObject    handle to chk13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk13
guidata(hObject, handles);

% --- Executes on button press in chk14.
function chk14_Callback(hObject, ~, handles)
% hObject    handle to chk14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk14
guidata(hObject, handles);

% --- Executes on button press in chk15.
function chk15_Callback(hObject, ~, handles)
% hObject    handle to chk15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk15
guidata(hObject, handles);

% --- Executes on button press in chk16.
function chk16_Callback(hObject, ~, handles)
% hObject    handle to chk16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk16
guidata(hObject, handles);

% --- Executes on button press in chk17.
function chk17_Callback(hObject, ~, handles)
% hObject    handle to chk17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk17
guidata(hObject, handles);

% --- Executes on button press in chk18.
function chk18_Callback(hObject, ~, handles)
% hObject    handle to chk18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk18
guidata(hObject, handles);



%% all creat function
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_numofaverage1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit_numofaverage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_numofaverage2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit_numofaverage2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt1_CreateFcn(hObject, ~, ~)
% hObject    handle to editt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editt2_CreateFcn(hObject, ~, ~)
% hObject    handle to editt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt3_CreateFcn(hObject, ~, ~)
% hObject    handle to editt3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, ~, ~)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt4_CreateFcn(hObject, ~, ~)
% hObject    handle to editt4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, ~, ~)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt5_CreateFcn(hObject, ~, ~)
% hObject    handle to editt5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, ~, ~)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt6_CreateFcn(hObject, ~, ~)
% hObject    handle to editt6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, ~, ~)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt7_CreateFcn(hObject, ~, ~)
% hObject    handle to editt7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, ~, ~)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt8_CreateFcn(hObject, ~, ~)
% hObject    handle to editt8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, ~, ~)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt9_CreateFcn(hObject, ~, ~)
% hObject    handle to editt9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, ~, ~)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt10_CreateFcn(hObject, ~, ~)
% hObject    handle to editt10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, ~, ~)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt11_CreateFcn(hObject, ~, ~)
% hObject    handle to editt11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, ~, ~)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt12_CreateFcn(hObject, ~, ~)
% hObject    handle to editt12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, ~, ~)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt13_CreateFcn(hObject, ~, ~)
% hObject    handle to editt13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, ~, ~)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt14_CreateFcn(hObject, ~, ~)
% hObject    handle to editt14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, ~, ~)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt15_CreateFcn(hObject, ~, ~)
% hObject    handle to editt15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, ~, ~)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt16_CreateFcn(hObject, ~, ~)
% hObject    handle to editt16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, ~, ~)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt17_CreateFcn(hObject, ~, ~)
% hObject    handle to editt17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, ~, ~)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editt18_CreateFcn(hObject, ~, ~)
% hObject    handle to editt18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.

function edit18_CreateFcn(hObject, ~, ~)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_simulatedspectra_CreateFcn(hObject, ~, ~)
% hObject    handle to edit_simulatedspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, ~, ~)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
