function [expDes, const] = runTrials(scr,const,expDes,my_key,textExp)
% ----------------------------------------------------------------------
% runTrials(scr,const,expDes,my_key,textExp,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Main trial function, display the trial function and save the experi-
% -mental data in different files.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containing all the constant configurations.
% expDes : struct containing all the variable design and configurations.
% my_key : keyboard keys names
% textExp : struct contanining all instruction text.
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------

%% initialize staircases

if const.staircasemode > 0

    lowerBound = -20; % -20
    upperBound = 20; % 20
    expDes.stair_counter = ones(1,expDes.numStaircases);

    if const.staircasemode == 1 % updown
        expDes.minStairThreshold = lowerBound;
        expDes.maxStairThreshold = upperBound; % deg

        for jj = 1:expDes.numStaircases

            % find whether this staircase is starting at clock or counterclockwise
            % direction
            designRow = min(find(expDes.trialMat(:,6)==jj));
            startClockwise = expDes.trialMat(designRow, 5);

            % init staircases with just initial values!
            if startClockwise > 0
                expDes.initStairCaseTilt = expDes.maxStairThreshold;
            else
                expDes.initStairCaseTilt = expDes.minStairThreshold;
            end

            %expDes.stairs = upDownStaircase(1,1,expDes.initStairCaseHeading,[4 0.5 8],'pest');
            expDes.stairs{jj} = upDownStaircase(1,1,expDes.initStairCaseTilt,[3 0.3],'levitt');
            expDes.stairs{jj}.minThreshold = expDes.minStairThreshold;
            expDes.stairs{jj}.maxThreshold = expDes.maxStairThreshold;

            expDes.stairs{jj}.strength = []; % must preallocate fields that will be added later, so struct fields are the same between new and old staircase structs
            expDes.stairs{jj}.direction = [];
            expDes.stairs{jj}.reversals = [];
            expDes.correctness{jj} = nan(1,expDes.nb_repeat);
        end
    elseif const.staircasemode == 2
        lowerBound = -30; % -20 (4/11/24)
        upperBound = 30; % 20 (4/11/24)
        incremBound = (upperBound-lowerBound) ./ 40; %(2*(upperBound-lowerBound)); % increment bound is set relative to the upper and lower bounds


        searchLB = lowerBound/2;
        searchUB = upperBound/2;

        stdFL = (upperBound-lowerBound)/8;
        stdFU = (upperBound-lowerBound)/4;
        stdI = (stdFU-stdFL) / 100;

        lapseR = 0; % do we want to set this to a different value?

        disp('initialize staircases...')
        for jj = 1:expDes.numStaircases

            % removing0 as a possible stimulus level results in always
            % -0.5 w/o this fix:
            if rand(1) > 0.5
                disp('greater')
                nearZeroVal = 0.0001;
            else
                disp('less')
                nearZeroVal = -0.0001;
            end

            tmp = lowerBound:incremBound:upperBound;

            tmp(tmp==0) = nearZeroVal;

            expDes.stairs{jj} = qpInitialize('stimParamsDomainList',{tmp}, 'psiParamsDomainList', ...
                {searchLB:incremBound:searchUB, stdFL:stdI:stdFU, lapseR}, 'qpPF', @qpPFNormal); % should we make boundaries the same as the stimulus extremes?
            expDes.correctness{jj} = nan(1,expDes.nb_repeat); % check that this account for c and cc
            disp('DONE initializing staircases.')
        end
    elseif const.staircasemode == 3
        for jj = 1:expDes.numStaircases
            expDes.stairs{jj}.tiltAngles = [-40, -35, -25, -8, 8, 25, 35, 40];
            trialsPerCondition = expDes.nb_repeat*2/ length(expDes.stairs{jj}.tiltAngles);
            trialAngles = repmat( expDes.stairs{jj}.tiltAngles, 1, trialsPerCondition);
            % Randomize the order of trials
            expDes.stairs{jj}.trialAngles = trialAngles(randperm(expDes.nb_repeat*trialsPerCondition));
            expDes.correctness{jj} = nan(1,expDes.nb_repeat);
        end
    end
end


% To record for overall respMatrix (check expDes.response)

expDes.tiltangle = NaN(expDes.nb_trials,1);

%% General instructions:

if ~const.DEBUG
    HideCursor(scr.scr_num);
end
const.instrct = 0; %change it back after
keyCode = instructions(scr,const,my_key,textExp.instruction);
tic

if keyCode(my_key.escape), return, end

FlushEvents('KeyDown');

%% Main Loop
frameCounter=1;
const.expStop = 0;
const.forceQuit = 0;

vbl = Screen('Flip',const.window);
t0=vbl;
expDes.trial_onsets = nan(1,(expDes.nb_trials));
expDes.stimulus_onsets = nan(1,(expDes.nb_trials));
blockTracker = 1;

%%
% simulatedPsiParams = [0, 3, 0];
%
% % Function handle that will take stimulus parameters x and simulate
% % a trial according to the parameters above.
% const.simulatedObserverFun = @(x) qpSimulatedObserver(x,@qpPFNormal,simulatedPsiParams);
%
% % Freeze random number generator so output is repeatable
% rng('default'); rng(2004,'twister');
% rng(6);
for ni=1:expDes.nb_trials

    const.instrct = 1;
    % add block structure
    % make sure approxtruial per block is defined in designconfig (line
    % 70-71 in the example code). initialize blocktracker outside the loop
    % (line 42 in runtrials).

    % for breaks
    if mod(ni,expDes.ApprxTrialperBlock)==0 && ni ~= 0 && ni ~= expDes.nb_trials && ~const.expStop
        blockbreak = sprintf(' Completed %s/%s blocks. Press [space] to continue. ',num2str(blockTracker), num2str(expDes.NumBlocks));
        textExp.blockbreak = {blockbreak};
        keyCode = instructions(scr,const,my_key,textExp.blockbreak);
        if keyCode(my_key.escape), return, end
        FlushEvents('KeyDown');
        blockTracker = blockTracker+1;
    end

    %fprintf('TRIAL %i ... ', ni)

    if ~const.expStop
        expDes.trial_onsets(ni) = vbl-t0; % log the onset of each trial
        [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl);
        expDes.stimulus_onsets(ni) = vbl-t0; % log the onset of each stimulus
        [expDes, const, frameCounter, vbl] = my_VRstim(my_key, scr, const, expDes, frameCounter, ni, vbl);
        %[expDes, const, frameCounter, vbl] = my_stim(my_key, scr, const, expDes, frameCounter, ni, vbl);
        expDes.respCue_onsets(ni) = vbl-t0; % log the onset of each response cue
        [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, ni, vbl);
        expDes.rt_onset(ni) = vbl-t0; % log the onset of each response

        performance_PC = 100*(nansum(expDes.response(:,2))/sum(~isnan(expDes.response(:,2))));
        disp(sprintf('CUMULATIVE PERCENT CORRECT: %s', num2str(performance_PC)))

    end
end


end