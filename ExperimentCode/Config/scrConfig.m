function [scr, const]=scrConfig(const)
% ----------------------------------------------------------------------
% [scr]=scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Give all information about the screen and the monitor.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing initial constant params.
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing all screen configuration.
% const strcut containing some additional params
% ----------------------------------------------------------------------

%% General

disp('~~~~~ Load HID Devices.. ~~~~~~')

LoadPsychHID

disp('~~~~~ SCR ~~~~~~')

% Instructions
const.text_size = 20;
const.text_font = 'Helvetica';

% Color Configuration :
const.white =    [ 1,  1,  1];
const.gray =    [ .5,  .5,  .5];
const.black =   [  0,   0,   0];
const.lightgray =   [  0.75,   0.75,   0.75 ];

% Time
const.my_clock_ini = clock;
scale2screen = 0;
fixIFI = 0;
    
%% Screen
computerDetails = Screen('Computer');  % check computer specs

scr.scr_num = max(Screen('Screens')); % use max screen (typically external monitor)

% Size of the display (mm)
[scrX_mm, scrY_mm] = Screen('DisplaySize',scr.scr_num);
scr.scrX_cm = scrX_mm/10; scr.scrY_cm = scrY_mm/10;

filepath = fullfile(sursuppRootPath, 'parameters.tsv');
%params = readtable(filepath, "FileType","text",'Delimiter', '\t');

% save other params to const struct
%const.gapRatio = params.gapRatio; 
const.stimType = 'noise'; % or 'grating' %params.stimType;

% find screen details
if ~computerDetails.windows
    switch computerDetails.localHostName
        case 'Ranias-MacBook-Pro-2'
            scr.experimenter = 'RE';
            const.keyboard = 'Apple Internal Keyboard / Trackpad';
            if scr.scr_num == 1
                scr.scrX_cm = 62; scr.scrY_cm = 34;
            end
            scr.scrViewingDist_cm = 57;
            Screen('Preference', 'SkipSyncTests', 1);
        otherwise
            scr.experimenter = 'Unknown';
            scr.scrViewingDist_cm = 57;
    end
else    % PC (field names are different)
    switch computerDetails.system
        case 'NT-10.0.9200 - '
            scr.experimenter = 'NYUAD Mock Scanner';
            scr.scrViewingDist_cm = 89;
            scr.scr_num = 1;
            scr.scrX_cm = 69.5; scr.scrY_cm = 39.25;
            const.keyboard = '';
        case 'NT-11.0.9200 - '
             scr.experimenter = 'Predator Helios 300';
            scr.scrViewingDist_cm = 57;
            const.keyboard = '';
            if ~scr.scr_num  
                fixIFI = 1;
            end
        otherwise
            scr.experimenter = 'Unknown';
            scr.scrViewingDist_cm = 57;
    end
end

if strcmp(scr.experimenter, 'Unknown') % default
    disp('Defaulting to first keyboard detected. This might work :)') 
    disp('If not, you can specify it by opening scrConfig.m and setting const.keyboard')
    disp('variable to the name of your keyboard. To print out connected keyboards:')
    disp('In MATLAB: [~, productNames, ~] = GetKeyboardIndices')
    const.keyboard = ''; % <-- add name here if needed
end

% Resolution of the display (pixels):
resolution = Screen('Resolution',scr.scr_num);
scr.scrX_px = resolution.width;
scr.scrY_px = resolution.height;
scr.scrPixelDepth_bpp = resolution.pixelSize; % bits per pixel

[scr.windX_px, scr.windY_px]=Screen('WindowSize', scr.scr_num);

const.stimRadius_deg = 1.5;

% load in eccentricity values and convert to pixels
% const.stimEcc_deg = params.stimEcc; const.stimEccpix = vaDeg2pix(const.stimEcc_deg, scr); 
% const.stimRadius_deg = params.stimRadius; 
const.stimRadiuspix = vaDeg2pix(const.stimRadius_deg, scr); 
% const.surroundRadius_deg = params.surroundRadius; const.surroundRadiuspix = vaDeg2pix(const.surroundRadius_deg, scr);
%const.gapRatio = params.gapRatio;

if const.miniWindow == 1 || const.DEBUG == 1
    %PsychDebugWindowConfiguration(0, 0.5)
    % Window resolution (pixel): [small window]
    scr.windX_px = scr.windX_px/2;
    scr.windY_px = scr.windY_px/2;
    scr_dim = [0, 0, scr.windX_px, scr.windY_px];
    [~] = Screen('Preference', 'SkipSyncTests', 1); % skip timing checks for debugging
