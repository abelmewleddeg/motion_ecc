%% Load variables
close all;
clearvars
i_subj = '20';
block_num = 2;
git_dir = 'C:\Users\rokers lab 2\Documents\Github';
data_dir_fn = 'C:\Users\rokers lab 2\Documents\Github\motion_ecc/data/StaircaseMode2';
data_dir = fullfile(data_dir_fn,i_subj);% '*0*.mat'));

des = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*design*.mat')));
const  = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*const*.mat')));
load(fullfile(const.folder,const.name)); load(fullfile(des.folder,des.name))
expDes.trialMat(:,7) = expDes.response(:,1);

%% Psychometric Plots
rootpath =  ("C:\Users\rokers lab 2\Documents\motionEcc_project\Figures\"); %vision Directory
pMatrix = nan(length(expDes.stairs)/2,3);
addpath(fullfile(git_dir,'psignifit'))
addpath(genpath('psignifit')) % not working

options.sigmoidName  = 'norm';
options.fixedPars      = [nan;  nan; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];
options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle(degrees)';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 1;
plotOptions.lineWidth      = 2;
plotOptions.dataSize = 75;

% sensitivity and bias variables per eccentricity
ecc7R = [];  Becc7R = [];
ecc20R = [];  Becc20R = [];
ecc30R = []; Becc30R = [];
ecc7T = [];  Becc7T = [];
ecc20T = [];  Becc20T = [];
ecc30T = []; Becc30T = [];
locc = []; dirr = [];
Sensitivity = [];
Bias = [];
figure;
if ~isfield(const,'staircasemode') || const.staircasemode == 1
    for i=1:(length(expDes.stairs)/2)
        x = [];
        xx = [];
        for ii=1:(length(expDes.stairs{1,1})-1)
            x = [x expDes.stairs{1,i}(ii).threshold];
            xx = [xx expDes.stairs{1,i+24}(ii).threshold];
        end
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
            xlim([-30 30]);;
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
            xlim([-30 30]);;
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
            xlim([-30 30]);;
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

            xlim([-30 30]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % saveas(gcf,filename)
            % saveas(figure(4),filename2,'fig');
            % saveas(figure(4),filename2,'pdf');
            saveas(figure(4),filename2,'png');
        end
       Sensitivity = [Sensitivity 1/sqrt(fitOutput.Fit(2))];
       Bias = [Bias fitOutput.Fit(1)];
    end
elseif const.staircasemode ==2
    for i=1:(length(expDes.stairs))
        x = [];
        for ii=1:(length(expDes.stairs{1,i}.trialData)); %numel(find(expDes.trialMat(:,6)==i));
            x = [x expDes.stairs{1,i}.trialData(ii).stim];
        end
        x = x'
        currIDx = find(expDes.trialMat(:,6) == i);
        currP = expDes.trialMat(min(currIDx),:);
        PAName = currP(1,2);
        eccName = currP(1,3);
        DirName = currP(1,4);
        pf_path = fullfile(rootpath,"\StaircaseMode2\psychometric_function",sprintf(const.subjID))
        pf_filename = ['S',sprintf(const.subjID),'_PF_',sprintf('m%i',DirName)];
        if ~isfolder(pf_path)
            mkdir(pf_path);
        end
        filename2 = fullfile(pf_path, pf_filename)
        % psychometric plots
        if mod(i+4,4) ==1
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
            end
            oi = floor((i+4)/4);
            figure(1);
            % hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            % plotOptions.dataColor = [0 0.4470 0.7410];
            % plotOptions.lineColor = [0 0.4470 0.7410];
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions);
            xlim([-30 30]); %xlim([-20 20]);;
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % % saveas(gcf,filename2,'fig')
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');
            hold on
        elseif mod(i+4,4) ==2
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
            end
            oi = floor((i+4)/4);
            figure(2);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi)
            % plotOptions.dataColor = [0.85 0.325 0.098];
            % plotOptions.lineColor = [0.85 0.325 0.098];
            fitOutput = psignifit(Utilt,options);
            plotPsych(fitOutput,plotOptions);
            xlim([-30 30]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % % saveas(gcf,filename2,'fig')
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');
            hold on
        elseif mod(i+4,4) ==3
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
            end
            oi = floor((i+4)/4);
            figure(3);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi);
            % plotOptions.dataColor = [0 0.4470 0.7410];
            % plotOptions.lineColor = [0 0.4470 0.7410];
            fitOutput = psignifit(Utilt,options);
            radial = plotPsych(fitOutput,plotOptions);
            xlim([-30 30]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % % saveas(gcf,filename2,'fig')
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');
            hold on
        elseif mod(i,4) ==0
            NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
            Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
            x(:,2) = Allind(~NaNind);            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt)
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
            end
            oi = floor((i+4)/4);
            figure(4);
            %hold on
            set(gcf,'Position',get(0,'ScreenSize'));
            subplot(2,3,oi-1)
            % plotOptions.dataColor = [0.85 0.325 0.098];
            % plotOptions.lineColor = [0.85 0.325 0.098];
            fitOutput = psignifit(Utilt,options);
            tangential =  plotPsych(fitOutput,plotOptions);

            %legend([radial tangential],{'radial','tangential'},'Location','northwest')
            xlim([-30 30]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % % saveas(gcf,filename2,'fig')
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');
            hold on
        end
        Sensitivity = [Sensitivity; 1/sqrt(fitOutput.Fit(2))];
        Bias = [Bias; fitOutput.Fit(1)];
    end
end
% organize variables in a table
subjID = repmat(const.subjID_numeric,24,1);
PolarAngles = [repmat(expDes.polarAngles(1),12,1); repmat(expDes.polarAngles(2),12,1)]
Eccentricities = repmat(repelem(expDes.Eccens,4),1,2)';
Directions = repmat(expDes.Dirs,1,6)';
% Names = ["subjID";"PolarAngles";"Eccentricities";"Directions";"Sensitivity";"Bias"];
result = table(PolarAngles,Eccentricities,Directions,Sensitivity,Bias);
for r = 1:size(result,1)
    if  result.Directions(r) == result.PolarAngles(r) | result.Directions(r) == result.PolarAngles(r) +180 | result.Directions(r) == result.PolarAngles(r) - 180
        result.rvt(r) = 1
    else
        result.rvt(r) = -1
    end
end

%% try using the table to make a bar similar to one below
pts = repmat([0.85;1.15;1.85;2.15;2.85;3.15],1,2);
d = result;
d.rvt = d.rvt*-1
d.BiasMagnitude = abs(d.Bias)
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
gp = groupsummary(d, ["Eccentricities", "PolarAngles","rvt"], "mean")
figure;
% h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
% set(h, 'linestyle', '-');


% TODO: add errorbars
hold on
g_std = groupsummary(d, ["Eccentricities", "rvt"], "std", "Sensitivity");
g_stdbias = groupsummary(d, ["Eccentricities", "rvt"], "std","BiasMagnitude");
g_std.stder = g_std.std_Sensitivity/sqrt(4);
g_stdbias.stder = g_stdbias.std_BiasMagnitude/sqrt(4);


% reshape variables
gms = (reshape(g.mean_Sensitivity,2,3))';
gmsb = (reshape(g.mean_BiasMagnitude,2,3))';
h = bar(gms,1);
hold on
gme = (reshape(g.Eccentricities,2,3))';
gmstder = (reshape(g_std.stder,2,3))';
gmBiasStder = (reshape(g_stdbias.stder,2,3))';
e = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gms,gmstder,'k.','LineWidth',1) % plot the errorbars

