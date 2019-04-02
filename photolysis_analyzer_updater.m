function [ handles ] = photolysis_analyzer_updater( handles, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

opt.update1 = 0;
opt.update2 = 0;
opt.update3 = 0;
opt.update4 = 0;
opt.update5 = 0;
opt.setlinnonlin = 0;
% opt.allandsumofrefsubtracted = 0;

opt.plot1 = 0;
opt.plot2 = 0;
opt.plot3 = 0;

opt.fig1 = 0;
opt.numofspec = 0;

opt.pbauto = 0;

[opt] = f_OptSet(opt, varargin);

%% saving the subtracted spectra into specific file
if opt.update1
    
    j = handles.popupmenu2.Value - 1;
    
    if handles.popupmenu1.Value > 1
        
        k = handles.popupmenu1.Value - 1;
        
        handles.sumofscaledrefspec.(strcat('section',num2str(j)))(:,k) = ...
            (handles.refspec1 * handles.scale1)+(handles.refspec2 * handles.scale2)+...
            (handles.refspec3 * handles.scale3)+(handles.refspec4 * handles.scale4)+...
            (handles.refspec5 * handles.scale5)+(handles.refspec6 * handles.scale6)+...
            (handles.refspec7 * handles.scale7)+(handles.refspec8 * handles.scale8)+...
            (handles.refspec9 * handles.scale9)+(handles.refspec10 * handles.scale10)+...
            (handles.refspec11 * handles.scale11)+(handles.refspec12 * handles.scale12)+...
            (handles.refspec13 * handles.scale13)+(handles.refspec14 * handles.scale14)+...
            (handles.refspec15 * handles.scale15)+(handles.refspec16 * handles.scale16)+...
            (handles.refspec17 * handles.scale17)+(handles.refspec18 * handles.scale18);
        
        handles.allrefsubtracted.(strcat('section',num2str(j)))(:,k) = ...
            handles.laserspectra - handles.sumofscaledrefspec.(strcat('section',num2str(j)))(:,k);
        
    else
        for k = 1:handles.size_uitable2(1,2) - 1
            for i = 1:18
                handles.(strcat('scale',num2str(i),num2str(i),num2str(i))) = ...
                    handles.uitable4_Data.(strcat('section',num2str(j)))(k,i);%handles.(strcat('spectra',num2str(k))).(strcat('scale',num2str(i))).(strcat('section',num2str(j)));
                handles.(strcat('refspec',num2str(i),num2str(i),num2str(i))) = ...
                    handles.(strcat('refspec',num2str(i)));%,'_sectioned')).(strcat('section',num2str(j)));
            end
            
            handles.sumofscaledrefspec.(strcat('section',num2str(j)))(:,k) = ...
                (handles.refspec111 * handles.scale111) + (handles.refspec222 * handles.scale222)+...
                (handles.refspec333 * handles.scale333) + (handles.refspec444 * handles.scale444)+...
                (handles.refspec555 * handles.scale555) + (handles.refspec666 * handles.scale666)+...
                (handles.refspec777 * handles.scale777) + (handles.refspec888 * handles.scale888)+...
                (handles.refspec999 * handles.scale999) + (handles.refspec101010 * handles.scale101010)+...
                (handles.refspec111111 * handles.scale111111) + (handles.refspec121212 * handles.scale121212)+...
                (handles.refspec131313 * handles.scale131313) + (handles.refspec141414 * handles.scale141414)+...
                (handles.refspec111111 * handles.scale151515) + (handles.refspec161616 * handles.scale161616)+...
                (handles.refspec111111 * handles.scale171717) + (handles.refspec181818 * handles.scale181818);
            
            handles.allrefsubtracted.(strcat('section',num2str(j)))(:,k) = ...
                handles.laserspectra(:,k) - handles.sumofscaledrefspec.(strcat('section',num2str(j)))(:,k);
        end
        
    end
end

%% defining spetra and scale (just for case popupmenue.Value is bigger than 1)
if opt.update2
    
    k = handles.popupmenu1.Value-1;
    j = handles.popupmenu2.Value - 1;
    handles.uitable4_Data.(strcat('section',num2str(j))) = handles.uitable4.Data;
    for i = 1:18
        handles.(strcat('scale',num2str(i))) = handles.uitable4_Data.(strcat('section',num2str(j)))(k,i);
        if ~isempty(handles.(strcat('editt',num2str(i))).String)
            handles.(strcat('edit',num2str(i))).String = num2str(handles.(strcat('scale',num2str(i))));
        end
    end
end

