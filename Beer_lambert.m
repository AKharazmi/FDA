function varargout = Beer_lambert(varargin)
% BEER_LAMBERT MATLAB code for Beer_lambert.fig
%      BEER_LAMBERT, by itself, creates a new BEER_LAMBERT or raises the existing
%      singleton*.
%
%      H = BEER_LAMBERT returns the handle to a new BEER_LAMBERT or the handle to
%      the existing singleton*.
%
%      BEER_LAMBERT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEER_LAMBERT.M with the given input arguments.
%
%      BEER_LAMBERT('Property','Value',...) creates a new BEER_LAMBERT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Beer_lambert_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Beer_lambert_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Beer_lambert

% Last Modified by GUIDE v2.5 13-Jun-2016 12:30:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Beer_lambert_OpeningFcn, ...
    'gui_OutputFcn',  @Beer_lambert_OutputFcn, ...
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


% --- Executes just before Beer_lambert is made visible.
function Beer_lambert_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Beer_lambert (see VARARGIN)

% Choose default command line output for Beer_lambert

handles.output = hObject;
handles.counter1 = 0;
handles.counter2 = 0;
handles.counter3 = 0;
handles.counter4 = 0;
handles.counter5 = 0;

a = findall(gcf);

InsertColorbar = findall(a,'ToolTipString','Insert Colorbar');
set(InsertColorbar,'Visible','Off');
Brushing = findall(a,'ToolTipString','Brush/Select Data');
set(Brushing,'Visible','Off');
NewFigure = findall(a,'ToolTipString','New Figure');
set(NewFigure,'Visible','Off');

%%
myToolbar = findall(gcf,'tag','FigureToolBar');

FileOpen_callback = findall(myToolbar,'tag','Standard.FileOpen');
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)Beer_lambert('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)Beer_lambert('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));

guidata(hObject, handles);

% UIWAIT makes Beer_lambert wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Beer_lambert_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--- Executes on button press in mysavefigure.
function pressure_input_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mysavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.counter1 = handles.counter1 + 1;

numofspec = inputdlg('How many specra do you have?','Number of reference spectra');

if isempty(numofspec)
    return
else
    handles.numofspec = str2double(numofspec{1,1});
    %input the number of spectra
    %%
    handles.pressures = cell(1,handles.numofspec);
    waitbar1 = waitbar(0,'Please wait...');
    for i = 1:handles.numofspec
        handles.pressures{i}=strcat('Pressure',num2str(i));
        waitbar(i / handles.numofspec)
    end
    close(waitbar1);
    %Making a series of string for pressures's name e.g. pressure1,
    %pressure2...
    %%
    handles.pressureslist = inputdlg([handles.pressures,'Baratron offset','Premix percentage (If it is not a premix type 0)'],'Spectras pressures');
    if isempty(handles.pressureslist)
        return
    else
        %Input the value of pressures
        %%
        waitbar1 = waitbar(0,'Please wait...');
        offset = str2double(handles.pressureslist{handles.numofspec+1,1});
        percentage = str2double(handles.pressureslist{handles.numofspec+2,1});
        
        %if the experiment is in neat condition percentage is going to be 1
        if percentage == 0
            percentage = 1;
        else
            percentage = str2double(handles.pressureslist{handles.numofspec+2,1})/100;
        end
        %if the experiment is in neat condition percentage is going to be 1
        
        handles.totalpressures = zeros (handles.numofspec,1);
        handles.partialpressure = zeros (handles.numofspec,1);
        for i = 1:handles.numofspec
            handles.totalpressures (i,1) = str2double(handles.pressureslist{i,1})-offset;
            handles.partialpressure (i,1) = handles.totalpressures(i,1)*percentage;
            waitbar(i / handles.numofspec)
        end
        close(waitbar1);
        
        handles.allpressures = [handles.totalpressures,handles.partialpressure];
        %%
        set (handles.pressuretable,'Data',handles.allpressures);
        set (handles.popupmenu1,'String',num2str(handles.pressuretable.Data(:,2)));
    end
end
guidata(hObject, handles);


%--- Executes on button press in loadexistingpressure.
function loadexistingpressure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to loadexistingpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.counter1 = handles.counter1 + 1;

[loadpressurefilenames,loadpressurepathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load file','baseline corrected allfinal text file.txt');
if isequal([loadpressurefilenames,loadpressurepathname] , [0,0])
    return
else
    tableofpressures = readtable(strcat(loadpressurepathname,loadpressurefilenames));
    handles.allpressures = tableofpressures{:,{'Total_pressures','Partial_pressures'}};
end

set (handles.pressuretable,'Data',handles.allpressures);
set (handles.popupmenu1,'String',num2str(handles.pressuretable.Data(:,2)));

guidata(hObject, handles);


% --- Executes on button press in mysavefigure.
function svaepressures_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mysavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filenameforpressursave,pathforpressuresave] = uiputfile('Pressures.txt','Save file name');
if isequal([filenameforpressursave,pathforpressuresave] ,[0,0])
    return
