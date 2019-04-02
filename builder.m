function varargout = builder(varargin)
% BUILDER MATLAB code for builder.fig
%      BUILDER, by itself, creates a new BUILDER or raises the existing
%      singleton*.
%
%      H = BUILDER returns the handle to a new BUILDER or the handle to
%      the existing singleton*.
%
%      BUILDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BUILDER.M with the given input arguments.
%
%      BUILDER('Property','Value',...) creates a new BUILDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before builder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to builder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help builder

% Last Modified by GUIDE v2.5 11-Jul-2016 11:53:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @builder_OpeningFcn, ...
                   'gui_OutputFcn',  @builder_OutputFcn, ...
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


% --- Executes just before builder is made visible.
function builder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to builder (see VARARGIN)

% Choose default command line output for builder
handles.output = hObject;

handles.counter1 = 0;
handles.counter2 = 0;
handles.counter3 = 0;

%%
all_gcf = findall(gcf);
% Turning off unnecessary bottons
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
set(FileOpen_callback, 'ClickedCallback',@(hObject,eventdata)builder('myopen_ClickedCallback',hObject,eventdata,guidata(hObject)));

Savefigure_callback = findall(myToolbar,'tag','Standard.SaveFigure');
set(Savefigure_callback, 'ClickedCallback','Save Figure','TooltipString','Save as');
set(Savefigure_callback, 'ClickedCallback',@(hObject,eventdata)builder('mysave_ClickedCallback',hObject,eventdata,guidata(hObject)));
%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes builder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = builder_OutputFcn(hObject, eventdata, handles) 
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

if ((isempty(handles.edit_nolaser.String) || str2double (handles.edit_nolaser.String) == 0) && ...
        (isempty(handles.edit_laseron.String) || str2double (handles.edit_laseron.String) == 0) && ...
        (isempty(handles.edit_laseroff.String) || str2double (handles.edit_laseroff.String) == 0))
    uiwait(errordlg('You should at least indentify the number of files for one of the parts'));
    
    else
        handles.counter3 = handles.counter3 + 1;
        
        [filenames1,pathname1] = uigetfile({'*.txt','text files';'*.dpt','dpt files';'*.m','Matlab files';'*.*','All files'},'Load files','MultiSelect','on');
        if isequal([filenames1,pathname1] , [0,0])
            return
        else
            cd (pathname1);
            
            wavenumber = importdata(char(fullfile(pathname1,filenames1(:,1))));
            wavenumber = wavenumber(:,1);
            wavenumber = sortrows(wavenumber,-1);
            min1 = min(wavenumber(:,1));
            max1 = max(wavenumber(:,1));
            if min1 < 700
                index1 = find (wavenumber(:,1) < 700 );
                size_index1 = size(index1);
                wavenumber(index1(1,1):index1(size_index1(1,1),1),:) = [];
            end
            if max1 > 3999.74
                index2 = find (wavenumber(:,1) > 3999.74 );
                size_index2 = size(index2);
                wavenumber(index2(1,1):index2(size_index2(1,1),1),:) = [];
            end
            
            length1 = size(wavenumber);
            length1 = length1(1,1);
            size_filenames1 = size(filenames1);
            spectra = spalloc(length1,size_filenames1(1,2),1);
            
            for i = 1:size_filenames1(1,2)
                xy = importdata(char(fullfile(pathname1,filenames1(:,i))));
                xy = sortrows(xy,-1);
                min1 = min(xy(:,1));
                max1 = max(xy(:,1));
                
                if min1 < 700
                index1 = find (xy(:,1) < 700 );
                size_index1 = size(index1);
                xy(index1(1,1):index1(size_index1(1,1),1),:) = [];
                end
                if max1 > 3999.74
                index2 = find (xy(:,1) > 3999.74 );
                size_index2 = size(index2);
                xy(index2(1,1):index2(size_index2(1,1),1),:) = [];
                end                

                spectra(:,i) = xy(:,2);
            end
            
            handles.all = [wavenumber,spectra];
%             handles.all = sortrows(handles.all,-1);
            
