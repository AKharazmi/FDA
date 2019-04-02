function varargout = nolaser(varargin)
% NOLASER MATLAB code for nolaser.fig
%      NOLASER, by itself, creates a new NOLASER or raises the existing
%      singleton*.
%
%      H = NOLASER returns the handle to a new NOLASER or the handle to
%      the existing singleton*.
%
%      NOLASER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOLASER.M with the given input arguments.
%
%      NOLASER('Property','Value',...) creates a new NOLASER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nolaser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nolaser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nolaser

% Last Modified by GUIDE v2.5 02-Jul-2018 20:28:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @nolaser_OpeningFcn, ...
    'gui_OutputFcn',  @nolaser_OutputFcn, ...
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


% --- Executes just before nolaser is made visible.
function nolaser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nolaser (see VARARGIN)

% Choose default command line output for nolaser
handles.output = hObject;

%%
all_gcf = findall(gcf);
% Turning off unnecessary bottons
Linking = findall(all_gcf,'ToolTipString','Link Plot');
set(Linking,'Visible','Off');
InsertColorbar = findall(all_gcf,'ToolTipString','Insert Colorbar');
set(InsertColorbar,'Visible','Off');
Brushing = findall(all_gcf,'ToolTipString','Brush/Select Data');
set(Brushing,'Visible','Off');

%%
myToolbar = findall(gcf,'tag','FigureToolBar');

FileOpen_callback = findall(myToolbar,'tag','Standard.FileOpen');
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)nolaser('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save as');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)nolaser('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));


NewFigure_callback = findall(myToolbar,'tag','Standard.NewFigure');
set(NewFigure_callback, 'ClickedCallback','New Figure','TooltipString','New Figure');
set(NewFigure_callback, 'ClickedCallback',@(hObject,eventdata)nolaser('new_ClickedCallback',hObject,eventdata,guidata(hObject)));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nolaser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nolaser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function myopen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filenames1,pathname1] = uigetfile({'*.txt','text files';'*.dpt','dpt files';...
    '*.m','Matlab files';'*.*','All files'},...
    'Load files','MultiSelect','on');
if isequal([filenames1,pathname1] , [0,0])
    return