else
    
    tableofpressures = array2table (handles.pressuretable.Data);
    %     ColumnName = cellstr(ColumnName);
    tableofpressures.Properties.VariableNames = {'Total_pressures','Partial_pressures'};
    
    pressurepathandfn = strcat (pathforpressuresave,filenameforpressursave);
    writetable (tableofpressures,pressurepathandfn);
end

guidata(hObject, handles);


% --- Executes on button press in load_files.
function myopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to load_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    errordlg('Pressures are not identified. You should first input pressures or load the related file');
else
    handles.counter2 = handles.counter2 + 1;
    [filenames,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select Spectra','multiselect','on');
    set(handles.figure1, 'Name', pathname);
    
    if isequal([filenames,pathname] , [0,0])
        return
    else
        handles.sizepressure = size(handles.pressuretable.Data);
        sizefilename = size (filenames);
        
        if isequal (sizefilename(1,2),handles.sizepressure(1,1))
            spectra = [];
            for i = 1:sizefilename(1,2)
                fn = importdata(char(strcat (pathname,filenames(:,i))));
                spectra = [spectra,fn(:,2)];
            end
        else
            errordlg('The number of spectra is not consitant with number of pressures!');
        end
    end
    
    handles.rawspectra = [fn(:,1),spectra];
    handles.rawspectra = sortrows(handles.rawspectra,-1);
    arraysize = size(handles.rawspectra);
    loopcount1 = arraysize(1,1);
    zero = zeros(1,arraysize(1,2));
    for j = 1:loopcount1
        if handles.rawspectra (j,1) > 4000
            handles.rawspectra(j,:) = zero;
        else if handles.rawspectra (j,1) < 700
                handles.rawspectra(j,:) = zero;
            end
        end
    end
    handles.rawspectra( ~any(handles.rawspectra,2), : ) = [];
    
    set (handles.datatable,'Data',handles.rawspectra,'ColumnName',['Wavenumber';cellstr(num2str(handles.pressuretable.Data(:,2)))]);
    
    axes(handles.axes1)
    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
    title('Raw spectra');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Abs. int.');
    xlim ([min(fn(:,1)) max(fn(:,1))]);
    legend (num2str(handles.pressuretable.Data(:,2)));
    %%
    
end
guidata(hObject, handles);


% --- Executes on button press in mysavefigure.
function baselinecorrection_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mysavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter2 == 0
    errordlg('You should first load spectra file');
else
    minmax1 = inputdlg({'Minimum of wavenumber to look for baseline correction:','Maximum of wavenumber to look for baseline correction:'},'Baseline correction');
    if isequal(minmax1 , {})
        return
    else
        min1 = str2double(minmax1{1,1});
        max1 = str2double(minmax1{2,1});
        index1 = find(handles.datatable.Data(:,1)> min1 & handles.datatable.Data(:,1)< max1);
        sizeindex1 = size(index1);
        offsets = zeros(1,handles.sizepressure(1,1));
        for k = 1:handles.sizepressure(1,1)
            meandata = mean(handles.datatable.Data(index1(sizeindex1(1,2),1):index1(sizeindex1(1,1),1),k+1));
            handles.datatable.Data(:,k+1) = handles.datatable.Data(:,k+1)- meandata;
            offsets(1,k) = meandata;
        end
        set (handles.datatable,'Data',handles.datatable.Data,'ColumnName',['Wavenumber';cellstr(num2str(handles.pressuretable.Data(:,2)))]);
        
        axes(handles.axes1)
        plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
        title('Raw spectra');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Abs. int.');
        xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
        legend (num2str(handles.pressuretable.Data(:,2)));
        
        set (handles.normbutton,'Value',0);
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function baselinecorrection2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter2 == 0
    errordlg('You should first load spectra file');
else
    wavenumbercutoff = menu('Load existing cut off file or input new one','Load exsiting file of wavenumber cut off for baseline correction',...
        'Input the new wavenumber cut off for baseline correction');
    if isempty(wavenumbercutoff)
        return
        %% load existing wavenumber cut off text file and doing further analysis
    elseif wavenumbercutoff == 1
        [filename,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select wavenumber cut off file');
        if isequal([filename,pathname],[0,0])
            return
        else
            wavenumbercutoff = importdata (fullfile(pathname,filename));
            
            size_wavenumbercutoff = size(wavenumbercutoff);
            split1 = size_wavenumbercutoff(1,1)/2;
            cutoff = cell(1,split1*2);
            i = 1;
            ii = 1;
            while i < split1*2+1
                pstr = num2str(ii);
                cutoff{i} = strcat('Minimum of the region', pstr);
                cutoff{i+1} = strcat('Maximum of the region', pstr);
                i = i + 2;
                ii = ii + 1;
            end
            regionslist = inputdlg(cutoff,'Regions Min and Max',1,(cellstr(num2str(wavenumbercutoff)))');
            if isempty(regionslist)
                return
            else
                sizedatatable = size(handles.datatable.Data);
                zerotoplot = (zeros(1,sizedatatable(1,1)))';
                j = sizedatatable(1,1);
                zero1 = zeros(1,sizedatatable(1,2));
                
                waitbar1 = waitbar(0,'Please wait...');
                i = 1;
                fileforreg = [];
                while i < split1*2+1
                    bcdata = handles.datatable.Data;
                    for k = 1:j
                        if bcdata(k,1) < str2double(regionslist(i,1))
                            bcdata (k,:) = zero1;
                        elseif bcdata (k,1) > str2double(regionslist(i+1,1))
                            bcdata (k,:) = zero1;
                            
                        end
                    end
                    waitbar(i / split1);
                    i = i + 2;
                    bcdata( ~any(bcdata,2), : ) = [];
                    fileforreg = [fileforreg;bcdata];
                end
                close(waitbar1);
                
                polyfitvalue = split1-1;
                dataformsbackadj = handles.datatable.Data;
                dataformsbackadj = sortrows(dataformsbackadj);
                check = 'runn';
                while strcmp(check,'runn')
                    %%
                    pp1 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    newy1 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    pp2 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    newy2 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    newy3 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    for m = 1:sizedatatable(1,2)-1
                        %% fit 1 linear
                        x1 = fileforreg(:,1);
                        y1 = fileforreg(:,m+1);
                        p1 = polyfit(x1,y1,1);
                        pp1(:,m) = polyval(p1,handles.datatable.Data(:,1));
                        newy1(:,m) = handles.datatable.Data(:,m+1)-pp1(:,m);
                        %% fit2 polyfit
                        x2 = fileforreg(:,1);
                        y2 = fileforreg(:,m+1);
                        p2 = polyfit(x2,y2,polyfitvalue);
                        pp2(:,m) = polyval(p2,handles.datatable.Data(:,1));
                        newy2(:,m) = handles.datatable.Data(:,m+1)-pp2(:,m);
                        %% fit 3
                        x3 = dataformsbackadj(:,1);
                        y3 = dataformsbackadj(:,m+1);
                        newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                    end
                    newy3 = flipud(newy3);
                    
                    figure(2)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end),...
                        handles.datatable.Data(:,1),pp1);
                    title ('Spectra before baseline correction and the linear regressed baseline');
                    legend ([num2str(handles.pressuretable.Data(:,2));num2str(handles.pressuretable.Data(:,2))]);
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy1,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after linear baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(3)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end),...
                        handles.datatable.Data(:,1),pp2);
                    title ('Spectra before baseline correction and the polynomial regressed baseline');
                    legend ([num2str(handles.pressuretable.Data(:,2));num2str(handles.pressuretable.Data(:,2))]);
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy2,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after polynomial baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(4)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end));
                    title ('Spectra before baseline correction');
                    legend (num2str(handles.pressuretable.Data(:,2)));
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy3,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after Matlab function baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(5)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2),...
                        handles.datatable.Data(:,1),newy1(:,1),...
                        handles.datatable.Data(:,1),newy2(:,1),handles.datatable.Data(:,1),newy3(:,1),...
                        handles.datatable.Data(:,1),zerotoplot);
                    title ('Comparison of there different baseline correction');
                    legend('Before baseline correction','Linear baseline correction',...
                        'Polynomial baseline correction','Baseline correction with Matlab function','Zero line')
                    
                    repeatQ = menu(strcat(['Degree of second polyfit was set',' ',num2str(polyfitvalue),'.',' Do want to change the degree of polyfit?']), 'YES','NO');
                    
                    if (repeatQ == 2 || repeatQ == 0)
                        check = 'stop';
                    else
                        polyfitvalue = str2double(inputdlg('Degree of polynomia fit','Change the degree of polynomial fit'));
                        if isempty(polyfitvalue)
                            return
                        end
                    end
                    
                end
                
                typeofbc = menu('Type of basleine correction to data', 'Linear baseline correction',...
                    'Polynomial basleine correction','Matlab function baseline correction','None');
                if isempty(typeofbc)
                    return
                else
                    switch typeofbc
                        case 1
                            handles.datatable.Data(:,2:end) = newy1;
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                            
                        case 2
                            set(handles.datatable,'Data',[handles.datatable.Data(:,1),newy2]);
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                            
                        case 3
                            set(handles.datatable,'Data',[handles.datatable.Data(:,1),newy3]);
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                    end
                end
            end
        end
        %% Input a new wavenumber cut off save as text file and doing further analysis
    elseif wavenumbercutoff == 2
        numofregions = inputdlg('Number of regions or points at which regression has to be done','Baseline correction info');
        if (isempty(numofregions) || isnan(str2double(numofregions)))
            return
        else
            sizedatatable = size(handles.datatable.Data);
            zerotoplot = (zeros(1,sizedatatable(1,1)))';
            figure(1)
            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end),...
                handles.datatable.Data(:,1),zerotoplot)
            
            %% input the number of spectra
            split1 = str2double(numofregions);
            cutoff = cell(1,split1*2);
            i = 1;
            ii = 1;
            while i < split1*2+1
                pstr = num2str(ii);
                cutoff{i} = strcat('Minimum of the region', pstr);
                cutoff{i+1} = strcat('Maximum of the region', pstr);
                i = i + 2;
                ii = ii + 1;
            end
            
            uiwait(msgbox('Find the wavenumber limits and then press enter','GUIDE'));
            
            regionslist = inputdlg(cutoff,'Regions Min and Max');
            [filename_regionlist,path_regionlist] = uiputfile({'*.txt','txt-file (*.txt)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save as','Wavenumber cut off for regression');
            if isequal ([filename_regionlist,path_regionlist],[0,0])
                return
            else
                dlmwrite (fullfile (path_regionlist,filename_regionlist),str2double(regionslist));
            end
            
            if isempty(regionslist)
                return
            else
                j = sizedatatable(1,1);
                zero1 = zeros(1,sizedatatable(1,2));
                
                waitbar1 = waitbar(0,'Please wait...');
                i = 1;
                fileforreg = [];
                while i < split1*2+1
                    bcdata = handles.datatable.Data;
                    for k = 1:j
                        if bcdata(k,1) < str2double(regionslist(i,1))
                            bcdata (k,:) = zero1;
                        elseif bcdata (k,1) > str2double(regionslist(i+1,1))
                            bcdata (k,:) = zero1;
                            
                        end
                    end
                    waitbar(i / split1);
                    i = i + 2;
                    bcdata( ~any(bcdata,2), : ) = [];
                    fileforreg = [fileforreg;bcdata];
                end
                close(waitbar1);
                
                polyfitvalue = split1-1;
                dataformsbackadj = handles.datatable.Data;
                dataformsbackadj = sortrows(dataformsbackadj);
                check = 'runn';
                while strcmp(check,'runn')
                    %%
                    pp1 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    newy1 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    pp2 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    newy2 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    newy3 = zeros(sizedatatable(1,1),sizedatatable(1,2)-1);
                    
                    for m = 1:sizedatatable(1,2)-1
                        %% fit 1 linear
                        x1 = fileforreg(:,1);
                        y1 = fileforreg(:,m+1);
                        p1 = polyfit(x1,y1,1);
                        pp1(:,m) = polyval(p1,handles.datatable.Data(:,1));
                        newy1(:,m) = handles.datatable.Data(:,m+1)-pp1(:,m);
                        %% fit2 polyfit
                        x2 = fileforreg(:,1);
                        y2 = fileforreg(:,m+1);
                        p2 = polyfit(x2,y2,polyfitvalue);
                        pp2(:,m) = polyval(p2,handles.datatable.Data(:,1));
                        newy2(:,m) = handles.datatable.Data(:,m+1)-pp2(:,m);
                        %% fit 3
                        x3 = dataformsbackadj(:,1);
                        y3 = dataformsbackadj(:,m+1);
                        newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                    end
                    newy3 = flipud(newy3);
                    
                    figure(2)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end),...
                        handles.datatable.Data(:,1),pp1);
                    title ('Spectra before baseline correction and the linear regressed baseline');
                    legend ([num2str(handles.pressuretable.Data(:,2));num2str(handles.pressuretable.Data(:,2))]);
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy1,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after linear baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(3)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end),...
                        handles.datatable.Data(:,1),pp2);
                    title ('Spectra before baseline correction and the polynomial regressed baseline');
                    legend ([num2str(handles.pressuretable.Data(:,2));num2str(handles.pressuretable.Data(:,2))]);
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy2,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after polynomial baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(4)
                    subplot(2,1,1)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end));
                    title ('Spectra before baseline correction');
                    legend (num2str(handles.pressuretable.Data(:,2)));
                    subplot(2,1,2)
                    plot(handles.datatable.Data(:,1),newy3,handles.datatable.Data(:,1),zerotoplot);
                    title ('Spectra after Matlab function baseline correction');
                    legend([cellstr(num2str(handles.pressuretable.Data(:,2)));'Zero line']);
                    
                    figure(5)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2),...
                        handles.datatable.Data(:,1),newy1(:,1),...
                        handles.datatable.Data(:,1),newy2(:,1),handles.datatable.Data(:,1),newy3(:,1),...
                        handles.datatable.Data(:,1),zerotoplot);
                    title ('Comparison of there different baseline correction');
                    legend('Before baseline correction','Linear baseline correction',...
                        'Polynomial baseline correction','Baseline correction with Matlab function','Zero line')
                    
                    repeatQ = menu(strcat(['Degree of second polyfit was set',' ',num2str(polyfitvalue),'.',' Do want to change the degree of polyfit?']), 'YES','NO');
                    
                    if (repeatQ == 2 || repeatQ == 0)
                        check = 'stop';
                    else
                        polyfitvalue = str2double(inputdlg('Degree of polynomia fit','Change the degree of polynomial fit'));
                        if isempty(polyfitvalue)
                            return
                        end
                    end
                    
                end
                
                typeofbc = menu('Type of basleine correction to data', 'Linear baseline correction',...
                    'Polynomial basleine correction','Matlab function baseline correction','None');
                if isempty(typeofbc)
                    return
                else
                    switch typeofbc
                        case 1
                            handles.datatable.Data(:,2:end) = newy1;
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                            
                        case 2
                            set(handles.datatable,'Data',[handles.datatable.Data(:,1),newy2]);
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                            
                        case 3
                            set(handles.datatable,'Data',[handles.datatable.Data(:,1),newy3]);
                            set (handles.normbutton,'Value',0);
                            
                            axes(handles.axes1)
                            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                            legend (num2str(handles.pressuretable.Data(:,2)));
                    end
                end
                
            end
        end
    end