for i = 1:3
    H2 = plot((pts([i*2-1 i*2],1)),gp.mean_Sensitivity([i*4-3 i*4-2]),'LineWidth',1.5,'LineStyle','-','Color','black')
    hold on
    H3 = plot((pts([i*2-1 i*2],2)),gp.mean_Sensitivity([i*4-1 i*4]),'LineWidth',1.5,'LineStyle','-.','Color','black')
    hold on
end
legend({'radial','tangential'},'Location','northwest')
xlabel('Eccentricities (degrees)'); ylabel('Sensitivity (1/\sigma)');
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);
title(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Sensitivity bar plot'])

fn = fullfile(pf_path,['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Sensitivity bar plot'])
saveas(gcf,fn,'png');

figure;bar(gmsb,1)
hold on
eb = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gmsb,gmBiasStder,'k.','LineWidth',1) % plot the errorbars
d.rvt = d.rvt*-1 %change back
legend({'radial','tangential'},'Location','northwest')
title(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Bias Magnitude bar plot'])
xlabel('Eccentricities (degrees)'); ylabel('Bias Magnitude (\mu)');
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);

fnb = fullfile(pf_path,['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Sensitivity bar plot'])
saveas(gcf,fnb,'png');
tablePath = fullfile('C:\Users\rokers lab 2\Documents\motionEcc_Project\2024_MotionAssymetries\code\data');
tableName = fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block),'.mat'])
save(tableName,'result')
if isfile(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block-1),'.mat']))
    load(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block),'.mat']));
    result2 = result;
    load(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block-1),'.mat']));
    result1  = result;
    AggResult = vertcat(result2,result1);