%             handles.min1 = min(handles.all(:,1));
%             handles.max1 = max(handles.all(:,1));
%             if handles.min1 < 700
%                 index1 = find (handles.all(:,1) < 700 );
%                 size_index1 = size(index1);
%                 handles.all (index1(1,1):index1(size_index1(1,1),1),:) = [];
%             end
%             if handles.max1 > 3999.74
%                 index2 = find (handles.all(:,1) > 3999.74 );
%                 size_index2 = size(index2);
%                 handles.all (index2(1,1):index2(size_index2(1,1),1),:) = [];
%             end
            
            handles.min1 = min(handles.all(:,1));
            handles.max1 = max(handles.all(:,1));
            
            if (isempty(handles.edit_nolaser.String) || str2double (handles.edit_nolaser.String) == 0)
                nolaser = [];
            else
                nolaser = cell (1,str2double(handles.edit_nolaser.String)); 
                for i = 1:str2double(handles.edit_nolaser.String)
                    nolaser{i} = strcat('nolaser',num2str(i));
                end
            end
            
            
            if (isempty(handles.edit_laseron.String) || str2double (handles.edit_laseron.String) == 0)
                laseron = [];
            else
                laseron = cell (1,str2double(handles.edit_laseron.String));  
                for i = 1:str2double(handles.edit_laseron.String)
                    laseron{i} = strcat('laseron',num2str(i));
                end
            end
            
            
            if (isempty(handles.edit_laseroff.String) || str2double (handles.edit_laseroff.String) == 0)
                laseroff = [];
            else
                laseroff = cell (1,str2double(handles.edit_laseroff.String));  
                for i = 1:str2double(handles.edit_laseroff.String)
                    laseroff{i} = strcat('laseroff',num2str(i));
                end
            end
            
            column_names = ['Wavenumber(cm-1)',nolaser,laseron,laseroff];
            
            handles.uitable1.Data = handles.all;
            handles.uitable1.ColumnName = column_names;
            handles.size_uitable1 = size(handles.uitable1.Data);
            set(handles.uitable1,'ColumnEditable',true(1,handles.size_uitable1(1,2)));
            
            axes(handles.axes1)
            plot(handles.all(:,1),handles.all(:,2:end));
            title ('Refspec subtraction');
            xlabel('Wavenumber(cm^-^1)');
            ylabel('Abs. int.');
            xlim([handles.min1 handles.max1]);
            legend(handles.uitable1.ColumnName(2:end,1));
        end
        

end
% assignin ('base','handles',handles);

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



function edit_nolaser_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nolaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nolaser as text
%        str2double(get(hObject,'String')) returns contents of edit_nolaser as a double


% --- Executes during object creation, after setting all properties.
function edit_nolaser_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nolaser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_laseron_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laseron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laseron as text
%        str2double(get(hObject,'String')) returns contents of edit_laseron as a double

handles.counter1 = handles.counter1 + 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_laseron_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laseron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_laseroff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laseroff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laseroff as text
%        str2double(get(hObject,'String')) returns contents of edit_laseroff as a double

handles.counter2 = handles.counter2 + 1;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_laseroff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laseroff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function baselinecorrection_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to mysavefigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter3 == 0
    errordlg('You should first load files');
else
    minmax1 = inputdlg({'Minimum of wavenumber to look for baseline correction:','Maximum of wavenumber to look for baseline correction:'},'Baseline correction');
    if isequal(minmax1 , {})
        return
    else
        min1 = str2double(minmax1{1,1});
        max1 = str2double(minmax1{2,1});
        index1 = find(handles.uitable1.Data(:,1)> min1 & handles.uitable1.Data(:,1)< max1);
        sizeindex1 = size(index1);
        