end

guidata(hObject, handles);


% --- Executes on button press in normbutton.
function normbutton_Callback(hObject, eventdata, handles)
% hObject    handle to normbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normbutton

if handles.counter2 == 0
    errordlg('You should first load spectra file');
else
    %     normbutton_value = get (handles.normbutton,'Value');
    switch handles.normbutton.Value
        case 0
            axes(handles.axes1)
            plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
            title('Raw spectra');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
            legend (num2str(handles.pressuretable.Data(:,2)));
        case 1
            handles.sizepressure = size(handles.pressuretable.Data);
            handles.normspectra = [];
            for i = 1:handles.sizepressure(1,1)
                norm = handles.datatable.Data(:,1+i)/handles.pressuretable.Data(i,2);
                handles.normspectra = [handles.normspectra,norm];
            end
            
            axes(handles.axes1)
            plot(handles.datatable.Data(:,1),handles.normspectra)
            title('Normalized to 1 Torr spectra');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
            legend (num2str(handles.pressuretable.Data(:,2)));
    end
end

guidata(hObject, handles);


% --- Executes on button press in beerlambert.
function beerlambert_Callback(hObject, eventdata, handles)
% hObject    handle to beerlambert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter2 == 0
    errordlg('You should first load spectra file');
else
    set (handles.outputfitting,'String',[]);
    
    
    handles.typeplot = menu('Type of beer_lambert law plot', '1.Integration under the curve','2.Single point');
    if isempty(handles.typeplot)
        return
    else
        switch handles.typeplot
            case 1
                handles.counter3 = handles.counter3 + 1;
                
                uiwait(msgbox('First choose the wavenumber region at which integration should be done and then press Enter'));
                
                minmax2 = inputdlg({'Minimum wavenumber from which integration should be done:','Maximum wavenumber from which integration should be done:'},'Wavenumber lim for integration');
                if isequal(minmax2 , {})
                    return
                else
                    handles.min2 = str2double(minmax2{1,1});
                    handles.max2 = str2double(minmax2{2,1});
                    index2 = find(handles.datatable.Data(:,1)> handles.min2 & handles.datatable.Data(:,1)< handles.max2);
                    sizeindex2 = size(index2);
                    handles.sizepressure = size(handles.pressuretable.Data);
                    ints = zeros(1,handles.sizepressure(1,1));
                    xforint = (handles.datatable.Data(index2(sizeindex2(1,2),1):index2(sizeindex2(1,1),1)));
                    for p = 1:handles.sizepressure(1,1)
                        int = -trapz(xforint,handles.datatable.Data(index2(sizeindex2(1,2),1):index2(sizeindex2(1,1),1),p+1));
                        ints (1,p) = int;
                    end
                    handles.yforbeerlambert = ints';
                end
                
                handles.totalpartialvalue = get(handles.totalpartial,'Value');
                switch handles.totalpartialvalue
                    case 1
                        handles.xforbeerlambert = handles.pressuretable.Data(:,1);
                        
                        axes(handles.axes2)
                        plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                        title('Beer_lambert plot based on total pressure');
                        xlabel('Pressure (Torr)');
                        ylabel('Spectra integration');
                        legend ('Spectrum integration','Location','best');
                        
                    case 0
                        handles.xforbeerlambert = handles.pressuretable.Data(:,2);
                        
                        axes(handles.axes2)
                        plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                        title('Beer_lambert plot based on partial pressure');
                        xlabel('Pressure (Torr)');
                        ylabel('Spectra integration');
                        legend ('Spectrum integration','Location','best');
                end
                
            case 2
                handles.counter3 = handles.counter3 + 1;
                uiwait(msgbox('Press okay and choose your the point'));
                point = ginput(1);
                handles.numofelement = find(handles.datatable.Data(:,1) > point(1,1)-0.1 & handles.datatable.Data(:,1) < point(1,1)+0.1);
                
                handles.yforbeerlambert = handles.datatable.Data(handles.numofelement(1,1),2:end)';
                
                handles.totalpartialvalue = get(handles.totalpartial,'Value');
                switch handles.totalpartialvalue
                    case 1
                        handles.xforbeerlambert = handles.pressuretable.Data(:,1);
                        
                        axes(handles.axes2)
                        plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                        title('Beer_lambert plot based on total pressure');
                        xlabel('Pressure (Torr)');
                        ylabel('Spectra single point');
                        legend ('Spectrum single point','Location','best');
                    case 0
                        handles.xforbeerlambert = handles.pressuretable.Data(:,2);
                        
                        axes(handles.axes2)
                        plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                        title('Beer_lambert plot based on partial pressure');
                        xlabel('Pressure (Torr)');
                        ylabel('Spectra single point');
                        legend ('Spectrum single point','Location','best');
                end
        end
    end
