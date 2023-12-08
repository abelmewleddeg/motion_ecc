load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\Bias 1.mat")
load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\Bias2.mat")
load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\SENpractice1.mat")
load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\SENpractice2.mat")
load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\Bias3.mat")
load("C:\Users\rokers lab 2\Documents\GitHub\motion_ecc\SENpractice3.mat")





%%
PLotPts = [0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85 2.85 2.85 2.85; 3.15 3.15 3.15 3.15];
errPts = [0.85,1.15,1.85,2.15,2.85,3.15];
wxxx = wxx2 - wxx1
w = [mean(wxxx(1,:)),mean(wxxx(2,:));mean(wxxx(3,:)),mean(wxxx(4,:));mean(wxxx(5,:)),mean(wxxx(6,:))];
ww =  [mean(wxxx(1,:)),mean(wxxx(2,:)),mean(wxxx(3,:)),mean(wxxx(4,:)),mean(wxxx(5,:)),mean(wxxx(6,:))];
figure;
bar(w)
hold on 
stder = (std(wxxx')/sqrt(4))'
plot(PLotPts,wxxx,'.','MarkerSize',12)
hold on
errorbar(errPts,ww,stder,'b.')
legend({'radial','tangential'})
ylim([-0.25 0.45]);xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'});yticks(0:0.05:0.5);
title('Sensitivity bar plot')
saveas(gcf,'C:\Users\rokers lab 2\Documents\SENbar.png');
hold off 
figure; 
coefficients1 = polyfit(wxx1,wxx2,1)
linefit1 = polyval(coefficients1,wxx1)
%corrplot(wxx1,wxx2);ylim([0 0.5]);xlim([0 0.5])
scatter(wxx1,wxx2);ylim([0 0.4]);xlim([0 0.4]) 
hold on
plot(wxx1,linefit1,'r-')
xlabel('Sensitivity session 1'); ylabel('Sensitivity session 2')
title('Sensitivity scatter plot')

%%

AbsBias = abs(Bias2-Bias1)
BiasMean = [mean(AbsBias(1,:)),mean(AbsBias(2,:));mean(AbsBias(3,:)),mean(AbsBias(4,:));mean(AbsBias(5,:)),mean(AbsBias(6,:))];
BiasMean2 = [mean(AbsBias(1,:)),mean(AbsBias(2,:)),mean(AbsBias(3,:)),mean(AbsBias(4,:)),mean(AbsBias(5,:)),mean(AbsBias(6,:))];
figure;
bar(BiasMean)
hold on 
stder = (std(AbsBias')/sqrt(4))'
plot([0.85 0.85 0.85 0.85; 1.15 1.15 1.15 1.15;1.85 1.85 1.85 1.85; 2.15 2.15 2.15 2.15;2.85 2.85 2.85 2.85; 3.15 3.15 3.15 3.15],AbsBias,'.','MarkerSize',12)
hold on
errorbar([0.85,1.15,1.85,2.15,2.85,3.15],BiasMean2,stder,'b.')
legend({'radial','tangential'})
%ylim([-0.25 0.45]);
xlabel('Eccentricities'); ylabel('Bias Magnitude');
xticklabels({'4','8','12'});%yticks(0:0.05:0.5);
title('Bias Magnitude bar plot')
saveas(gcf,'C:\Users\rokers lab 2\Documents\BiasBar.png');
hold off
figure;
coefficients2 = polyfit(Bias1,Bias2,1)
linefit2 = polyval(coefficients2,Bias1)
%corrplot(wxx1,wxx2);ylim([0 0.5]);xlim([0 0.5])
scatter(Bias1,Bias2);%ylim([0 0.5]);xlim([0 0.5])
hold on
plot(Bias1,linefit2,'r-')
xlabel('Bias Magnitude session 1'); ylabel('Bias Magnitude session 2')
title('Bias Magnitude scatter plot')

%% combined plots

Comwxx = [wxx1,wxx2,wxx3]
Comw = [mean(Comwxx(1,:)),mean(Comwxx(2,:));mean(Comwxx(3,:)),mean(Comwxx(4,:));mean(Comwxx(5,:)),mean(Comwxx(6,:))];
Comww =  [mean(Comwxx(1,:)),mean(Comwxx(2,:)),mean(Comwxx(3,:)),mean(Comwxx(4,:)),mean(Comwxx(5,:)),mean(Comwxx(6,:))];
figure;
bar(Comw)
hold on 
Comstder = (std(Comwxx')/sqrt(12))'
plot([PLotPts,PLotPts,PLotPts],Comwxx,'.','MarkerSize',9)
errorbar(errPts,Comww,Comstder,'b.')
legend({'radial','tangential'})
xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'})
title('Combined Sensitivity bar plot')
saveas(gcf,'C:\Users\rokers lab 2\Documents\ComSENbar.png');
hold off 
%% Combined 1 and 2
OnTwxx = [wxx1,wxx2]
OnTw = [mean(OnTwxx(1,:)),mean(OnTwxx(2,:));mean(OnTwxx(3,:)),mean(OnTwxx(4,:));mean(OnTwxx(5,:)),mean(OnTwxx(6,:))];
OnTww =  [mean(OnTwxx(1,:)),mean(OnTwxx(2,:)),mean(OnTwxx(3,:)),mean(OnTwxx(4,:)),mean(OnTwxx(5,:)),mean(OnTwxx(6,:))];
figure;
bar(OnTw)
hold on 
OnTstder = (std(OnTwxx')/sqrt(8))'
plot([PLotPts,PLotPts],OnTwxx,'.','MarkerSize',9)
errorbar(errPts,OnTww,OnTstder,'b.')
legend({'radial','tangential'})
xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'})
title('Combined Sensitivity bar plot (1&2)')
saveas(gcf,'C:\Users\rokers lab 2\Documents\OnTSENbar.png');
hold off 
%% Combined two and three

TwoTwxx = [wxx2,wxx3]
TwoTw = [mean(TwoTwxx(1,:)),mean(TwoTwxx(2,:));mean(TwoTwxx(3,:)),mean(TwoTwxx(4,:));mean(TwoTwxx(5,:)),mean(TwoTwxx(6,:))];
TwoTww =  [mean(TwoTwxx(1,:)),mean(TwoTwxx(2,:)),mean(TwoTwxx(3,:)),mean(TwoTwxx(4,:)),mean(TwoTwxx(5,:)),mean(TwoTwxx(6,:))];
figure;
bar(TwoTw)
hold on 
TwoTstder = (std(TwoTwxx')/sqrt(8))'
plot([PLotPts,PLotPts],TwoTwxx,'.','MarkerSize',9)
errorbar(errPts,TwoTww,TwoTstder,'b.')
legend({'radial','tangential'})
xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'})
title('Combined Sensitivity bar plot (2&3)')
saveas(gcf,'C:\Users\rokers lab 2\Documents\TwoTSENbar.png');
hold off 
%% Combine one and three
Onetrwxx = [wxx1,wxx3]
Onetrw = [mean(Onetrwxx(1,:)),mean(Onetrwxx(2,:));mean(Onetrwxx(3,:)),mean(Onetrwxx(4,:));mean(Onetrwxx(5,:)),mean(Onetrwxx(6,:))];
Onetrww =  [mean(Onetrwxx(1,:)),mean(Onetrwxx(2,:)),mean(Onetrwxx(3,:)),mean(Onetrwxx(4,:)),mean(Onetrwxx(5,:)),mean(Onetrwxx(6,:))];
figure;
bar(Onetrw)
hold on 
Onetrstder = (std(Onetrwxx')/sqrt(8))'
plot([PLotPts,PLotPts],Onetrwxx,'.','MarkerSize',9)
errorbar(errPts,Onetrww,Onetrstder,'b.')
legend({'radial','tangential'})
xlabel('Eccentricities'); ylabel('Sensitivity');
xticklabels({'4','8','12'})
title('Combined Sensitivity bar plot (1&3)')
saveas(gcf,'C:\Users\rokers lab 2\Documents\OnetrSENbar.png');
hold off 

% Bias? something weird is happening.. im getting biases higher than my
% tilt angle. I will talk to rania first before I generate any plots.

