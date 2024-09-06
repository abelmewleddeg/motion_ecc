% Analyze motion assymetry data with lme
% 
% TODO: check that the sensitivity variable truly contains sensitivity, 
% or if it is /sigma (i.e. 1/sensitivity)

clear all
close all
main_dir = 'Z:\UsersShare\Abel\motionEcc_project'
data_dir = fullfile(main_dir,'Data/Analysis') %"C:\Users\rokers lab 2\Documents\motionEcc_Project\2024_MotionAssymetries\code"
load(fullfile(data_dir,'LMEtable.mat'));
%%
d = LMEtable; % rename variable
% d.sub = d.("Subject Number"); % remove space from variable 
% d.rvt = d.("Radial/Tangential"); % remove / from variable

% visual check
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
figure;
h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
set(h, 'linestyle', '-');


% add errorbars
hold on 
g_std = groupsummary(d, ["Eccentricities", "rvt"], "std", "Sensitivity");
g_std.stder = g_std.std_Sensitivity/sqrt(numel(unique(d.sub)));

% reshape variables 
 gms = (reshape(g.mean_Sensitivity,2,3))';
 gme = (reshape(g.Eccentricities,2,3))';
 gmstder = (reshape(g_std.stder,2,3))';
 e = errorbar(gme,gms,gmstder,'k.','LineWidth',1) % plot the errorbars
 

ylim([0 0.28]);
xlabel('Eccentricity (deg)')
ylabel('Sensitivity (1/\sigma)')
legend('tangential','radial') % please check this is the correct order 
saveas(gcf,'Ras','png');
% Run model for eccentricity
lm = fitlme(d, 'Sensitivity ~  rvt * Eccentricities + (1|sub)')

% Run model for bias
lm = fitlme(d, 'Bias ~ Eccentricities + rvt + (1|sub)')

%% Barplots?
% d = LMEtable;
    if  d.Directions(1) == d.PolarAngles(1) | d.Directions(1) == d.PolarAngles(1) +180 | d.Directions(1) == d.PolarAngles(1) - 180
        d.rvt = d.rvt*-1; %include a check here
    end
d.BiasMagnitude = abs(d.Bias)
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
gp = groupsummary(d, ["Eccentricities", "PolarAngles","rvt"], "mean")
figure;
% h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
% set(h, 'linestyle', '-');


% TODO: add errorbars
hold on
s = groupsummary(d, ["sub","Eccentricities", "rvt"], "mean","Sensitivity");
sbias = groupsummary(d, ["sub","Eccentricities", "rvt"], "mean","BiasMagnitude");
g_std = groupsummary(s, ["Eccentricities","rvt"], "std", "mean_Sensitivity");
g_stdbias = groupsummary(sbias, ["Eccentricities","rvt"], "std","mean_BiasMagnitude");
g_std.stder = g_std.std_mean_Sensitivity/sqrt(numel(unique(d.sub)));
g_stdbias.stder = g_stdbias.std_mean_BiasMagnitude/sqrt(numel(unique(d.sub)));
% g_std.stder = g_std.std_Sensitivity/sqrt(48);
% g_stdbias.stder = g_stdbias.std_BiasMagnitude/sqrt(48);
% 

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
title('Sensitivity bar plot')
fn = fullfile(main_dir,'/Figures/StaircaseMode2','__Sensitivity bar plot')
saveas(gcf,fn,'png');

figure;bar(gmsb,1)
hold on
eb = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gmsb,gmBiasStder,'k.','LineWidth',1) % plot the errorbars
legend({'radial','tangential'},'Location','northwest')
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);
title('Bias Magnitude bar plot');
xlabel('Eccentricities (degrees)'); ylabel('Bias Magnitude (\mu)');
fnb = fullfile(main_dir,'/Figures/StaircaseMode2','__Bias Magnitude bar plot')
saveas(gcf,fnb,'png');
%% plot comparing tangential at every location
% ind = d.rvt ~= 1;
% d11 = d(ind,:);
% ind2 = d11.Eccentricities == 30
% d2 = d11(ind2,:)
% d2_mean = groupsummary(d2,["PolarAngles","Directions"],"mean");
% d2Bar = reshape(d2_mean.mean_Bias,2,4)'
% figure;  bar(d2Bar([1 3],:),1); xlabel('Polar Angles');ylabel('Bias (degrees)');
% title('Bias Direction Comparison')
% legend({' Dir 135',' Dir 315'});
% figure; bar(d2Bar([2 4],:),1); xlabel('Polar Angles');ylabel('Bias (degrees)');
% xticklabels({'135','315'});
% legend({' Dir 45',' Dir 225'});
% % yline(mean(d2.Bias),'r')
% title('Bias Direction Comparison')


