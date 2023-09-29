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
    

%% initialize staircases

expDes.numStaircases = 2;
expDes.minStairThreshold = 0.01;
expDes.maxStairThreshold = 20; % deg
expDes.initStairCaseTilt = expDes.maxStairThreshold;

for jj = 1:expDes.numStaircases
    % init staircases with just initial values!
    %expDes.stairs1 = upDownStaircase(1,1,expDes.initStairCaseHeading,[4 0.5 8],'pest'); 
    expDes.stairs1 = upDownStaircase(1,1,expDes.initStairCaseTilt,[4 1.5],'levitt'); 
    expDes.stairs1.minThreshold = expDes.minStairThreshold;
    expDes.stairs1.maxThreshold = expDes.maxStairThreshold;     
    
    %expDes.stairs2 = upDownStaircase(1,1,expDes.initStairCaseHeading,[4 0.5 8],'pest');
    expDes.stairs2 = upDownStaircase(1,1,expDes.initStairCaseTilt,[4 1.5],'levitt'); 
    expDes.stairs2.minThreshold = expDes.minStairThreshold;
    expDes.stairs2.maxThreshold = expDes.maxStairThreshold;     
end

for jj = 1:expDes.numStaircases
    expDes.stairs1.strength = []; % must preallocate fields that will be added later, so struct fields are the same between new and old staircase structs
    expDes.stairs1.direction = [];
    expDes.stairs1.reversals = []; 
    
    expDes.stairs2.strength = []; % must preallocate fields that will be added later, so struct fields are the same between new and old staircase structs
    expDes.stairs2.direction = [];
    expDes.stairs2.reversals = []; 
end

expDes.tiltangle = NaN(expDes.nb_trials,1);
expDes.correctness = {nan(1,expDes.nb_trials/2); nan(1, expDes.nb_trials/2)};

%%

for ni=1:expDes.nb_trials
    
    fprintf('TRIAL %i ... ', ni)

    if ~const.expStop
        expDes.trial_onsets(ni) = vbl-t0; % log the onset of each trial
        [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl);
        expDes.stimulus_onsets(ni) = vbl-t0; % log the onset of each stimulus
        [expDes, const, frameCounter, vbl] = my_stim(my_key, scr, const, expDes, frameCounter, ni, vbl);
        expDes.respCue_onsets(ni) = vbl-t0; % log the onset of each response cue
        [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, ni, vbl);
    end
end


end