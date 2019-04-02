function varargout = Ref_Analyzer(varargin)
% REF_ANALYZER MATLAB code for Ref_Analyzer.fig
%      REF_ANALYZER, by itself, creates a new REF_ANALYZER or raises the existing
%      singleton*.
%
%      H = REF_ANALYZER returns the handle to a new REF_ANALYZER or the handle to
%      the existing singleton*.
%
%      REF_ANALYZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REF_ANALYZER.M with the given input arguments.
%
%      REF_ANALYZER('Property','Value',...) creates a new REF_ANALYZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Ref_Analyzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Ref_Analyzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Ref_Analyzer

% Last Modified by GUIDE v2.5 20-Jun-2016 12:31:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Ref_Analyzer_OpeningFcn, ...
    'gui_OutputFcn',  @Ref_Analyzer_OutputFcn, ...
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


% --- Executes just before Ref_Analyzer is made visible.
function Ref_Analyzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ref_Analyzer (see VARARGIN)

% Choose default command line output for Ref_Analyzer

handles.output = hObject;

handles.counter1 = 0;
handles.counter2 = 0;
%%
all_gcf = findall(gcf);

% Savefigure = findall(all_gcf,'ToolTipString','Save Figure');
% set(Savefigure,'Visible','Off');
% Linking = findall(all_gcf,'ToolTipString','Link Plot');
% set(Linking,'Visible','Off');
% InsertLegend = findall(a,'ToolTipString','Insert Legend');
% set(InsertLegend,'Visible','Off');
InsertColorbar = findall(all_gcf,'ToolTipString','Insert Colorbar');
set(InsertColorbar,'Visible','Off');
Brushing = findall(all_gcf,'ToolTipString','Brush/Select Data');
set(Brushing,'Visible','Off');
NewFigure = findall(all_gcf,'ToolTipString','New Figure');
set(NewFigure,'Visible','Off');
% FileOpen = findall(a,'ToolTipString','Open File');
% set(FileOpen,'Visible','Off');
%%
myToolbar = findall(gcf,'tag','FigureToolBar');

