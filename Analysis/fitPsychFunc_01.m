%% Load variables
close all;
clearvars
i_subj = '14';
block_num = 1; % we are not using block 1 for subjects 10 and 13. analye blocks 2 and 3 instead
git_dir = 'C:\Users\rokers lab 2\Documents\Github';
main_dir = 'Z:\UsersShare\Abel\motionEcc_project' %insert vision directory or 'C:\Users\rokers lab 2\Documents\Github\motion_ecc/
% data_dir_fn = data/';
data_dir = fullfile(main_dir,'Data/StaircaseMode2',i_subj); %data_dir = fullfile(data_dir_fn,i_subj);% '*0*.mat'));

des = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*design*.mat')));
const  = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*const*.mat')));
load(fullfile(const.folder,const.name)); load(fullfile(des.folder,des.name))
expDes.trialMat(:,7) = expDes.response(:,1);
addAnchors = 0;
%% Psychometric Plots
rootpath =  fullfile(main_dir,'Figures/');%("C:\Users\rokers lab 2\Documents\motionEcc_project\Figures\"); %vision Directory
pMatrix = nan(length(expDes.stairs)/2,3);
% addpath(fullfile(git_dir,'psignifit'))
addpath(genpath(fullfile(git_dir,'psignifit')))
%set psignifit plot parameters here
options.sigmoidName  = 'norm';
options.fixedPars      = [nan;  nan; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];
options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle(degrees)';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 2;
plotOptions.lineWidth      = 2;
plotOptions.dataSize = 75;

% initialize sensitivity and bias vectors
Sensitivity = [];
Bias = [];
figure;
if addAnchors == 1 % combine the experiment with anchor points to the existing data. 
    expDes2 = expDes
    i_subj = '24';
    block_num = 3; 
    % data_dir_fn2 = 'C:\Users\rokers lab 2\Documents\Github\motion_ecc/data/StaircaseMode3';
    data_dir2 = fullfile(main_dir,'Data/StaircaseMode3',i_subj);
    des = (dir(fullfile(data_dir2, sprintf('Block%d%',block_num),'*design*.mat')));
    load(fullfile(des.folder,des.name));
    expDes3 = expDes
    expDes3.trialMat(:,7) = expDes3.response(:,1);
    expDes2.trialMat = vertcat(expDes2.trialMat,expDes3.trialMat);
    expDes2.response = vertcat(expDes2.response,expDes3.response);
    expDes2.correctness = vertcat(expDes2.correctness,expDes3.correctness);
    for i = 1:24
        for ii  = 1:16
            expDes2.stairs{1,i}.trialData(60+ii).stim = expDes3.stairs{1,i}.trialAngles(ii)
            expDes2.stairs{1,i}.trialData(60+ii).outcome = 2
        end
    end
    expDes = expDes2;
end
% plot psychometric functions
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
        sp_path = fullfile(rootpath,"\StaircaseMode1\staircase_plot",sprintf(const.subjID));
        pf_path = fullfile(rootpath,"\StaircaseMode1\psychometric_function",sprintf(const.subjID));
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
        filename = fullfile(sp_path, sp_filename);
        filename2 = fullfile(pf_path, pf_filename);

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
            xlim([-40 40]);;
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
            xlim([-40 40]);;
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
elseif const.staircasemode == 2 % QUEST+
    for i=1:(length(expDes.stairs))
        x = [];
        for ii=1:(length(expDes.stairs{1,i}.trialData)) %numel(find(expDes.trialMat(:,6)==i));
            x = [x expDes.stairs{1,i}.trialData(ii).stim];
        end
        x = x';
        currIDx = find(expDes.trialMat(:,6) == i);
        currP = expDes.trialMat(min(currIDx),:);
        PAName = currP(1,2);
        eccName = currP(1,3);
        DirName = currP(1,4);
        pf_path = fullfile(rootpath,"\StaircaseMode2\psychometric_function",sprintf(const.subjID));
        pf_filename = ['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'_PF_',sprintf('m%i',DirName)];
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
           
            if any(Utilt(:,1)>20)
                z = find(Utilt(:,1)>20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z,1));
                Utilt(length(Utilt),2) = sum(Utilt(z,2));
                Utilt(length(Utilt),3) = sum(Utilt(z,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z,4));
                Utilt(z,:) = [];
            end
            if any(Utilt(:,1)<-20)
                z2 = find(Utilt(:,1)<-20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z2,1));
                Utilt(length(Utilt),2) = sum(Utilt(z2,2));
                Utilt(length(Utilt),3) = sum(Utilt(z2,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z2,4));   
                Utilt(z2,:) = [];
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
            xlim([-100 100]); %xlim([-20 20]);;
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % text(min(Utilt(:,1))-1,0.85 ,['a:' num2str(Accuracy(i))],'FontSize',9,'fontweight', 'bold')

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
            if any(Utilt(:,1)>20)
                z = find(Utilt(:,1)>20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z,1));
                Utilt(length(Utilt),2) = sum(Utilt(z,2));
                Utilt(length(Utilt),3) = sum(Utilt(z,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z,4));
                Utilt(z,:) = [];
            end
            if any(Utilt(:,1)<-20)
                z2 = find(Utilt(:,1)<-20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z2,1));
                Utilt(length(Utilt),2) = sum(Utilt(z2,2));
                Utilt(length(Utilt),3) = sum(Utilt(z2,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z2,4));   
                Utilt(z2,:) = [];
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
            xlim([-50 50]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % text(min(Utilt(:,1))-1,0.85 ,['a:' num2str(Accuracy(i))],'FontSize',9,'fontweight', 'bold')
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
           if any(Utilt(:,1)>20)
                z = find(Utilt(:,1)>20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z,1));
                Utilt(length(Utilt),2) = sum(Utilt(z,2));
                Utilt(length(Utilt),3) = sum(Utilt(z,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z,4));
                Utilt(z,:) = [];
            end
            if any(Utilt(:,1)<-20)
                z2 = find(Utilt(:,1)<-20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z2,1));
                Utilt(length(Utilt),2) = sum(Utilt(z2,2));
                Utilt(length(Utilt),3) = sum(Utilt(z2,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z2,4));   
                Utilt(z2,:) = [];
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
            xlim([-40 40]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % text(min(Utilt(:,1))-1,0.85 ,['a:' num2str(Accuracy(i))],'FontSize',9,'fontweight', 'bold')
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
            if any(Utilt(:,1)>20)
                z = find(Utilt(:,1)>20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z,1));
                Utilt(length(Utilt),2) = sum(Utilt(z,2));
                Utilt(length(Utilt),3) = sum(Utilt(z,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z,4));
                Utilt(z,:) = [];
            end
            if any(Utilt(:,1)<-20)
                z2 = find(Utilt(:,1)<-20)
                Utilt(length(Utilt)+1,1) = mean(Utilt(z2,1));
                Utilt(length(Utilt),2) = sum(Utilt(z2,2));
                Utilt(length(Utilt),3) = sum(Utilt(z2,3));
                % Utilt(length(Utilt),4) = sum(Utilt(z2,4));   
                Utilt(z2,:) = [];
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
            xlim([-40 40]);
            title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            text(min(Utilt(:,1))-1,0.9 ,['\mu: ' num2str(fitOutput.Fit(1))],'FontSize',9, 'fontweight', 'bold' )
            text(min(Utilt(:,1))-1,0.95 ,['1/\sigma:' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9,'fontweight', 'bold')
            % text(min(Utilt(:,1))-1,0.85 ,['a:' num2str(Accuracy(i))],'FontSize',9,'fontweight', 'bold')
            % % saveas(gcf,filename2,'fig')
            % saveas(gcf,filename2,'pdf');
            saveas(gcf,filename2,'png');
            hold on
        end
        Sensitivity = [Sensitivity; 1/sqrt(fitOutput.Fit(2))];
        Bias = [Bias; fitOutput.Fit(1)];
    end
% elseif const.staircasemode == 3 % constants
%     NaNind = isnan(expDes.trialMat(find(expDes.trialMat(:,6) == i),7)) % to isolate and remove incomplete trials
%     Allind = expDes.trialMat(find(expDes.trialMat(:,6) == i),7)
%     x(:,2) = Allind(~NaNind);
%     Utilt = unique(x(:,1));
end
% organize important variables in a table
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

%%  sensitivity and Bias magnitude for 1 session
pts = repmat([0.85;1.15;1.85;2.15;2.85;3.15],1,2);
d = result;
d.rvt = d.rvt*-1;
d.BiasMagnitude = abs(d.Bias)
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
gp = groupsummary(d, ["Eccentricities", "PolarAngles","rvt"], "mean")
figure;
% h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
% set(h, 'linestyle', '-');

hold on
g_std = groupsummary(d, ["Eccentricities", "rvt"], "std", "Sensitivity");
g_stdbias = groupsummary(d, ["Eccentricities", "rvt"], "std","BiasMagnitude");
g_std.stder = g_std.std_Sensitivity/sqrt(4);
g_stdbias.stder = g_stdbias.std_BiasMagnitude/sqrt(4);

% reshape variables to make bar plots
gms = (reshape(g.mean_Sensitivity,2,3))';
gmsb = (reshape(g.mean_BiasMagnitude,2,3))';
% sensitivity plot
H1 = bar(gms,1);
hold on
gme = (reshape(g.Eccentricities,2,3))';
gmstder = (reshape(g_std.stder,2,3))'; 
gmBiasStder = (reshape(g_stdbias.stder,2,3))';
e = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gms,gmstder,'k.','LineWidth',1) % plot the errorbars
% Draw lines connecting average sensitivity at each polar angle
for i = 1:3
    H2 = plot((pts([i*2-1 i*2],1)),gp.mean_Sensitivity([i*4-3 i*4-2]),'LineWidth',1.5,'LineStyle','-','Color','black')
    hold on
    H3 = plot((pts([i*2-1 i*2],2)),gp.mean_Sensitivity([i*4-1 i*4]),'LineWidth',1.5,'LineStyle','-.','Color','black')
    hold on