else
    
    cd (pathname1);
    set(handles.figure1, 'Name', pathname1);
    
    wavenumber = importdata(char(strcat(pathname1,filenames1(:,1))));
    wavenumber = wavenumber(:,1);
    length1 = size(wavenumber);
    length1 = length1(1,1);
    
    handles.size_filenames1 = size(filenames1);
    spectra = sparse(length1,handles.size_filenames1(1,2));
    
    for i = 1:handles.size_filenames1(1,2)
        xy = importdata(char(fullfile(pathname1,filenames1(:,i))));
        spectra(:,i) = xy(:,2);
    end
    
    handles.all = [wavenumber,spectra];
    handles.all = sortrows(handles.all,-1);
    
    handles.min1 = min(handles.all(:,1));
    handles.max1 = max(handles.all(:,1));
    if handles.min1 < 700
        index1 = find (handles.all(:,1) < 700 );
        size_index1 = size(index1);
        handles.all (index1(1,1):index1(size_index1(1,1),1),:) = [];
    end
    if handles.max1 > 3999.74
        index2 = find (handles.all(:,1) > 3999.74 );
        size_index2 = size(index2);
        handles.all (index2(1,1):index2(size_index2(1,1),1),:) = [];
    end
    
    handles.min1 = min(handles.all(:,1));
    handles.max1 = max(handles.all(:,1));
    
    nolaser = cell (1,handles.size_filenames1(1,2));
    for j = 1:handles.size_filenames1(1,2)
        nolaser{j} = strcat('nolaser',num2str(j));
    end
    
    column_names = ['Wavenumber(cm-1)',nolaser];
    
    handles.uitable1.Data = handles.all;
    handles.uitable1.ColumnName = column_names;
    handles.size_uitable1 = size(handles.uitable1.Data);
    set(handles.uitable1,'ColumnEditable',true(1,handles.size_uitable1(1,2)));
    
    axes(handles.axes1)
    plot(handles.all(:,1),handles.all(:,2:end));
    title ('Nolaser spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim([handles.min1 handles.max1]);
    legend(handles.uitable1.ColumnName(2:end,1));
    
end

handles.linexp.Value = 1;


guidata(hObject, handles);


% --- Executes on button press in mysavefigure.
function baselinecorrection_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mysavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


minmax1 = inputdlg({'Minimum of wavenumber to look for baseline correction:','Maximum of wavenumber to look for baseline correction:'},'Baseline correction');
if isequal(minmax1 , {})
    return
else
    min1 = str2double(minmax1{1,1});
    max1 = str2double(minmax1{2,1});
    index1 = find(handles.uitable1.Data(:,1)> min1 & handles.uitable1.Data(:,1)< max1);
    sizeindex1 = size(index1);
    offsets = sparse(1,handles.size_filenames1(1,2));
    for k = 1:handles.size_filenames1(1,2)
        meandata = mean(handles.uitable1.Data(index1(sizeindex1(1,2),1):index1(sizeindex1(1,1),1),k+1));
        handles.uitable1.Data(:,k+1) = handles.uitable1.Data(:,k+1)- meandata;
        offsets(1,k) = meandata;
    end
    
    axes(handles.axes1)
    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
    title ('Nolaser spectra');
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim([handles.min1 handles.max1]);
    legend(handles.uitable1.ColumnName(2:end,1));
    
end


guidata(hObject, handles);


% --------------------------------------------------------------------
function baselinecorrection2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


wavenumbercutoff = menu('Load existing cut off file or input new one','Load exsiting file of wavenumber cut off for baseline correction',...
    'Input the new wavenumber cut off for baseline correction');
if isempty(wavenumbercutoff)
    return
    %% load existing wavenumber cut off text file and doing further analysis
else if wavenumbercutoff == 1
        [filename,pathname] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Select wavenumber cut off file');
        if isequal([filename,pathname],[0,0]);
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
                sizedatatable = size(handles.uitable1.Data);
                zerotoplot = (zeros(1,sizedatatable(1,1)))';
                j = sizedatatable(1,1);
                zero1 = zeros(1,sizedatatable(1,2));
                
                waitbar1 = waitbar(0,'Please wait...');
                i = 1;
                fileforreg = [];
                while i < split1*2+1
                    bcdata = handles.uitable1.Data;
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
                dataformsbackadj = handles.uitable1.Data;
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
                        pp1(:,m) = polyval(p1,handles.uitable1.Data(:,1));
                        newy1(:,m) = handles.uitable1.Data(:,m+1)-pp1(:,m);
                        %% fit2 polyfit
                        x2 = fileforreg(:,1);
                        y2 = fileforreg(:,m+1);
                        p2 = polyfit(x2,y2,polyfitvalue);
                        pp2(:,m) = polyval(p2,handles.uitable1.Data(:,1));
                        newy2(:,m) = handles.uitable1.Data(:,m+1)-pp2(:,m);
                        %% fit 3
                        x3 = dataformsbackadj(:,1);
                        y3 = dataformsbackadj(:,m+1);
                        newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                    end
                    newy3 = flipud(newy3);
                    
                    figure(2)
                    subplot(2,1,1)
                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end),...
                        handles.uitable1.Data(:,1),pp1);
                    title ('Spectra before baseline correction and the linear regressed baseline');
                    legend ([handles.uitable1.ColumnName(2:end,1);handles.uitable1.ColumnName(2:end,1)]);
                    subplot(2,1,2)
                    plot(handles.uitable1.Data(:,1),newy1,handles.uitable1.Data(:,1),zerotoplot);
                    title ('Spectra after linear baseline correction');
                    legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                    
                    figure(3)
                    subplot(2,1,1)
                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end),...
                        handles.uitable1.Data(:,1),pp2);
                    title ('Spectra before baseline correction and the polynomial regressed baseline');
                    legend ([handles.uitable1.ColumnName(2:end,1);handles.uitable1.ColumnName(2:end,1)]);
                    subplot(2,1,2)
                    plot(handles.uitable1.Data(:,1),newy2,handles.uitable1.Data(:,1),zerotoplot);
                    title ('Spectra after polynomial baseline correction');
                    legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                    
                    figure(4)
                    subplot(2,1,1)
                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end));
                    title ('Spectra before baseline correction');
                    legend (handles.uitable1.ColumnName(2:end,1));
                    subplot(2,1,2)
                    plot(handles.uitable1.Data(:,1),newy3,handles.uitable1.Data(:,1),zerotoplot);
                    title ('Spectra after Matlab function baseline correction');
                    legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                    
                    figure(5)
                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2),...
                        handles.uitable1.Data(:,1),newy1(:,1),...
                        handles.uitable1.Data(:,1),newy2(:,1),handles.uitable1.Data(:,1),newy3(:,1),...
                        handles.uitable1.Data(:,1),zerotoplot);
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
                            handles.uitable1.Data(:,2:end) = newy1;
                            
                            axes(handles.axes1)
                            plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                            legend (handles.uitable1.ColumnName(2:end,1));
                            
                        case 2
                            set(handles.uitable1,'Data',[handles.uitable1.Data(:,1),newy2]);
                            
                            axes(handles.axes1)
                            plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                            legend (handles.uitable1.ColumnName(2:end,1));
                            
                        case 3
                            set(handles.uitable1,'Data',[handles.uitable1.Data(:,1),newy3]);
                            
                            axes(handles.axes1)
                            plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                            title('Raw spectra');
                            xlabel('Wavenumber (cm^-^1)');
                            ylabel('Abs. int.');
                            xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                            legend (handles.uitable1.ColumnName(2:end,1));
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
                sizedatatable = size(handles.uitable1.Data);
                zerotoplot = (zeros(1,sizedatatable(1,1)))';
                figure(1)
                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end),...
                    handles.uitable1.Data(:,1),zerotoplot)
                
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
                        bcdata = handles.uitable1.Data;
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
                    dataformsbackadj = handles.uitable1.Data;
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
                            pp1(:,m) = polyval(p1,handles.uitable1.Data(:,1));
                            newy1(:,m) = handles.uitable1.Data(:,m+1)-pp1(:,m);
                            %% fit2 polyfit
                            x2 = fileforreg(:,1);
                            y2 = fileforreg(:,m+1);
                            p2 = polyfit(x2,y2,polyfitvalue);
                            pp2(:,m) = polyval(p2,handles.uitable1.Data(:,1));
                            newy2(:,m) = handles.uitable1.Data(:,m+1)-pp2(:,m);
                            %% fit 3
                            x3 = dataformsbackadj(:,1);
                            y3 = dataformsbackadj(:,m+1);
                            newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                        end
                        newy3 = flipud(newy3);
                        
                        figure(2)
                        subplot(2,1,1)
                        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end),...
                            handles.uitable1.Data(:,1),pp1);
                        title ('Spectra before baseline correction and the linear regressed baseline');
                        legend (handles.uitable1.ColumnName(2:end,1));
                        subplot(2,1,2)
                        plot(handles.uitable1.Data(:,1),newy1,handles.uitable1.Data(:,1),zerotoplot);
                        title ('Spectra after linear baseline correction');
                        legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                        
                        figure(3)
                        subplot(2,1,1)
                        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end),...
                            handles.uitable1.Data(:,1),pp2);
                        title ('Spectra before baseline correction and the polynomial regressed baseline');
                        legend ([handles.uitable1.ColumnName(2:end,1);handles.uitable1.ColumnName(2:end,1)]);
                        subplot(2,1,2)
                        plot(handles.uitable1.Data(:,1),newy2,handles.uitable1.Data(:,1),zerotoplot);
                        title ('Spectra after polynomial baseline correction');
                        legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                        
                        figure(4)
                        subplot(2,1,1)
                        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end));
                        title ('Spectra before baseline correction');
                        legend (handles.uitable1.ColumnName(2:end,1));
                        subplot(2,1,2)
                        plot(handles.uitable1.Data(:,1),newy3,handles.uitable1.Data(:,1),zerotoplot);
                        title ('Spectra after Matlab function baseline correction');
                        legend([handles.uitable1.ColumnName(2:end,1);'Zero line']);
                        
                        figure(5)
                        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2),...
                            handles.uitable1.Data(:,1),newy1(:,1),...
                            handles.uitable1.Data(:,1),newy2(:,1),handles.uitable1.Data(:,1),newy3(:,1),...
                            handles.uitable1.Data(:,1),zerotoplot);
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
                                handles.uitable1.Data(:,2:end) = newy1;
                                
                                axes(handles.axes1)
                                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                legend (handles.uitable1.ColumnName(2:end,1));
                                
                            case 2
                                set(handles.uitable1,'Data',[handles.uitable1.Data(:,1),newy2]);
                                
                                axes(handles.axes1)
                                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                legend (handles.uitable1.ColumnName(2:end,1));
                                
                            case 3
                                set(handles.uitable1,'Data',[handles.uitable1.Data(:,1),newy3]);
                                
                                axes(handles.axes1)
                                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                legend (handles.uitable1.ColumnName(2:end,1));
                        end
                    end
                    
                end
            end
        end
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function reference_database_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to reference_database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filenames11,pathname11] = uigetfile({'*.txt','text files';'*.dpt','dpt files';...
    '*.m','Matlab files';'*.*','All files'},'Load file');
