% Analyze motion assymetry data with lme
% 
% TODO: check that the sensitivity variable truly contains sensitivity, 
% or if it is /sigma (i.e. 1/sensitivity)

clear all
close all

load('data/LMEtable.mat');
%%
d = LMEtable; % rename variable
% d.sub = d.("Subject Number"); % remove space from variable 
% d.rvt = d.("Radial/Tangential"); % remove / from variable

% visual check
g = groupsummary(d, ["Eccentricities", "rvt"], "mean")
figure;
h = gscatter(g.Eccentricities, g.mean_Sensitivity, g.rvt);
set(h, 'linestyle', '-');


% TODO: add errorbars
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
d = LMEtable;
d.rvt = d.rvt*-1;
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
title('Sensitivity bar plot')
fn = fullfile(cd,'/data','__Sensitivity bar plot')
saveas(gcf,fn,'png');

figure;bar(gmsb,1)
hold on
eb = errorbar([0.85,1.15;1.85,2.15;2.85,3.15],gmsb,gmBiasStder,'k.','LineWidth',1) % plot the errorbars
legend({'radial','tangential'},'Location','northwest')
xticks(1:3);xticklabels({'7','20','30'}); %yticks(0:0.05:0.25);
title('Bias Magnitude bar plot');
xlabel('Eccentricities (degrees)'); ylabel('Bias Magnitude (\mu)');
fnb = fullfile(cd,'/data','__Bias Magnitude bar plot')
saveas(gcf,fnb,'png');
%% plot comparing tangential at every location
ind = d.rvt ~= 1;
d11 = d(ind,:);
ind2 = d11.Eccentricities == 30
d2 = d11(ind2,:)
d2_mean = groupsummary(d2,["PolarAngles","Directions"],"mean");
d2Bar = reshape(d2_mean.mean_Bias,2,4)'
figure;  bar(d2Bar([1 3],:),1); xlabel('Polar Angles');ylabel('Bias (degrees)');
title('Bias Direction Comparison')
legend({' Dir 135',' Dir 315'});
figure; bar(d2Bar([2 4],:),1); xlabel('Polar Angles');ylabel('Bias (degrees)');
xticklabels({'135','315'});
legend({' Dir 45',' Dir 225'});
% yline(mean(d2.Bias),'r')
title('Bias Direction Comparison')

%% try doing it rania's way
d.sub = categorical(d.sub);
d.PolarAngles = categorical(d.PolarAngles);
d.Eccentricities = categorical(d.Eccentricities);
d.rvt = categorical(d.rvt);
lme = fitlme(d, 'Sensitivity ~ rvt + Eccentricities + PolarAngles + rvt*Eccentricities + (1|sub)')

%% Barplots?

