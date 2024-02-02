%function [expDes, const] = plottt(const,expDes)

% clear all; close all; clc;
%addpath(genpath('~/Documents/GitHub/motion_ecc/Data/%s',const.subjID))
% load(sprintf('S%s_design_Block%i.mat',const.subjID,const.block))
% load(sprintf('S%d_design_Block%d.mat',const.subjID,const.block))
% 
% load('SRania3_design_Block1.mat')
%load('SAbelTest_design_Block1.mat')

expDes.trialMat(:,7) = expDes.response(:,1);

pMatrix = nan(length(expDes.stairs)/2,3);
figure;
addpath(genpath('~/psignifit'))
options.sigmoidName  = 'norm';
options.fixedPars      = [nan; nan ; nan; 0.01;nan];
% options.borders(3,:)=[0,.1];

options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle';     % xLabel
plotOptions.yLabel         = '% of clockwise responses'; 
vvvv = nan(24,30);
ecc4R = [];  Becc4R = [];
ecc8R = [];  Becc8R = [];
ecc12R = []; Becc12R = [];
ecc4T = [];  Becc4T = [];
ecc8T = [];  Becc8T = [];
ecc12T = []; Becc12T = [];
locc = []; dirr = [];
 
if const.staircasemode == 1  
    for i=1:(length(expDes.stairs)/2)
       x = [];
       xx = [];
        
        for ii=1:(length(expDes.stairs{1,1})-1)
            x = [x expDes.stairs{1,i}(ii).threshold];
            xx = [xx expDes.stairs{1,i+24}(ii).threshold];
        end
        % vvvv(i,:) = x;
        % vvvx(i,:) = xx;
        currIDx = find(expDes.trialMat(:,6) == i);
        currP = expDes.trialMat(min(currIDx),:);
        PAName = currP(1,2);
        eccName = currP(1,3);
        DirName = currP(1,4);
      
            
        %pMatrix(i,)
    
       
        a = 1:length(x);
        b = 1:length(xx);
        oi = floor((i+4)/4);
        if mod(i+4,4) ==1
            figure(1);
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            scatter(a,x,'filled','b');xlim([0 30]); ylim([-20 20]); yline(0);yticks(-20:4:20);
            %coefficients = polyfit(a,x,2);
            % xRange = min(a):0.1:max(a);
            % yFit = polyval(coefficients,xRange);
            xlabel('Staircase Iterations')
            ylabel('Tilt Angle')
    
            hold on
            plot(a,x,'-b')
            %plot(xRange,yFit,'b','LineWidth',1)
    
    
            hold on;
            scatter(a,xx,'filled','r');xlim([0 30]); ylim([-20 20]);yticks(-20:4:20);
            % coefficients = polyfit(b,xx,2);
            % xRange = min(b):0.1:max(b);
            % yFit = polyval(coefficients,xRange);
            hold on
            plot(b,xx,'-r')   
            % legend(x,xx{'clockwise','counterclockwise'})
    
            
    
    
            %plot(xRange,yFit,'r','LineWidth',1)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % path = ['Z:\UsersShare\Abel\motionEcc_project\Figures/StaircaseMode',int2str(const.staircasemode),'/staircase_plot/',sprintf(const.subjID),'/fig']
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\staircase_plot\Rania\pdf/sub_',sprintf(const.subjID),'Staircase plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)
            %saveas(gcf,'C:\Users\rokers lab 2\Documents\Dir 45.png');
            
            psyMat(:,1) = [x';xx']
            psyMat(:,2) = [expDes.trialMat(find(expDes.trialMat(:,6) == i),7);expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)]
            %psyMat((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)
            Utilt = unique(psyMat(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(psyMat(:,1) == Utilt(ix,1)))
                Utilt(ix,2) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == 1)))
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
    
            figure(2);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(14,0.1 ,['Bias: ' num2str(fitOutput.Fit(1))],'FontSize',9)
            text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\psychometric_function\Rania\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)    
        elseif mod(i+4,4) ==3
            figure(5);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            scatter(a,x,'filled','b');xlim([0 30]); ylim([-20 20]); yline(0);yticks(-20:4:20);
            %coefficients = polyfit(a,x,2);
            % xRange = min(a):0.1:max(a);
            % yFit = polyval(coefficients,xRange);
            xlabel('Staircase Iterations')
            ylabel('Tilt Angle')
            % legend({'clockwise','counterclockwise'})
    
    
            hold on
            plot(a,x,'-b')
            %plot(xRange,yFit,'b','LineWidth',1)
    
    
            hold on;
            scatter(a,xx,'filled','r');xlim([0 30]); ylim([-20 20]);yticks(-20:4:20);
            % coefficients = polyfit(b,xx,2);
            % xRange = min(b):0.1:max(b);
            % yFit = polyval(coefficients,xRange);
            hold on
            plot(b,xx,'-r')
            
    
            %plot(xRange,yFit,'r','LineWidth',1)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\staircase_plot\Rania\pdf/sub_',sprintf(const.subjID),'Staircase plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)            %hold off
    
            psyMat(:,1) = [x';xx']
            psyMat(:,2) = [expDes.trialMat(find(expDes.trialMat(:,6) == i),7);expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)]
            %psyMat((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)
            Utilt = unique(psyMat(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(psyMat(:,1) == Utilt(ix,1)))
                Utilt(ix,2) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == 1)))
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
    
            figure(6);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(14,0.1 ,['Bias: ' num2str(fitOutput.Fit(1))],'FontSize',9)
            text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\psychometric_function\Rania\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)    
        elseif mod(i,4) ==0
            figure(7);
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi-1)
            scatter(a,x,'filled','b');xlim([0 30]); ylim([-20 20]); yline(0);yticks(-20:4:20);
            %coefficients = polyfit(a,x,2);
            % xRange = min(a):0.1:max(a);
            % yFit = polyval(coefficients,xRange);
            xlabel('Staircase Iterations')
            ylabel('Tilt Angle')
            % legend({'clockwise','counterclockwise'})
    
            hold on
            plot(a,x,'-b')
            %plot(xRange,yFit,'b','LineWidth',1)
    
    
            hold on;
            scatter(a,xx,'filled','r');xlim([0 30]); ylim([-20 20]);yticks(-20:4:20);
            % coefficients = polyfit(b,xx,2);
            % xRange = min(b):0.1:max(b);
            % yFit = polyval(coefficients,xRange);
            hold on
            plot(b,xx,'-r')
    
    
            %plot(xRange,yFit,'r','LineWidth',1)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\staircase_plot\Rania\pdf/sub_',sprintf(const.subjID),'Staircase plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)    
            psyMat(:,1) = [x';xx']
            psyMat(:,2) = [expDes.trialMat((find(expDes.trialMat(:,6) == i)),7);expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)]
            %psyMat((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)
            Utilt = unique(psyMat(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(psyMat(:,1) == Utilt(ix,1)))
                Utilt(ix,2) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == 1)))
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
    
            figure(8);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi-1)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(14,0.1 ,['Bias: ' num2str(fitOutput.Fit(1))],'FontSize',9)
            text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\psychometric_function\Rania\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)    
            
        elseif mod(i+4,4) ==2
            figure(3);
            hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            scatter(a,x,'filled','b');xlim([0 30]); ylim([-20 20]); yline(0);yticks(-20:4:20);
            %coefficients = polyfit(a,x,2);
            % xRange = min(a):0.1:max(a);
            % yFit = polyval(coefficients,xRange);
            xlabel('Staircase Iterations')
            ylabel('Tilt Angle')
            % legend({'clockwise','counterclockwise'})
            hold on
            plot(a,x,'-b')
            %plot(xRange,yFit,'b','LineWidth',1)
    
    
            hold on;
            scatter(a,xx,'filled','r');xlim([0 30]); ylim([-20 20]);yticks(-20:4:20);
            % coefficients = polyfit(b,xx,2);
            % xRange = min(b):0.1:max(b);
            % yFit = polyval(coefficients,Range);
            hold on
            plot(b,xx,'-r')
    
    
            %plot(xRange,yFit,'r','LineWidth',1)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\staircase_plot\Rania\pdf/sub_',sprintf(const.subjID),'Staircase Plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)            % hold off
    
            psyMat(:,1) = [x';xx']
            psyMat(:,2) = [expDes.trialMat(find(expDes.trialMat(:,6) == i),7);expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)]
            %psyMat((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == i+24),7)
            Utilt = unique(psyMat(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(psyMat(:,1) == Utilt(ix,1)))
                Utilt(ix,2) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == 1)))
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
    
            figure(4);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(14,0.1 ,['Bias: ' num2str(fitOutput.Fit(1))],'FontSize',9)
            text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\psychometric_function\Rania\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)        
        end 
        if eccName == 4 && DirName == 45 || eccName == 4 && DirName == 225
            ecc4R  = [ecc4R 1/sqrt(fitOutput.Fit(2))];
            Becc4R = [Becc4R fitOutput.Fit(1)]
        elseif eccName == 4 && DirName == 315 || eccName == 4 && DirName == 135
            ecc4T  = [ecc4T 1/sqrt(fitOutput.Fit(2))];
            Becc4T = [Becc4T fitOutput.Fit(1)]
        elseif eccName == 8 && DirName == 45 || eccName == 8 && DirName == 225
            ecc8R  = [ecc8R 1/sqrt(fitOutput.Fit(2))];
             Becc8R = [Becc8R fitOutput.Fit(1)]
             locc = [locc PAName]
             dirr = [dirr DirName]
        elseif eccName == 8 && DirName == 135 || eccName == 8 && DirName == 315
            ecc8T  = [ecc8T 1/sqrt(fitOutput.Fit(2))];
            Becc8T = [Becc8T fitOutput.Fit(1)]
        elseif eccName == 12 && DirName == 45 || eccName == 12 && DirName == 225
            ecc12R  = [ecc12R 1/sqrt(fitOutput.Fit(2))];
            Becc12R = [Becc12R fitOutput.Fit(1)]
    
        elseif eccName == 12 && DirName == 135 || eccName == 12 && DirName == 315
            ecc12T  = [ecc12T 1/sqrt(fitOutput.Fit(2))];
            Becc12T = [Becc12T fitOutput.Fit(1)]
    
        end
    end