if isequal([filenames11,pathname11] , [0,0])
    return
else
    handles.fnstructure = importdata(fullfile (pathname11,filenames11));
    handles.allrefspec = handles.fnstructure.data;
    
    handles.ColumnName = char(handles.fnstructure.textdata);
    handles.legend = (handles.fnstructure.textdata(:,2:end))';
    
    %     set (handles.uitable2,'Data',handles.allrefspec,'ColumnName',handles.ColumnName);
    set (handles.popupmenu1,'String',handles.ColumnName(2:end,:));
    
end

guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

handles.spectrum = handles.allrefspec(:,handles.popupmenu1.Value+1);

time1 = [];

coeffs_linear_all = [];
% coeffs_linear2_all = [];
% coeffs_nonlinear_all = [];


for i = 1:handles.size_filenames1(1,2)
    time1 = [time1,str2double(handles.spectrumtime.String)*i];
    coeffs_linear = lsqlin (handles.spectrum,handles.uitable1.Data(:,i+1));
    coeffs_linear_all = [coeffs_linear_all,coeffs_linear];
end

handles.time1 = time1;
handles.coeffs_linear_all = coeffs_linear_all;
x = linspace(0,handles.time1(1,handles.size_filenames1(1,2)) ,100);

switch handles.linexp.Value
    
    case 1
        P = polyfit (handles.time1',handles.coeffs_linear_all',1);
        y = handles.coeffs_linear_all;
        
        handles.a = P(1,1);
        handles.b = P(1,2);
        
        %         x = linspace(0,handles.time1(1,handles.size_filenames1(1,2)) ,100);
        y_fit0 = polyval(P,handles.time1);
        handles.y_fit02 = P(1,2)+handles.time1(1,1)*P(1,1);
        y_fit = polyval(P,x);
        
        % Compute the residual values as a vector of signed numbers
        
        yresid = y - y_fit0;
        
        % Square the residuals and total them to obtain the residual sum of squares
        SSresid = sum(yresid.^2);
        
        % Compute the total sum of squares of y by multiplying the variance of y by the number of observations minus 1
        SStotal = (length(y)-1) * var(y);
        
        % Compute R2 using the formula given in the introduction of this topic:
        rsq = 1 - (SSresid/SStotal);
        rsq_adj = 1 - SSresid/SStotal * (length(y)-1)/(length(y)-length(P));
        
        handles.fitting_info.String = {'f(x) = a*x + b';...
            strcat('a =',' ',num2str(P(1,1)));...
            strcat('b =',' ',num2str(P(1,2)));
            strcat('rsquare =',' ',num2str(rsq));...
            strcat('adjrsquare =',' ',num2str(rsq_adj));...
            strcat('residual sum of squares =',' ',num2str(SStotal))};
        
    case 2
        [f,gof] = fit (handles.time1',handles.coeffs_linear_all','exp1');
        handles.a = f.a;
        handles.b = f.b;
        handles.fitting_info.String = {'f(x) = a * exp(b*x)';...
            strcat('a =',' ',num2str(f.a));...
            strcat('b =',' ',num2str(f.b));
            strcat('sse =',' ',num2str(gof.sse));...
            strcat('rsquare =',' ',num2str(gof.rsquare));...
            strcat('dfe =',' ',num2str(gof.dfe));...
            strcat('adjrsquare =',' ',num2str(gof.adjrsquare));...
            strcat('rmse =',' ',num2str(gof.rmse))};
        
        %         x = linspace(0,handles.time1(1,handles.size_filenames1(1,2)) ,100);
        
        y_fit = f.a * exp(f.b*x);
        
    case 3
        x1 = handles.time1'; %// Define numbers here - either row or column vectors
        y = handles.coeffs_linear_all';
        M = [ones(numel(x1),1), x1(:)]; %// Ensure x is a column vector
        lny = log(y(:)); %// Ensure y is a column vector and take ln
        
        X = M \ lny; %// Solve for parameters
        A = exp(X(1)); %// Solve for A
        b = X(2); %// Get b
        
        handles.a = A;
        handles.b = b;
        
        %         x = linspace(min(x), max(x));
        y_fit = A*exp(b*x);
        
        handles.fitting_info.String = {'f(x) = a * exp(b*x)';...
            strcat('a =',' ',num2str(A));...
            strcat('b =',' ',num2str(b))};
        
