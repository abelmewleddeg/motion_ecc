% reliablbility plots
close all;
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
Sens = [];
 for i=1:(length(expDes.stairs))
       
        for iui = 1:12
             x = [];
             for ii=1:5*iui; %(length(expDes.stairs{1,i}.trialData))
                x = [x expDes.stairs{1,i}.trialData(ii).stim];
             end
             x = x'
            currIDx = find(expDes.trialMat(:,6) == i);
            currP = expDes.trialMat(min(currIDx),:);
            PAName = currP(1,2);
            eccName = currP(1,3);
            DirName = currP(1,4);
            if  i == 12;% mod(i+4,4) ==1
                tiltResponses =  [expDes.trialMat(find(expDes.trialMat(:,6) == i),7)]
                x(:,2) =tiltResponses(1:5*iui);
                Utilt = unique(x(:,1));
                for ix = 1:length(Utilt)
                    Utilt(ix,3) = length(find(x(:,1) == Utilt(ix,1)));
                    Utilt(ix,2) = length(find((x(:,1) == Utilt(ix,1)) & (x(:,2) == 1)));
                     %Utilt(ix,4) = length(find((psyMat(:,1) == Utilt(ix,1)) & (psyMat(:,2) == -1)))
                end
                oi = floor((i+4)/4);
                
                %hold on
                set(gcf,'Position',get(0,'ScreenSize'));
               if iui <= 6
                   figure(1);
                   set(gcf,'Position',get(0,'ScreenSize'));
                   subplot(2,3,iui);
               else
                   figure(2);
                   set(gcf,'Position',get(0,'ScreenSize'));
                   subplot(2,3,iui-6);
               end
                fitOutput = psignifit(Utilt,options);
                Sens =  [Sens 1/sqrt(fitOutput.Fit(2))];
                plotPsych(fitOutput,plotOptions)
                title(sprintf('PA%i ecc%i Dir%i', PAName,eccName,DirName))
                % xlabel('Tilt Angle'); ylabel('% of clockwise responses')
                text(max(Utilt(:,1))/2,0.1 ,['B: ' num2str(fitOutput.Fit(1))],'FontSize',9)
                text(max(Utilt(:,1))/2,0.15 ,['S: ' num2str(1/sqrt(fitOutput.Fit(2)))],'FontSize',9)
                % %saveas(gcf,'C:\Users\rokers lab 2\Documents\PsyDir 45.png'); 
                figure(3)
                plot(Sens,'k.','MarkerSize',25)
                hold on
                plot(Sens,'-b')
                xlabel('Batches'); ylabel('Sensitivity');title('Reliability Plot st 12 (135 12 315)')
            end
        end
 end