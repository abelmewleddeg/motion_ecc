function [const]=constConfig(scr,const,expDes)
% ----------------------------------------------------------------------
% [const]=constConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Compute all constant data of this experiment.
% ----------------------------------------------------------------------
% Input(s) :
% scr : window pointer
% const : struct containg previous constant configurations.
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing all constant data.
% ----------------------------------------------------------------------

%% Stimulus Properties             

disp('~~~~~ CONST ~~~~~~')

const.speedDeg = 8; %in degrees per second
const.speedPixel = vaDeg2pix(const.speedDeg,scr)*scr.ifi;
% grating and noise can be rotated, but this is only very meaningful for
% grating
%const.stimOri = 90;                                     % 90 deg (vertical orientation)

if strcmp(expDes.stimulus, 'grating')
    % stimulus spatial frequency
    const.stimSF_cpd = 2;                                   % cycle per degree
    const.stimSF_cpp = const.stimSF_cpd/vaDeg2pix(1, scr);  % cycle per pixel
    const.stimSF_radians = const.stimSF_cpp*(2*pi);         % in radians
    const.stimSF_ppc = ceil(1/const.stimSF_cpp);            % pixel per cycle
elseif strcmp(expDes.stimulus, 'perlinNoise')
    % stimulus scalar for noise
    const.scalar4noiseTarget = 0.05; % unitless
end

const.flicker_hz = 4; % in hertz

%% Define width of the cosine ramp (and check that smaller than stimulus/surround)

% starting value (set this and the code below will decrease if too large)
const.stimCosEdge_deg = 0.3;
const.stimCosEdge_pix = vaDeg2pix(const.stimCosEdge_deg, scr);

% calculate the amount of area of surround exclusing target
const.nonTargetRadiuspix = const.surroundRadiuspix - const.stimRadiuspix;
const.surround2GapRadiusPix = const.nonTargetRadiuspix*(const.gapRatio); % outer boundary of the gap
const.gap_pxfromBoundary = const.surroundRadiuspix*(const.gapRatio);
const.gapWidth = (const.surroundRadiuspix-const.stimRadiuspix)*const.gapRatio;
const.surroundWidth = const.surroundRadiuspix - const.gapWidth - const.stimRadiuspix;

% cosine ramp is applied at the edge of the center stimulus
% and is applied at the two edges of the surround stimulus
% so need to make sure that rampSize > center, and 2*rampSize > surroundwith

if const.stimCosEdge_pix > const.stimRadiuspix
    disp('The soft edges (cosine ramp) exceeds the stimulus radius..')
    disp('Decreasing the width of the ramp to 1/4 stimRadius..')
    const.stimCosEdge_pix = const.stimRadiuspix/4; % just make ramp 1/4 of the target radius
    const.stimCosEdge_deg = pix2vaDeg(const.stimCosEdge_pix, scr);
end
if 2*const.stimCosEdge_pix > const.surroundWidth
    disp('The soft edges (cosine ramp*2) exceeds the surround radius..')
    disp('Decreasing the width of the ramp to 1/(4*2) surround radius..')
    const.stimCosEdge_pix = const.surroundWidth/(4*2); % just make ramp 1/4 of the target radius
    const.stimCosEdge_deg = pix2vaDeg(const.stimCosEdge_pix, scr);
end

%% CENTER GRATING W/ RAMP

% Initialize displaying of grating (to save time for initial build):

% STIMULUS
const.grating_halfw= const.stimRadiuspix;
const.visiblesize=2*floor(const.grating_halfw)+1;

backgroundColor = [.5 .5 .5 0];

% center stimulus 
if strcmp(expDes.stimulus, 'perlinNoise')
    const.squarewavetex = CreateProceduralScaledNoise(const.window, const.visiblesize, const.visiblesize, 'ClassicPerlin', backgroundColor, const.visiblesize/2);
elseif strcmp(expDes.stimulus, 'grating')
    const.squarewavetex = CreateProceduralSineGrating(const.window, const.visiblesize, const.visiblesize, backgroundColor, const.visiblesize/2, 1);
end

% center ramp
distance_fromRadius = 0;
x = meshgrid(-const.grating_halfw:const.grating_halfw, 1); % + const.stimSF_ppc, 1);
mask = ones(length(x),length(x)).*0.5;
[mask(:,:,2), filterparam] = create_cosRamp(mask, distance_fromRadius, const.stimCosEdge_pix, 1, [], []); % 1 for initialize mask
const.centermask=Screen('MakeTexture', const.window, mask);


%%
% prepare input for stimulus
const.phaseLine = rand(3, expDes.nb_trials) .* 360;

%% PTB orientation/direction conversion
if strcmp(expDes.stimulus, 'grating')
     orientationids = 0:45:315; ptborientation = {90, 45, 0, 135, 90, 45, 0, 135};
     directionids = 0:45:315; ptbdirection = {180, 135, 90, 45, 0, 315, 270, 225};
elseif strcmp(expDes.stimulus, 'perlinNoise')
     orientationids = 0:45:315; ptborientation = {90, 45, 0, 135, 90, 45, 0, 135};
     directionids = 0:45:315; ptbdirection = {225, 180, 135, 90, 45, 0, 315, 270,};
end
const.maporientation = containers.Map(orientationids,ptborientation);
const.mapdirection = containers.Map(directionids,ptbdirection);

% orientationids = 0:45:315; ptborientation = {90, 45, 0, 135, 90, 45, 0, 135};
% const.maporientation = containers.Map(orientationids,ptborientation);
% 
% directionids = 0:45:315; ptbdirection = {180, 135, 90, 45, 0, 315, 270, 225};
% const.mapdirection = containers.Map(directionids,ptbdirection);

%% Saving procedure :

const.expStart = 0;

% .mat file
save(const.const_fileMat,'const');

const


end