%% ttest
% [h7 p7] = ttest(d.Sensitivity(find(d.rvt == -1 & d.Eccentricities == 7)),d.Sensitivity(find(d.rvt == 1 & d.Eccentricities == 7)));
% [h20 p20] = ttest(d.Sensitivity(find(d.rvt == -1 & d.Eccentricities == 20)),d.Sensitivity(find(d.rvt == 1 & d.Eccentricities == 20)));
% [h30 p30] = ttest(d.Sensitivity(find(d.rvt == -1 & d.Eccentricities == 30)),d.Sensitivity(find(d.rvt == 1 & d.Eccentricities == 30)));
% % summarize the data per subject first
s = groupsummary(d, ["sub","Eccentricities", "rvt"], "mean","Sensitivity")
% s = groupsummary(d, ["PolarAngles","Eccentricities", "rvt","Directions"], "mean")
[h7 p7] = ttest(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 7)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 7)));
[h20 p20] = ttest(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 20)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 20)),Alpha = 0.05);
[h30 p30] = ttest(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 30)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 30)),Alpha = 0.05);

Es1 = meanEffectSize(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 7)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 7)),Paired=true,Effect="Cohen");
Es2 = meanEffectSize(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 20)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 20)),Paired=true,Effect="Cohen");
Es3 = meanEffectSize(s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 30)),s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 30)),Paired=true,Effect="Cohen");
%% plotting radial tangential difference for each participant
% at every polar angle
s.rvt = s.rvt*-1 % make sure s.rvt == 1 fir radial conditions
a = (s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 7)) - s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 7)))./s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 7));
b = (s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 20)) -s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 7)))./s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 20));
c = (s.mean_Sensitivity(find(s.rvt == 1 & s.Eccentricities == 30)) - s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 30)))./s.mean_Sensitivity(find(s.rvt == -1 & s.Eccentricities == 30));
diff = [a';b';c']
figure;boxplot(diff')
hold on
scatter([1 2 3],diff',20,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1);%'.','MarkerSize',20);
legend({'1','2','3','4','5','6'},'Location','northwest')
Ymax = (max(diff,[],'all')+0.02);
ylabel('Radial/Tangential Sensitivity Difference (%)');%
% ylim([0 Ymax]);xlabel('Eccentricities (degrees)'); %ylabel('Sensitivity Difference (1/\sigma)');
    xticklabels({'7','20','30'});yticks(0:0.05:0.4); yticklabels({'0','5','10','15','20','25','30','35','40'})
title('Radial Advantage box plot');
filename6 = fullfile(main_dir,'/Figures/StaircaseMode2/Difference Bar');
saveas(gcf,filename6,'png');
%%  plotting radial tangential difference per polar angle
pa = groupsummary(d, ["PolarAngles","Eccentricities", "rvt"], "mean","Sensitivity");
pa.rvt = pa.rvt*-1
x = (pa.mean_Sensitivity(find(pa.rvt == 1 & pa.Eccentricities == 7)) - pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 7)))./pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 7));
y = (pa.mean_Sensitivity(find(pa.rvt == 1 & pa.Eccentricities == 20)) -pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 7)))./pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 20));
z = (pa.mean_Sensitivity(find(pa.rvt == 1 & pa.Eccentricities == 30)) - pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 30)))./pa.mean_Sensitivity(find(pa.rvt == -1 & pa.Eccentricities == 30));
diff = [x';y';z']
figure;boxplot(diff')
hold on
scatter([1 2 3],diff',20,'filled','MarkerEdgeColor',[0 0 0],'LineWidth',1);%'.','MarkerSize',20);
legend({'1','2','3','4','5','6'},'Location','northwest')
Ymax = (max(diff,[],'all')+0.02);
ylabel('Radial/Tangential Sensitivity Difference (%)');%
ylim([0 Ymax]);xlabel('Eccentricities (degrees)'); %ylabel('Sensitivity Difference (1/\sigma)');
xticklabels({'7','20','30'});yticks(0:0.05:0.4); yticklabels({'0','5','10','15','20','25','30','35','40'})
title('Radial Advantage box plot'); 
filename7 = fullfile(main_dir,'/Figures/StaircaseMode2/Difference Bar2');
legend({'45','225','135','315'},'Location','northwest');
saveas(gcf,filename7,'png');

%% LME

d.sub = categorical(d.sub);
d.PolarAngles = categorical(d.PolarAngles);
% d.Eccentricities = categorical(d.Eccentricities);
d.Eccentricities = double(d.Eccentricities);
d.rvt = categorical(d.rvt);
%d.rvt = double(d.rvt);
lme = fitlme(d, 'Sensitivity ~  rvt + Eccentricities + rvt*Eccentricities + (1|sub)')
 