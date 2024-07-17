close all;
load('fitOutput3.mat');
load('fitOutput2.mat');
load('fitOutput1.mat');
load('Sens3.mat');
load('Sens2.mat');
load('Sens1.mat');

load('Bias3.mat');
load('Bias2.mat');
load('Bias1.mat');

% figure;
%addpath(genpath(const.MainDirectory,'/psignifit'));
options.sigmoidName  = 'norm';
options.fixedPars      = [nan; nan ; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];

options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 1;
plotOptions.lineWidth      = 2;
plotOptions.dataSize = 1;
titles = {' S2 ecc 7 Dir 45','S2 ecc 7 Dir 135','S2 ecc 7 Dir 225','S2 ecc 7 Dir 315','S2 ecc 20 Dir 45','S2 ecc 20 Dir 135','S2 ecc 20 Dir 225','S2 ecc 20 Dir 315','S2 ecc 30 Dir 45','S2 ecc 30 Dir 135','S2 ecc 30 Dir 225','S2 ecc 30 Dir 315'};

for i = 1:(length(Bias3(:,1))/2)
    figure;
    subplot(1,2,1);
    S1 =  plot(Bias1(i,:),'.','MarkerSize',25,'Color',"#4DBEEE");
    hold on
    plot(Bias1(i,:),"-",'Color',"#4DBEEE");
    hold on
    S2 = plot(Bias1(i+12,:),'.','MarkerSize',25,'Color','m');
    hold on
    plot(Bias1(i+12,:),'-m');
    hold on

    subplot(1,2,1);
    S3 = plot(Bias2(i,:),'.','MarkerSize',25,'Color','r');
    hold on
    plot(Bias2(i,:),'-r');
    hold on
    S4 = plot(Bias2(i+12,:),'.','MarkerSize',25,'Color','k');
    hold on
    plot(Bias2(i+12,:),'-k');
    hold on

    subplot(1,2,1);
    S5 = plot(Bias3(i,:),'.','MarkerSize',25,'Color','b');
    hold on
    plot(Bias3(i,:),'-b');
    hold on
    S6 = plot(Bias3(i+12,:),'.','MarkerSize',25,'Color',"#7E2F8E");
    hold on
    plot(Bias3(i+12,:),'-','Color',"#7E2F8E");

    tick = (1:12)
    xticks(tick);
    xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
    legend([S1 S2 S3 S4 S5 S6],{'45 (before)','225 (before)','135(after)','315(after)','45 (after)', '225(after)'});
    xlabel('Staircase Iterations'); ylabel('Sensitivity (1/\sigma)');

    title(titles{i})
    hold on

    subplot(1,2,2);
    plotPsych(fitOutput1(1,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.15 ,['1/\sigma: ' num2str(1/sqrt(fitOutput1(1,i).Fit(2)))],'FontSize',9,'Color',[0.3010 0.7450 0.9330])
    plotOptions.dataColor = [0.3010 0.7450 0.9330];
    plotOptions.lineColor = [0.3010 0.7450 0.9330];
    xlim([-30 30]);
    hold on

    plotPsych(fitOutput1(1,i+12),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.2 ,['1/\sigma: ' num2str(1/sqrt(fitOutput1(1,i+12).Fit(2)))],'FontSize',9,'Color', 'm')
    plotOptions.dataColor = [1 0 1];
    plotOptions.lineColor = [1 0 1];
    xlim([-30 30]);
    hold on

    plotPsych(fitOutput2(1,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.25 ,['1/\sigma: ' num2str(1/sqrt(fitOutput2(1,i).Fit(2)))],'FontSize',9,'Color','r')
    plotOptions.dataColor = [1 0 0];
    plotOptions.lineColor = [1 0 0];
    xlim([-30 30]);
    hold on

    plotPsych(fitOutput2(1,i+12),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.3 ,['1/\sigma: ' num2str(1/sqrt(fitOutput2(1,i+12).Fit(2)))],'FontSize',9,'Color','k')
    plotOptions.dataColor = [0 0 0];
    plotOptions.lineColor = [0 0 0];
    hold on

    plotPsych(fitOutput3(1,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.35 ,['1/\sigma: ' num2str(1/sqrt(fitOutput3(1,i).Fit(2)))],'FontSize',9,'Color','b')
    plotOptions.dataColor = [0 0 1];
    plotOptions.lineColor = [0 0 1];
    xlim([-30 30]);
    hold on

    plotPsych(fitOutput3(1,i+12),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
    text(20,0.4 ,['1/\sigma: ' num2str(1/sqrt(fitOutput3(1,i+12).Fit(2)))],'FontSize',9,'Color',[0.4940 0.1840 0.5560])
    plotOptions.dataColor = [0.4940 0.1840 0.5560];
    plotOptions.lineColor = [0.4940 0.1840 0.5560];
    xlim([-30 30]);
    title(titles{i})


    % set(gcf,'Position',[50 242 2.0186e+03 820]);
    set(gcf,'Position',[10 100 1500 650]);
    filename = titles
    saveas(gcf,titles{i},'png');

end


%% Do the same thing for the other subject

close all;
load('fitOutput6.mat');
% load('fitOutput5.mat');
% load('fitOutput4.mat');
load('fitOutput13.mat');
load('fitOutput14.mat');
load('fitOutput15.mat');
load('Bias6.mat');
% load('Sens5.mat');
% load('Sens4.mat');
load('Bias13.mat');
load('Bias14.mat');
load('Bias15.mat');
%%
% figure;
%addpath(genpath(const.MainDirectory,'/psignifit'));
close all;
options.sigmoidName  = 'norm';
options.fixedPars      = [nan; nan ; 0; 0.01;nan];
% options.borders(3,:)=[0,.1];

options.expType = 'equalAsymptote';
plotOptions.xLabel         = 'Tilt Angle';     % xLabel
plotOptions.yLabel         = '% of clockwise responses';
plotOptions.extrapolLength = 1;
plotOptions.lineWidth      = 2;
plotOptions.dataSize = 50;
titles = {'S1 ecc 7 Dir 45','S1 ecc 7 Dir 135','S1 ecc 7 Dir 225','S1 ecc 7 Dir 315','S1 ecc 20 Dir 45','S1 ecc 20 Dir 135','S1 ecc 20 Dir 225','S1 ecc 20 Dir 315','S1 ecc 30 Dir 45','S1 ecc 30 Dir 135','S1 ecc 30 Dir 225','S1 ecc 30 Dir 315'};
C1 = nan(1,4);
C2 = nan(1,4);
C3 = nan(1,4);
C4 = nan(1,4);
C5 = nan(1,4);
C6 = nan(1,4);
C7 = nan(1,4);
C8 = nan(1,4);



for i = 1:4 %(length(Bias13(:,1))/2)
    x = (1:12);
    jitter_amount = 0.5; % Adjust the amount of jitter as needed
    jitter = jitter_amount * (rand(size(x)) - 0.5);
    x_jittered = x;  %x + jitter;
    figure;
    subplot(1,2,1);
    for ii = 1:12
        plot(Bias6(i+8,:),".-",'Color',"#4DBEEE");
        hold on
        % errorLower = 1./sqrt(fitOutput6(ii,i+8).Fit(2)) - 1./sqrt(fitOutput6(ii,i+8).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput6(ii,i+8).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput6(ii,i+8).Fit(2));
        errorLower = (fitOutput6(ii,i+8).Fit(1)) - (fitOutput6(ii,i+8).conf_Intervals(1,1,1));
        errorUpper = (fitOutput6(ii,i+8).conf_Intervals(1,2,1)) - (fitOutput6(ii,i+8).Fit(1));

        %CI1(1,i) = 1./sqrt(fitOutput6(ii,i+8).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput6(ii,i+8).conf_Intervals(2,2,1));
        CI1(1,i) = fitOutput6(ii,i+8).conf_Intervals(1,2,1) - (fitOutput6(ii,i+8).conf_Intervals(1,1,1));
        S1 = errorbar(x_jittered(ii),Bias6(i+8,ii),errorLower,errorUpper,'.','Color',"#4DBEEE")
        % S1 =  plot([ii ii],1./sqrt(fitOutput6(ii,i+8).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k') %"#4DBEEE");


        % S1 =  plot(Bias6(i+8,:),'.','MarkerSize',25,'Color',"#4DBEEE");
        % hold on
        % plot(Bias6(i+8,:),"-",'Color',"#4DBEEE");
        hold on
        plot(Bias6(i+20,:),'.-','Color',"#D95319");
        hold on
        % errorLower = 1./sqrt(fitOutput6(ii,i+20).Fit(2)) - 1./sqrt(fitOutput6(ii,i+20).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput6(ii,i+20).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput6(ii,i+20).Fit(2));
        errorLower = (fitOutput6(ii,i+20).Fit(1)) - (fitOutput6(ii,i+20).conf_Intervals(1,1,1));
        errorUpper = (fitOutput6(ii,i+20).conf_Intervals(1,2,1)) - (fitOutput6(ii,i+20).Fit(1));

        %CI2(1,i) = 1./sqrt(fitOutput6(ii,i+20).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput6(ii,i+20).conf_Intervals(2,2,1))
        CI2(1,i) = fitOutput6(ii,i+20).conf_Intervals(1,2,1) - (fitOutput6(ii,i+20).conf_Intervals(1,1,1));

        S2 = errorbar(x_jittered(ii),Bias6(i+20,ii),errorLower,errorUpper,'.','Color',"#D95319")
        % S2 = plot(Bias6(i+20,:),'.','MarkerSize',25,'Color',"#D95319");
        % S2 =  plot([ii ii],1./sqrt(fitOutput6(ii,i+20).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        hold on

        % hold on

        subplot(1,2,1);
        plot(Bias13(i,:),'.-','Color',"#0072BD");
        hold on
        % S3 = plot(Bias13(i,:),'.','MarkerSize',25,'Color',"#0072BD");
        % errorLower = 1./sqrt(fitOutput13(ii,i).Fit(2)) - 1./sqrt(fitOutput13(ii,i).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput13(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput13(ii,i).Fit(2));
        errorLower = (fitOutput13(ii,i).Fit(1)) - (fitOutput13(ii,i).conf_Intervals(1,1,1));
        errorUpper = (fitOutput13(ii,i).conf_Intervals(1,2,1)) - (fitOutput13(ii,i).Fit(1));

        %CI3(1,i) = 1./sqrt(fitOutput13(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput13(ii,i).conf_Intervals(2,2,1));
        CI3(1,i) = fitOutput13(ii,i).conf_Intervals(1,2,1) - (fitOutput13(ii,i).conf_Intervals(1,1,1));

        S3 = errorbar(x_jittered(ii),Bias13(i,ii),errorLower,errorUpper,'.','Color',"#0072BD")
        % S3 =  plot([ii ii],1./sqrt(fitOutput13(ii,i).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        hold on

        plot(Bias13(i+4,:),'.-r');
        hold on
        % errorLower = 1./sqrt(fitOutput13(ii,i+4).Fit(2)) - 1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput13(ii,i+4).Fit(2));
        errorLower = (fitOutput13(ii,i+4).Fit(1)) - (fitOutput13(ii,i+4).conf_Intervals(1,1,1));
        errorUpper = (fitOutput13(ii,i+4).conf_Intervals(1,2,1)) - (fitOutput13(ii,i+4).Fit(1));

        %CI4(1,i) = 1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,2,1));;
        CI4(1,i) = fitOutput13(ii,i+4).conf_Intervals(1,2,1) - (fitOutput13(ii,i+4).conf_Intervals(1,1,1));

        S4 = errorbar(x_jittered(ii),Bias13(i+4,ii),errorLower,errorUpper,'.','Color',"r")
        % S4 =  plot([ii ii],1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        % S4 = plot(Bias13(i+4,:),'.','MarkerSize',25,'Color','r');

        hold on


        subplot(1,2,1);

        plot(Bias14(i,:),'.-','Color',"b");
        hold on
        % errorLower = 1./sqrt(fitOutput14(ii,i).Fit(2)) - 1./sqrt(fitOutput14(ii,i).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput14(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput14(ii,i).Fit(2));
        errorLower = (fitOutput14(ii,i).Fit(1)) - (fitOutput14(ii,i).conf_Intervals(1,1,1));
        errorUpper = (fitOutput14(ii,i).conf_Intervals(1,2,1)) - (fitOutput14(ii,i).Fit(1));
        S5 = errorbar(x_jittered(ii),Bias14(i,ii),errorLower,errorUpper,'.','Color',"b")
        %CI5(1,i) = 1./sqrt(fitOutput14(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput14(ii,i).conf_Intervals(2,2,1));
        CI5(1,i) = fitOutput14(ii,i).conf_Intervals(1,2,1) - (fitOutput14(ii,i).conf_Intervals(1,1,1));
        % S5 = plot(Bias14(i,:),'.','MarkerSize',25,'Color','b');
        % S5 =  plot([ii ii],1./sqrt(fitOutput14(ii,i).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        hold on

        plot(Bias14(i+4,:),'.-','Color',"#A2142F");
        hold on
        % S6 = plot(Bias14(i+4,:),'.','MarkerSize',25,'Color',"#A2142F");
        % errorLower = 1./sqrt(fitOutput14(ii,i+4).Fit(2)) - 1./sqrt(fitOutput14(ii,i+4).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput14(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput14(ii,i+4).Fit(2));
        errorLower = (fitOutput14(ii,i+4).Fit(1)) - (fitOutput14(ii,i+4).conf_Intervals(1,1,1));
        errorUpper = (fitOutput14(ii,i+4).conf_Intervals(1,2,1)) - (fitOutput14(ii,i+4).Fit(1));
        S6 = errorbar(x_jittered(ii),Bias14(i+4,ii),errorLower,errorUpper,'.','Color',"#A2142F")
        %CI6(1,i) = 1./sqrt(fitOutput14(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput14(ii,i+4).conf_Intervals(2,2,1));
        CI6(1,i) = fitOutput14(ii,i+4).conf_Intervals(1,2,1) - (fitOutput14(ii,i+4).conf_Intervals(1,1,1));
        % S6 =  plot([ii ii],1./sqrt(fitOutput13(ii,i+4).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        hold on

        subplot(1,2,1);

        plot(Bias15(i,:),'.-','Color',"g");
        hold on
        % errorLower = 1./sqrt(fitOutput15(ii,i).Fit(2)) - 1./sqrt(fitOutput15(ii,i).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput15(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput15(ii,i).Fit(2));
        errorLower = (fitOutput15(ii,i).Fit(1)) - (fitOutput15(ii,i).conf_Intervals(1,1,1));
        errorUpper = (fitOutput15(ii,i).conf_Intervals(1,2,1)) - (fitOutput15(ii,i).Fit(1));
        S7 = errorbar(x_jittered(ii),Bias15(i,ii),errorLower,errorUpper,'.','Color',"g")
        %CI7(1,i) = 1./sqrt(fitOutput15(ii,i).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput15(ii,i).conf_Intervals(2,2,1));
        CI7(1,i) = fitOutput15(ii,i).conf_Intervals(1,2,1) - (fitOutput15(ii,i).conf_Intervals(1,1,1));
        % S5 = plot(Bias14(i,:),'.','MarkerSize',25,'Color','b');
        % S5 =  plot([ii ii],1./sqrt(fitOutput14(ii,i).conf_Intervals(2,:,1)),'-','MarkerSize',45,'Color','k')
        hold on

        plot(Bias15(i+4,:),'.-','Color',"k");
        hold on
        % S6 = plot(Bias14(i+4,:),'.','MarkerSize',25,'Color',"#A2142F");
        % errorLower = 1./sqrt(fitOutput15(ii,i+4).Fit(2)) - 1./sqrt(fitOutput15(ii,i+4).conf_Intervals(2,2,1));
        % errorUpper = 1./sqrt(fitOutput15(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput15(ii,i+4).Fit(2));
        errorLower = (fitOutput15(ii,i+4).Fit(1)) - (fitOutput15(ii,i+4).conf_Intervals(1,1,1));
        errorUpper = (fitOutput15(ii,i+4).conf_Intervals(1,2,1)) - (fitOutput15(ii,i+4).Fit(1));
        S8 = errorbar(x_jittered(ii),Bias15(i+4,ii),errorLower,errorUpper,'.','Color',"k")
        %CI8(1,i) = 1./sqrt(fitOutput15(ii,i+4).conf_Intervals(2,1,1)) - 1./sqrt(fitOutput15(ii,i+4).conf_Intervals(2,2,1));
        CI8(1,i) = fitOutput15(ii,i+4).conf_Intervals(1,2,1) - (fitOutput15(ii,i+4).conf_Intervals(1,1,1));
        tick = (1:12)
        xlim([0 12.5]);
        % ylim([0.1 1.1]);
        xticks(tick);
        xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
        legend([S1 S2 S3 S4 S5 S6 S7 S8],{'135 (3)','315 (3)','135(4)','315(4)','135 (5)', '315 (5)','135(6)','315(6)'})
        xlabel('Staircase Iterations');  ylabel('Bias (\mu)')%ylabel('Sensitivity (1/\sigma)');
        title(titles{i+8})
        hold on
    end
    subplot(1,2,2);
    plotOptions.dataColor = [0.3010 0.7450 0.9330];
    plotOptions.lineColor =[0.3010 0.7450 0.9330];
    plotPsych(fitOutput6(12,i+8),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.05 ,['1/\sigma: ' num2str(1/sqrt(fitOutput6(12,i+8).Fit(2)))],'FontSize',9,'Color', "#4DBEEE")
    xlim([-30 30]);

    hold on

    plotOptions.dataColor = [0.8500 0.3250 0.0980];
    plotOptions.lineColor = [0.8500 0.3250 0.0980];
    plotPsych(fitOutput6(12,i+20),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.1 ,['1/\sigma: ' num2str(1/sqrt(fitOutput6(12,i+20).Fit(2)))],'FontSize',9,'Color', "#D95319")
   
    xlim([-30 30]);
    hold on
    
    plotOptions.dataColor = [0 0.4470 0.7410];
    plotOptions.lineColor = [0 0.4470 0.7410];
    plotPsych(fitOutput13(12,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.15 ,['1/\sigma: ' num2str(1/sqrt(fitOutput13(12,i).Fit(2)))],'FontSize',9,'Color',"#0072BD")
   
    xlim([-30 30]);
    hold on
    plotOptions.dataColor = [1 0 0];
    plotOptions.lineColor = [1 0 0];
    plotPsych(fitOutput13(12,i+4),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.2 ,['1/\sigma: ' num2str(1/sqrt(fitOutput13(12,i+4).Fit(2)))],'FontSize',9,'Color','r')
   
    hold on
     plotOptions.dataColor = [0 0 1];
    plotOptions.lineColor = [0 0 1];
    plotPsych(fitOutput14(12,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.25 ,['1/\sigma: ' num2str(1/sqrt(fitOutput14(12,i).Fit(2)))],'FontSize',9,'Color','b')
   
    xlim([-30 30]);
    hold on
     plotOptions.dataColor = [0.6350 0.0780 0.1840];
    plotOptions.lineColor = [0.6350 0.0780 0.1840];
    plotPsych(fitOutput14(12,i+4),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.3 ,['1/\sigma: ' num2str(1/sqrt(fitOutput14(12,i+4).Fit(2)))],'FontSize',9,'Color',"#A2142F")
   
    xlim([-30 30]);
    hold on
    plotOptions.dataColor = [0 1 0];
    plotOptions.lineColor = [0 1 0];
    plotPsych(fitOutput15(12,i),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.35 ,['1/\sigma: ' num2str(1/sqrt(fitOutput15(12,i).Fit(2)))],'FontSize',9,'Color','g')
    
    xlim([-30 30]);
    hold on
   
    plotOptions.dataColor = [0 0 0];
    plotOptions.lineColor = [0 0 0];
    plotPsych(fitOutput15(12,i+4),plotOptions)
    % title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
    xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
    % text(20/2,0.1 ,['\mu ' num2str(fitOutput6(1,i).Fit(1))],'FontSize',9)
    text(20,0.4 ,['1/\sigma: ' num2str(1/sqrt(fitOutput15(12,i+4).Fit(2)))],'FontSize',9,'Color',"k")
    
    xlim([-30 30]);

    title(titles{i+8})



    % set(gcf,'Position',[50 242 2.0186e+03 820]);
    set(gcf,'Position',[10 100 1500 650]);
    saveas(gcf,['Bias ',titles{i+8}],'png');
    CIs = [CI1(1,i),CI2(1,i);CI3(1,i),CI4(1,i);CI5(1,i),CI6(1,i);CI7(1,i),CI8(1,i)];

    figure;
    bar(CIs,1);
    xticklabels({'3','4','5','6'});
    xlabel('Sessions'); ylabel('Confidence Intervals (\mu)');
    title(['Confidence Interval ',sprintf(titles{i+8})])
    legend({'135','315'})
    saveas(gcf,['CIbs',sprintf('%d',i)],'png');
end

%% DO THE BARPLOT

CIag = [mean(CI1),mean(CI2);mean(CI3),mean(CI4);mean(CI5),mean(CI6);mean(CI7),mean(CI8)];
figure;
bar(CIag,1);
xticklabels({'3','4','5','6'});
% ylim([0 0.11])
xlabel('Sessions'); ylabel('Confidence Intervals (\mu)');
title('Confidence Interval plot')
legend({'135','315'})

% set(gcf,'Position',[10 100 1500 650]);
saveas(gcf,'CIbs','png');
%% Bias Magnitude
load('Bias1.mat');
load('Bias2.mat');
load('Bias3.mat');
load('Bias4.mat');
load('Bias5.mat');
load('Bias6.mat');
Bias1 = abs(Bias1); Bias2 = abs(Bias2); Bias3 = abs(Bias3);
titles = {'S2 ecc 7 Dir 45','S2 ecc 7 Dir 135','S2 ecc 7 Dir 225','S2 ecc 7 Dir 315','S2 ecc 20 Dir 45','S2 ecc 20 Dir 135','S2 ecc 20 Dir 225','S2 ecc 20 Dir 315','S2 ecc 30 Dir 45','S2 ecc 30 Dir 135','S2 ecc 30 Dir 225','S2 ecc 30 Dir 315'};
for i = 1:(length(Bias1(:,1))/2)
    figure;
    S1 =  plot(Bias1(i,:),'.','MarkerSize',25,'Color',"#4DBEEE");
    hold on
    plot(Bias1(i,:),"-",'Color',"#4DBEEE");
    hold on
    S2 = plot(Bias1(i+12,:),'.','MarkerSize',25,'Color','m');
    hold on
    plot(Bias1(i+12,:),'-m');
    hold on

    S3 = plot(Bias2(i,:),'.','MarkerSize',25,'Color','r');
    hold on
    plot(Bias2(i,:),'-r');
    hold on
    S4 = plot(Bias2(i+12,:),'.','MarkerSize',25,'Color','k');
    hold on
    plot(Bias2(i+12,:),'-k');
    hold on


    S5 = plot(Bias3(i,:),'.','MarkerSize',25,'Color','b');
    hold on
    plot(Bias3(i,:),'-b');
    hold on
    S6 = plot(Bias3(i+12,:),'.','MarkerSize',25,'Color',"#7E2F8E");
    hold on
    plot(Bias3(i+12,:),'-','Color',"#7E2F8E");
    hold on

    tick = (1:12)
    xticks(tick);
    xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
    legend([S1 S2 S3 S4 S5 S6],{'45 (before)','225 (before)','135(after)','315(after)','45 (after)', '225(after)'})
    xlabel('Staircase Iterations'); ylabel('Bias Magnitude (|\mu|)');
    title(titles{i})
    fname = [(sprintf(titles{i})),' Bias'];
    saveas(gcf,fname,'png');
end

%% Visua;izing the no change in sensitivity and bias. 2 plotys 2 locations
P1 = [Sens6(9,12),Sens13(1,12),Sens14(1,12),Sens15(1,12);
    Sens6(10,12),Sens13(2,12),Sens14(2,12),Sens15(2,12);
    Sens6(11,12),Sens13(3,12),Sens14(3,12),Sens15(3,12);
    Sens6(12,12),Sens13(4,12),Sens14(4,12),Sens15(4,12)];

P2 = [Sens6(21,12),Sens13(5,12),Sens14(5,12),Sens15(5,12);
    Sens6(22,12),Sens13(6,12),Sens14(6,12),Sens15(6,12);
    Sens6(23,12),Sens13(7,12),Sens14(7,12),Sens15(7,12);
    Sens6(24,12),Sens13(8,12),Sens14(8,12),Sens15(8,12)];
figure;
subplot(1,2,1)
bar(P1,1);xticklabels({'45','135','225','315'});
xlabel('Direction (degrees)');ylabel('Sensitivity(1/\sigma)')
legend ({'Session 3','Session 4','Session 5','Session 6'},'Location','northwest');
ylim([0 0.37]);
title('PA 135');

subplot(1,2,2)
bar(P2,1);xticklabels({'45','135','225','315'});
xlabel('Direction (degrees)');ylabel('Sensitivity(1/\sigma)')
legend ({'Session 3','Session 4','Session 5','Session 6'},'Location','northwest');
ylim([0 0.37]);
title('PA 315');
set(gcf,'Position',[488 242 1.0186e+03 420]);

%% plot for bias as well Visua;izing the no change in sensitivity and bias. 2 plotys 2 locations
B1 = [Bias6(9,12),Bias13(1,12),Bias14(1,12),Bias15(1,12);
    Bias6(10,12),Bias13(2,12),Bias14(2,12),Bias15(2,12);
    Bias6(11,12),Bias13(3,12),Bias14(3,12),Bias15(3,12);
    Bias6(12,12),Bias13(4,12),Bias14(4,12),Bias15(4,12)];

B2 = [Bias6(21,12),Bias13(5,12),Bias14(5,12),Bias15(5,12);
    Bias6(22,12),Bias13(6,12),Bias14(6,12),Bias15(6,12);
    Bias6(23,12),Bias13(7,12),Bias14(7,12),Bias15(7,12);
    Bias6(24,12),Bias13(8,12),Bias14(8,12),Bias15(8,12)];
figure;
subplot(1,2,1)
bar(B1,1);xticklabels({'45','135','225','315'});
xlabel('Direction (degrees)');ylabel('Bias(degrees)')
legend ({'Session 3','Session 4','Session 5','Session 6'},'Location','northwest');
ylim([-11 20]);
title('PA 135');

subplot(1,2,2)
bar(B2,1);xticklabels({'45','135','225','315'});
xlabel('Direction (degrees)');ylabel('Bias(degrees)')
legend ({'Session 3','Session 4','Session 5','Session 6'},'Location','northwest');
ylim([-11 20]);
title('PA 315');
set(gcf,'Position',[488 242 1.0186e+03 420]);

%% let's do the comparison thing again
T1 =  [Bias6(9,12),Bias6(21,12);Bias13(1,12),Bias13(5,12);Bias14(1,12),Bias14(5,12);Bias15(1,12),Bias15(5,12)];
T2 =  [Bias6(11,12),Bias6(23,12);Bias13(3,12),Bias13(7,12);Bias14(3,12),Bias14(7,12);Bias15(3,12),Bias15(7,12)];

 figure;
subplot(1,2,1)
bar(T1,1);xticklabels({'3','4','5','6'});
xlabel('Sessions');ylabel('Bias(degrees)')
legend ({'PA 135','PA 315'},'Location','northwest');
ylim([-11 20]);
title('Dir 45');

subplot(1,2,2)
bar(T2,1);xticklabels({'3','4','5','6'});
xlabel('Direction (degrees)');ylabel('Bias(degrees)')
legend ({'PA 135','PA 315'},'Location','northwest');
ylim([-11 20]);
title('Dir 225');
set(gcf,'Position',[488 242 1.0186e+03 420]); 

%% BM FOR SUB 10
Bias4 = abs(Bias4); Bias5 = abs(Bias5); Bias6 = abs(Bias6);
titles = {'S1 ecc 7 Dir 45','S1 ecc 7 Dir 135','S1 ecc 7 Dir 225','S1 ecc 7 Dir 315','S1 ecc 20 Dir 45','S1 ecc 20 Dir 135','S1 ecc 20 Dir 225','S1 ecc 20 Dir 315','S1 ecc 30 Dir 45','S1 ecc 30 Dir 135','S1 ecc 30 Dir 225','S1 ecc 30 Dir 315'};
for i = 1:(length(Bias4(:,1))/2)
    figure;
    S1 =  plot(Bias4(i,:),'.','MarkerSize',25,'Color',"#D95319");
    hold on
    plot(Bias4(i,:),"-",'Color',"#D95319");
    hold on
    S2 = plot(Bias4(i+12,:),'.','MarkerSize',25,'Color',[.5 .5 .5]);
    hold on
    plot(Bias4(i+12,:),'-','Color',[.5 .5 .5]);
    hold on

    S3 = plot(Bias5(i,:),'.','MarkerSize',25,'Color','b');
    hold on
    plot(Bias5(i,:),'-b');
    hold on
    S4 = plot(Bias5(i+12,:),'.','MarkerSize',25,'Color','m');
    hold on
    plot(Bias5(i+12,:),'-m');
    hold on


    S5 = plot(Bias6(i,:),'.','MarkerSize',25,'Color','r');
    hold on
    plot(Bias6(i,:),'-r');
    hold on
    S6 = plot(Bias6(i+12,:),'.','MarkerSize',25,'Color','k');
    hold on
    plot(Bias6(i+12,:),'-k');
    hold on

    tick = (1:12)
    xticks(tick);
    xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
    legend([S1 S2 S3 S4 S5 S6],{'135 (before)','315 (before)','45(after)','225(after)','135 (after)', '315(after)'})
    xlabel('Staircase Iterations'); ylabel('Bias Magnitude (|\mu|)');
    title(titles{i})
    fname = [(sprintf(titles{i})),' Bias'];
    saveas(gcf,fname,'png');
end

%% aggregates
titles = {' S2 ecc 7 Dir 45','S2 ecc 7 Dir 135','S2 ecc 7 Dir 225','S2 ecc 7 Dir 315','S2 ecc 20 Dir 45','S2 ecc 20 Dir 135','S2 ecc 20 Dir 225','S2 ecc 20 Dir 315','S2 ecc 30 Dir 45','S2 ecc 30 Dir 135','S2 ecc 30 Dir 225','S2 ecc 30 Dir 315'};
figure

S1 =  plot(sens7(1,:),'.','MarkerSize',15,'Color',"#4DBEEE");
hold on
plot(sens7(1,:),"-",'Color',"#4DBEEE");
hold on
S2 = plot(sens7(2,:),'.','MarkerSize',15,'Color','m');
hold on
plot(sens7(2,:),'-m');
hold on


S3 = plot(sens8(1,:),'.','MarkerSize',15,'Color','r');
hold on
plot(sens8(1,:),'-r');
hold on
S4 = plot(sens8(2,:),'.','MarkerSize',15,'Color','k');
hold on
plot(Bias2(2,:),'-k');
hold on


S5 = plot(sens9(1,:),'.','MarkerSize',15,'Color','b');
hold on
plot(sens9(1,:),'-b');
hold on
S6 = plot(sens9(2,:),'.','MarkerSize',15,'Color',"#7E2F8E");
hold on
plot(sens9(2,:),'-','Color',"#7E2F8E");

tick = (1:12)
xticks(tick);
xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
legend([S1 S2 S3 S4 S5 S6],{'45 (before)','225 (before)','135(after)','315(after)','45 (after)', '225(after)'});
xlabel('Staircase Iterations'); ylabel('Sensitivity (1/\sigma)');1212

title('Subject 2')
hold on
%%
subplot(1,2,2);
plotPsych(fitOutput1(1,i),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.15 ,['1/\sigma: ' num2str(1/sqrt(fitOutput1(1,i).Fit(2)))],'FontSize',9,'Color',[0.3010 0.7450 0.9330])
plotOptions.dataColor = [0.3010 0.7450 0.9330];
plotOptions.lineColor = [0.3010 0.7450 0.9330];
xlim([-30 30]);
hold on

plotPsych(fitOutput1(1,2),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.2 ,['1/\sigma: ' num2str(1/sqrt(fitOutput1(1,2).Fit(2)))],'FontSize',9,'Color', 'm')
plotOptions.dataColor = [1 0 1];
plotOptions.lineColor = [1 0 1];
xlim([-30 30]);
hold on

plotPsych(fitOutput2(1,i),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.25 ,['1/\sigma: ' num2str(1/sqrt(fitOutput2(1,i).Fit(2)))],'FontSize',9,'Color','r')
plotOptions.dataColor = [1 0 0];
plotOptions.lineColor = [1 0 0];
xlim([-30 30]);
hold on

plotPsych(fitOutput2(1,2),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.3 ,['1/\sigma: ' num2str(1/sqrt(fitOutput2(1,2).Fit(2)))],'FontSize',9,'Color','k')
plotOptions.dataColor = [0 0 0];
plotOptions.lineColor = [0 0 0];
hold on

plotPsych(fitOutput3(1,i),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.35 ,['1/\sigma: ' num2str(1/sqrt(fitOutput3(1,i).Fit(2)))],'FontSize',9,'Color','b')
plotOptions.dataColor = [0 0 1];
plotOptions.lineColor = [0 0 1];
xlim([-30 30]);
hold on

plotPsych(fitOutput3(1,2),plotOptions)
% title(['S',sprintf(const.subjID),sprintf('__PA%i ecc%i Dir%i', PAName,eccName,DirName)])
xlabel('Tilt Angle(degrees)'); ylabel('% of clockwise responses');xlim([-30 30]);
% text(20/2,0.1 ,['\mu ' num2str(fitOutput3(1,i).Fit(1))],'FontSize',9)
text(20,0.4 ,['1/\sigma: ' num2str(1/sqrt(fitOutput3(1,2).Fit(2)))],'FontSize',9,'Color',[0.4940 0.1840 0.5560])
plotOptions.dataColor = [0.4940 0.1840 0.5560];
plotOptions.lineColor = [0.4940 0.1840 0.5560];
xlim([-30 30]);
title(titles{i})


% set(gcf,'Position',[50 242 2.0186e+03 820]);
set(gcf,'Position',[10 100 1500 650]);
filename = titles
saveas(gcf,titles{i},'png');
%%

figure;

S1 =  plot(sens10(1,:),'.','MarkerSize',15,'Color',"#D95319");
hold on
plot(sens10(1,:),"-",'Color',"#D95319");
hold on
S2 = plot(sens10(2,:),'.','MarkerSize',15,'Color',[.5 .5 .5]);
hold on
plot(sens10(2,:),'-','Color',[.5 .5 .5]);
hold on


S3 = plot(sens11(1,:),'.','MarkerSize',15,'Color','b');
hold on
plot(sens11(1,:),'-b');
hold on
S4 = plot(sens11(2,:),'.','MarkerSize',15,'Color','m');
hold on
plot(sens11(2,:),'-m');
hold on


S5 = plot(sens12(1,:),'.','MarkerSize',15,'Color','r');
hold on
plot(sens12(1,:),'-r');
hold on
S6 = plot(sens12(2,:),'.','MarkerSize',15,'Color','k');
hold on
plot(sens12(2,:),'-k');

tick = (1:12)
xticks(tick);
xticklabels({'5','10','15','20','25','30','35','40','45','50','55','60'}); %ylim([0 0.6])
legend([S1 S2 S3 S4 S5 S6],{'135 (before)','315 (before)','45(after)','225(after)','135 (after)', '315(after)'})
xlabel('Staircase Iterations'); ylabel('Sensitivity (1/\sigma)');
title('Subject 1')
hold on


