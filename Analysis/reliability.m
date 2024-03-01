% reliablbility plots
close all;
expDes.trialMat(:,7) = expDes.response(:,1);
pMatrix = nan(length(expDes.stairs)/2,3);
figure;
%addpath(genpath(const.MainDirectory,'/psignifit'));
options.sigmoidName  = 'norm';
options.fixedPars      = [nan; nan ; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];

options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 1;
vvvv = nan(24,30);
 for i=1:(length(expDes.stairs))
        figure(i);
        Sens = [];
        Bias = [];
        tick = [];
        for iui = 1:(ceil(length(expDes.stairs{1,i}.trialData)/5))
             x = [];
             y = [(5:5:5*(ceil(length(expDes.stairs{1,i}.trialData)/5)-1)) length(expDes.stairs{1,i}.trialData)]
             ii = 5*iui; 
             for ii= 1:5*iui; %1:(length(expDes.stairs{1,i}.trialData)); 
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
            for ix = 1:length(Utilt)
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

            fitOutput = psignifit(Utilt,options);
            Sens =  [Sens 1/sqrt(fitOutput.Fit(2))];
            Bias = [Bias fitOutput.Fit(1)]
            % plotPsych(fitOutput,plotOptions)
            % title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
            % % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
            % text(max(Utilt(:,1))/2,0.1 ,['B: ' num2str(fitOutput.Fit(1))],'FontSize',9)
            % text(max(Utilt(:,1))/2,0.15 ,['S: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
            % % %saveas(gcf,'C:\Users\rokers lab 2\Documents\PsyDir 45.png'); 
            tick = [tick iui];
            % plot(Bias,'k.','MarkerSize',25);
            % hold on
            % plot(Bias,'-b')
            % hold off
            subplot(1,2,1);
            plot(Sens,'k.','MarkerSize',25)
            hold on
            plot(Sens,'-b')
            hold off
            xticks(tick);
            xticklabels(y(1:iui)) %('5','10','15','20','25','30','35','40','45','50','55','60')
            % xlabel('Staircase Iterations'); ylabel('Bias');title(['S',sprintf(const.subjID),'__Reliability Plot_',sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            xlabel('Staircase Iterations'); ylabel('Sensitivity');title(['S',sprintf(const.subjID),'__Reliability Plot_',sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName)])
            %ylim([-8 6]);yticks(-8:6)
            ylim([0 1.1]);yticks(0:0.1:1.1)
          %saveas(gcf,'C:\Users\rokers lab 2\Documents\)
            %end
        end
    subplot(1,2,2);
    plotPsych(fitOutput,plotOptions)
    title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-20 20]);
    text(max(Utilt(:,1))/2,0.1 ,['\mu ' num2str(fitOutput.Fit(1))],'FontSize',9)
    text(max(Utilt(:,1))/2,0.15 ,['1/\sigma: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
    % %saveas(gcf,'C:\Users\rokers lab 2\Documents\PsyDir 45.png'); 
    set(gcf,'Position',[488 242 1.0186e+03 420]);

   %  % xticklabels('5','10','15','20','25','30','35','40','45','50','55','60')
   filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode2\reliability\',sprintf(const.subjID),['\S',sprintf(const.subjID),'_reliability_plot__', sprintf('pa%i_ecc%i_m%i', PAName,eccName,DirName)]];
   saveas(gcf,filename,'fig');
   % saveas(gcf,filename,'pdf');
   saveas(gcf,filename,'png');   

 end
 %% Let's also plot rt here
 rt = []
%  for i=1:length(expDes.stairs)
%     currIDx = find(expDes.trialMat(:,6) == i);
%     currP = expDes.trialMat(min(currIDx),:);
%     PAName = currP(1,2);
%     eccName = currP(1,3);
%     DirName = currP(1,4);
    stim_on = expDes.stimulus_onsets(isnan(expDes.stimulus_onsets) == 0)
    rt_on = expDes.rt_onset(isnan(expDes.rt_onset) == 0);
    % rtIDx = find(expDes.trialMat(:,6) == i);
    % rt = [rt nanmean(expDes.rt_onset(rtIDx)-stim_on(rtIDx))]
%  e
NaNInd = find(isnan(expDes.trialMat(:,5))==0)
stairN = expDes.trialMat(:,6)
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
 pts = [0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85 2.85 2.85 2.85; 3.15 3.15 3.15 3.15];
figure;
w = [nanmean(rt4R),nanmean(rt4T);nanmean(rt8R),nanmean(rt8T);nanmean(rt12R),nanmean(rt12T)];
 %wxx3 = [rt4R;rt4T;rt8R;rt8T;rt12R;rt12T];
%Bias3 = [Becc4R;Becc4T;Becc8R;Becc8T;Becc12R;Becc12T]
ww = [nanmean(rt4R),nanmean(rt4T),nanmean(rt8R),nanmean(rt8T),nanmean(rt12R),nanmean(rt12T)];
% w = [radE4,tanE4;radE8,tanE8;radE12,tanE12]
% wxx = [r4;t4;r8;t8;r12;t12]
% ww = [radE4,tanE4,radE8,tanE8,radE12,tanE12]
bar(w)
hold on 
stder = [(nanstd(rt4R)/sqrt(4))';(nanstd(rt4T)/sqrt(4))';(nanstd(rt8R)/sqrt(4))';(nanstd(rt8T)/sqrt(4))';(nanstd(rt12R)/sqrt(4))';(nanstd(rt12T)/sqrt(4))']
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],ww,stder,'b.')
%Ymax = (max(wxx3,[],'all'));
legend({'radial','tangential'})
%ylim([0 Ymax]
xlabel('Eccentricities(degrees)'); ylabel('Reaction Time(s)');
xticklabels({'4','8','12'});%yticks(0:0.2:Ymax);
title(['S',sprintf(const.subjID),'__Reaction Time bar plot']);
filename = ['Z:\UsersShare\Abel\motionEcc_project\Figures\StaircaseMode1\reactiontime\',sprintf(const.subjID),['\S',sprintf(const.subjID),'_reactiontime']];
% saveas(gcf,filename,'fig');
% saveas(gcf,filename,'pdf');
saveas(gcf,filename,'png');

% hold on 
% stder = (std(wxx3')/sqrt(4))'
% plot(pts,wxx3,'.','MarkerSize',12)
% hold on
% errorbar([0.85,1.15,1.85,2.15,2.85,3.15],ww,stder,'b.')

