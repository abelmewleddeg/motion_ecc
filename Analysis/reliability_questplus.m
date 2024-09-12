%% Load variables
close all;
clearvars
i_subj = '26';
block_num = 2; % we are not using block 1 for subjects 10 and 13. analye blocks 2 and 3 instead
git_dir = 'C:\Users\rokers lab 2\Documents\Github';
main_dir = 'Z:\UsersShare\Abel\motionEcc_project' %insert vision directory or 'C:\Users\rokers lab 2\Documents\Github\motion_ecc/
% data_dir_fn = data/';
data_dir = fullfile(main_dir,'Data/StaircaseMode2',i_subj); %data_dir = fullfile(data_dir_fn,i_subj);% '*0*.mat'));

des = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*design*.mat')));
const  = (dir(fullfile(data_dir, sprintf('Block%d%',block_num),'*const*.mat')));
load(fullfile(const.folder,const.name)); load(fullfile(des.folder,des.name))
expDes.trialMat(:,7) = expDes.response(:,1);
addAnchors = 1;

%% reliablbility plots
rootpath =  fullfile(main_dir,'Figures/')
% expDes.trialMat(:,7) = expDes.response(:,1);
pMatrix = nan(length(expDes.stairs)/2,3);
figure;
%addpath(genpath(const.MainDirectory,'/psignifit'));
options.sigmoidName  = 'norm';
options.fixedPars      = [nan; nan ; 0; 0.01;nan];
%options.borders(3,:)=[0,.1];