FileOpen_callback = findall(myToolbar,'tag','Standard.FileOpen');
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)Ref_Analyzer('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

% InsertLegend_callback = findall(myToolbar,'tag','Annotation.InsertLegend');
% set(InsertLegend_callback, 'ClickedCallback','Insert Legend','TooltipString','Legend (hide/show)');
% set(InsertLegend_callback, 'ClickedCallback',@(hObject,eventdata)Ref_Analyzer('mylegend_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)Ref_Analyzer('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));
% assignin('base','myToolbar',myToolbar);
% assignin('base','Savefigure_callback',Savefigure_callback);
%%
handles.Na = 6.022140857E23;
handles.R = 0.082057338;% Unit: L atm K?1 mol?1
handles.l = 17;% Unit: cm
handles.T = 294; % Unit: Kelvin
%%
handles.initial_handles = handles;
% Update handles structure
%@(hObject,eventdata)Beer_lambert('load_files_Callback',hObject,eventdata,guidata(hObject))
guidata(hObject, handles);
%%

% UIWAIT makes Ref_Analyzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Ref_Analyzer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function myopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set (handles.normto1torr,'Value',0);

handles.normto1torr_value = get (handles.normto1torr,'Value');
%%

[filenames,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select Spectra','multiselect','on');
set(handles.figure1, 'Name', pathname);

if isequal([filenames,pathname] , [0,0])
    return
else
    handles.counter1 = handles.counter1 + 1;
    
    handles.sizefilename = size (filenames);
    spectra = [];
    for i = 1:handles.sizefilename(1,2)
        fn = importdata(char(strcat (pathname,filenames(:,i))));
        spectra = [spectra,fn(:,2)];
    end
    handles.rawspectra = [fn(:,1), spectra];
    
    handles.rawpectra = sortrows(handles.rawspectra,-1);% keeping a raw spectra sorted from bigest to lowest wavenumber value and restricted between 700 to 4000 cm-1
    arraysize = size(handles.rawpectra);
    loopcount1 = arraysize(1,1);
    zero = zeros(1,arraysize(1,2));
    for j = 1:loopcount1;
        if handles.rawpectra (j,1) > 4000
            handles.rawpectra(j,:) = zero;
        else if handles.rawpectra (j,1) < 700
                handles.rawpectra(j,:) = zero;
            end
        end
    end
    handles.rawpectra( ~any(handles.rawpectra,2), : ) = [];
    
    handles.spectra = handles.rawpectra;
    handles.legend1 = filenames;
    
    axes(handles.axes1)
    plot(handles.spectra(:,1),handles.spectra(:,2:end));
    title('Absorbance of raw spectra');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Abs. int.');
    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
    legend(handles.legend1);
end
%%
pressureinfo = menu('Load existing pressure info file or input new one','Load exsiting pressure info file',...
    'Input the new pressure information');
switch pressureinfo
    case isempty(pressureinfo)
        return
    case 1
        [filename,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select pressure info file');
        if isequal([filename,pathname],[0,0]);
            return
        else
            pressure_infofile = importdata (fullfile(pathname,filename));
            pressure_info = inputdlg({'Toral pressure:',...
                'Premix percentage (If it is not a premix type 0)','Baratron offset'},...
                'Pressure information',1,(cellstr(num2str(pressure_infofile)))');
        end
    case 2
        pressure_info = inputdlg({'Toral pressure:','Premix percentage (If it is not a premix type 0)','Baratron offset'},'Pressure information');
        if isempty(pressure_info)
            return
        else
            [filename_pressureinfo,path_pressureinfo] = uiputfile({'*.txt','txt-file (*.txt)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save as','Pressure_info');
            if isequal ([filename_pressureinfo,path_pressureinfo],[0,0])
                return
            else
                dlmwrite (fullfile (path_pressureinfo,filename_pressureinfo),str2double(pressure_info));
            end
        end
        
end

pressure_value = str2double(pressure_info{1,1});
percentage = str2double(pressure_info{2,1});
offset = str2double(pressure_info{3,1});

%if the experiment is in neat condition percentage is going to be 1
if percentage == 0
    percentage_value = 1;
else
    percentage_value = str2double(pressure_info{2,1})/100;
end

totalpressure = pressure_value - offset;
set(handles.totalpressure,'String',num2str(totalpressure));

partialpressure = totalpressure * percentage_value;
set(handles.partialpressure,'String',num2str(partialpressure));

set(handles.premix,'String',pressure_info{2,1});
set(handles.baratronoffset,'String',num2str(offset));
%%
partialpressure_atm = partialpressure/760; %Unit: atm
C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
N = (C * handles.Na)/1000; % Unit: molecule/cc

% crosssection = handles.spectra(:,2:end) * (log(10)/(N*handles.l)); % Unit: cm^2/molec
% extinctioncoeff = handles.spectra(:,2:end) * (1/(C*handles.l));% Unit: L/mol*cm
set (handles.temperature,'String',num2str(handles.T));
set (handles.numberdensity,'String',num2str(N));
set (handles.concentration,'String',num2str(C));

guidata(hObject, handles);


% --- Executes on button press in baselinecorrection.
function baselinecorrection_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else
    minmax1 = inputdlg({'Minimum of wavenumber to look for baseline correction:','Maximum of wavenumber to look for baseline correction:'},'Baseline correction');
    if isempty(minmax1)
        return
    else
        min1 = str2double(minmax1{1,1});
        max1 = str2double(minmax1{2,1});
        index1 = find(handles.spectra(:,1)> min1 & handles.spectra(:,1)< max1);
        sizeindex1 = size(index1);
        sizespectra = size (handles.spectra);
        
        offsets = zeros(1,sizespectra(1,2));
        for i = 1:sizespectra(1,2)-1
            meandata = mean(handles.spectra(index1(sizeindex1(1,2),1):index1(sizeindex1(1,1),1),i+1));
            handles.spectra (:,i+1) = handles.spectra(:,i+1)- meandata;
            offsets(1,i) = meandata;
        end
        
        switch handles.normto1torr_value
            case 0
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
                
            case 1
                partialpressure = str2double(get(handles.partialpressure,'String'));
                %                 partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
    
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function baselinecorrection2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% assignin('base','legend',handles.legend1);
if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else
    wavenumbercutoff = menu('Load existing cut off file or input new one','Load exsiting file of wavenumber cut off for baseline correction',...
        'Input the new wavenumber cut off for baseline correction');
    if isempty(wavenumbercutoff)
        return
%% load existing wavenumber cut off text file and doing further analysis
    else if wavenumbercutoff == 1
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
                    sizedatatable = size(handles.spectra);
                    zerotoplot = (zeros(1,sizedatatable(1,1)))';
                    j = sizedatatable(1,1);
                    zero1 = zeros(1,sizedatatable(1,2));
                    
                    waitbar1 = waitbar(0,'Please wait...');
                    i = 1;
                    fileforreg = [];
                    while i < split1*2+1
                        bcdata = handles.spectra;
                        for k = 1:j;
                            if bcdata(k,1) < str2double(regionslist(i,1))
                                bcdata (k,:) = zero1;
                            else if bcdata (k,1) > str2double(regionslist(i+1,1))
                                    bcdata (k,:) = zero1;
                                end
                            end
                        end
                        waitbar(i / split1);
                        i = i + 2;
                        bcdata( ~any(bcdata,2), : ) = [];
                        fileforreg = [fileforreg;bcdata];
                    end
                    close(waitbar1);
                    
                    polyfitvalue = split1-1;
                    dataformsbackadj = handles.spectra;
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
                            pp1(:,m) = polyval(p1,handles.spectra(:,1));
                            newy1(:,m) = handles.spectra(:,m+1)-pp1(:,m);
                            %% fit2 polyfit
                            x2 = fileforreg(:,1);
                            y2 = fileforreg(:,m+1);
                            p2 = polyfit(x2,y2,polyfitvalue);
                            pp2(:,m) = polyval(p2,handles.spectra(:,1));
                            newy2(:,m) = handles.spectra(:,m+1)-pp2(:,m);
                            %% fit 3
                            x3 = dataformsbackadj(:,1);
                            y3 = dataformsbackadj(:,m+1);
                            newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                        end
                        assignin('base','pp1',pp1);
                        assignin('base','pp2',pp2);
                        assignin('base','newy1',newy1);
                        assignin('base','newy2',newy2);
                        assignin('base','x1',handles.spectra(:,1));
                        
                        newy3 = flipud(newy3);
                        
                        figure(2)
                        subplot(2,1,1)
                        plot(handles.spectra(:,1),handles.spectra(:,2:end),...
                            handles.spectra(:,1),pp1);
                        title ('Spectra before baseline correction and the linear regressed baseline');
                        legend ([handles.legend1,handles.legend1]);
                        subplot(2,1,2)
                        plot(handles.spectra(:,1),newy1,handles.spectra(:,1),zerotoplot);
                        title ('Spectra after linear baseline correction');
                        legend([handles.legend1,'Zero line']);
                        
                        figure(3)
                        subplot(2,1,1)
                        plot(handles.spectra(:,1),handles.spectra(:,2:end),...
                            handles.spectra(:,1),pp2);
                        title ('Spectra before baseline correction and the polynomial regressed baseline');
                        legend ([handles.legend1,handles.legend1]);
                        subplot(2,1,2)
                        plot(handles.spectra(:,1),newy2,handles.spectra(:,1),zerotoplot);
                        title ('Spectra after polynomial baseline correction');
                        legend([handles.legend1,'Zero line']);
                        
                        figure(4)
                        subplot(2,1,1)
                        plot(handles.spectra(:,1),handles.spectra(:,2:end));
                        title ('Spectra before baseline correction');
                        legend (handles.legend1);
                        subplot(2,1,2)
                        plot(handles.spectra(:,1),newy3,handles.spectra(:,1),zerotoplot);
                        title ('Spectra after Matlab function baseline correction');
                        legend([handles.legend1,'Zero line']);
                        
                        figure(5)
                        plot(handles.spectra(:,1),handles.spectra(:,2),...
                            handles.spectra(:,1),newy1(:,1),...
                            handles.spectra(:,1),newy2(:,1),handles.spectra(:,1),newy3(:,1),...
                            handles.spectra(:,1),zerotoplot);
                        title ('Comparison of there different baseline correction');
                        legend('Before baseline correction','Linear baseline correction',...
                            'Polynomial baseline correction','Baseline correction with Matlab function','Zero line')
                        
                        repeatQ = menu(strcat(['Degree of second polyfit was set',' ',num2str(split1-1),'.',' Do want to change the degree of polyfit?']), 'YES','NO');
                        
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
                                handles.spectra(:,2:end) = newy1;
                                
                                axes(handles.axes1)
                                plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                legend (handles.legend1);
                                
                            case 2
                                handles.spectra(:,2:end) = newy2;
                                
                                axes(handles.axes1)
                                plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                legend (handles.legend1);
                                
                            case 3
                                handles.spectra(:,2:end) = newy3;
                                
                                axes(handles.axes1)
                                plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                legend (handles.legend1);
                        end
                    end
                end
            end         
%% Input a new wavenumber cut off save as text file and doing further analysis                        
        else if wavenumbercutoff == 2
                numofregions = inputdlg('Number of regions or points at which regression has to be done','Baseline correction info');
                if (isempty(numofregions) || isnan(str2double(numofregions)))
                    return
                else
                    split1 = str2double(numofregions);
                    
                    sizedatatable = size(handles.spectra);
                    zerotoplot = (zeros(1,sizedatatable(1,1)))';
                    figure(1)
                    plot(handles.spectra(:,1),handles.spectra(:,2:end),...
                        handles.spectra(:,1),zerotoplot)
                    
                    %% input the number of spectra
                    fileforreg = [];
                    
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
                        while i < split1*2+1
                            bcdata = handles.spectra;
                            for k = 1:j;
                                if bcdata(k,1) < str2double(regionslist(i,1))
                                    bcdata (k,:) = zero1;
                                else if bcdata (k,1) > str2double(regionslist(i+1,1))
                                        bcdata (k,:) = zero1;
                                    end
                                end
                            end
                            waitbar(i / split1);
                            i = i + 2;
                            bcdata( ~any(bcdata,2), : ) = [];
                            fileforreg = [fileforreg;bcdata];
                        end
                        close(waitbar1);
                        
                        polyfitvalue = split1-1;
                        dataformsbackadj = handles.spectra;
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
                                pp1(:,m) = polyval(p1,handles.spectra(:,1));
                                newy1(:,m) = handles.spectra(:,m+1)-pp1(:,m);
                                %% fit2 polyfit
                                x2 = fileforreg(:,1);
                                y2 = fileforreg(:,m+1);
                                p2 = polyfit(x2,y2,polyfitvalue);
                                pp2(:,m) = polyval(p2,handles.spectra(:,1));
                                newy2(:,m) = handles.spectra(:,m+1)-pp2(:,m);
                                %% fit 3
                                x3 = dataformsbackadj(:,1);
                                y3 = dataformsbackadj(:,m+1);
                                newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                            end
                            newy3 = flipud(newy3);
                            
                            figure(2)
                            subplot(2,1,1)
                            plot(handles.spectra(:,1),handles.spectra(:,2:end),...
                                handles.spectra(:,1),pp1);
                            title ('Spectra before baseline correction and the linear regressed baseline');
                            legend ([handles.legend1,handles.legend1]);
                            subplot(2,1,2)
                            plot(handles.spectra(:,1),newy1,handles.spectra(:,1),zerotoplot);
                            title ('Spectra after linear baseline correction');
                            legend([handles.legend1,'Zero line']);
                            
                            figure(3)
                            subplot(2,1,1)
                            plot(handles.spectra(:,1),handles.spectra(:,2:end),...
                                handles.spectra(:,1),pp2);
                            title ('Spectra before baseline correction and the polynomial regressed baseline');
                            legend ([handles.legend1,handles.legend1]);
                            subplot(2,1,2)
                            plot(handles.spectra(:,1),newy2,handles.spectra(:,1),zerotoplot);
                            title ('Spectra after polynomial baseline correction');
                            legend([handles.legend1,'Zero line']);
                            
                            figure(4)
                            subplot(2,1,1)
                            plot(handles.spectra(:,1),handles.spectra(:,2:end));
                            title ('Spectra before baseline correction');
                            legend (handles.legend1);
                            subplot(2,1,2)
                            plot(handles.spectra(:,1),newy3,handles.spectra(:,1),zerotoplot);
                            title ('Spectra after Matlab function baseline correction');
                            legend([handles.legend1,'Zero line']);
                            
                            figure(5)
                            plot(handles.spectra(:,1),handles.spectra(:,2),...
                                handles.spectra(:,1),newy1(:,1),...
                                handles.spectra(:,1),newy2(:,1),handles.spectra(:,1),newy3(:,1),...
                                handles.spectra(:,1),zerotoplot);
                            title ('Comparison of there different baseline correction');
                            legend('Before baseline correction','Linear baseline correction',...
                                'Polynomial baseline correction','Baseline correction with Matlab function','Zero line')
                            
                            repeatQ = menu(strcat(['Degree of second polyfit was set',' ',num2str(split1-1),'.',' Do want to change the degree of polyfit?']), 'YES','NO');
                            
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
                                    handles.spectra(:,2:end) = newy1;
                                    
                                    axes(handles.axes1)
                                    plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                    title('Raw spectra');
                                    xlabel('Wavenumber (cm^-^1)');
                                    ylabel('Abs. int.');
                                    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                    legend (handles.legend1);
                                    
                                case 2
                                    handles.spectra(:,2:end) = newy2;
                                    
                                    axes(handles.axes1)
                                    plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                    title('Raw spectra');
                                    xlabel('Wavenumber (cm^-^1)');
                                    ylabel('Abs. int.');
                                    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                    legend (handles.legend1);
                                    
                                case 3
                                    handles.spectra(:,2:end) = newy3;
                                    
                                    axes(handles.axes1)
                                    plot(handles.spectra(:,1),handles.spectra(:,2:end))
                                    title('Raw spectra');
                                    xlabel('Wavenumber (cm^-^1)');
                                    ylabel('Abs. int.');
                                    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                                    legend (handles.legend1);
                            end
                        end 
                    end
                end
            end
        end
    end
end

guidata(hObject, handles);


% --- Executes on button press in average.
function average_Callback(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else
%     assignin('base','handles',handles);
    handles.counter2 = handles.counter2 + 1;
    
    switch handles.normto1torr_value
        case 0
            handles.average_spectra = mean(handles.spectra(:,2:end),2);
            
            handles.spectrabasednorm = handles.spectra(:,2);
            handles.title_average = 'Average spectra';
            
            axes(handles.axes2)
            plot(handles.spectra(:,1),handles.spectrabasednorm,handles.spectra(:,1),handles.average_spectra)
            title(handles.title_average);
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
            legend('One of spectra','Average of all spectra');
            
            partialpressure = str2double(get(handles.partialpressure,'String'));
            partialpressure_atm = partialpressure/760; %Unit: atm
            C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
            N = (C * handles.Na)/1000; % Unit: molecule/cc
            
            handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
            handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
            
        case 1
            handles.average_spectra = mean(handles.spectranormed(:,2:end),2);
            
            handles.spectrabasednorm = handles.spectra(:,2)/str2double(handles.partialpressure.String);
            handles.title_average = 'Average spectra-Normalized to 1 Torr';
            
            axes(handles.axes2)
            plot(handles.spectra(:,1),handles.spectrabasednorm,handles.spectra(:,1),handles.average_spectra)
            title(handles.title_average);
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
            legend('One of spectra','Average of all spectra-Normalized to 1 Torr');
            
            partialpressure_atm = 1/760; %Unit: atm
            C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
            N = (C * handles.Na)/1000; % Unit: molecule/cc
            
            handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
            handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
    end
    
    axes(handles.axes3)
    plot(handles.spectra(:,1),handles.crosssection);
    title('Absorption Cross Section');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Absorption cross section \sigma (cm^2/molec)');
    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
    legend('Absorption cross section of averaged spectra');
    
    axes(handles.axes4)
    plot(handles.spectra(:,1),handles.extinctioncoeff);
    title('Extinction coefficient');
    xlabel('Wavenumber (cm^-^1)');
    ylabel('Extinction coefficient \epsilon (L/mol x cm)');
    xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
    legend('Extinction coefficient of averaged spectra');
end

guidata(hObject, handles);


% --- Executes on button press in normto1torr.
function normto1torr_Callback(hObject, eventdata, handles)
% hObject    handle to normto1torr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normto1torr
if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else
    
    handles.normto1torr_value = get (handles.normto1torr,'Value');
    
    switch handles.normto1torr_value
        case 0
            axes(handles.axes1)
            plot(handles.spectra(:,1),handles.spectra(:,2:end));
            title('Absorbance of raw spectra');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
            legend(handles.legend1);
            
            partialpressure = str2double(get(handles.partialpressure,'String'));
            partialpressure_atm = partialpressure/760; %Unit: atm
            C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
            N = (C * handles.Na)/1000; % Unit: molecule/cc
            
        case 1
            handles.spectranormed = [handles.spectra(:,1),handles.spectra(:,2:end)/str2double(handles.partialpressure.String)];
            
            axes(handles.axes1)
            plot(handles.spectra(:,1),handles.spectranormed(:,2:end));
            title('Absorbance of raw spectra scaled to 1 Torr');
            xlabel('Wavenumber (cm^-^1)');
            ylabel('Abs. int.');
            xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
            legend(handles.legend1);
            
            partialpressure_atm = 1/760; %Unit: atm
            C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
            N = (C * handles.Na)/1000; % Unit: molecule/cc
    end
    set (handles.numberdensity,'String',num2str(N));
    set (handles.concentration,'String',num2str(C));
end


guidata(hObject, handles);



function totalpressure_Callback(hObject, eventdata, handles)
% hObject    handle to totalpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalpressure as text
%        str2double(get(hObject,'String')) returns contents of totalpressure as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else if handles.counter2 == 0
        uiwait(errordlg('You should have your average sepctra to continue'));
    else
        totalpressure = get (handles.totalpressure,'String');
        if isempty (totalpressure)
            uiwait(errordlg('You should identfity the pressure value first.'));
        else
            
            totalpressure = str2double(get (handles.totalpressure,'String'));
            
            percentage = get(handles.premix,'String');
            if isempty (percentage)
                uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
            else
                percentage = str2double(get(handles.premix,'String'));
                if percentage == 0
                    uiwait(msgbox ('The percentage value 0 means the experiment is done under neat condition. If it is not a neat experiment input the rigth percentage value.','!!Warning!!'));
                    percentage_value = 1;
                else
                    percentage_value = percentage/100;
                end
                
                offset = get(handles.baratronoffset,'String');
                if isempty(offset)
                    uiwait(errordlg('You should identfity the offset value first. '));
                else
                    offset = str2double(get(handles.baratronoffset,'String'));
                    
                    totalpressure = totalpressure - offset;
                    set(handles.totalpressure,'String',num2str(totalpressure));
                    
                    partialpressure = totalpressure * percentage_value;
                    set(handles.partialpressure,'String',num2str(partialpressure));
                    
                    temperature = get(handles.temperature,'String');
                    if isempty(temperature)
                        uiwait(errordlg('You should identfity the temperature value first.'));
                    else
                        handles.T = str2double(temperature);
                        
                        partialpressure_atm = partialpressure/760; %Unit: atm
                        C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
                        N = (C * handles.Na)/1000; % Unit: molecule/cc
                        
                        set (handles.numberdensity,'String',num2str(N));
                        set (handles.concentration,'String',num2str(C));
                        
                        handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
                        handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
                    end
                end
                
            end
        end
        
        axes(handles.axes3)
        plot(handles.spectra(:,1),handles.crosssection);
        title('Absorption Cross Section');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Absorption cross section \sigma (cm^2/molec)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Absorption cross section of averaged spectra');
        
        axes(handles.axes4)
        plot(handles.spectra(:,1),handles.extinctioncoeff);
        title('Extinction coefficient');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Extinction coefficient \epsilon (L/mol x cm)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Extinction coefficient of averaged spectra');
        
        handles.normto1torr_value = get (handles.normto1torr,'Value');
        switch handles.normto1torr_value
            case 0
                handles.spectra = handles.pectra;
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
            case 1
                handles.spectra = handles.pectra;
                partialpressure = get(handles.partialpressure,'String');
                partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function totalpressure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function partialpressure_Callback(hObject, eventdata, handles)
% hObject    handle to partialpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of partialpressure as text
%        str2double(get(hObject,'String')) returns contents of partialpressure as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else if handles.counter2 == 0
        uiwait(errordlg('You should have your average sepctra to continue'));
    else
        partialpressure = get (handles.partialpressure,'String');
        if isempty (partialpressure)
            uiwait(errordlg('You should identfity the pressure value first.'));
        else
            
            partialpressure = str2double(get (handles.partialpressure,'String'));
            
            percentage = get(handles.premix,'String');
            if isempty (percentage)
                uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
            else
                percentage = str2double(get(handles.premix,'String'));
                if percentage == 0
                    uiwait(msgbox ('The percentage value 0 means the experiment is done under neat condition. If it is not a neat experiment input the rigth percentage value.','!!Warning!!'));
                    percentage_value = 1;
                else
                    percentage_value = percentage/100;
                end
                
                offset = get(handles.baratronoffset,'String');
                if isempty(offset)
                    uiwait(errordlg('You should identfity the offset value first. '));
                else
                    offset = str2double(get(handles.baratronoffset,'String'));
                    
                    partialpressure = partialpressure - offset*percentage_value;
                    totalpressure = partialpressure / percentage_value;
                    
                    set(handles.partialpressure,'String',num2str(partialpressure));
                    
                    set(handles.totalpressure,'String',num2str(totalpressure));
                    
                    temperature = get(handles.temperature,'String');
                    if isempty(temperature)
                        uiwait(errordlg('You should identfity the temperature value first.'));
                    else
                        handles.T = str2double(temperature);
                        
                        partialpressure_atm = partialpressure/760; %Unit: atm
                        C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
                        N = (C * handles.Na)/1000; % Unit: molecule/cc
                        
                        set (handles.numberdensity,'String',num2str(N));
                        set (handles.concentration,'String',num2str(C));
                        
                        handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
                        handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
                    end
                end
            end
        end
        
        axes(handles.axes3)
        plot(handles.spectra(:,1),handles.crosssection);
        title('Absorption Cross Section');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Absorption cross section \sigma (cm^2/molec)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Absorption cross section of averaged spectra');
        
        axes(handles.axes4)
        plot(handles.spectra(:,1),handles.extinctioncoeff);
        title('Extinction coefficient');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Extinction coefficient \epsilon (L/mol x cm)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Extinction coefficient of averaged spectra');
        
        handles.normto1torr_value = get (handles.normto1torr,'Value');
        switch handles.normto1torr_value
            case 0
                handles.spectra = handles.pectra;
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
            case 1
                handles.spectra = handles.pectra;
                partialpressure = get(handles.partialpressure,'String');
                partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function partialpressure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to partialpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function premix_Callback(hObject, eventdata, handles)
% hObject    handle to premix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of premix as text
%        str2double(get(hObject,'String')) returns contents of premix as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else if handles.counter2 == 0
        uiwait(errordlg('You should have your average sepctra to continue'));
    else
        percentage = get(handles.premix,'String');
        if isempty (percentage)
            uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
        else
            totalpressure = get (handles.totalpressure,'String');
            partialpressure = get (handles.partialpressure,'String');
            
            if (isempty (totalpressure) && isempty (partialpressure))
                uiwait(errordlg('You should identfity the pressure value first.'));
            else
                
                percentage = str2double(get(handles.premix,'String'));
                if percentage == 0
                    uiwait(msgbox ('The percentage value 0 means the experiment is done under neat condition. If it is not a neat experiment input the rigth percentage value.','!!Warning!!'));
                    percentage_value = 1;
                else
                    percentage_value = percentage/100;
                end
                
                offset = get(handles.baratronoffset,'String');
                if isempty(offset)
                    uiwait(errordlg('You should identfity the offset value first. '));
                else
                    offset = str2double(get(handles.baratronoffset,'String'));
                    
                    if isempty (totalpressure)
                        partialpressure = str2double(get (handles.partialpressure,'String'));
                        partialpressure = partialpressure - offset*percentage_value;
                        totalpressure = partialpressure / percentage_value;
                        set(handles.totalpressure,'String',num2str(totalpressure));
                    else
                        totalpressure = str2double(get (handles.totalpressure,'String'));
                        totalpressure = totalpressure - offset;
                        partialpressure = totalpressure * percentage_value;
                        set(handles.partialpressure,'String',num2str(partialpressure));
                    end
                    
                    temperature = get(handles.temperature,'String');
                    if isempty(temperature)
                        uiwait(errordlg('You should identfity the temperature value first.'));
                    else
                        handles.T = str2double(temperature);
                        
                        partialpressure_atm = partialpressure/760; %Unit: atm
                        C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
                        N = (C * handles.Na)/1000; % Unit: molecule/cc
                        
                        set (handles.numberdensity,'String',num2str(N));
                        set (handles.concentration,'String',num2str(C));
                        
                        handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
                        handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
                    end
                end
            end
        end
        
        axes(handles.axes3)
        plot(handles.spectra(:,1),handles.crosssection);
        title('Absorption Cross Section');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Absorption cross section \sigma (cm^2/molec)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Absorption cross section of averaged spectra');
        
        axes(handles.axes4)
        plot(handles.spectra(:,1),handles.extinctioncoeff);
        title('Extinction coefficient');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Extinction coefficient \epsilon (L/mol x cm)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Extinction coefficient of averaged spectra');
        
        handles.normto1torr_value = get (handles.normto1torr,'Value');
        switch handles.normto1torr_value
            case 0
%                 handles.spectra = handles.pectra;
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
            case 1
                handles.spectra = handles.pectra;
                partialpressure = get(handles.partialpressure,'String');
                partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function premix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to premix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function baratronoffset_Callback(hObject, eventdata, handles)
% hObject    handle to baratronoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of baratronoffset as text
%        str2double(get(hObject,'String')) returns contents of baratronoffset as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else if handles.counter2 == 0
        uiwait(errordlg('You should have your average sepctra to continue'));
    else
        offset = get(handles.baratronoffset,'String');
        if isempty (offset)
            uiwait(errordlg('You should identfity the baratronoffset  first.'));
        else
            totalpressure = get (handles.totalpressure,'String');
            partialpressure = get (handles.partialpressure,'String');
            
            if (isempty (totalpressure) && isempty (partialpressure))
                uiwait(errordlg('You should identfity the pressure value first.'));
            else
                
                percentage = get(handles.premix,'String');
                if isempty (percentage)
                    uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
                else
                    percentage = str2double(get(handles.premix,'String'));
                    if percentage == 0
                        uiwait(msgbox ('The percentage value 0 means the experiment is done under neat condition. If it is not a neat experiment input the rigth percentage value.','!!Warning!!'));
                        percentage_value = 1;
                    else
                        percentage_value = percentage/100;
                    end
                    
                    offset = str2double(get(handles.baratronoffset,'String'));
                    
                    if isempty (totalpressure)
                        partialpressure = str2double(get (handles.partialpressure,'String'));
                        partialpressure = partialpressure - offset*percentage_value;
                        totalpressure = partialpressure / percentage_value;
                        set(handles.totalpressure,'String',num2str(totalpressure));
                    else
                        totalpressure = str2double(get (handles.totalpressure,'String'));
                        totalpressure = totalpressure - offset;
                        partialpressure = totalpressure * percentage_value;
                        set(handles.partialpressure,'String',num2str(partialpressure));
                    end
                    
                    temperature = get(handles.temperature,'String');
                    if isempty(temperature)
                        uiwait(errordlg('You should identfity the temperature value first.'));
                    else
                        handles.T = str2double(temperature);
                        
                        partialpressure_atm = partialpressure/760; %Unit: atm
                        C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
                        N = (C * handles.Na)/1000; % Unit: molecule/cc
                        
                        set (handles.numberdensity,'String',num2str(N));
                        set (handles.concentration,'String',num2str(C));
                        
                        handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
                        handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
                    end
                end
            end
        end
        
        
        axes(handles.axes3)
        plot(handles.spectra(:,1),handles.crosssection);
        title('Absorption Cross Section');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Absorption cross section \sigma (cm^2/molec)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Absorption cross section of averaged spectra');
        
        axes(handles.axes4)
        plot(handles.spectra(:,1),handles.extinctioncoeff);
        title('Extinction coefficient');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Extinction coefficient \epsilon (L/mol x cm)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Extinction coefficient of averaged spectra');
        
        handles.normto1torr_value = get (handles.normto1torr,'Value');
        switch handles.normto1torr_value
            case 0
                handles.spectra = handles.pectra;
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
            case 1
                handles.spectra = handles.pectra;
                partialpressure = get(handles.partialpressure,'String');
                partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function baratronoffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baratronoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temperature_Callback(hObject, eventdata, handles)
% hObject    handle to temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temperature as text
%        str2double(get(hObject,'String')) returns contents of temperature as a double

if handles.counter1 == 0
    uiwait(errordlg('You should first load spectra file'));
else if handles.counter2 == 0
        uiwait(errordlg('You should have your average sepctra to continue'));
    else
        temperature = get(handles.temperature,'String');
        if isempty(temperature)
            uiwait(errordlg('You should identfity the temperature value first.'));
        else
            
            partialpressure = get (handles.partialpressure,'String');
            totalpressure = get (handles.totalpressure,'String');
            if (isempty (totalpressure) && isempty (partialpressure))
                uiwait(errordlg('You should identfity the pressure value first.'));
            else
                
                percentage = get(handles.premix,'String');
                if isempty (percentage)
                    uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
                else
                    percentage = str2double(get(handles.premix,'String'));
                    if percentage == 0
                        uiwait(msgbox ('The percentage value 0 means the experiment is done under neat condition. If it is not a neat experiment input the rigth percentage value.','!!Warning!!'));
                        percentage_value = 1;
                    else
                        percentage_value = percentage/100;
                    end
                    
                    offset = get(handles.baratronoffset,'String');
                    if isempty (offset)
                        uiwait(errordlg('You should identfity the percentage value first. If it is not a premix experiment input 0.'));
                    else
                        offset = str2double(get(handles.baratronoffset,'String'));
                        
                        if isempty (totalpressure)
                            partialpressure = str2double(get (handles.partialpressure,'String'));
                            partialpressure = partialpressure - offset*percentage_value;
                            totalpressure = partialpressure / percentage_value;
                            set(handles.totalpressure,'String',num2str(totalpressure));
                        else
                            totalpressure = str2double(get (handles.totalpressure,'String'));
                            totalpressure = totalpressure - offset;
                            partialpressure = totalpressure * percentage_value;
                            set(handles.partialpressure,'String',num2str(partialpressure));
                        end
                        
                        handles.T = str2double(temperature);
                        
                        partialpressure_atm = partialpressure/760; %Unit: atm
                        C = partialpressure_atm/(handles.R*handles.T);% Unit: mol/L
                        N = (C * handles.Na)/1000; % Unit: molecule/cc
                        
                        set (handles.numberdensity,'String',num2str(N));
                        set (handles.concentration,'String',num2str(C));
                        
                        handles.crosssection = handles.average_spectra * (log(10)/(N*handles.l)); % Unit: cm^2/molec
                        handles.extinctioncoeff = handles.average_spectra * (1/(C*handles.l));% Unit: L/mol*cm
                    end
                end
            end
        end
        
        
        axes(handles.axes3)
        plot(handles.spectra(:,1),handles.crosssection);
        title('Absorption Cross Section');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Absorption cross section \sigma (cm^2/molec)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Absorption cross section of averaged spectra');
        
        axes(handles.axes4)
        plot(handles.spectra(:,1),handles.extinctioncoeff);
        title('Extinction coefficient');
        xlabel('Wavenumber (cm^-^1)');
        ylabel('Extinction coefficient \epsilon (L/mol x cm)');
        xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
        legend('Extinction coefficient of averaged spectra');
        
        handles.normto1torr_value = get (handles.normto1torr,'Value');
        switch handles.normto1torr_value
            case 0
                handles.spectra = handles.pectra;
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
            case 1
                handles.spectra = handles.pectra;
                partialpressure = get(handles.partialpressure,'String');
                partialpressure = str2double(partialpressure);
                handles.spectra = [handles.spectra(:,1),handles.spectra(:,2:end)/partialpressure];
                
                axes(handles.axes1)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra scaled to 1 Torr');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
        end
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function temperature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberdensity_Callback(hObject, eventdata, handles)
% hObject    handle to numberdensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberdensity as text
%        str2double(get(hObject,'String')) returns contents of numberdensity as a double


% --- Executes during object creation, after setting all properties.
function numberdensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberdensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function concentration_Callback(hObject, eventdata, handles)
% hObject    handle to concentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of concentration as text
%        str2double(get(hObject,'String')) returns contents of concentration as a double


% --- Executes during object creation, after setting all properties.
function concentration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concentration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

savemenu = menu('Save options','Save Averaged Absorbance Spectra',...
    'Save Absorption Cross Section','Save Extinction Coefficient',...
    'Save Experimental Information','Save All');

if isempty(savemenu)
    return
else
    
    switch savemenu
        
        case 1
            if handles.counter2 == 0
                errordlg('There is no Average Absorbance spectra to save');
            else
                filetosave = [handles.spectra(:,1),handles.average_spectra];
                [filenametosave,pathtosave] = uiputfile({'*.txt','txt-file (*.txt)';...
                    '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                    '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                    'Save as','Averaged Absorbance Spectrum');
                
                if isequal([filenametosave,pathtosave] ,[0,0])
                    return
                else
                    path_file = fullfile (pathtosave,filenametosave);
                    dlmwrite (path_file,filetosave,'precision',10);
                end
            end
            
        case 2
            if handles.counter2 == 0
                errordlg('There is no Absorption Cross Section spectrum to save');
            else
                filetosave = [handles.spectra(:,1),handles.crosssection];
                [filenametosave,pathtosave] = uiputfile({'*.txt','txt-file (*.txt)';...
                    '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                    '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                    'Save as','Absorption Cross Section');% {'*.txt','*.m';'*.slx';'*.mat';'*.*'}
                
                if isequal([filenametosave,pathtosave] ,[0,0])
                    return
                else
                    path_file = strcat (pathtosave,filenametosave);
                    dlmwrite (path_file,filetosave,'precision',10);
                end
            end
            
        case 3
            if handles.counter2 == 0
                errordlg('There is no Extinction Coefficient spectrum to save');
            else
                filetosave = [handles.spectra(:,1),handles.extinctioncoeff];
                [filenametosave,pathtosave] = uiputfile({'*.txt','txt-file (*.txt)';...
                    '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                    '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                    'Save as','Extinction Coefficient');
                
                if isequal([filenametosave,pathtosave] ,[0,0])
                    return
                else
                    path_file = strcat (pathtosave,filenametosave);
                    dlmwrite (path_file,filetosave,'precision',10);
                end
            end
            
        case 4
            [filenametosave,pathtosave] = uiputfile({'*.txt','txt-file (*.txt)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save as','Experimental info');
            
            if isequal([filenametosave,pathtosave] ,[0,0])
                return
            else
                switch handles.normto1torr.Value
                    case 0
                        handles.expinfo_output = {strcat(['Total Pressure:','  ',handles.totalpressure.String]);...
                            [];...
                            strcat(['Partial Pressure (Torr):','  ',handles.partialpressure.String]);...
                            [];...
                            strcat(['Premix Percentage:','  ',handles.premix.String]);...
                            [];...
                            strcat(['Baratron Offset (Torr): ','  ',handles.baratronoffset.String]);...
                            [];...
                            strcat(['Temperature (K):','  ',handles.temperature.String]);...
                            [];...
                            strcat(['Number Density (cm^2/molec):','  ',handles.numberdensity.String]);...
                            [];...
                            strcat(['Concentration (L/mol*cm)\n:','  ',handles.concentration.String])};
                        handles.expinfo.String = handles.expinfo_output;
                        
                    case 1
                        handles.expinfo_output = {'The experiment is done at the below conditions but pressure is normalized to 1 Torr and so concentration and number density are calculated based on 1 Torr pressure.';...
                            [];...
                            strcat(['Total Pressure:','  ',handles.totalpressure.String]);...
                            [];...
                            strcat(['Partial Pressure (Torr):','  ',handles.partialpressure.String]);...
                            [];...
                            strcat(['Premix Percentage:','  ',handles.premix.String]);...
                            [];...
                            strcat(['Baratron Offset (Torr): ','  ',handles.baratronoffset.String]);...
                            [];...
                            strcat(['Temperature (K):','  ',handles.temperature.String]);...
                            [];...
                            ('Number Density and Concentration calculated based on 1 Torr');...
                            [];...
                            strcat(['Number Density (cm^2/molec):','  ',handles.numberdensity.String]);...
                            [];...
                            strcat(['Concentration (L/mol*cm)\n:','  ',handles.concentration.String])};
                        handles.expinfo.String = handles.expinfo_output; 
                end
                path_file = fullfile (pathtosave,filenametosave);
                handles.expinfo_output = char(cellstr(handles.expinfo.String));
                size1 = size(handles.expinfo_output);
                fileID = fopen(path_file,'w');
                for i = 1:size1(1,1)
                    fprintf(fileID,'%s\r\n',handles.expinfo_output(i,:));
                end
                fclose(fileID);
            end
            
        case 5
            if handles.counter2 == 0
                errordlg('There is no file to save');
            else
                [filenametosave,pathtosave] = uiputfile({'*.txt','txt-file (*.txt)';...
                    '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                    '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                    'Save as','All');
                
                if isequal ([filenametosave,pathtosave] ,[0,0])
                    return
                else
                    % put all the spectra in one file
                    filetosave1 = [handles.spectra(:,1),handles.average_spectra];
                    path_file1 = fullfile (pathtosave,'Averaged Absorbance Spectra.txt');
                    filetosave2 = [handles.spectra(:,1),handles.crosssection];
                    path_file2 = fullfile (pathtosave,'Absorption Cross Section.txt');
                    filetosave3 = [handles.spectra(:,1),handles.extinctioncoeff];
                    path_file3 = fullfile (pathtosave,'Extinction Coefficient.txt');
                    path_file4 = fullfile (pathtosave,'Expermental info.txt');
                    
                    dlmwrite (path_file1,filetosave1,'precision',10);
                    dlmwrite (path_file2,filetosave2,'precision',10);
                    dlmwrite (path_file3,filetosave3,'precision',10);
                    
                    switch handles.normto1torr.Value
                        case 0
                            handles.expinfo_output = {strcat(['Total Pressure:','  ',handles.totalpressure.String]);...
                                [];...
                                strcat(['Partial Pressure (Torr):','  ',handles.partialpressure.String]);...
                                [];...
                                strcat(['Premix Percentage:','  ',handles.premix.String]);...
                                [];...
                                strcat(['Baratron Offset (Torr): ','  ',handles.baratronoffset.String]);...
                                [];...
                                strcat(['Temperature (K):','  ',handles.temperature.String]);...
                                [];...
                                strcat(['Number Density (cm^2/molec):','  ',handles.numberdensity.String]);...
                                [];...
                                strcat(['Concentration (L/mol*cm)\n:','  ',handles.concentration.String])};
                            handles.expinfo.String = handles.expinfo_output;
                            
                        case 1
                            handles.expinfo_output = {'The experiment is done at the below conditions but pressure is normalized to 1 Torr and so concentration and number density are calculated based on 1 Torr pressure.';...
                                [];...
                                strcat(['Total Pressure:','  ',handles.totalpressure.String]);...
                                [];...
                                strcat(['Partial Pressure (Torr):','  ',handles.partialpressure.String]);...
                                [];...
                                strcat(['Premix Percentage:','  ',handles.premix.String]);...
                                [];...
                                strcat(['Baratron Offset (Torr): ','  ',handles.baratronoffset.String]);...
                                [];...
                                strcat(['Temperature (K):','  ',handles.temperature.String]);...
                                [];...
                                ('Number Density and Concentration calculated based on 1 Torr');...
                                [];...
                                strcat(['Number Density (cm^2/molec):','  ',handles.numberdensity.String]);...
                                [];...
                                strcat(['Concentration (L/mol*cm)\n:','  ',handles.concentration.String])};
                            handles.expinfo.String = handles.expinfo_output;
                    end
                    handles.expinfo_output = char(cellstr(handles.expinfo.String));
                    size1 = size(handles.expinfo_output);
                    fileID = fopen(path_file4,'w');
                    for i = 1:size1(1,1)
                        fprintf(fileID,'%s\r\n',handles.expinfo_output(i,:));
                    end
                    fclose(fileID);
                end
            end
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function savefigure_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to savefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveoptions = menu ('Figure to save:','Figure(6)-Abs. Raw spectra',...
    'Figure(7)-Averaged spectra','Figure(8)-Abs. Cross section',...
    'Figure(9)-Extinction coeffcicient','All figures');

if isempty(saveoptions)
    return
else

    switch saveoptions
        case 1
            if isequal(handles.counter1,0)
                errordlg('Figure not found. You should first load the files.')
            else
                figure (6)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
                
                [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                    '*.jpg', 'JPEG files (*.jpg)';...
                    '*.fig','Figures (*.fig)';...
                    '*.*',  'All Files (*.*)'},...
                    'Save as','Abs. Raw spectra');
                if isequal ([filename, pathname],[0,0])
                    return
                else
                    filepath = fullfile (pathname,filename);
                    saveas(figure(6),filepath);
                end
            end
            
        case 2
            if isequal(handles.counter2,0)
                errordlg('Figure not found. You should first Average spectra.')
            else
                figure(7)
                plot(handles.spectra(:,1),handles.spectrabasednorm,handles.spectra(:,1),handles.average_spectra)
                title(handles.title_average);
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('One of spectra',handles.title_average);

                [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                    '*.jpg', 'JPEG files (*.jpg)';...
                    '*.fig','Figures (*.fig)';...
                    '*.*',  'All Files (*.*)'},...
                    'Save as','Averaged spectra');
                if isequal ([filename, pathname],[0,0])
                    return
                else
                    filepath = fullfile (pathname,filename);
                    saveas(figure(7),filepath);
                end
            end
            
        case 3
            if isequal(handles.counter2,0)
                errordlg('Figure not found. You should first Average spectra.')
            else
                figure(8)
                plot(handles.spectra(:,1),handles.crosssection);
                title('Absorption Cross Section');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Absorption cross section \sigma (cm^2/molec)');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('Absorption cross section of averaged spectra');
                
                [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                    '*.jpg', 'JPEG files (*.jpg)';...
                    '*.fig','Figures (*.fig)';...
                    '*.*',  'All Files (*.*)'},...
                    'Save as','Abs. Cross section');
                if isequal ([filename, pathname],[0,0])
                    return
                else
                    filepath = fullfile (pathname,filename);
                    saveas(figure(8),filepath);
                end
            end
            
        case 4
            if isequal(handles.counter2,0)
                errordlg('Figure not found. You should first Average spectra.')
            else
                figure(9)
                plot(handles.spectra(:,1),handles.extinctioncoeff);
                title('Extinction coefficient');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Extinction coefficient \epsilon (L/mol x cm)');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('Extinction coefficient of averaged spectra');
                
                [filename, pathname] = uiputfile({'*.png','png Files (*.png)';...
                    '*.jpg', 'JPEG files (*.jpg)';...
                    '*.fig','Figures (*.fig)';...
                    '*.*',  'All Files (*.*)'},...
                    'Save as','Extinction coefficient');
                if isequal ([filename, pathname],[0,0])
                    return
                else
                    filepath = fullfile (pathname,filename);
                    saveas(figure(9),filepath);
                end
            end

        case 5
            if (isequal(handles.counter1,0) && isequal(handles.counter2,0))
                errordlg('Possible troubleshooting: 1. Load spectra. or 2. Average spectra.')
            else
                figure (6)
                plot(handles.spectra(:,1),handles.spectra(:,2:end));
                title('Absorbance of raw spectra');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend(handles.legend1);
                
                figure(7)
                plot(handles.spectra(:,1),handles.spectrabasednorm,handles.spectra(:,1),handles.average_spectra)
                title(handles.title_average);
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Abs. int.');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('One of spectra',handles.title_average);
                
                figure(8)
                plot(handles.spectra(:,1),handles.crosssection);
                title('Absorption Cross Section');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Absorption cross section \sigma (cm^2/molec)');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('Absorption cross section of averaged spectra');
                
                figure(9)
                plot(handles.spectra(:,1),handles.extinctioncoeff);
                title('Extinction coefficient');
                xlabel('Wavenumber (cm^-^1)');
                ylabel('Extinction coefficient \epsilon (L/mol x cm)');
                xlim ([min(handles.spectra(:,1)) max(handles.spectra(:,1))]);
                legend('Extinction coefficient of averaged spectra');

                [filename, pathname] = uiputfile('All.fig','Save as');
                if isequal ([filename, pathname],[0,0])
                    return
                else
                    saveas(figure(6),fullfile(pathname,'Raw spectra.fig'));
                    saveas(figure(7),fullfile(pathname,'Averaged spectra.fig'));
                    saveas(figure(8),fullfile(pathname,'Abs. Cross section.fig'));
                    saveas(figure(9),fullfile(pathname,'Extinction coefficient.fig'));
                end
            end
    end
    
end

% set (handles.numberdensity,'String',num2str(N));
% set (handles.concentration,'String',num2str(C));
guidata(hObject, handles);


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Clear command window:

handles = handles.initial_handles;
handles.initial_handles = handles;

cla (handles.axes1,'reset');
cla (handles.axes2,'reset');
cla (handles.axes3,'reset');
cla (handles.axes4,'reset');
handles.totalpressure.String = [];
handles.partialpressure.String = [];
handles.premix.String = [];
handles.baratronoffset.String = [];
handles.temperature.String = [];
handles.numberdensity.String = [];
handles.concentration.String = [];


guidata(hObject, handles);