end
tableName = fullfile(tablePath,['S',sprintf(const.subjID),'Agg']);
save(tableName,'AggResult')



%% calculating aggregate sensitivity and Bias
close all
load(tableName);
pts = repmat([0.85;1.15;1.85;2.15;2.85;3.15],1,2);
d = AggResult;
d.rvt = d.rvt*-1
d.BiasMagnitude = abs(d.Bias)
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
gp = groupsummary(d, ["Eccentricities", "PolarAngles","rvt"], "mean")
figure;
% h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
% set(h, 'linestyle', '-');


% TODO: add errorbars
hold on
g_std = groupsummary(d, ["Eccentricities", "rvt"], "std", "Sensitivity");
g_stdbias = groupsummary(d, ["Eccentricities", "rvt"], "std","BiasMagnitude");
g_std.stder = g_std.std_Sensitivity/sqrt(4);
g_stdbias.stder = g_stdbias.std_BiasMagnitude/sqrt(4);


% reshape variables
gms = (reshape(g.mean_Sensitivity,2,3))';
gmsb = (reshape(g.mean_BiasMagnitude,2,3))';
h = bar(gms,1);
hold on
gme = (reshape(g.Eccentricities,2,3))';
gmstder = (reshape(g_std.stder,2,3))';
gmBiasStder = (reshape(g_stdbias.stder,2,3))';
e = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gms,gmstder,'k.','LineWidth',1) % plot the errorbars
legend({'radial','tangential'},'Location','northwest')
xlabel('Eccentricities (degrees)'); ylabel('Sensitivity (1/\sigma)');
xticks(1:3);xticklabels({'7','20','30'}); yticks(0:0.05:0.25)
title(['S',sprintf(const.subjID),'__Sensitivity bar plot'])
fn = fullfile(pf_path,['S',sprintf(const.subjID),'__Sensitivity bar plot'])
saveas(gcf,fn,'png');

figure;bar(gmsb,1)
hold on
eb = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gmsb,gmBiasStder,'k.','LineWidth',1) % plot the errorbars
legend({'radial','tangential'},'Location','northwest')
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);
title(['S',sprintf(const.subjID),'__Bias Magnitude bar plot'])
xlabel('Eccentricities (degrees)'); ylabel('Bias Magnitude (\mu)');
fnb = fullfile(pf_path,['S',sprintf(const.subjID),'__Bias Magnitude bar plot'])
saveas(gcf,fnb,'png');


% once done, combine this matric with the bigger matrix to do aggregate
% analyses. go to analyze_data_err.m
%% ttests?
% [h7 p7] = ttest(result1.Sensitivity(find(result1.rvt == -1 & result1.Eccentricities == 7)),result1.Sensitivity(find(result1.rvt == 1 & result1.Eccentricities == 7)));
% [h20 p20] = ttest(result1.Sensitivity(find(result1.rvt == -1 & result1.Eccentricities == 20)),result1.Sensitivity(find(result1.rvt == 1 & result1.Eccentricities == 20)));
% [h30 p30] = ttest(result1.Sensitivity(find(result1.rvt == -1 & result1.Eccentricities == 30)),result1.Sensitivity(find(result1.rvt == 1 & result1.Eccentricities == 30)));
% 
% [h7 p7] = ttest(result2.Sensitivity(find(result2.rvt == -1 & result2.Eccentricities == 7)),result2.Sensitivity(find(result2.rvt == 1 & result2.Eccentricities == 7)));
% [h20 p20] = ttest(result2.Sensitivity(find(result2.rvt == -1 & result2.Eccentricities == 20)),result2.Sensitivity(find(result2.rvt == 1 & result2.Eccentricities == 20)));
% [h30 p30] = ttest(result2.Sensitivity(find(result2.rvt == -1 & result2.Eccentricities == 30)),result2.Sensitivity(find(result2.rvt == 1 & result2.Eccentricities == 30)));

[h7 p7] = ttest(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 7)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 7)));
[h20 p20] = ttest(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 20)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 20)));
[h30 p30] = ttest(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 30)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 30)));

% Update my table
d = LMEtable; % rename variable
d.sub = d.("Subject Number"); % remove space from variable 
d.rvt = d.("Radial/Tangential"); % remove / from variable
d = removevars(d, "Subject Number"); 
d = removevars(d,"Radial/Tangential")
AggResult.sub(1:48) = repmat(6,1,48)
LMEtable = vertcat(d,AggResult);
save(fullfile(tablePath,'LMEtable'),'LMEtable')