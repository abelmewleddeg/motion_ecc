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

possiblePAs = [45, 135, 225, 315];

if const.block==1 || const.DEBUG
    %TO DO: pick ;2 random locations from possiblePAs;
    const.PArandi = randperm(length(possiblePAs));
    expDes.polarAngles = possiblePAs(const.PArandi([1 2]));

else %eif const.block==2

    npriorB = const.block-1;
    completedPAs = [];
    for bb=1:npriorB

        % LOAD IN THE DSEIGN FILE FROM RUN 1, expDes.polarAngles
        filename = sprintf('S%s_design_Block%i.mat',const.subjID,bb);
        % % const.blockDir is your path strrep(const.blockDir, 'Block2', 'Block1')
        block1dir = strrep(const.blockDir, sprintf('Block%s', num2str(const.block)), sprintf('Block%s', num2str(bb)));
        tmp_oldsession = load(fullfile(block1dir, filename));
        old_polarangles = tmp_oldsession.expDes.polarAngles;
        
        completedPAs = [completedPAs old_polarangles];

    end

    % TO DO: then select two randomly from possiblePAs that are NOT in this array that is in possible locs.
    
    drawfromPAs = setdiff(possiblePAs,completedPAs);
     const.PArandi = randperm(length(drawfromPAs));

    if length(drawfromPAs) <= 1
        error('ONE OR LESS POLAR ANGLE LOCATIONS IN SESSION. PLEASE MODIFY.')
    else
        expDes.polarAngles = drawfromPAs(const.PArandi([1 2]));
    end
 
end

% this is to fill the response cue arrow
expDes.fillArrow = 1; % 0 or 1

% save random number generator / seed for each run
expDes.rng = rng(const.block);

%% Experimental sequence

% number of repeats (actual trial number is double this number to
% distribute clockwise / counterclockwise trials evenly of a condition)
expDes.nb_repeat = 1; 

expDes.contrasts = .5;

if ~ (mod(expDes.nb_repeat,2)==0)
    disp('expDes.nb_repeat MUST BE EVEN - clockwise and counterclockwise trials per condition must be distributed equally')
end

expDes.Eccens = [4, 8, 12];
expDes.Dirs = [45, 135, 225, 315];

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

% add a column for unique staircase indices (e.g, 1 staircase = a motionDir,
% at a paLoc at an eccen that is clockwise)
expDes.numStaircases = 2*numClock;
staircaseLabels = (1:expDes.numStaircases)';
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

expDes.stimDur_s  = .3;   % 0.5 sec stimulus duration
expDes.itiDur_s  = .8;      % 2 inter-trial interval (fixation)
expDes.total_s = (expDes.nb_trials*(expDes.stimDur_s+expDes.itiDur_s));

expDes.stimDur_nFrames  =     round(expDes.stimDur_s/scr.ifi); % # frames
expDes.itiDur_nFrames  =      round(expDes.itiDur_s/scr.ifi); % # frames

expDes.totalframes = expDes.stimDur_nFrames*expDes.nb_trials+ ...
    expDes.itiDur_nFrames*expDes.nb_trials;
 
expDes.TrialsStart_frame = 1;
expDes.TrialsEnd_frame = expDes.totalframes;

%% Saving procedure

save(const.design_fileMat,'expDes'); 

end