end
% ylim([0 0.65])
legend([H1 H2 H3],{'radial','tangential',sprintf('%d',expDes.polarAngles(1)),sprintf('%d',expDes.polarAngles(2))},'Location','northeast','FontSize', 8);
xlabel('Eccentricities (degrees)'); ylabel('Sensitivity (1/\sigma)');
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);
title(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Sensitivity bar plot'])

fn = fullfile(pf_path,['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Sensitivity bar plot']); % plot name and path
saveas(gcf,fn,'png');
% bias magnitude plot
figure;bar(gmsb,1);
hold on
eb = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gmsb,gmBiasStder,'k.','LineWidth',1) % plot the errorbars
d.rvt = d.rvt*-1 %change back
legend({'radial','tangential'},'Location','northwest')
title(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Bias Magnitude bar plot'])
xlabel('Eccentricities (degrees)'); ylabel('Bias Magnitude (\mu)');
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);

fnb = fullfile(pf_path,['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'__Bias Magnitude bar plot']); % plot name and path
saveas(gcf,fnb,'png');
tablePath = fullfile(main_dir,'Data/Analysis',i_subj); %fullfile('C:\Users\rokers lab 2\Documents\motionEcc_Project\2024_MotionAssymetries\code\data');
if ~isfolder(tablePath)
    mkdir(tablePath);
end
tableName = fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block),'.mat'])
save(tableName,'result') % save table for 1 session
% combine result table from both sessions
%% 
if isfile(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block-1),'.mat'])) 
    load(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block),'.mat']));
    result2 = result;
    load(fullfile(tablePath,['S',sprintf(const.subjID),'session_',sprintf('%d',const.block-1),'.mat']));
    result1  = result;
    AggResult = vertcat(result2,result1);
    AggResult.subjID = repmat(const.subjID_numeric,length(AggResult.rvt),1)