%         handles.size_uitable1 = size(handles.uitable1.Data);
        offsets = sparse(1,handles.size_uitable1(1,2)-1);
        for k = 1:handles.size_uitable1(1,2)-1
            meandata = mean(handles.uitable1.Data(index1(sizeindex1(1,2),1):index1(sizeindex1(1,1),1),k+1));
            handles.uitable1.Data(:,k+1) = handles.uitable1.Data(:,k+1)- meandata;
            offsets(1,k) = meandata;
        end
        %         handles.uitable1.Data = handles.uitable1.Data;
        
        axes(handles.axes1)
        plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end));
        title ('Refspec subtraction');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim([handles.min1 handles.max1]);
        legend(handles.uitable1.ColumnName(2:end,1));
    end
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function baselinecorrection2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to baselinecorrection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter3 == 0
    errordlg('You should first load files');
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
                    sizedatatable = size(handles.uitable1.Data);
                    zerotoplot = (sparse(1,sizedatatable(1,1)))';
                    j = sizedatatable(1,1);
                    zero1 = sparse(1,sizedatatable(1,2));
                    
                    waitbar1 = waitbar(0,'Please wait...');
                    i = 1;
                    fileforreg = [];
                    while i < split1*2+1
                        bcdata = handles.uitable1.Data;
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
                    dataformsbackadj = handles.uitable1.Data;
                    dataformsbackadj = sortrows(dataformsbackadj);
                    
                    check = 'runn';
                    while strcmp(check,'runn')
                        %%
                        pp1 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                        newy1 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                        
                        pp2 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                        newy2 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                        
                        newy3 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                        
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
%                             x3 = dataformsbackadj(:,1);
%                             y3 = dataformsbackadj(:,m+1);
%                             newy3(:,m) = msbackadj(x3,y3,'RegressionMethod','spline','SmoothMethod', 'rlowess');
                        end
%                         newy3 = flipud(newy3);
                        
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
                        legend(handles.uitable1.ColumnName(2:end,1));
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
                                legend(handles.uitable1.ColumnName(2:end,1));
                                
                            case 2
                                handles.uitable1.Data(:,2:end) = newy2;
                                
                                axes(handles.axes1)
                                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                legend(handles.uitable1.ColumnName(2:end,1));
                                
                            case 3
                                handles.uitable1.Data(:,2:end) = newy3;
                                
                                axes(handles.axes1)
                                plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                title('Raw spectra');
                                xlabel('Wavenumber (cm^-^1)');
                                ylabel('Abs. int.');
                                xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                legend(handles.uitable1.ColumnName(2:end,1));
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
                    zerotoplot = (sparse(1,sizedatatable(1,1)))';
                    
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
                        zero1 = sparse(1,sizedatatable(1,2));
                        
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
                            pp1 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                            newy1 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                            
                            pp2 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                            newy2 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                            
                            newy3 = sparse(sizedatatable(1,1),sizedatatable(1,2)-1);
                            
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
                            legend(handles.uitable1.ColumnName(2:end,1));
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
                                    legend(handles.uitable1.ColumnName(2:end,1));
                                    
                                case 2
                                    handles.uitable1.Data(:,2:end) = newy2;
                                    
                                    axes(handles.axes1)
                                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                    title('Raw spectra');
                                    xlabel('Wavenumber (cm^-^1)');
                                    ylabel('Abs. int.');
                                    xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                    legend(handles.uitable1.ColumnName(2:end,1));
                                    
                                case 3
                                    handles.uitable1.Data(:,2:end) = newy3;
                                    
                                    axes(handles.axes1)
                                    plot(handles.uitable1.Data(:,1),handles.uitable1.Data(:,2:end))
                                    title('Raw spectra');
                                    xlabel('Wavenumber (cm^-^1)');
                                    ylabel('Abs. int.');
                                    xlim ([min(handles.uitable1.Data(:,1)) max(handles.uitable1.Data(:,1))]);
                                    legend(handles.uitable1.ColumnName(2:end,1));
                            end
                        end
                        
                    end
                end
            end
        end
    end
end

guidata(hObject, handles);


% --- Executes on button press in pb_savecoeffs.
function mysave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_savecoeffs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileforsave,pathforsave] =...
    uiputfile({'*.txt','txt-file (*.txt)';'*.csv','csv-file (*.csv)';...
                '*.dpt','dpt-file (*.dpt)';'*.dat','dpt-file (*.dat)';...
                '*.m','MATLAB Code (*.m)';'*.mat','MATLAB Data(*.mat)';'*.*','All files (*.*)'},...
                'Save file name','baseline corrected allfinal text file');

if isequal([fileforsave,pathforsave] ,[0,0])
    return
else
    handles.fnname = fullfile (pathforsave,fileforsave);

    datacell = num2cell (handles.uitable1.Data);

    all = [(cellstr(handles.uitable1.ColumnName))';datacell];
    
    filename = fullfile(pathforsave,fileforsave);

    cell2csv(filename,all);
     
end

guidata(hObject, handles);
