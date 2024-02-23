%function [expDes, const] = plottt(const,expDes)

% clear all; close all; clc;
%addpath(genpath('~/Documents/GitHub/motion_ecc/Data/%s',const.subjID))
% load(sprintf('S%s_design_Block%i.mat',const.subjID,const.block))
% load(sprintf('S%d_design_Block%d.mat',const.subjID,const.block))
% 
% load('SRania3_design_Block1.mat')
%load('SAbelTest_design_Block1.mat')
close all;
expDes.trialMat(:,7) = expDes.response(:,1);
rootpath =  ("C:\Users\rokers lab 2\Documents\motionEcc_project\Figures\");
%rootpath =  ("Y:\UsersShare\Abel\motionEcc_project\Figures\");

pMatrix = nan(length(expDes.stairs)/2,3);
figure;
addpath(genpath('~/psignifit'))
options.sigmoidName  = 'norm';
options.fixedPars      = [nan;  nan; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];


options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle(degrees)';     % xLabel
plotOptions.yLabel         = '% of clockwise responses'; 
plotOptions.extrapolLength = 1
vvvv = nan(24,30);
ecc4R = [];  Becc4R = [];
ecc8R = [];  Becc8R = [];
ecc12R = []; Becc12R = [];
ecc4T = [];  Becc4T = [];
ecc8T = [];  Becc8T = [];
ecc12T = []; Becc12T = [];
locc = []; dirr = [];
ecc4rO = [];
ecc4rI = [];
ecc8rO = [];
ecc8rI = [];
ecc12rO = [];
ecc12rI = [];
 
if ~isfield(const,'staircasemode') || const.staircasemode == 1 
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
        sp_path = fullfile(rootpath,"\StaircaseMode1\staircase_plot",sprintf(const.subjID))
        pf_path = fullfile(rootpath,"\StaircaseMode1\psychometric_function",sprintf(const.subjID))
        if ~isfolder(sp_path)
            mkdir(sp_path);
        end
        if ~isfolder(pf_path)
            mkdir(pf_path);
        end

        %sp_path = fullfile("C:\Users\rokers lab 2\Documents\motionEcc_Project\Figures\StaircaseMode1\staircase_plots",sprintf(const.subjID))%,['S',sprintf(const.subjID),'_SP_',sprintf('pa%i_ecc%i_m%i', PAName,eccName,DirName)])
        % pf_path = fullfile("C:\Users\rokers lab 2\Documents\motionEcc_Project\Figures\StaircaseMode1\psychometric_function",sprintf(const.subjID))%,"S",sprintf(const.subjID),'PF',(sprintf('pa%i_ecc%i_m%i', PAName,eccName,DirName))]
        sp_filename = ['S',sprintf(const.subjID),'_SP_',sprintf('m%i',DirName)];
        pf_filename = ['S',sprintf(const.subjID),'_PF_',sprintf('m%i',DirName)];
        filename = fullfile(sp_path, sp_filename)
        filename2 = fullfile(pf_path, pf_filename)


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
            ylabel('Tilt Angle(degrees)')
    
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
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % path = ['Z:\UsersShare\Abel\motionEcc_project\Figures/StaircaseMode',int2str(const.staircasemode),'/staircase_plot/',sprintf(const.subjID),'/fig']
            % saveas(figure(1),filename,'pdf');
            % saveas(figure(1),filename,'fig');
            %saveas(figure(1),filename,'png');

            %saveas(gcf,filename,'fig');
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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses') 
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(figure(2),filename2,'pdf');
            % saveas(figure(2),filename2,'fig');
            saveas(figure(2),filename2,'png');

          %  saveas(gcf,filename)    
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
            ylabel('Tilt Angle(degrees)')
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
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
           % saveas(gcf,filename)            %hold off
            % saveas(figure(5),filename,'fig');
            % saveas(figure(5),filename,'pdf');
            saveas(figure(5),filename,'png');

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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('___PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
           % saveas(gcf,filename)  
           
            % saveas(figure(6),filename2,'fig');
            % saveas(figure(6),filename2,'pdf');
            %saveas(figure(6),filename2,'png');

        elseif mod(i,4) ==0
            figure(7);
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi-1)
            scatter(a,x,'filled','b');xlim([0 30]); ylim([-20 20]); yline(0);yticks(-20:4:20);
            %coefficients = polyfit(a,x,2);
            % xRange = min(a):0.1:max(a);
            % yFit = polyval(coefficients,xRange);
            xlabel('Staircase Iterations')
            ylabel('Tilt Angle(degrees)')
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
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
           % saveas(gcf,filename)    
           % saveas(figure(7),filename,'fig');
           % saveas(figure(7),filename,'pdf');
           %saveas(figure(7),filename,'png');

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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
           text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
           text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
          %  saveas(gcf,filename)    
          % saveas(figure(8),filename2,'fig');
          % saveas(figure(8),filename2,'pdf');
          %saveas(figure(8),filename2,'png');

            
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
            ylabel('Tilt Angle(degrees)')
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
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
           % saveas(gcf,filename)            % hold off
            % saveas(figure(3),filename,'pdf');
            % saveas(figure(3),filename,'fig');
            saveas(figure(3),filename,'png');

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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
           % saveas(gcf,filename)  
           % saveas(figure(4),filename2,'fig');
           % saveas(figure(4),filename2,'pdf');
           saveas(figure(4),filename2,'png');
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
         pf_path = fullfile(rootpath,"\StaircaseMode2\psychometric_function",sprintf(const.subjID))
        %pf_path = fullfile("Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\psychometric_function",sprintf(const.subjID))
        pf_filename = ['S',sprintf(const.subjID),'_PF_',sprintf('m%i',DirName)];
        if ~isfolder(pf_path)
            mkdir(pf_path);
        end

        filename2 = fullfile(pf_path, pf_filename)


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
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(gcf,filename2,'fig') 
            % saveas(gcf,filename2,'pdf');   
            saveas(gcf,filename2,'png');
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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(gcf,filename2,'fig') 
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');

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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(gcf,filename2,'fig') 
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');

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
            plotPsych(fitOutput,plotOptions);
            xlim([-20 20]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(gcf,filename2,'fig') 
            % saveas(gcf,filename2,'pdf'); 
            saveas(gcf,filename2,'png');

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
         % %%inwardoutward
         % if eccName == 4 && DirName == 135 && DirName == PAName
         %     ecc4rO = [ecc4rO 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 4 && DirName == 315 && DirName == PAName
         %     ecc4rO = [ecc4rO 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 4 && DirName == 135 && DirName ~= PAName
         %      ecc4rI = [ecc4rI 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 4 && DirName == 315 && DirName ~= PAName
         %      ecc4rI = [ecc4rI 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 8 && DirName == 135 && DirName == PAName
         %     ecc8rO = [ecc8rO 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 8 && DirName == 315 && DirName == PAName
         %     ecc8rO = [ecc8rO 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 8 && DirName == 135 && DirName ~= PAName
         %      ecc8rI = [ecc8rI 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 8 && DirName == 315 && DirName ~= PAName
         %      ecc8rI = [ecc8rI 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 12 && DirName == 135 && DirName == PAName
         %     ecc12rO = [ecc12rO 1/sqrt(fitOutput.Fit(2))];
         %  elseif eccName == 12 && DirName == 315 && DirName == PAName
         %     ecc12rO = [ecc12rO 1/sqrt(fitOutput.Fit(2))];
         % elseif eccName == 12 && DirName == 135 && DirName ~= PAName
         %      ecc12rI = [ecc12rI 1/sqrt(fitOutput.Fit(2))];
         %  elseif eccName == 12 && DirName == 315 && DirName ~= PAName
         %      ecc12rI = [ecc12rI 1/sqrt(fitOutput.Fit(2))];
         % end
     end
end

%% 

pts = [0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85 2.85 2.85 2.85; 3.15 3.15 3.15 3.15]
figure;
w = [mean(ecc4R),mean(ecc4T);mean(ecc8R),mean(ecc8T);mean(ecc12R),mean(ecc12T)];
wxx3 = [ecc4R;ecc4T;ecc8R;ecc8T;ecc12R;ecc12T]
Bias3 = [Becc4R;Becc4T;Becc8R;Becc8T;Becc12R;Becc12T]
Bias3 = abs(Bias3)
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


%plot(([0.5 2.5]), ([0.1429    0.1278]),'.')
%plot(wx,'.')
% errorbar(x,w)
% hold on

Ymax = (max(wxx3,[],'all')+0.05);
%legend({'radial','tangential'})
ylim([0 0.25]);xlabel('Eccentricities (degrees)'); ylabel('Sensitivity');
xticklabels({'4','8','12'});yticks(0:0.05:0.25);
title(['S',sprintf(const.subjID),'__Sensitivity bar plot'])
filename3 = fullfile(pf_path, ['S',sprintf(const.subjID),'__summary_bar_plot'])
 saveas(gcf,filename3,'png');
% end

%% quest+ psychometric plots

% % parameter for the search, and impose as parameter bounds the range
% % provided to QUEST+.
% for str = 1:length(expDes.stairs)
%     psiParamsIndex = qpListMaxArg(expDes.stairs{1,str}.posterior);
%     psiParamsQuest = expDes.stairs{1,str}.psiParamsDomain(psiParamsIndex,:);
%     % fprintf('Simulated parameters: %0.1f, %0.1f, %0.1f, \n', ...
%     % simulatedPsiParams(1),simulatedPsiParams(2),simulatedPsiParams(3));
%     % fprintf('Max posterior QUEST+ parameters: %0.1f, %0.1f, %0.1f\n', ...
%     % psiParamsQuest(1),psiParamsQuest(2),psiParamsQuest(3));
% 
% 
%     psiParamsFit = qpFit(expDes.stairs{1,str}.trialData,expDes.stairs{1,str}.qpPF,psiParamsQuest,expDes.stairs{1,str}.nOutcomes,...
%         'lowerBounds', [-10 1 0],'upperBounds',[10 10 0]);
%     fprintf('Maximum likelihood fit parameters: %0.1f, %0.1f, %0.1f\n', ...
%         psiParamsFit(1),psiParamsFit(2),psiParamsFit(3));
% 
%     % Plot of trial locations with maximum likelihood fit
%     figure; clf; hold on
%     stimCounts = qpCounts(qpData(expDes.stairs{1,str}.trialData),expDes.stairs{1,str}.nOutcomes);
%     stim = [stimCounts.stim];
%     stimFine = linspace(-20,20,100)';
%     plotProportionsFit = qpPFNormal(stimFine,psiParamsFit);
%     for cc = 1:length(stimCounts)
%         nTrials(cc) = sum(stimCounts(cc).outcomeCounts);
%         pCorrect(cc) = stimCounts(cc).outcomeCounts(2)/nTrials(cc);
%     end
%     for cc = 1:length(stimCounts)
%         h = scatter(stim(cc),pCorrect(cc),100,'o','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],...
%             'MarkerFaceAlpha',nTrials(cc)/max(nTrials),'MarkerEdgeAlpha',nTrials(cc)/max(nTrials));
%     end
%     plot(stimFine,plotProportionsFit(:,2),'-','Color',[1.0 0.2 0.0],'LineWidth',3);
%     xlabel('Stimulus Value');
%     ylabel('Proportion Correct');
%     xlim([-20, 20]); ylim([0 1]);
%     title({'Estimate Normal threshold', ''});
%     drawnow;    
% end