else
    disp('Block does not exist.')
end
tableName = fullfile(tablePath,['S',sprintf(const.subjID),'Agg']);
save(tableName,'AggResult'); % result table for 1 subject



 %% calculating aggregate sensitivity and Bias
% close all
load(tableName);
% AggResult.subjID = repmat(const.subjID,1,48)
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
g_std.stder = g_std.std_Sensitivity/sqrt(8);
g_stdbias.stder = g_stdbias.std_BiasMagnitude/sqrt(8);


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
xticks(1:3);xticklabels({'7','20','30'}); yticks(0:0.05:0.25);
title(['S',sprintf(const.subjID),'__Sensitivity bar plot']);
fn = fullfile(pf_path,['S',sprintf(const.subjID),'__Sensitivity bar plot']);
saveas(gcf,fn,'png');

figure;bar(gmsb,1);
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
%% ttests and effect size
% for individual sessions. uncomment if needed
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

Es1 = meanEffectSize(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 7)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 7)),Effect="cohen",Alpha = 0.05);
Es2 = meanEffectSize(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 20)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 20)),Effect="cohen",Alpha = 0.05);
Es3 = meanEffectSize(AggResult.Sensitivity(find(AggResult.rvt == -1 & AggResult.Eccentricities == 30)),AggResult.Sensitivity(find(AggResult.rvt == 1 & AggResult.Eccentricities == 30)),Effect="cohen",Alpha = 0.05);

%%
% Update table (include new subject data)
% d = LMEtable; % rename variable
% d.sub = d.("Subject Number"); % remove space from variable 
% d.rvt = d.("Radial/Tangential"); % remove / from variable
% d = removevars(d, "Subject Number"); 
% d = removevars(d,"Radial/Tangential")
% % AggResult.sub(1:48) = repmat(6,1,48)
% % LMEtable = vertcat(d,AggResult);
% 
% 
% % save(fullfile(tablePath,'LMEtable'),'LMEtable');
% 
% % For analysis across participants go to /Users/rokers lab
% % 2/Documents/Github/motion_ecc/Analysis/analyze_data_final
% % check if the table exists. check if the subject is loaded in. if not append the subject
% % temp -- add subject ID to the existing tables
 %% 
data_dir = dir(fullfile(tablePath, '*Agg.mat'));
data_fn = {data_dir.name}';
if ~isfile(fullfile(tablePath,'LMEtable.mat'))
    for ii = 1:numel(data_fn);  %(unique(LMEtable.sub))
        subData = 'S%d%Agg.mat'
        load(fullfile(tablePath,data_fn{ii}))
        if ii ==1
            LMEtable = AggResult
        else
            LMEtable = vertcat(LMEtable,AggResult);
        end

        % if ~any(LMEtable.subjID == AggResult.subjID) %sprintf(subData,ii)
        %     LMEtable = vertcat(LMEtable,AggResult);
        % else
        %     disp('Subject already exists')
        % end
    end
end
save(fullfile(tablePath,'LMEtable'),'LMEtable');