end

guidata(hObject, handles);


% --- Executes on button press in lnfit.
function lnfit_Callback(hObject, eventdata, handles)
% hObject    handle to lnfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter3 == 0
    errordlg('You sould first plot the Beer lambert data points.');
else
    handles.counter5 = handles.counter5 + 1;
    handles.totalpartialvalue = get(handles.totalpartial,'Value');
    switch handles.totalpartialvalue
        case 0
            handles.xforbeerlambert = handles.pressuretable.Data(:,2);
            pfit = polyfit(handles.xforbeerlambert,handles.yforbeerlambert,1);
            handles.yfit = polyval (pfit,handles.xforbeerlambert);
            
            yresid = handles.yforbeerlambert - handles.yfit;
            SSresid = sum(yresid.^2);
            SStotal = (length(handles.yforbeerlambert)-1) * var(handles.yforbeerlambert);
            rsq = 1 - SSresid/SStotal;
            pressureoffset = -(pfit(2)/pfit(1));
            
            switch handles.typeplot
                case 1
                    handles.fitting_output = {strcat(['Wavenumber region at which integration is done:','  ',num2str(handles.min2),'-',num2str(handles.max2)]);...
                        [];...
                        strcat(['The coefficient of determination (R squared) is:','  ',num2str(rsq)]);...
                        [];...
                        strcat(['The intercept is: ','  ',num2str(pfit(2))]);...
                        [];...
                        strcat(['The pressure offset is: ','  ',num2str(pressureoffset)])};
                    set (handles.outputfitting,'String',handles.fitting_output);
                    
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
                    title('Beer_lambert plot based on partial pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra integration');
                    legend ('Spectrum integration','Fitted line','Location','best');
                case 2
                    handles.fitting_output = {strcat(['Wavenumber at which beer lamber law is plotted:','  ',num2str(handles.datatable.Data(handles.numofelement(1,1),1))]);...
                        [];...
                        strcat(['The coefficient of determination (R squared) is:','  ',num2str(rsq)]);...
                        [];...
                        strcat(['The intercept is: ','  ',num2str(pfit(2))]);...
                        [];...
                        strcat(['The pressure offset is: ','  ',num2str(pressureoffset)])};
                    set (handles.outputfitting,'String',handles.fitting_output);
                    
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
                    title('Beer_lambert plot based on partial pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra single point');
                    legend ('Spectrum single point','Fitted line','Location','best');
            end
            
            
        case 1
            handles.xforbeerlambert = handles.pressuretable.Data(:,1);
            pfit = polyfit(handles.xforbeerlambert,handles.yforbeerlambert,1);
            handles.yfit = polyval (pfit,handles.xforbeerlambert);
            
            yresid = handles.yforbeerlambert - handles.yfit;
            SSresid = sum(yresid.^2);
            SStotal = (length(handles.yforbeerlambert)-1) * var(handles.yforbeerlambert);
            rsq = 1 - SSresid/SStotal;
            pressureoffset = -(pfit(2)/pfit(1));
            
            switch handles.typeplot
                case 1
                    handles.fitting_output = {strcat(['Wavenumber region at which integration is done:','  ',num2str(handles.min2),'-',num2str(handles.max2)]);...
                        [];...
                        strcat(['The coefficient of determination (R squared) is:','  ',num2str(rsq)]);...
                        [];...
                        strcat(['The intercept is: ','  ',num2str(pfit(2))]);...
                        [];...
                        strcat(['The pressure offset is: ','  ',num2str(pressureoffset)])};
                    set (handles.outputfitting,'String',handles.fitting_output);
                    
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
                    title('Beer_lambert plot based on total pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra integration');
                    legend ('Spectrum integration','Fitted line','Location','best');
                case 2
                    handles.fitting_output = {strcat(['Wavenumber at which beer lamber law is plotted:','  ',num2str(handles.datatable.Data(handles.numofelement(1,1),1))]);...
                        [];...
                        strcat(['The coefficient of determination (R squared) is:','  ',num2str(rsq)]);...
                        [];...
                        strcat(['The intercept is: ','  ',num2str(pfit(2))]);...
                        [];...
                        strcat(['The pressure offset is: ','  ',num2str(pressureoffset)])};
                    set (handles.outputfitting,'String',handles.fitting_output);
                    
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
                    title('Beer_lambert plot based on total pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra single point');
                    legend ('Spectrum single point','Fitted line','Location','best');
            end
            
    end