elseif const.staircasemode ==2
     for i=1:(length(expDes.stairs))
        x = [];
         for ii=1:(length(expDes.stairs{1,i}.trialData))
            x = [x expDes.stairs{1,i}.trialData(ii).stim];
         end
         x = x'
        currIDx = find(expDes.trialMat(:,6) == i);
        currP = expDes.trialMat(min(currIDx),:);
        PAName = currP(1,2);
        eccName = currP(1,3);
        DirName = currP(1,4);
        if mod(i+4,4) ==1
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
            oi = floor((i+4)/4);
            figure(1);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function\S03\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)        
        elseif mod(i+4,4) ==2
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);            
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
            oi = floor((i+4)/4);
            figure(2);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function\S03\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)
        elseif mod(i+4,4) ==3
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);            
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
            oi = floor((i+4)/4);
            figure(3);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function\S03\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)  
        elseif mod(i,4) ==0
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
            oi = floor((i+4)/4);
            figure(4);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi-1)
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions)
            title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function\S03\pdf/sub_',sprintf(const.subjID),'Psychometric plot', sprintf('   Dir%i.pdf', DirName)]
            saveas(gcf,filename)       
        end
         if eccName == 4 && DirName == 45 || eccName == 4 && DirName == 225
            ecc4R  = [ecc4R 1/sqrt(fitOutput.Fit(2))];
            Becc4R = [Becc4R fitOutput.Fit(1)]
        elseif eccName == 4 && DirName == 315 || eccName == 4 && DirName == 135
            ecc4T  = [ecc4T 1/sqrt(fitOutput.Fit(2))];
            Becc4T = [Becc4T fitOutput.Fit(1)]
        elseif eccName == 8 && DirName == 45 || eccName == 8 && DirName == 225
            ecc8R  = [ecc8R 1/sqrt(fitOutput.Fit(2))];
             Becc8R = [Becc8R fitOutput.Fit(1)]
             locc = [locc PAName]
             dirr = [dirr DirName]
        elseif eccName == 8 && DirName == 135 || eccName == 8 && DirName == 315
            ecc8T  = [ecc8T 1/sqrt(fitOutput.Fit(2))];
            Becc8T = [Becc8T fitOutput.Fit(1)]
        elseif eccName == 12 && DirName == 45 || eccName == 12 && DirName == 225
            ecc12R  = [ecc12R 1/sqrt(fitOutput.Fit(2))];
            Becc12R = [Becc12R fitOutput.Fit(1)]
    
        elseif eccName == 12 && DirName == 135 || eccName == 12 && DirName == 315
            ecc12T  = [ecc12T 1/sqrt(fitOutput.Fit(2))];
            Becc12T = [Becc12T fitOutput.Fit(1)]
    
        end
     end