else
    % Window resolution is Screen resolution: [fullscreen]
    scr.windX_px = scr.windX_px;
    scr.windY_px = scr.windY_px;
    scr_dim = []; % PTB says better precision when empty
end

% check if lawful parameter size relative to screen
% if const.surroundRadiuspix >= const.stimEccpix
%     disp('Surround radius must NOT exceed stimulus eccentricity.')
%     scale2screen = 1;
% end
% if const.surroundRadiuspix >= scr.windY_px/2
%     disp('Surround radius must NOT exceed half the screen height.')
%     scale2screen = 1;
% end
% if const.surroundRadiuspix+const.stimEccpix >= scr.windX_px/2
%     disp('Surround radius + eccentricity must NOT exceed the screen width.')
%     scale2screen = 1;
% end
%

% if scale2screen % this is mainly for testing
%     disp('Scaling params to fit current window..')
%     disp('and setting eccentricity to maximize stimulus range..')
%     
%     const.stimEccpix = scr.windX_px/4;
%     const.stimEcc_deg = pix2vaDeg(const.stimEccpix, scr);
%     
%     radiusConstraints = [scr.windX_px/2, scr.windY_px/2, const.stimEccpix];
%     minConstraint = min(radiusConstraints);
%     
%     scalingFactor = minConstraint/const.surroundRadiuspix;
%     const.surroundRadiuspix = minConstraint;
%     const.surroundRadius_deg = pix2vaDeg(const.surroundRadiuspix, scr);
%     const.stimRadiuspix = const.stimRadiuspix*scalingFactor;
%     const.stimRadius_deg = pix2vaDeg(const.stimRadiuspix, scr);
% end

% if ~((const.gapRatio >= 0) && (const.gapRatio <= 1))
%     disp('Gap ratio must be between 0 and 1..')
%     disp('Setting to default value of 0.5')
%     const.gapRatio = 0.5;
% end


%% Fixation Properties

const.fixationRadius_px = 0.01*scr.windY_px;
const.fixationRadius_deg = pix2vaDeg(const.fixationRadius_px, scr);

%%


PsychDefaultSetup(2); % assert OpenGL, setup unifiedkeys and unit color range
PsychImaging('PrepareConfiguration'); % First step in starting pipeline
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
ListenChar(1);                        % Listen for keyboard input

%% Prepare the VR if it is connected