end

guidata(hObject, handles);


% --- Executes on button press in totalpartial.
function totalpartial_Callback(hObject, eventdata, handles)
% hObject    handle to totalpartial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of totalpartial

if handles.counter3 == 0
    errordlg('You sould first plot the Beer lambert data points.');
else
    set (handles.outputfitting,'String',[]);
    handles.totalpartialvalue = get(handles.totalpartial,'Value');
    switch handles.totalpartialvalue
        
        %if it is based on partial pressure
        case 0
            handles.xforbeerlambert = handles.pressuretable.Data(:,2);
            set (handles.outputfitting,'String',[]);
            switch handles.typeplot
                case 1
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                    title('Beer_lambert plot based on partial pressure')
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra integration');
                    legend ('Spectrum integration','Location','best');
                case 2
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                    title('Beer_lambert plot based on partial pressure')
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra single point');
                    legend ('Spectrum single point','Location','best');
            end
            
            %if it is based on total pressure
        case 1
            handles.xforbeerlambert = handles.pressuretable.Data(:,1);
            switch handles.typeplot
                case 1
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                    title('Beer_lambert plot based on total pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra integration');
                    legend ('Spectrum integration','Location','best');
                case 2
                    axes(handles.axes2)
                    plot(handles.xforbeerlambert,handles.yforbeerlambert,'o')
                    title('Beer_lambert plot based on total pressure');
                    xlabel('Pressure (Torr)');
                    ylabel('Spectra single point');
                    legend ('Spectrum single point','Location','best');
            end
    end