end
%% let's do a histogram of the bias and maybe some psychometric fits
% I will write all 12 conditions
% radial1
% PA225E4D45 = (mean(vvvv(1,(28:30))) + mean(vvvx(1,(28:30)))/2);
% PA225E4D225 = (mean(vvvv(3,(28:30))) + mean(vvvx(3,(28:30)))/2);
% PA225E4Drad = (PA225E4D45+PA225E4D225)/2;
% 
% %tangential1
% PA225E4D135 = (mean(vvvv(2,(28:30))) + mean(vvvx(2,(28:30)))/2);
% PA225E4D315 = (mean(vvvv(4,(28:30))) + mean(vvvx(4,(28:30)))/2);
% PA225E4Dtan = (PA225E4D135 + PA225E4D315)/2;
% 
% %radial2
% PA225E8D45 = (mean(vvvv(5,(28:30))) + mean(vvvx(5,(28:30)))/2);
% PA225E8D225 = (mean(vvvv(7,(28:30))) + mean(vvvx(7,(28:30)))/2);
% PA225E8Drad = (PA225E8D45 + PA225E8D225)/2;
% 
% %tangential2
% PA225E8D135 = (mean(vvvv(6,(28:30))) + mean(vvvx(6,(28:30)))/2);
% PA225E8D315 = (mean(vvvv(8,(28:30))) + mean(vvvx(8,(28:30)))/2);
% PA225E8Dtan = (PA225E8D135 + PA225E8D315)/2;
% 
% %radial3
% PA225E12D45 = (mean(vvvv(9,(28:30))) + mean(vvvx(9,(28:30)))/2);
% PA225E12D225 = (mean(vvvv(11,(28:30))) + mean(vvvx(11,(28:30)))/2);
% PA225E12Drad = (PA225E12D45 + PA225E12D225)/2
% 
% %tangential3
% PA225E12D135 = (mean(vvvv(10,(28:30))) + mean(vvvx(10,(28:30)))/2);
% PA225E12D315 = (mean(vvvv(12,(28:30))) + mean(vvvx(12,(28:30)))/2);
% PA225E12Dtan = (PA225E12D135 + PA225E12D315)/2
% 
% %radial4
% PA45E4D45 = (mean(vvvv(13,(28:30))) + mean(vvvx(13,(28:30)))/2);
% PA45E4D225 = (mean(vvvv(15,(28:30))) + mean(vvvx(15,(28:30)))/2);
% PA45E4Drad = (PA45E4D45 + PA45E4D225)/2;
% 
% %tangential4
% PA45E4D135 = (mean(vvvv(14,(28:30))) + mean(vvvx(14,(28:30)))/2);
% PA45E4D315 = (mean(vvvv(16,(28:30))) + mean(vvvx(16,(28:30)))/2);
% PA45E4Dtan = (PA45E4D135 + PA45E4D315)/2
% 
% %radial5
% PA45E8D45 = (mean(vvvv(17,(28:30))) + mean(vvvx(17,(28:30)))/2);
% PA45E8D225 = (mean(vvvv(19,(28:30))) + mean(vvvx(19,(28:30)))/2);
% PA45E8Drad = (PA45E8D45 + PA45E8D225)/2
% 
% %tangential5
% PA45E8D135 = (mean(vvvv(18,(28:30))) + mean(vvvx(18,(28:30)))/2);
% PA45E8D315 = (mean(vvvv(20,(28:30))) + mean(vvvx(20,(28:30)))/2);
% PA45E8Dtan = (PA45E8D135 + PA45E8D315)/2
% 
% %radial6
% PA45E12D45 = (mean(vvvv(21,(28:30))) + mean(vvvx(21,(28:30)))/2);
% PA45E12D225 = (mean(vvvv(23,(28:30))) + mean(vvvx(23,(28:30)))/2);
% PA45E12Drad = (PA45E12D45 + PA45E12D225)/2
% 
% %tangentail6
% PA45E12D135 = (mean(vvvv(22,(28:30))) + mean(vvvx(22,(28:30)))/2);
% PA45E12D315 = (mean(vvvv(24,(28:30))) + mean(vvvx(24,(28:30)))/2);
% PA45E12Dtan = (PA45E12D135 + PA45E12D315)/2
% figure;
% %% bar plots
% %subplot(2,1,1)
% figure
% radplot = bar([PA225E4Drad PA225E8Drad PA225E12Drad PA45E4Drad PA45E8Drad PA45E12Drad])
% title('radial plots')
% ylim([-12 12]);xlabel('Locations'); ylabel('Mean threshold (last 3 staircases)');
% xticklabels({'225e4','225e8','225e12','45e4','45e8','45e12'});yticks(-12:2:12);
% %figure;
% %subplot(2,1,2)
% tanplot = bar([PA225E4Dtan PA225E8Dtan PA225E12Dtan PA45E4Dtan PA45E8Dtan PA45E12Dtan])
% title('Tangential plots')
% ylim([-12 12]);xlabel('Locations'); ylabel('Mean threshold (last 3 staircases)');
% xticklabels({'225e4','225e8','225e12','45e4','45e8','45e12'});yticks(-12:2:12);
% %% psycho,metric plotting rad1
% expDes.trialMat(:,7) = expDes.response(:,1)
% expDes.trialMat(:,8) = expDes.tiltangle
% 
% %psychometric plots
% % % radial 1
% rad1(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 1),8)
% rad1(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 1),7)
% rad1((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 25),8)
% rad1((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 25),7)
% rad1(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 3),8)
% rad1(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 3),7)
% rad1((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 27),8)
% rad1((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 27),7)
% NumCW = sum(rad1(:,2) ==1)
% perCW = (NumCW/numel(rad1(:,2)))*100
% 
% %plot parameters
% Utilt = unique(rad1(:,1));
% for ix = 1:length(Utilt)
%     Utilt(ix,3) = length(find(rad1(:,1) == Utilt(ix,1)))
%     Utilt(ix,2) = length(find((rad1(:,1) == Utilt(ix,1)) & (rad1(:,2) == 1)))
%      %Utilt(ix,4) = length(find((rad1(:,1) == Utilt(ix,1)) & (rad1(:,2) == -1)))
% end
% 
% % Utilt(find((Utilt(:,1) >0) & (Utilt(:,2) == 0)),:) = []
% % Utilt(find((Utilt(:,1) <0) & (Utilt(:,2)./Utilt(:,3) == 1)),:) = []
% % Utilt(find((Utilt(:,1) >0) & (Utilt(:,2)./Utilt(:,3) < 0.85)),:) = []
% % Utilt(find((Utilt(:,1) <0) & (Utilt(:,2)./Utilt(:,3) > 0.25)),:) = []
% 
% 
% 
% % Utilt(24,:) = []
% % Utilt(28,:) = []
% % Utilt(31,:) = []
% % Utilt(33,:) = []
% % Utilt(37,:) = []
% % Utilt(27,:) = []
% % Utilt(29,:) = []
% % Utilt(3,:) = []
% 
% %psychometric plot
% s = scatter(Utilt(:,1), Utilt(:,3)./Utilt(:,2), 50, 'filled');
% s.Annotation.LegendInformation.IconDisplayStyle = 'off';
% title('Stimulus-Response Scatterplot', 'FontSize', 18)
% xlabel('Stimulus Level (degrees)')
% ylabel('CW Responses (%)')
% colormap = get(gca,'ColorOrder');
% %color = get(s,'Color');
% %s.CData = colormap(ci,:);
% hold on
% nYes = Utilt(:,3); % define CW as 'yes'
% nNo = Utilt(:,2) - nYes; % 'no' = total trials - yeses
% 
% [uEst,varEst] = FitCumNormYN(Utilt(:,1), nYes, nNo);
% 
% bias = uEst; % the horizontal shift of the model
% sensitivity = 1/sqrt(varEst); % steepness of the model
%  minStim = min(Utilt(:,1)); 
% maxStim = max(Utilt(:,1));sprintvvv
% stimPlotRange = linspace(minStim, maxStim, 100);
% P = normcdf(stimPlotRange,uEst,varEst);
% plot(stimPlotRange, P, 'linewidth', 2)
% 
% 
% 
% 
% %% psychometric plotting tan1
% 
% %tangentail 1
% tan1(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 2),8)
% tan1(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 2),7)
% tan1((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 26),8)
% tan1((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 26),7)
% tan1(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 4),8)
% tan1(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 4),7)
% tan1((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 28),8)
% tan1((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 28),7)
% 
% Utilt2 = unique(tan1(:,1));
% for ix = 1:length(Utilt2)
%     Utilt2(ix,3) = length(find(tan1(:,1) == Utilt2(ix,1)))
%     Utilt2(ix,2) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% % 
% % %psychometric plot
% % s = scatter(Utilt2(:,1), Utilt2(:,3)./Utilt2(:,2), 50, 'filled');
% % s.Annotation.LegendInformation.IconDisplayStyle = 'off';
% % title('Stimulus-Response Scatterplot', 'FontSize', 18)
% % xlabel('Stimulus Level (degrees)')
% % ylabel('CW Responses (%)')
% % colormap = get(gca,'ColorOrder');
% % %color = get(s,'Color');
% % %s.CData = colormap(ci,:);
% % hold on
% % nYes = Utilt2(:,2); % define CCW as 'yes'
% % nNo = Utilt2(:,3) - nYes; % 'no' = total trials - yeses
% % 
% % [uEst,varEst] = FitCumNormYN(Utilt2(:,1), nYes, nNo);
% % 
% % bias = uEst; % the horizontal shift of the model
% % sensitivity = 1/sqrt(varEst); % steepness of the model
% %  minStim = min(Utilt2(:,1));
% % maxStim = max(Utilt2(:,1));
% % stimPlotRange = linspace(minStim, maxStim, 100);
% % P = normcdf(stimPlotRange,uEst,varEst);
% % plot(stimPlotRange, P, 'linewidth', 2)
% % hold on
% 
% %% psychometric plotting rad2
% %radial 2
% % 
% rad2(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 5),8)
% rad2(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 5),7)
% rad2((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 29),8)
% rad2((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 29),7)
% rad2(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 7),8)
% rad2(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 7),7)
% rad2((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 31),8)
% rad2((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 31),7)
% 
% Utilt3 = unique(rad2(:,1));
% for ix = 1:length(Utilt3)
%     Utilt3(ix,3) = length(find(rad2(:,1) == Utilt3(ix,1)))
%     Utilt3(ix,2) = length(find((rad2(:,1) == Utilt3(ix,1)) & (rad2(:,2) == 1)))
%      %Utilt3(ix,4) = length(find((rad1(:,1) == Utilt3(ix,1)) & (rad1(:,2) == -1)))
% end
% % 
% % 
% % %psychometric plot
% % s = scatter(Utilt3(:,1), Utilt3(:,3)./Utilt3(:,2), 50, 'filled');
% % s.Annotation.LegendInformation.IconDisplayStyle = 'off';
% % title('Stimulus-Response Scatterplot', 'FontSize', 18)
% % xlabel('Stimulus Level (degrees)')
% % ylabel('CW Responses (%)')
% % colormap = get(gca,'ColorOrder');
% % %color = get(s,'Color');
% % %s.CData = colormap(ci,:);
% % hold on
% % nYes = Utilt3(:,3); % define CCW as 'yes'
% % nNo = Utilt3(:,2) - nYes; % 'no' = total trials - yeses
% % 
% % [uEst,varEst] = FitCumNormYN(Utilt3(:,1), nYes, nNo);
% % 
% % bias = uEst; % the horizontal shift of the model
% % sensitivity = 1/sqrt(varEst); % steepness of the model
% %  minStim = min(Utilt3(:,1));
% % maxStim = max(Utilt5(:,1));
% % stimPlotRange = linspace(minStim, maxStim, 100);
% % P = normcdf(stimPlotRange,uEst,varEst);
% % plot(stimPlotRange, P, 'linewidth', 2)
% % hold on
% 
% %% psychometric plotting tan2
% %tangential 2
% % 
% tan2(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 6),8)
% tan2(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 6),7)
% tan2((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 30),8)
% tan2((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 30),7)
% tan2(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 8),8)
% tan2(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 8),7)
% tan2((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 32),8)
% tan2((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 32),7)
% Utilt4 = unique(tan2(:,1));
% for ix = 1:length(Utilt4)
%     Utilt4(ix,3) = length(find(tan2(:,1) == Utilt4(ix,1)))
%     Utilt4(ix,2) = length(find((tan2(:,1) == Utilt4(ix,1)) & (tan2(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% 
% %% psychometric plotting rad3
% %radial 3
% % 
% rad3(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 9),8)
% rad3(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 9),7)
% rad3((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 33),8)
% rad3((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 33),7)
% rad3(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 11),8)
% rad3(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 11),7)
% rad3((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 35),8)
% rad3((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 35),7)
% 
% Utilt5 = unique(rad3(:,1));
% for ix = 1:length(Utilt5)
%     Utilt5(ix,3) = length(find(rad3(:,1) == Utilt5(ix,1)))
%     Utilt5(ix,2) = length(find((rad3(:,1) == Utilt5(ix,1)) & (rad3(:,2) == 1)))
%      %Utilt5(ix,4) = length(find((rad1(:,1) == Utilt5(ix,1)) & (rad1(:,2) == -1)))
% end
% 
% %% psychometric plotting tan3
% 
% %tangential 3
% 
% tan3(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 10),8)
% tan3(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 10),7)
% tan3((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 34),8)
% tan3((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 34),7)
% tan3(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 12),8)
% tan3(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 12),7)
% tan3((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 36),8)
% tan3((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 36),7)
% 
% Utilt6 = unique(tan3(:,1));
% for ix = 1:length(Utilt6)
%     Utilt6(ix,3) = length(find(tan3(:,1) == Utilt6(ix,1)))
%     Utilt6(ix,2) = length(find((tan3(:,1) == Utilt6(ix,1)) & (tan3(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% %% psychometric plotting rad4
% 
% %radial 4
% 
% rad4(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 13),8)
% rad4(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 13),7)
% rad4((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 37),8)
% rad4((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 37),7)
% rad4(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 15),8)
% rad4(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 15),7)
% rad4((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 39),8)
% rad4((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 39),7)
% 
% Utilt7 = unique(rad4(:,1));
% for ix = 1:length(Utilt7)
%     Utilt7(ix,3) = length(find(rad4(:,1) == Utilt7(ix,1)))
%     Utilt7(ix,2) = length(find((rad4(:,1) == Utilt7(ix,1)) & (rad4(:,2) == 1)))
%      %Utilt7(ix,4) = length(find((rad1(:,1) == Utilt7(ix,1)) & (rad1(:,2) == -1)))
% end
% 
% %% psychometric plotting tan4
% %tangential 4
% % 
% tan4(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 14),8)
% tan4(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 14),7)
% tan4((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 38),8)
% tan4((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 38),7)
% tan4(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 16),8)
% tan4(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 16),7)
% tan4((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 40),8)
% tan4((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 40),7)
% 
% Utilt8 = unique(tan4(:,1));
% for ix = 1:length(Utilt8)
%     Utilt8(ix,3) = length(find(tan4(:,1) == Utilt8(ix,1)))
%     Utilt8(ix,2) = length(find((tan4(:,1) == Utilt8(ix,1)) & (tan4(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% %% psychometric plotting rad5
% 
% %radial 5
% % 
% rad5(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 17),8)
% rad5(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 17),7)
% rad5((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 41),8)
% rad5((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 41),7)
% rad5(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 19),8)
% rad5(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 19),7)
% rad5((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 43),8)
% rad5((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 43),7)
% 
% Utilt9 = unique(rad5(:,1));
% for ix = 1:length(Utilt9)
%     Utilt9(ix,3) = length(find(rad5(:,1) == Utilt9(ix,1)))
%     Utilt9(ix,2) = length(find((rad5(:,1) == Utilt9(ix,1)) & (rad5(:,2) == 1)))
%      %Utilt9(ix,4) = length(find((rad1(:,1) == Utilt9(ix,1)) & (rad1(:,2) == -1)))
% end
% 
% %% psychometric plotting tan5
% 
% %tangential 5
% 
% tan5(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 18),8)
% tan5(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 18),7)
% tan5((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 42),8)
% tan5((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 42),7)
% tan5(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 20),8)
% tan5(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 20),7)
% tan5((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 44),8)
% tan5((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 44),7)
% 
% Utilt10 = unique(tan5(:,1));
% for ix = 1:length(Utilt10)
%     Utilt10(ix,3) = length(find(tan5(:,1) == Utilt10(ix,1)))
%     Utilt10(ix,2) = length(find((tan5(:,1) == Utilt10(ix,1)) & (tan5(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% %% psychometric plotting rad6
% 
% %radial 6
% 
% rad6(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 21),8)
% rad6(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 21),7)
% rad6((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 45),8)
% rad6((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 45),7)
% rad6(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 23),8)
% rad6(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 23),7)
% rad6((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 47),8)
% rad6((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 47),7)
% 
% Utilt11 = unique(rad6(:,1));
% for ix = 1:length(Utilt11)
%     Utilt11(ix,3) = length(find(rad6(:,1) == Utilt11(ix,1)))
%     Utilt11(ix,2) = length(find((rad6(:,1) == Utilt11(ix,1)) & (rad6(:,2) == 1)))
%      %Utilt11(ix,4) = length(find((rad1(:,1) == Utilt11(ix,1)) & (rad1(:,2) == -1)))
% end
% 
% %% psychometric plotting tan6
% 
% %tangential 6
% % 
% tan6(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 22),8)
% tan6(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 22),7)
% tan6((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 46),8)
% tan6((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 46),7)
% tan6(:,1) = expDes.trialMat(find(expDes.trialMat(:,6) == 4),8)
% tan6(:,2) = expDes.trialMat(find(expDes.trialMat(:,6) == 4),7)
% tan6((31:60),1) = expDes.trialMat(find(expDes.trialMat(:,6) == 48),8)
% tan6((31:60),2) = expDes.trialMat(find(expDes.trialMat(:,6) == 48),7)
% 
% Utilt12 = unique(tan6(:,1));
% for ix = 1:length(Utilt12)
%     Utilt12(ix,3) = length(find(tan6(:,1) == Utilt12(ix,1)))
%     Utilt12(ix,2) = length(find((tan6(:,1) == Utilt12(ix,1)) & (tan6(:,2) == 1)))
%      %Utilt2(ix,4) = length(find((tan1(:,1) == Utilt2(ix,1)) & (tan1(:,2) == -1)))
% end
% 
% %%
% 
% 
% addpath(genpath('~/Documents/GitHub/psignifit'))
% options.sigmoidName  = 'norm';
% options.fixedPars      = [nan ; nan ; 0; 0.01; nan]
% options.expType = 'equalAsymptote';
% plotOptions.xLabel         = 'Tilt Angle';     % xLabel
% plotOptions.yLabel         = '% of clockwise responses';
% figure;
% fitOutput = psignifit(Utilt,options);
% plotPsych(fitOutput,plotOptions)
% title('PA225 e4 Dir 225')
% % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
% text(14,0.1 ,['Bias: ' num2str(fitOutput.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
% % addpath(genpath('~/Documents/GitHub/psignifit'))
% % options.sigmoidName  = 'norm';
% options.expType = 'equalAsymptote';
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e4 Dir225.png');
% 
% 
% figure;
% fitOutput2 = psignifit(Utilt2,options);
% 
% plotOptions.dataSize       = 30000./sum(fitOutput2.data(:,3))
% plotPsych(fitOutput2,plotOptions);
% 
% title('PA225 e4  Dir315')
% text(14,0.1 ,['Bias: ' num2str(fitOutput2.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput2.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e4 Dir315.png');
% 
% 
% figure;
% fitOutput3 = psignifit(Utilt3,options);
% plotPsych(fitOutput3)
% title('PA225 e8  Dir225')
% text(14,0.1 ,['Bias: ' num2str(fitOutput3.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput3.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e8 Dir225.png');
% 
% 
% 
% 
% figure;
% fitOutput4 = psignifit(Utilt4,options);
% plotPsych(fitOutput4)
% title('PA225 e8  Dir315')
% text(14,0.1 ,['Bias: ' num2str(fitOutput4.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput4.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e8 Dir315.png');
% 
% figure;
% fitOutput5 = psignifit(Utilt5,options);
% plotPsych(fitOutput5)
% title('PA225 e12  Dir225')
% text(14,0.1 ,['Bias: ' num2str(fitOutput5.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput5.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e12 Dir225.png');
% 
% 
% figure;
% fitOutput6 = psignifit(Utilt6,options);
% plotPsych(fitOutput6)
% title('PA225 e12  Dir315')
% text(14,0.1 ,['Bias: ' num2str(fitOutput6.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput6.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA225 e12 Dir315.png');
% 
% 
% figure;
% fitOutput7 = psignifit(Utilt7,options);
% plotPsych(fitOutput7)
% title('PA45 e4  Dir225')
% text(14,0.1 ,['Bias: ' num2str(fitOutput7.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput7.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e4 Dir225.png');
% 
% 
% figure;
% fitOutput8 = psignifit(Utilt8,options);
% plotPsych(fitOutput8)
% title('PA45 e4  Dir315')
% text(14,0.1 ,['Bias: ' num2str(fitOutput8.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput8.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e4 Dir315.png');
% 
% figure;
% fitOutput9 = psignifit(Utilt9,options);
% plotPsych(fitOutput9)
% title('PA45 e8  Dir225')
% text(14,0.1 ,['Bias: ' num2str(fitOutput9.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput9.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e8 Dir225.png');
% 
% 
% figure;
% fitOutput10 = psignifit(Utilt10,options);
% plotPsych(fitOutput10,plotOptions)
% title('PA45 e8  Dir315')
% text(14,0.1 ,['Bias: ' num2str(fitOutput10.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput10.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e8 Dir315.png');
% 
% 
% figure;
% fitOutput11 = psignifit(Utilt11,options);
% plotPsych(fitOutput11,plotOptions)
% title('PA45 e12  Dir225')
% text(14,0.1 ,['Bias: ' num2str(fitOutput11.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput11.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\radial6.png');
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e12 Dir225.png');
% 
% figure;
% fitOutput12 = psignifit(Utilt12,options);
% plotOptions.dataSize       = 30000./sum(fitOutput12.data(:,3))
% plotPsych(fitOutput12,plotOptions)
% title('PA45 e12  Dir315');xlim([-20 20])
% text(14,0.1 ,['Bias: ' num2str(fitOutput12.Fit(1))],'FontSize',9)
% text(14,0.15 ,['Sensitivity: ' num2str(1/sqrt(fitOutput12.Fit(2)))],'FontSize',9)
% saveas(gcf,'C:\Users\rokers lab 2\Documents\PA45 e12 Dir315.png');
% 
% %%
% figure;
% % x = 1:3
% % xw = 0.5:0.5:3
% % wx = [(1/sqrt(fitOutput.Fit(2)))  (1/sqrt(fitOutput7.Fit(2))); (1/sqrt(fitOutput2.Fit(2)))  (1/sqrt(fitOutput8.Fit(2))); (1/sqrt(fitOutput3.Fit(2)))  (1/sqrt(fitOutput9.Fit(2))); ...
% %     (1/sqrt(fitOutput4.Fit(2)))  (1/sqrt(fitOutput10.Fit(2))); (1/sqrt(fitOutput5.Fit(2)))  (1/sqrt(fitOutput11.Fit(2))); (1/sqrt(fitOutput6.Fit(2)))  (1/sqrt(fitOutput12.Fit(2)))]
% % 
% % w =[((1/sqrt(fitOutput.Fit(2))) + (1/sqrt(fitOutput7.Fit(2))))/2 ((1/sqrt(fitOutput2.Fit(2))) + (1/sqrt(fitOutput8.Fit(2))))/2; ((1/sqrt(fitOutput3.Fit(2))) + (1/sqrt(fitOutput9.Fit(2))))/2 ...
% %     ((1/sqrt(fitOutput4.Fit(2))) + (1/sqrt(fitOutput10.Fit(2))))/2; ((1/sqrt(fitOutput5.Fit(2))) + (1/sqrt(fitOutput11.Fit(2))))/2 ((1/sqrt(fitOutput6.Fit(2))) + (1/sqrt(fitOutput12.Fit(2))))/2]
% radE4 = mean([0.2467,0.25057,0.24483,0.15927]); r4 = [0.2467,0.25057,0.24483,0.15927]
% tanE4 = mean([0.17128,0.17956,0.16861,0.21294]); t4 = [0.17128,0.17956,0.16861,0.21294]
% radE8 = mean([0.28556,0.1669,0.34674,0.1742]);   r8 = [0.28556,0.1669,0.34674,0.1742]
% tanE8 = mean([0.17137,0.17728,0.17853,0.15777]); t8 = [0.17137,0.17728,0.17853,0.15777]
% radE12 = mean([0.178003,0.14862,0.19211,0.14648]); r12 = [0.178003,0.14862,0.19211,0.14648]
% tanE12 = mean([0.15495,0.29315,0.15219,0.1861]);  t12 = [0.15495,0.29315,0.15219,0.1861] 
pts = [0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85 2.85 2.85 2.85; 3.15 3.15 3.15 3.15]
figure;
w = [mean(ecc4R),mean(ecc4T);mean(ecc8R),mean(ecc8T);mean(ecc12R),mean(ecc12T)];
wxx3 = [ecc4R;ecc4T;ecc8R;ecc8T;ecc12R;ecc12T]
Bias3 = [Becc4R;Becc4T;Becc8R;Becc8T;Becc12R;Becc12T]
ww = [mean(ecc4R),mean(ecc4T),mean(ecc8R),mean(ecc8T),mean(ecc12R),mean(ecc12T)]
% w = [radE4,tanE4;radE8,tanE8;radE12,tanE12]
% wxx = [r4;t4;r8;t8;r12;t12]
% ww = [radE4,tanE4,radE8,tanE8,radE12,tanE12]
bar(w)
hold on 
stder = (std(wxx3')/sqrt(4))'
plot(pts,wxx3,'.','MarkerSize',12)
hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],ww,stder,'b.')
% 
% Bias
% 
% 
% 
% Release the hold on the plot

%plot(([0.5 2.5]), ([0.1429    0.1278]),'.')
%plot(wx,'.')
% errorbar(x,w)
% hold on

Ymax = (max(wxx3,[],'all')+0.05);
legend({'radial','tangential'})
ylim([0 Ymax]);xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'});yticks(0:0.05:Ymax);
title('Sensitivity bar plot')
saveas(gcf,'Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function\S03\pdf//SummaryBar.pdf');
% 
% %z = bar([((1/sqrt(fitOutput2.Fit(2))) + (1/sqrt(fitOutput8.Fit(2))))/2 ((1/sqrt(fitOutput4.Fit(2))) + (1/sqrt(fitOutput10.Fit(2))))/2 ((1/sqrt(fitOutput6.Fit(2))) + (1/sqrt(fitOutput12.Fit(2))))/2])
% 
% % x = [x expDes.stairs{1,i}(ii).threshold];
% 
% 
% 
% 
% 
% 
% 
% 
% 
%end       