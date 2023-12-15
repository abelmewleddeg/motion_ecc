function [expDes]=designConfig(scr,const)
% ----------------------------------------------------------------------
% [expDes]=designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Load trial sequence matrix containing condition labels
% used in the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing all constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg all trial sequence data.
% ----------------------------------------------------------------------

disp('~~~~~ DESIGN ~~~~~~')

 possiblePAs = [[45,135];[225,315]];

 if mod(const.subjID_numeric,2) % if odd subject number
     const.PArandi = [1,2];
 else
     const.PArandi = [2,1];
 end
 
 
if mod(const.block,2) || const.DEBUG % if odd block number
    expDes.polarAngles = (possiblePAs(:,const.PArandi(1,1)))';
elseif ~mod(const.block,2) % if even block number
    expDes.polarAngles = (possiblePAs(:,const.PArandi(1,2)))';
 
end

% this is to fill the response cue arrow
expDes.fillArrow = 1; % 0 or 1

% save random number generator / seed for each run
expDes.rng = rng(const.block);

%% Experimental sequence

% number of repeats (actual trial number is double this number to
% distribute clockwise / counterclockwise trials evenly of a condition)

if const.staircasemode == 0 % for practice
    expDes.nb_repeat = 6; 
else
    expDes.nb_repeat = 30; % 30 clockwise and 30 counteclockwise (ish); for either staircase method
end

expDes.contrasts = .5;

if ~ (mod(expDes.nb_repeat,2)==0)
    disp('expDes.nb_repeat MUST BE EVEN - clockwise and counterclockwise trials per condition must be distributed equally')
end

expDes.Eccens = [8]; %[4, 8, 12];

% limit the practice to only 1 eccentricity
if const.staircasemode == 0
    expDes.Eccens = expDes.Eccens(2); % take the middle eccentricity for practice
end

expDes.Dirs = [45];%[45, 135, 225, 315];

expDes.mainStimTypes = [];

for i=1:numel(expDes. polarAngles)
    for ii=1:numel(expDes.Eccens)
        for iii= 1:numel(expDes.Dirs)
            tmp = [expDes.polarAngles(i), expDes.Eccens(ii),expDes.Dirs(iii)];
            expDes.mainStimTypes = [expDes.mainStimTypes; tmp];
        end
    end
end

% grating or perlinNoise
if strcmp(const.stimType, 'noise')
    expDes.stimulus = 'perlinNoise';
elseif strcmp(const.stimType, 'grating')
    expDes.stimulus = 'grating';
end

[numClock, ~] = size(expDes.mainStimTypes);

% double (for clockwise and counterclockwise)
% distribute even number of clockwise / clounterclockwise responses
% clockwiseStim is whether the stimulus is clockwise (1) or
% counterclockwise (-1). Clockwise tilts are positive in my_stim.
trialsequenceMAT = repmat(expDes.mainStimTypes, 2, 1);
clockwiseStim = [ones(numClock, 1); -1*ones(numClock, 1)];

% add a column for unique staircase indices (e.g, for 1up1down: 1 staircase = a motionDir,
% at a paLoc at an eccen that is clockwise; for bayesian: 1 staircase = a motionDir,
% at a paLoc at an eccen that is either clockwise or counterclockwise)
if const.staircasemode == 1
    expDes.numStaircases = 2*numClock;
    staircaseLabels = (1:expDes.numStaircases)';
elseif const.staircasemode == 2
    expDes.numStaircases = numClock;
    staircaseLabels = (1:expDes.numStaircases)';
    staircaseLabels = repmat(staircaseLabels, 2, 1, 1); % double this (to keep consistent)
    clockwiseStim = clockwiseStim*nan; % non informative in this case, just change to nan
elseif const.staircasemode == 0
    expDes.numStaircases = 0;
    [trialtypes, ~] = size(trialsequenceMAT);
    staircaseLabels = nan(trialtypes, 1);
end

trialsequenceMAT = [trialsequenceMAT, clockwiseStim, staircaseLabels];

% create trialMat with total trial number (since already doubled to
% evenly account for clockwise+counterclockwise
trialsequenceMAT = repmat(trialsequenceMAT, expDes.nb_repeat, 1);

% randomize
trialsequenceMAT = trialsequenceMAT(randperm(length(trialsequenceMAT)), :);

[expDes.nb_trials, ~] = size(trialsequenceMAT);

expDes.mainStimTypes = array2table(expDes.mainStimTypes,'VariableNames',{'polarAngle', 'eccen', 'motionDir'});

% Experimental matrix
trialIDs = 1:expDes.nb_trials;
expDes.trialMat = [trialIDs', trialsequenceMAT];
expDes.trialMat

% rows = trials, cols = [response (-1 cc, 1 c), correct (1 correct, 0
% incorrect) 
expDes.response = nan(expDes.nb_trials,2);

%% Experiental timing settings
if const.staircasemode > 0
    expDes.stimDur_s  = .01 %.3;   % 0.5 sec stimulus duration
    expDes.itiDur_s  = 0; %.8;      % 2 inter-trial interval (fixation)
    expDes.NumBlocks = 8;
else
    expDes.stimDur_s  = 1; %.3;   % 0.5 sec stimulus duration
    expDes.itiDur_s  = .8; %.8;      % 2 inter-trial interval (fixation)
    expDes.NumBlocks = 1;
end
expDes.total_s = (expDes.nb_trials*(expDes.stimDur_s+expDes.itiDur_s));
expDes.ApprxTrialperBlock = round(expDes.nb_trials/expDes.NumBlocks);

expDes.stimDur_nFrames  =     round(expDes.stimDur_s/scr.ifi); % # frames
expDes.itiDur_nFrames  =      round(expDes.itiDur_s/scr.ifi); % # frames

expDes.totalframes = expDes.stimDur_nFrames*expDes.nb_trials+ ...
    expDes.itiDur_nFrames*expDes.nb_trials;
 
expDes.TrialsStart_frame = 1;
expDes.TrialsEnd_frame = expDes.totalframes;

%% Saving procedure

save(const.design_fileMat,'expDes'); 

end