options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 1;
plotOptions.dataColor = [0 0.4470 0.7410];
plotOptions.lineColor = [0 0.4470 0.7410];
vvvv = nan(24,30);
Sens6 = nan(24,12);
Bias6 = nan(24,12);
 for i=1:(length(expDes.stairs))
        figure(i);
        tick = [];
        for iui = 1:(ceil(length(expDes.stairs{1,i}.trialData)/5))
             x = [];
             y = [(5:5:5*(ceil(length(expDes.stairs{1,i}.trialData)/5)-1)) length(expDes.stairs{1,i}.trialData)];
             ii = 5*iui; 
             orr = [5 10 15 20 25 30 35 40 45 50 55 length(expDes.stairs{1,i}.trialData)];
             for ii= 1:orr(iui) %1:(length(expDes.stairs{1,i}.trialData)); 
                x = [x expDes.stairs{1,i}.trialData(ii).stim];
             end
             % if  iui <= (ceil(length(expDes.stairs{1,i}.trialData)/5)-1) %mod(length(expDes.stairs{1,i}.trialData),5) == 0;%
             %     for ii= 1:5*iui %1:(length(expDes.stairs{1,i}.trialData)); 
             %            x = [x expDes.stairs{1,i}.trialData(ii).stim];
             % 
             %     end
             % % elseif  ii == length(expDes.stairs{1,i}.trialData) %iui >=5 && iui<6  %mod(length(expDes.stairs{1,i}.trialData),5) == 0;%iui <6
             % %     for ii= 1:(length(expDes.stairs{1,i}.trialData)) 
             % %            x = [x expDes.stairs{1,i}.trialData(ii).stim];
             % %     end
             % else %ii > 25 && length( expDes.stairs{1,i}.trialData) > 25
             %        % iui = 6
             %        x = [];
             %        for ii = 1:length(expDes.stairs{1,i}.trialData)
             %             x = [x expDes.stairs{1,i}.trialData(ii).stim];
             %        end
             % end
            x = x';
            currIDx = find(expDes.trialMat(:,6) == i);
            currP = expDes.trialMat(min(currIDx),:);
            PAName = currP(1,2);
            eccName = currP(1,3);
            DirName = currP(1,4);
            %if  i == 7;% mod(i+4,4) ==1
            tiltResponses =  [expDes.trialMat(find(expDes.trialMat(:,6) == i),7)];
            x(:,2) =tiltResponses(1:ii);
            Utilt = unique(x(:,1));
            for ix = 1:length(Utilt);
                Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                 %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
            end
            oi = floor((i+4)/4);
            
           %hold on
           % set(gcf,'Position',get(0,'ScreenSize'));
           % if iui <= 6
           %     figure(1);
           %     set(gcf,'Position',get(0,'ScreenSize'));
           %     subplot(2,3,iui);
           % else
           %     figure(2);
           %     set(gcf,'Position',get(0,'ScreenSize'));
           %     subplot(2,3,iui-6);
           % end
            % set(gcf,'Position',get(0,'ScreenSize'));

            fitOutput6(iui,i) = psignifit(Utilt,options);
            Sens6(i,iui) =  1/sqrt(fitOutput6(iui,i).Fit(2));
            
            Bias6(i,iui) = fitOutput6(iui,i).Fit(1);
            % plotPsych(fitOutput6,plotOptions)
            % title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            % text(max(Utilt(:,1))/2,0.1 ,['B: ' num2str(fitOutput6.Fit(1))],'FontSize',9)
            % text(max(Utilt(:,1))/2,0.15 ,['S: ' num2str(1/sqrt(fitOutput6.Fit(2)))],'FontSize',9)
            % % %saveas(gcf,'C:\Users\rokers lab 2\Documents\PsyDir 45.png'); 
            tick = [tick iui];
            % plot(Bias6,'k.','MarkerSize',25);
            % hold on
            % plot(Bias6,'-b')
            % hold off
            subplot(1,2,1);
            plot(Sens6(i,:),'.','MarkerSize',25,'Color',"#0072BD")
            hold on
            plot(Sens6(i,:),'-b')
            hold off
            xticks(tick);
            xticklabels(y(1:iui)) %('5','10','15','20','25','30','35','40','45','50','55','60')
            % xlabel('Staircase Iterations'); ylabel('Bias6');title(['S',sprintf(const.subjID),'__Reliability Plot_',sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Staircase Iterations'); ylabel('Sens6itivity');
            % title(['S',sprintf(const.subjID),'__Reliability Plot_',sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            %ylim([-8 6]);yticks(-8:6)
            ylim([0 1.1]);yticks(0:0.1:1.1)
          %saveas(gcf,'C:\Users\rokers lab 2\Documents\)
            %end
        end
    title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    subplot(1,2,2);
    plotPsych(fitOutput6(12,i),plotOptions)
    title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-20 20]);
    text(max(Utilt(:,1))/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(max(Utilt(:,1))/2,0.15 ,['1/\sigma: ' num2str(1/sqrt(fitOutput6(1,i).Fit(2)))],'FontSize',9)
    % %saveas(gcf,'C:\Users\rokers lab 2\Documents\PsyDir 45.png'); 
    set(gcf,'Position',[488 242 1.0186e+03 420]);
    filepath = fullfile(rootpath,'StaircaseMode2/reliability',i_subj)
     if ~isfolder(filepath)
            mkdir(filepath);
     end
    filename = ['S',sprintf(const.subjID),'__Reliability Plot_',sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName)]
    filename2 = fullfile(filepath,filename)
   %  % xticklabels('5','10','15','20','25','30','35','40','45','50','55','60')
   % filename = ['C:\Users\rokers lab 2\Documents\motionEcc_project\Figures\StaircaseMode2\reliability\',sprintf(const.subjID),['\S',sprintf(const.subjID),'_reliability_plot__', sprintf('pa%i_ecc%i_m%i', PAName,eccName,DirName)]];
   % saveas(gcf,filename,'fig');
   % saveas(gcf,filename,'pdf');
   saveas(gcf,filename2,'png');   

 end
 % % save('Sens6.mat','Sens6');
 % save('Bias6.mat','Bias6');
 % save('fitOutput6.mat','fitOutput6');
 %% Let's also plot rt here
 rt = [];
%  for i=1:length(expDes.stairs)
%     currIDx = find(expDes.trialMat(:,6) == i);
%     currP = expDes.trialMat(min(currIDx),:);
%     PAName = currP(1,2);
%     eccName = currP(1,3);
%     DirName = currP(1,4);
    stim_on = expDes.stimulus_onsets(isnan(expDes.stimulus_onsets) == 0);
    rt_on = expDes.rt_onset(isnan(expDes.rt_onset) == 0);
    % rtIDx = find(expDes.trialMat(:,6) == i);
    % rt = [rt nanmean(expDes.rt_onset(rtIDx)-stim_on(rtIDx))]
%  e
NaNInd = find(isnan(expDes.trialMat(:,5))==0);
stairN = expDes.trialMat(:,6);
 st = (stairN(NaNInd) == [2 4 14 16]);
 rtIDx4R = find(sum(st,2) == 1);
  rt4R = rt_on(rtIDx4R)-stim_on(rtIDx4R);
  rt4R((rt4R >=10)) = nan;

  st = (stairN(NaNInd) == ([1 3 13 15]));
  rtIDx4T = find(sum(st,2) == 1);
  rt4T = rt_on(rtIDx4T)-stim_on(rtIDx4T);
  rt4T((rt4T >=10)) = nan;

  st = (stairN(NaNInd) == ([6 8 18 20]));
  rtIDx8R = find(sum(st,2) == 1);
  rt8R = rt_on(rtIDx8R)-stim_on(rtIDx8R);
  rt8R((rt8R >=10)) = nan;

  st = (stairN(NaNInd) == ([5 7 17 19]));
  rtIDx8T = find(sum(st,2) == 1);
  rt8T = rt_on(rtIDx8T)-stim_on(rtIDx8T);
  rt8T((rt8T >=10)) = nan;

  st = (stairN(NaNInd) == ([10 12 22 24]));
  rtIDx12R = find(sum(st,2) == 1);
  rt12R = rt_on(rtIDx12R)-stim_on(rtIDx12R);
  rt12R((rt12R >=10)) = nan;

  st = (stairN(NaNInd) == ([9 11 21 23]));
  rtIDx12T = find(sum(st,2) == 1);
  rt12T = rt_on(rtIDx12T)-stim_on(rtIDx12T);
  rt12T((rt12T >=10)) = nan;
 pts = [0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85  2.85 2.85 2.85; 3.15 3.15 3.15 3.15];
figure;
w = [nanmean(rt4R),nanmean(rt4T);nanmean(rt8R),nanmean(rt8T);nanmean(rt12R),nanmean(rt12T)];
 %wxx3 = [rt4R;rt4T;rt8R;rt8T;rt12R;rt12T];
%Bias63 = [Becc4R;Becc4T;Becc8R;Becc8T;Becc12R;Becc12T]
ww = [nanmean(rt4R),nanmean(rt4T),nanmean(rt8R),nanmean(rt8T),nanmean(rt12R),nanmean(rt12T)];
% w = [radE4,tanE4;radE8,tanE8;radE12,tanE12]
% wxx = [r4;t4;r8;t8;r12;t12]
% ww = [radE4,tanE4,radE8,tanE8,radE12,tanE12]
bar(w,1)
hold on 
RT = vertcat(rt4R,rt4T,rt8R,rt8T,rt12R,rt12T);
stder = nanstd(RT')/sqrt(size(RT,2))
% stder = [(nanstd(rt4R)/sqrt(240))';(nanstd(rt4T)/sqrt(240))';(nanstd(rt8R)/sqrt(240))';(nanstd(rt8T)/sqrt(240))';(nanstd(rt12R)/sqrt(240))';(nanstd(rt12T)/sqrt(240))'];
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],ww,stder,'b.')
Ymax = (max(w,[],'all')+  0.5);
legend({'radial','tangential'})
ylim([0 Ymax]);
xlabel('Eccentricities(degrees)'); ylabel('Response Time(s)');
xticklabels({'7','20','30'});%yticks(0:0.2:Ymax);
title(['S',sprintf(const.subjID),'Response Time bar plot']);
% filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\reactiontime\',sprintf(const.subjID),['\S',sprintf(const.subjID),'_reactiontime']];
% saveas(gcf,filename,'fig');
% saveas(gcf,filename,'pdf');
filenameRT = fullfile(filepath,[sprintf('S%i_ses_%i',const.subjID_numeric,const.block),'RT']);
saveas(gcf,filenameRT,'png');
% save(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'RT1'],'RT');
% save(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'RTW1'],'w');
% save(['S',sprintf(const.subjID),'ses_',sprintf('%d',const.block),'RTWW1'],'ww');

% hold on 
% stder = (std(wxx3')/sqrt(4))'
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
% errorbar([0.85,1.15,1.85,2.15,2.85,3.15],ww,stder,'b.')
%%
RT2 = RT;
w2 = w
ww2 = ww
load('S18ses_1RT1.mat');
load('S18ses_1RTW1.mat');
load('S18ses_1RTWW1.mat');

RTW = (w +w2)/2;
RTT = (RT2+RT)/2;
RTWW = (ww +ww2)/2;
figure;
bar(RTW,1)
hold on 
stder = nanstd(RTT')/sqrt(size(RTT,2))
% stder = [(nanstd(rt4R)/sqrt(240))';(nanstd(rt4T)/sqrt(240))';(nanstd(rt8R)/sqrt(240))';(nanstd(rt8T)/sqrt(240))';(nanstd(rt12R)/sqrt(240))';(nanstd(rt12T)/sqrt(240))'];
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],nanmean(RTT'),stder,'b.')
Ymax = (max(RTW,[],'all')+0.5);
legend({'radial','tangential'})
ylim([0 Ymax]);
xlabel('Eccentricities(degrees)'); ylabel('Response Time(s)');
xticklabels({'4','8','12'});%yticks(0:0.2:Ymax);
title(['S',sprintf(const.subjID),'Response Time bar plot']);

filename4 = fullfile(pf_path, ['S',sprintf(const.subjID),'__summary_RT_plot'])
saveas(gcf,filename4,'png');

save(['S',sprintf(const.subjID),'RT'],'RT');
save(['S',sprintf(const.subjID),'RTW'],'w');
save(['S',sprintf(const.subjID),'RTWW'],'ww');
%%

figure
load('S10RT.mat'); 
load('S10RTW.mat');
load('S10RTWW.mat');
R1T = RT;
w1 = w
ww1 = ww


load('S13RT.mat'); 
load('S13RTW.mat');
load('S13RTWW.mat');
R2T = RT;
w2 = w
ww2 = ww

load('S14RT.mat'); 
load('S14RTW.mat');
load('S14RTWW.mat');
R3T = RT;
w3 = w
ww3 = ww

load('S15RT.mat'); 
load('S15RTW.mat');
load('S15RTWW.mat');
R4T = RT;
w4 = w
ww4 = ww

load('S18RT.mat'); 
load('S18RTW.mat');
load('S18RTWW.mat');
R5T = RT;
w5 = w
ww5 = ww
% 
% load('S17.mat'); 
% load('S17w3.mat');
% load('S17wL3.mat');

% w35 = w3;
% wx5x = wxx;
% w5L3 = wL3;
% 
% load('S18ses_1.mat'); 
% load('S18ses_1w.mat');
% load('S18ses_1wL.mat');
RTWt = (w1 +w2 +w3 +w4)/4;
RTTt = (R1T+R2T+R3T+R4T)/4;
RTWWt = (ww1 +ww2+ ww3 +ww4)/4;
figure;
bar(RTWt,1)
hold on 
stder = nanstd(RTTt')/sqrt(size(RTTt,2))
% stder = [(nanstd(rt4R)/sqrt(240))';(nanstd(rt4T)/sqrt(240))';(nanstd(rt8R)/sqrt(240))';(nanstd(rt8T)/sqrt(240))';(nanstd(rt12R)/sqrt(240))';(nanstd(rt12T)/sqrt(240))'];
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],nanmean(RTTt'),stder,'k.','LineWidth',1)
Ymax = (max(RTWt,[],'all')+0.5);
legend({'radial','tangential'})
ylim([0 Ymax]);
xlabel('Eccentricities(degrees)'); ylabel('Response Time(s)');
xticklabels({'7','20','30'});%yticks(0:0.2:Ymax);
title('Response Time bar plot');

filename4 = ('Summary_RT_plot')
saveas(gcf,filename4,'png');