end

guidata(hObject, handles);


% --- Executes on button press in meanofspectra.
function meanofspectra_Callback(hObject, eventdata, handles)
% hObject    handle to meanofspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.counter2 == 0
    errordlg('You should first load spectra file');
else
    handles.counter4 = handles.counter4 + 1;
    handles.sizepressure = size(handles.pressuretable.Data);
    
    handles.normspectra = [];
    for i = 1:handles.sizepressure(1,1)
        norm = handles.datatable.Data(:,1+i)/handles.pressuretable.Data(i,2);
        handles.normspectra = [handles.normspectra,norm];
    end
    
    handles.meanofnormspectra = mean(handles.normspectra,2);
    
    axes(handles.axes3)
    plot(handles.datatable.Data(:,1),handles.meanofnormspectra)
    title('Average of normalized spectra');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Abs. int.');
    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
    legend ('Average of normalized to 1 Torr spectra');
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


% --- Executes on button press in Remove.
function Remove_Callback(hObject, eventdata, handles)
% hObject    handle to Remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter2 == 0
    return
else
    handles.remove_value =  get(handles.popupmenu1,'Value');
    if handles.counter3 == 0
        handles.yforbeerlambert = [];%(handles.remove_value,:)
        %         handles.xforbeerlambert = [];
    else
        handles.yforbeerlambert(handles.remove_value,:) = [];
        %         handles.xforbeerlambert(handles.remove_value+1,:) = [];
    end
    
    handles.pressuretable.Data(handles.remove_value,:) = [];
    
    set (handles.pressuretable,'Data',handles.pressuretable.Data);
    set(handles.popupmenu1,'String',num2str(handles.pressuretable.Data));
    
    handles.datatable.Data(:,handles.remove_value+1) = [];
    handles.datatable.ColumnName(handles.remove_value+1,:) = [];
    
    set (handles.datatable,'Data',handles.datatable.Data);
    popupmenu_string = get (handles.popupmenu1,'String');
    size_string = size(popupmenu_string);
    set (handles.popupmenu1,'Value',size_string(1,1));
    
    axes(handles.axes1)
    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
    title('Raw spectra');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Abs. int.');
    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
    legend (num2str(handles.pressuretable.Data(:,2)));
