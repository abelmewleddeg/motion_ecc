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

%% General instructions:

if ~const.DEBUG
    HideCursor(scr.scr_num);
end
const.instrct = 0;
keyCode = instructions(scr,const,my_key,textExp.instruction);
tic

% cols: contrast, RT
expDes.task = nan(expDes.nb_trials, 2);

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
    

%% initialize staircases

expDes.minStairThreshold = -20; %0.01;
expDes.maxStairThreshold = 20; % deg
expDes.stair_counter = ones(1,expDes.numStaircases);

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
 


% To record for overall respMatrix (check expDes.response)

expDes.tiltangle = NaN(expDes.nb_trials,1);

%%

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
    
    fprintf('TRIAL %i ... ', ni)

    if ~const.expStop
        expDes.trial_onsets(ni) = vbl-t0; % log the onset of each trial
        [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl);
        expDes.stimulus_onsets(ni) = vbl-t0; % log the onset of each stimulus
        [expDes, const, frameCounter, vbl] = my_stim(my_key, scr, const, expDes, frameCounter, ni, vbl);
        expDes.respCue_onsets(ni) = vbl-t0; % log the onset of each response cue
        [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, ni, vbl);
        expDes.rt_onset(ni) = vbl-t0; % log the onset of each response
    end
end


end