if const.VRdisplay==1
    InitializeMatlabOpenGL(1);
    load('DefaultHMDParameters.mat'); % RE: should this be inside loop?
    scr.oc.defaultState = defaultState;
    scr.oc.multiSample = 8;

    %if const.VRconnect ==1 % have this output from a try/catch statement
    try
        scr.hmd = PsychVRHMD('AutoSetupHMD', 'Tracked3DVR', 'LowPersistence TimeWarp FastResponse DebugDisplay', 0);
        
        PsychVRHMD('SetHSWDisplayDismiss', scr.hmd, -1);
    
        %     Return matrices for left and right “eye cameras” which can be directly
        % used as OpenGL GL_MODELVIEW matrices for rendering the scene. 4x4 matrices
        % for left- and right eye are contained in state.modelView{1} and {2}.
        % as of the PTB release for the CV1, there is built-in gamma correction
        % in Psychtoolbox for the devices
        scr.oc.defaultIPD = 0.0;%0.064; % in m
        scr.oc.viewingDistance = 0.0;%.45;
        defaultState.modelViewDataLeft = [1 0 0 -scr.oc.defaultIPD/2; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %+/- IPD/2
        defaultState.modelViewDataRight = [1 0 0 scr.oc.defaultIPD/2; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1];
        scr.oc.defaultState.modelView = {defaultState.modelViewDataLeft, defaultState.modelViewDataRight};
        scr.oc.defaultState.modelView{1}(13) = scr.oc.defaultIPD/2;
        scr.oc.defaultState.modelView{1}(15) = -scr.oc.viewingDistance;
        scr.oc.defaultState.modelView{2}(13) = -scr.oc.defaultIPD/2;
        scr.oc.defaultState.modelView{2}(15) = -scr.oc.viewingDistance;

        % keeps automatically setting the stereo mode to 6 for the oculus - this is because, as indicated in MorphDemo.m: "% Fake some stereomode if HMD is used, to trigger stereo rendering"
        [const.window, const.windowRect] = PsychImaging('OpenWindow', scr.scr_num, 0, [], [], [], [], scr.oc.multiSample);  
        scr.oc.hmdinfo = PsychVRHMD('GetInfo', scr.hmd); % verifies that all of the basic requirements have been set up.

    catch
     %else % oculus not connected
        scr.hmd = [];
        fprintf('No VR-HMD available, using default values.\n');
        %load('OculusDK2Gamma.mat'); % load the oculus gamma table % RE: check
        %if new gamma is needed for VR
        % for gamma correction
        %scr.oc.gammaVals = [GammaValue GammaValue GammaValue];
        % CSB. split screen mode; "4" sets this

        [const.window, const.windowRect] = PsychImaging('OpenWindow', scr.scr_num, 0, [], [], [], 4, scr.oc.multiSample); 
    end
else
    % non VR display
    % open a grey window (size defined above)
    [const.window, const.windowRect] = PsychImaging('OpenWindow', scr.scr_num, [.5 .5 .5], scr_dim, [], [], [], [], []);
end


% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(const.windowRect); 
scr.windCenter_px = [xCenter, yCenter];

% Flip to clear
scr.vbl = Screen('Flip', const.window);

% Query the frame duration
scr.ifi = Screen('GetFlipInterval', const.window);

% fix the Helios incorrect reading here
if fixIFI
    scr.ifi = 1/144; % RE: check whether this still applies inside headset
end

if const.VRdisplay==1 
    if ~isempty(scr.hmd)
        scr.oc.windowRect = const.windowRect % RE: just to get it to work now
        disp('wind rect values:')
        scr.oc.windowRect
        scr.oc.yc = RectHeight(scr.oc.windowRect)/2; % the horizontal center of the display in pixels
        scr.oc.xc = RectWidth(scr.oc.windowRect)/2; % the vertical center of the display in pixels
        % 1080 x 1200 - not workinhg
        %scr.oc.xycenter =  [1344/2, 1600,2]
        scr.oc.xycenter = [scr.oc.xc, scr.oc.yc];
        scr.oc.x_offset = 100;

        scr.oc.Height = 1.7614; % virtual height of the surround texture in meters, based on viewing distance - we want this to relate to the shorter dimension of the display
        scr.oc.halfHeight = scr.oc.Height/2;
        scr.oc.Width = 1.7614; % virtual width of the surround texture in meters, based on viewing distance - we want this to relate to the longer dimension of the display
        scr.oc.halfWidth = scr.oc.Width/2;

        
        if strcmp(scr.oc.hmdinfo.modelName, 'Oculus Rift CV1')
            scr.oc.hmdinfo = PsychVRHMD('GetInfo', scr.hmd); % query CV1 for params
            
            % Calculate display properties
            scr.oc.screenRenderWidthMonocular_px   = 2*scr.oc.xc; % the discrepancy btw. oculus's spec reported res of 1080 * 1200 is that the render resolution is higher than the screen res in order to make up for the barrel transform.
            scr.oc.screenRenderHeightMonocular_px  = 2*scr.oc.yc;
            scr.oc.screenWidthMonocular_px         = 1080; % this is what is reported in oculus's cv1 specs.
            scr.oc.screenHeightMonocular_px        = 1200; % this is what is reported in oculus's cv1 specs.
            scr.oc.screenWidthBinocular_px         = scr.oc.screenWidthMonocular_px*2; % apparently just multiply by # of lens.
            scr.oc.screenWidthBinocular_px         = scr.oc.screenHeightMonocular_px*2; % apparently just multiply by # of lens.
            scr.oc.hFOV = 80; % in deg - this is what is spit back from the Oculus readings at the start - horizontal field of view
            scr.oc.vFOV = 90;  % in deg - vertical field of view
            scr.oc.hFOV_perPersonAvg   = 84; % based on averages taken from https://www.infinite.cz/blog/VR-Field-of-View-measured-explained
            scr.oc.hFOV_psych          = scr.oc.hmdinfo.fovL(1) + scr.oc.hmdinfo.fovL(2); % in deg - symmetric for fovL and fovR
            scr.oc.vFOV_perPersonAvg   = 84; % based on averages taken from https://www.infinite.cz/blog/VR-Field-of-View-measured-explained
            scr.oc.hFOV_psych          = scr.oc.hmdinfo.fovL(3) + scr.oc.hmdinfo.fovL(4); % in deg - vertical field of view
            scr.oc.screenX_deg = scr.oc.hFOV_perPersonAvg;
            scr.oc.screenY_deg = scr.oc.vFOV_perPersonAvg;
            scr.oc.viewportWidthDeg = scr.oc.hFOV;
            scr.oc.viewportWidthM = .09;% height component of the display - corresponding to the longer side of the display
            scr.oc.hor_px_per_deg  = (scr.oc.screenRenderWidthMonocular_px*1)/scr.oc.hFOV_perPersonAvg; %~15.45 this seems pretty good check out: https://www.roadtovr.com/understanding-pixel-density-retinal-resolution-and-why-its-important-for-vr-and-ar-headsets/
            scr.oc.ver_px_per_deg  = (scr.oc.screenRenderHeightMonocular_px*1)/scr.oc.vFOV_perPersonAvg*1;
            scr.oc.deg_per_px  = 1/scr.oc.hor_px_per_deg;
            scr.oc.focalLength = 1.2;
            
            scr.oc.dFOV = sqrt(scr.oc.hFOV^2 + scr.oc.vFOV^2);
            
            scr.oc.metersPerDegree =  scr.oc.viewportWidthM/scr.oc.hFOV_perPersonAvg;
            scr.oc.degreesPerM = scr.oc.hFOV_perPersonAvg/scr.oc.viewportWidthM;
            
            
            scr.oc.pixelsPerM = sqrt(RectHeight(scr.oc.windowRect)^2 + RectWidth(scr.oc.windowRect)^2) / scr.oc.viewportWidthM;
            
            % scr.oc.frameRate = 90;
            scr.oc.frameRate = 1./scr.oc.hmdinfo.videoRefreshDuration;
        end
    elseif isempty(scr.hmd)
        scr.oc.hFOV_perPersonAvg = 84; %deg
        scr.oc.vFOV_perPersonAvg = 84; %deg
        scr.oc.screenRenderWidthMonocular_px = 1792/2;
        scr.oc.screenRenderHeightMonocular_px = 1080;
        scr.oc.hor_px_per_deg = scr.oc.screenRenderWidthMonocular_px/scr.oc.hFOV_perPersonAvg; %
        scr.oc.ver_px_per_deg = scr.oc.screenRenderHeightMonocular_px/scr.oc.vFOV_perPersonAvg;
        scr.oc.deg_per_px = 1/scr.oc.hor_px_per_deg;
        
        scr.oc.pixelsPerM = 1792/0.2159;
        
        scr.oc.textCoords = [scr.oc.screenRenderWidthMonocular_px/2 scr.oc.screenRenderHeightMonocular_px/2];
        scr.oc.focalLength = 1.2;
    end

    % Setup the OpenGL rendering context of the onscreen window for use by
    % OpenGL wrapper. After this command, all following OpenGL commands will
    % draw into the onscreen window 'ds.w':
    Screen('BeginOpenGL', const.window);
    
    glDisable(GL.LIGHTING);
    glEnable(GL.DEPTH_TEST);
    glDepthFunc(GL.LEQUAL); % From NeHe, specify what kind of depth testing
    
    glEnable(GL.LINE_SMOOTH);
    glEnable(GL.POINT_SMOOTH);
    glEnable(GL.POLYGON_SMOOTH);
    
    glHint(GL.POINT_SMOOTH_HINT, GL.NICEST);
    glHint(GL.LINE_SMOOTH_HINT, GL.NICEST);
    glHint(GL.POLYGON_SMOOTH_HINT, GL.NICEST);
    
    % for proper gamma correction as per Mario Kleiner's advice
    glEnable(GL.FRAMEBUFFER_SRGB);
    
    % Set viewport properly:
    glViewport(0, 0, RectWidth(const.windowRect), RectHeight(const.windowRect));  % this is how the viewport is specified in all of the demos, but what it does it makes the horizontal dimension the shorter one and the vertical dimension the longer one
    
    % Enable alpha-blending for smooth dot drawing:
    glEnable(GL.BLEND);
    glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
    
    % Enable alpha testing for horizontal dot plane (fixation dot, post)
    %glAlphaFunc(GL.EQUAL, -1);
    %glEnable(GL.ALPHA_TEST);
    
    % Set projection matrix: This defines a perspective projection,
    % corresponding to the model of a pin-hole camera - which is a good
    % approximation of the human eye and of standard real world cameras --
    % well, the best aproximation one can do with 3 lines of code ;-)
    glMatrixMode(GL.PROJECTION);
    
    
    % model view matrix
    
    % Initialize oculus modelview for head motion tracking
    %scr.oc.modelViewDataLeft = []; % may as well save the model view matrix data as well - the hope is that this covers all of the critical information to later go back and analyze/reconstruct the head motion
    %scr.oc.modelViewDataRight = []; % may as well save the model view matrix data as well - the hope is that this covers all of the critical information to later go back and analyze/reconstruct the head motion
    
    % added this from the main code
    % Camera position when using head tracking + HMD: (according to SuperShapeDemo.m)
    globalPos = [0, 0, 0]; % x,y,z  % in meters - just put something in here for now, will likely be much larger later for viewing the tv/'real' world - the demos use large values too
    heading = 0; % yaw
    scr.oc.globalHeadPose = PsychGetPositionYawMatrix(globalPos, heading); % initialize observer's start position to the default camera position specified above
    

    % % Switched this block with the bit about camera position above
    % % Retrieve and set camera projection matrix for optimal rendering on the HMD:
    if ~isempty(scr.hmd)
        % RE: I put this in from the main script: if you want head tracking
        [scr.oc.projMatrix{1}, scr.oc.projMatrix{2}] = PsychVRHMD('GetStaticRenderParameters', scr.hmd);
        scr.oc.initialState = PsychVRHMD('PrepareRender', scr.hmd, scr.oc.globalHeadPose);  % get the state of the hmd now

        % just for debugging (remove later
        % disp('HMD connected')
        % scr.oc.initialState = scr.oc.defaultState;
        % scr.oc.initialState.modelView{1} = scr.oc.defaultState.modelViewDataLeft;
        % scr.oc.initialState.modelView{2} = scr.oc.defaultState.modelViewDataRight;

    else
        % RE: commented these lines out b/c .mat file does not exist.
        %temp = load('dsHmdInfoCV1.mat');
        %scr.oc.projMatrix = temp.scr.oc.projMatrix;
        %clear temp

        % RE: I put this in from the main script. For now, default state is
        % used b/c we are displaying relative to head position.
        % This is already done in SetupDisplay
        % load DefaultHMDParameters.mat;
        % oc.defaultState = defaultState;
        % Some stuff needs to be done here to get a proper initialState
        % There is something messed up with using both initial and default
        % state
        % can we simplify using only one or the other?  
        scr.oc.initialState = scr.oc.defaultState;
        scr.oc.initialState.modelView{1} = scr.oc.defaultState.modelViewDataLeft;
        scr.oc.initialState.modelView{2} = scr.oc.defaultState.modelViewDataRight;
    end

    % glLoadMatrixd(projMatrix);
    
    % Setup modelview matrix: This defines the position, orientation and
    % looking direction of the virtual camera:
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    
    % Set background clear color
    glClearColor(0.5,0.5,0.5,1); % mid-gray
    % glClearColor(0,0,0,1); % black
    
    % Clear out the backbuffer: This also cleans the depth-buffer for
    % proper occlusion handling: You need to glClear the depth buffer whenever
    % you redraw your scene, e.g., in an animation loop. Otherwise occlusion
    % handling will screw up in funny ways...
    glClear;
    
    glEnable(GL_TEXTURE_2D); % Prepare environment for low level OpenGL Texture Rendering
    % If geometry is not textured, it's likely because
    % GL_TEXTURE_2D is not enabled
    
    % Finish OpenGL rendering into PTB window. This will switch back to the
    % standard 2D drawing functions of Screen and will check for OpenGL errors.
    
    Screen('EndOpenGL', const.window);
end



%% load in gamma table for appropriate contrast
if ~const.DEBUG
    gammaVals = load(const.gammaTablePath);
    const.gammaVals = gammaVals.gamma;
    [~, const.calibSuccess] = Screen('LoadNormalizedGammaTable', const.window, const.gammaVals.*[1 1 1]);
    if const.calibSuccess
        disp('Successfully incorporated the gamma table from the config folder.')
        disp('NOTE: if this gamma table was not re-created for your setup, please replace file.')
    else
        disp('Calibration of screen color/contrast values failed.')
    end
end

%%

% Enable alpha-blending, set it to a blend equation useable for linear
% additive superposition. This allows to linearly
% superimpose gabor patches in the mathematically correct manner, should
% they overlap. Alpha-weighted source means: The 'globalAlpha' parameter in
% the 'DrawTextures' can be used to modulate the intensity of each pixel of
% the drawn patch before it is superimposed to the framebuffer image, ie.,
% it allows to specify a global per-patch contrast value:
%Screen('BlendFunction', const.window, GL_ONE, GL_ONE);
%Screen('BlendFunction', const.window, GL_SRC_ALPHA,
%GL_ONE_MINUS_SRC_ALPHA); % put back

% Set drawing to maximum priority level
topPriorityLevel = MaxPriority(const.window);
Priority(topPriorityLevel);

% save .mat file with screen parameters used
save(const.scr_fileMat,'scr');

end