end
guidata(hObject, handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.counter2 == 0
    return
else
    set (handles.pressuretable,'Data',handles.allpressures);
    set (handles.popupmenu1,'String',num2str(handles.pressuretable.Data(:,2)));
    set (handles.datatable,'Data',handles.rawspectra,'ColumnName',['Wavenumber';cellstr(num2str(handles.pressuretable.Data(:,2)))]);
end
guidata(hObject, handles);


function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter4 == 0
    errordlg('You have no average spectrum to save.');
else
    [filenameforsave,pathforsave] = uiputfile('Average spectrum.txt','Save file name');
    if isequal([filenameforsave,pathforsave] ,[0,0])
        return
    else
        savefnname1 = strcat (pathforsave,filenameforsave);
        dlmwrite(savefnname1,[handles.datatable.Data(:,1),handles.meanofnormspectra],...
            'precision',10);
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function savefigure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveoptions = menu ('Figure to save:','Figure(6)-Raw spectra','Figure(7)-Beer Lambert plot','Figure(8)-Averaged spectra','All figures');

switch saveoptions
    case 1
        if isequal(handles.counter2,0)
            errordlg('Figure not found. You should first load the files.')
        else
            switch handles.normbutton.Value
                case 0
                    figure(6)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                    title('Raw spectra');
                    xlabel('Wavenumber (cm^-^1)');
                    ylabel('Abs. int.');
                    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                    legend (num2str(handles.pressuretable.Data(:,2)));
                case 1
                    handles.sizepressure = size(handles.pressuretable.Data);
                    handles.normspectra = [];
                    for i = 1:handles.sizepressure(1,1)
                        norm = handles.datatable.Data(:,1+i)/handles.pressuretable.Data(i,2);
                        handles.normspectra = [handles.normspectra,norm];
                    end
                    figure(6)
                    plot(handles.datatable.Data(:,1),handles.normspectra)
                    title('Normalized to 1 Torr spectra');
                    xlabel('Wavenumber (cm^-^1)');
                    ylabel('Abs. int.');
                    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                    legend (num2str(handles.pressuretable.Data(:,2)));
            end
            
            [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                '*.jpg', 'JPEG files (*.jpg)';...
                '*.fig','Figures (*.fig)';...
                '*.*',  'All Files (*.*)'},...
                'Save as','Raw spectra');
            if isequal ([filename, pathname],[0,0])
                return
            else
                filepath = fullfile (pathname,filename);
                saveas(figure(6),filepath);
            end
        end
        
    case 2
        if (isequal(handles.counter5,0) && isequal(handles.counter3,0))
            errordlg('Figure not found. You should first plot beer lambert and complete fitting.')
        else
            figure(7)
            plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
            title('Beer_lambert plot based on total pressure');
            xlabel('Pressure (Torr)');
            ylabel('Spectra integration');
            legend ('Spectrum integration','Location','best');
            ylim1=get(gca,'ylim');
            xlim1=get(gca,'xlim');
            text(xlim1(1),ylim1(2)-(ylim1(2)/4),handles.fitting_output);
            
            [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                '*.jpg', 'JPEG files (*.jpg)';...
                '*.fig','Figures (*.fig)';...
                '*.*',  'All Files (*.*)'},...
                'Save as','Beer_lambert plot');
            if isequal ([filename, pathname],[0,0])
                return
            else
                filepath = fullfile (pathname,filename);
                saveas(figure(7),filepath);
            end
        end
        
    case 3
        if (isequal(handles.counter2,0) && isequal(handles.counter3,0) &&...
                isequal(handles.counter4,0) && isequal(handles.counter5,0))
            errordlg('Figure not found. You should first take average of the spectra.')
        else
            figure(8)
            plot(handles.datatable.Data(:,1),handles.meanofnormspectra)
            title('Average of normalized spectra');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
            legend ('Average of normalized to 1 Torr spectra');
            
            [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                '*.jpg', 'JPEG files (*.jpg)';...
                '*.fig','Figures (*.fig)';...
                '*.*',  'All Files (*.*)'},...
                'Save as','Averaged spectra');
            if isequal ([filename, pathname],[0,0])
                return
            else
                filepath = fullfile (pathname,filename);
                saveas(figure(8),filepath);
            end
        end
        
    case 4
        if (isequal(handles.counter2,0) && isequal(handles.counter3,0) &&...
                isequal(handles.counter4,0) && isequal(handles.counter5,0))
            errordlg('Possible troubleshooting: 1. Load spectra. or 2. Make sure beer lambert is plotted anf fitting completed. or 3. Make sure spectra are averaged.')
        else
            switch handles.normbutton.Value
                case 0
                    figure(6)
                    plot(handles.datatable.Data(:,1),handles.datatable.Data(:,2:end))
                    title('Raw spectra');
                    xlabel('Wavenumber (cm^-^1)');
                    ylabel('Abs. int.');
                    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                    legend (num2str(handles.pressuretable.Data(:,2)));
                case 1
                    handles.sizepressure = size(handles.pressuretable.Data);
                    handles.normspectra = [];
                    for i = 1:handles.sizepressure(1,1)
                        norm = handles.datatable.Data(:,1+i)/handles.pressuretable.Data(i,2);
                        handles.normspectra = [handles.normspectra,norm];
                    end
                    figure(6)
                    plot(handles.datatable.Data(:,1),handles.normspectra)
                    title('Normalized to 1 Torr spectra');
                    xlabel('Wavenumber (cm^-^1)');
                    ylabel('Abs. int.');
                    xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
                    legend (num2str(handles.pressuretable.Data(:,2)));
            end
            
            figure(7)
            plot(handles.xforbeerlambert,handles.yforbeerlambert,'o',handles.xforbeerlambert,handles.yfit,'r-')
            title('Beer_lambert plot based on total pressure');
            xlabel('Pressure (Torr)');
            ylabel('Spectra integration');
            legend ('Spectrum integration','Location','best');
            ylim1=get(gca,'ylim');
            xlim1=get(gca,'xlim');
            text(xlim1(1),ylim1(2)-(ylim1(2)/4),handles.fitting_output);
            
            figure(8)
            plot(handles.datatable.Data(:,1),handles.meanofnormspectra)
            title('Average of normalized spectra');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.datatable.Data(:,1)) max(handles.datatable.Data(:,1))]);
            legend ('Average of normalized to 1 Torr spectra');
            
            [filename, pathname] = uiputfile('All.fig','Save as');
            if isequal ([filename, pathname],[0,0])
                return
            else
                saveas(figure(6),fullfile(pathname,'Raw spectra.fig'));
                saveas(figure(7),fullfile(pathname,'Beer_lambert plot.fig'));
                saveas(figure(8),fullfile(pathname,'Averaged spectra.fig'));
            end
        end
end


guidata(hObject, handles);