%% finding refsubtracted data for one specific scale and reference just for opoupmenu.Value bigger than 1
if opt.update3
    
    j = handles.popupmenu2.Value - 1;
    k = handles.popupmenu1.Value - 1;

    handles.(strcat('scale',num2str(opt.update3))) = str2double(handles.(strcat('edit',num2str(opt.update3))).String);
    handles.uitable4_Data.(strcat('section',num2str(j)))(k,opt.update3) = handles.(strcat('scale',num2str(opt.update3)));
    handles.uitable4.Data(k,opt.update3) = handles.(strcat('scale',num2str(opt.update3)));

    handles.laserspectra = handles.uitable2.Data(:,handles.popupmenu1.Value);
    
    handles.refsubtracted = handles.laserspectra - (handles.(strcat('refspec',num2str(opt.update3)))*...
        handles.(strcat('scale',num2str(opt.update3))));
end
%%
if opt.update4
    if isempty (handles.(strcat('editt',num2str(opt.update4))).String)
        handles.(strcat('counter_edit',num2str(opt.update4),num2str(opt.update4))) = 0;
        
        size_refspec = size(handles.uitable3.Data);
        zero_refspec = zeros(size_refspec(1,1),1);
        handles.(strcat('refspec',num2str(opt.update4))) = zero_refspec;
        handles.(strcat('chk',num2str(opt.update4))).String = [];
        handles.(strcat('chk',num2str(opt.update4))).Value = 0;
        handles.uitable4.ColumnName(opt.update4,1) = {''};
    else
        [index_x,index_y] = find(strcmpi(handles.uitable3.ColumnName,...
            strtrim(handles.(strcat('editt',num2str(opt.update4))).String)));
        if isempty([index_x,index_y])
            errordlg('Refrence spectra could not be found');
        else
            handles.(strcat('counter_edit',num2str(opt.update4),num2str(opt.update4))) = ...
                handles.(strcat('counter_edit',num2str(opt.update4),num2str(opt.update4))) + 1;
            
            handles.(strcat('refspec',num2str(opt.update4))) = handles.uitable3.Data(:,index_x);
            handles.(strcat('chk',num2str(opt.update4))).String = ...
                handles.(strcat('editt',num2str(opt.update4))).String;
            handles.(strcat('chk',num2str(opt.update4))).Value = 1;
            
            handles.uitable4.ColumnName(opt.update4,1) = cellstr(handles.(strcat('editt',num2str(opt.update4))).String);
            
        end
    end
end

%% setting linear and nonlinear scales 
if opt.setlinnonlin 
    
    numofloop = handles.size_uitable2(1,2) - 1;
    j = handles.popupmenu2.Value - 1;
    %% setting the scales into the uitable4
    if handles.popupmenu1.Value > 1
        for i = 1:18            
            switch opt.setlinnonlin
                case 1
                    l = (i*2)-1;
                case 2
                    l = i*2;
            end
            
            handles.uitable4.ColumnName{i} = handles.(strcat('editt',num2str(i))).String;
            
            if handles.(strcat('chk',num2str(i))).Value == 1
                k = handles.popupmenu1.Value - 1;
                handles.uitable4_Data.(strcat('section',num2str(j)))(k,i) = handles.uitable1.Data(k,l);
            end
        end
        handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j)));
    else
        for i = 1:18            
            switch opt.setlinnonlin
                case 1
                    l = (i*2)-1;
                case 2
                    l = i*2;
            end
            
            handles.uitable4.ColumnName{i} = handles.(strcat('editt',num2str(i))).String;
            
            if handles.(strcat('chk',num2str(i))).Value == 1
                for k = 1:numofloop
                    handles.uitable4_Data.(strcat('section',num2str(j)))(k,i) = handles.uitable1.Data(k,l);
                end
            end
        end
        handles.uitable4.Data = handles.uitable4_Data.(strcat('section',num2str(j))); 
    end 
end

%% Ploting axes1
if opt.plot1
    
    if handles.popupmenu1.Value == 1
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
    else
        x = handles.popupmenu1.Value - 1;
        axes(handles.axes1)
        plot(x,handles.uitable4.Data(x,:),'o')
        legend(handles.uitable4.ColumnName)
    end
    