end

axes(handles.axes2)
plot(time1,handles.coeffs_linear_all,'o',...
    x,y_fit);
title ('pressures as a function of time');
legend('Pressures','expontial fitting');
xlabel('time (s)');
ylabel('Coefficients');

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



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double
ftime1 = str2double(handles.time.String);

switch handles.linexp.Value
    case 1
        fpressure = handles.b + handles.a*ftime1;
        
        handles.calculatedpressure.String = num2str(fpressure);
        
        lostpressure = handles.b - fpressure;
        
        handles.lostpressure.String = num2str (lostpressure);
        
    case 2
        fpressure = handles.a * exp(handles.b*ftime1);
        
        handles.calculatedpressure.String = num2str(fpressure);
        
        lostpressure = handles.a - fpressure;
        
        handles.lostpressure.String = num2str (lostpressure);
        
    case 3
        fpressure = handles.a * exp(handles.b*ftime1);
        
        handles.calculatedpressure.String = num2str(fpressure);
        
        lostpressure = handles.a - fpressure;
        
        handles.lostpressure.String = num2str (lostpressure);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in linexp.
function linexp_Callback(hObject, eventdata, handles)
% hObject    handle to linexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns linexp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from linexp


% --- Executes during object creation, after setting all properties.
function linexp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_savecoeffs.
function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_savecoeffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileforsave,pathforsave] =...
    uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
    '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
    '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
    'Save file name','Time and Coefficients');

if isequal([fileforsave,pathforsave] ,[0,0])
    return
else
    
    time_coeff = [handles.time1',handles.coeffs_linear_all'];
    time_coeff_cell = num2cell (time_coeff);
    finalstringfile = [{'Time','Coefficient'};time_coeff_cell];
    filename = fullfile(pathforsave,fileforsave);
    cell2csv(filename,finalstringfile);
    
end

guidata(hObject, handles);