end
%% ploting axes2
if opt.plot2
    
    j = handles.popupmenu2.Value - 1;
    
    if handles.popupmenu1.Value == 1
        axes(handles.axes2)
        plot(handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j))))
        title ('All refspec subtracted');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend(handles.popupmenu1.String(2:end,1));
        %xlim ([handles.min1 handles.max1]);
    else
        nameoffile = handles.popupmenu1.String(handles.popupmenu1.Value,1);
        k = handles.popupmenu1.Value - 1;
        legend1 = strcat('Photolyzed spectrum',' of',{' '},nameoffile);
        legend2 = strcat('Scaled',{' '},handles.(strcat('editt',num2str(opt.plot2))).String);
        legend3 = strcat('Subtracting',' scaled',{' '},handles.(strcat('editt',num2str(opt.plot2))).String);
        
        axes(handles.axes2)
        plot(handles.x1,handles.laserspectra,handles.x1,...
            handles.(strcat('refspec',num2str(opt.plot2)))*handles.(strcat('scale',num2str(opt.plot2))),...
            handles.x1,handles.allrefsubtracted.(strcat('section',num2str(j)))(:,k))%handles.refsubtracted
        title ('Refspec subtraction');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim (handles.xlim1);
        ylim (handles.ylim1);
        %xlim ([handles.min1 handles.max1]);
        legend([legend1,legend2,legend3]);
    end
end
%% plotting axes3
if opt.plot3
    
    j = handles.popupmenu2.Value - 1;
    k = handles.popupmenu1.Value - 1;
    
    if handles.popupmenu1.Value == 1
        
        axes(handles.axes3)
        plot(handles.x1,handles.laserspectra,handles.x1,handles.sumofscaledrefspec.(strcat('section',num2str(j))))
        title ('Average of photolysed spectra and sum of scaled reference spectra');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        %xlim ([handles.min1 handles.max1]);
        legend(handles.popupmenu1.String(2:end,1),handles.popupmenu1.String(2:end,1));
    else
        nameoffile = handles.popupmenu1.String(k+1,1);
        legend1 = strcat('Photolyzed spectrum',' of',{' '},nameoffile);
        legend2 = strcat('Sum of scaled reference spectra',' for',{' '},nameoffile);
        axes(handles.axes3)
        plot(handles.x1,handles.laserspectra,handles.x1,handles.sumofscaledrefspec.(strcat('section',num2str(j)))(:,k))
        title ('Photolysed spectra and sum of scaled reference spectra');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        xlim (handles.xlim1);
        ylim (handles.ylim1);
%         xlim ([handles.min1 handles.max1]);
        legend([legend1,legend2]);
    end
end

%% ploting figure 1

if opt.fig1
    
    y1 = handles.(strcat('refspec',num2str(opt.numofspec)));
    
    nameoffile = handles.popupmenu1.String(handles.popupmenu1.Value,1);
    legend1 = strcat('Photolyzed spectrum',' of',{' '},nameoffile);
    legend2 = strcat(handles.(strcat('editt',num2str(opt.numofspec))).String,{' '},'reference spectra');
    
    figure(1)
    plot (handles.x1,handles.laserspectra,handles.x1,y1);
    title ('Choose the wavenumber region at which scaling has to be done and then close the figure','FontSize', 10);
    xlabel('Wavenumber(cm^-^1)');
    ylabel('Abs. int.');
    xlim ([handles.min1 handles.max1]);
    legend([legend1,legend2]);
    uiwait(figure(1))
    
end
%%
if opt.pbauto
    
    x1 = handles.x1;
    handles.y1 = handles.laserspectra;
    handles.minmax = inputdlg({'Minimum','Maximum'},'Min and Max');
    
    
    if ~isempty (handles.minmax)
        
        [scale1,scale2,scale3,data_avephotolysis,data_forsclaingrefspec,newydata1,newydata2] = ...
            newxy(handles.minmax,handles.x1,handles.y1,handles.(strcat('refspec',num2str(opt.pbauto))));
        
        figure(2);
        subplot(3,2,1);
        plot(data_avephotolysis(:,1), data_avephotolysis(:,2), data_forsclaingrefspec(:,1), scale1*newydata2);
        title('check fitting by scale obtained from integration');
        legend('Photolyzed molecule', 'ref spec');
        ylim1=get(gca,'ylim');
        xlim1=get(gca,'xlim');
        text(xlim1(1),ylim1(2)-(ylim1(2)/2),strcat('scale1 is: ',num2str(scale1)));
        subplot(3,2,3);
        plot(data_avephotolysis(:,1), newydata1, data_forsclaingrefspec(:,1), scale2*newydata2);
        title('check fitting by scale obtained from points fitting');
        legend('Photolyzed molecule','ref spec');
        ylim2=get(gca,'ylim');
        xlim2=get(gca,'xlim');
        text(xlim2(1),ylim2(2)-(ylim2(2)/2),strcat('scale2 is: ' ,num2str(scale2)));
        subplot(3,2,5);
        plot(data_avephotolysis(:,1), data_avephotolysis(:,2), data_forsclaingrefspec(:,1), scale3*data_forsclaingrefspec(:,2));
        title('check fitting by scale obtained from points fitting without baseline shifting');
        legend('Photolyzed molecule','ref spec');
        ylim3=get(gca,'ylim');
        xlim3=get(gca,'xlim');
        text(xlim3(1),ylim3(2)-(ylim3(2)/2),strcat('scale is3: ' ,num2str(scale3)));
        subplot(3,2,2);
        plot(handles.x1, handles.y1, x1, scale1*handles.(strcat('refspec',num2str(opt.pbauto))));
        title('check fitting by scale obtained from integration');
        legend('Photolyzed molecule','ref spec');
        subplot(3,2,4);
        plot(handles.x1, handles.y1, x1, scale2*handles.(strcat('refspec',num2str(opt.pbauto))));
        title('check fitting by scale obtained from points fitting');
        legend('Photolyzed molecule','ref spec');
        subplot(3,2,6);
        plot(handles.x1, handles.y1, x1, scale3*handles.(strcat('refspec',num2str(opt.pbauto))));
        title('check fitting by scale obtained from points fitting without baseline shifting');
        legend('Photolyzed molecule','ref spec');
        
        figure(3);
        subplot(2,2,1);
        plot (handles.x1,handles.y1-(scale1*handles.(strcat('refspec',num2str(opt.pbauto)))));
        title('Photolyzed molecule after ref spec subtraction by looking at integration');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        ylim1=get(gca,'ylim');
        xlim1=get(gca,'xlim');
        text(xlim1(1),ylim1(2)-(ylim1(2)/2),strcat('scale1 is:  ' ,num2str(scale1)));
        subplot(2,2,2);
        plot (handles.x1,handles.y1-(scale2*handles.(strcat('refspec',num2str(opt.pbauto)))));
        title('Photolyzed molecule after ref spec subtraction by fitting data points');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        ylim2=get(gca,'ylim');
        xlim2=get(gca,'xlim');
        text(xlim2(1),ylim2(2)-(ylim2(2)/2),strcat('scale2 is: ' ,num2str(scale2)));
        subplot(2,2,3);
        plot (handles.x1,handles.y1-(scale3*handles.(strcat('refspec',num2str(opt.pbauto)))));
        title('Photolyzed molecule after ref spec subtraction by fitting data points and baseline correction');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        ylim3=get(gca,'ylim');
        xlim3=get(gca,'xlim');
        text(xlim3(1),ylim3(2)-(ylim3(2)/2),strcat('scale is3: ' ,num2str(scale3)));
        subplot(2,2,4);
        plot (handles.x1,handles.y1-(scale1*handles.(strcat('refspec',num2str(opt.pbauto)))),handles.x1,handles.y1-(scale2*handles.(strcat('refspec',num2str(opt.pbauto)))),handles.x1,handles.y1-(scale3*handles.(strcat('refspec',num2str(opt.pbauto)))));
        title('Photolyzed molecule after ref spec subtraction');
        xlabel('Wavenumber(cm^-^1)');
        ylabel('Abs. int.');
        legend('subtracted with scale1','subtracted with scale2','subtracted with scale3');
        %%
        numofscale = menu('Please choose the coefficient for reference subtraction',...
            '1.scale1-coeff from integration','2.scale2-from fitting and baseline correction',...
            '3.scale3-from fitting without baeline correction','average of option 1 and 2',...
            'average of option 1 and 3','average of option 2 and 3','average of all 3');
        
        if (~isempty(numofscale) && numofscale ~=0)
            
            switch numofscale
                case 1
                    finalscale1 = scale1;
                case 2
                    finalscale1 = scale2;
                case 3
                    finalscale1 = scale3;
                case 4
                    finalscale1 = (scale1+scale2)/2;
                case 5
                    finalscale1 = (scale1+scale3)/2;
                case 6
                    finalscale1 = (scale2+scale3)/2;
                case 7
                    finalscale1 = (scale1+scale2+scale3)/3;
            end
            
            handles.(strcat('edit',num2str(opt.pbauto))).String = finalscale1;
            
            handles.(strcat('scale',num2str(opt.pbauto))) = finalscale1;

            handles.refsubtracted = handles.laserspectra - (handles.(strcat('refspec',num2str(opt.pbauto)))*...
                handles.(strcat('scale',num2str(opt.pbauto))));
        end
    end
end