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

%% Instructions texture


MainDirectory = sursuppRootPath;
imagefile = fullfile(MainDirectory,'ExperimentCode','Instructions','InstructionsFigure.jpeg');
image = imread(imagefile);
const.imageTexture = Screen('MakeTexture',const.window,image);
imageSize = size(image);
const.imageRect = CenterRectOnPoint([0, 0, imageSize(2), imageSize(1)], const.windowRect(3)/2, const.windowRect(4)/2);
const.imageRect_nonVR = CenterRectOnPoint([0, 0, imageSize(2)./4, imageSize(1)./4], const.windowRect(3)/2, const.windowRect(4)/2);

if const.VRdisplay==1 
    global GL;
    InitializeMatlabOpenGL(1);
    Screen('BeginOpenGL',const.window);

    %glTexEnvi(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.DECAL);
    %glTexEnvi(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.BLEND);
    %glTexEnvi(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.REPLACE);

    %image = flipud(image);

    glColor3f(1,1,1);
    
    % % fixation target (just trying this here)
    % 
    % %tmp = glGenLists(1);
    % %glCallList(tmp);

    const.imagePlaneID = glGenLists(1);

    % Enable texture mapping
    glEnable(GL.TEXTURE_2D); % this makes the image appear all white

    glNewList(const.imagePlaneID, GL.COMPILE);
    
    % glPushMatrix;
    % glColor3f(0.0, 0.0, 1.0) % blue rectange
    % glutSolidSphere(0.025, 32, 32);
    % glRectf(-1.0, -1.0, 1.0, 1.0)
    % glPopMatrix;

    % Generate and bind the texture (this has to exist before the image)
    textureID = glGenTextures(1);
    glBindTexture(GL.TEXTURE_2D, textureID); % Bind the texture before drawing the rectangle


    % Load the image data to the texture
    % 768, 1024
    glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, size(image, 2), size(image, 1), 0, GL.RGB, GL.UNSIGNED_BYTE, uint8(image));
    %glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, 512, 384, 0, GL.RGB, GL.UNSIGNED_BYTE, uint8(image));

    % Specify texture parameters
    glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR); %_MIPMAP_LINEAR);
    glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR); %_MIPMAP_LINEAR);
    glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

    glBindTexture(GL.TEXTURE_2D, textureID);

    % Draw the rectangle with texture coordinates
    % glVertices determine the SIZE and distance of the shape/canvas
    glBegin(GL.QUADS);
    glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -3.0);
    glTexCoord2f(.25, 0.0); glVertex3f(1.0, -1.0, -3.0);
    glTexCoord2f(.25, .33); glVertex3f(1.0, 1.0, -3.0);
    glTexCoord2f(0.0, .33); glVertex3f(-1.0, 1.0, -3.0);

    % glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, 0.0);
    % glTexCoord2f(1.0, 0.0); glVertex3f(1.0, -1.0, 0.0);
    % glTexCoord2f(1.0, 1.0); glVertex3f(1.0, 1.0, 0.0);
    % glTexCoord2f(0.0, 1.0); glVertex3f(-1.0, 1.0, 0.0);

    glEnd();

    %glDisable(GL.TEXTURE_2D)
   
    %glRotatef(90.0, 1.0, 0.0, 0.0)


    % pa.floorHeight = -0.25;
    % pa.fixationSize = 0.025; % m
    % pa.fixationdist = 0.25;
    % glTranslatef(0,-pa.fixationSize/2,-pa.fixationdist) % - is away from camera


    glEndList(); 

    %% create the fixation

    % glBegin(GL.QUADS);
    % glVertex2f(-0.1,-0.1); % Bottom-left
    % glVertex2f(0.1,-0.1); % Bottom-right
    % glVertex2f(0.1,0.1); % top-left
    % glVertex2f(-0.1,0.1); % top-right
    % glEnd();
    %glColor4f(1,1,1,1);
    %quadratic=gluNewQuadric();
    %gluSphere(quadratic,fixationRadius,fixationSlices,fixationStacks); 
    %glTranslatef(0, 0, -10);

    % const.fixation = glGenLists(1);
    % glNewList(const.fixation, GL.COMPILE);
    % fixationRadius = 50;
    % fixationSlices = 50;
    % fixationStacks = 50;
    % glColor3f(0.0, 1.0, 0.0);
    % %glColor4f(1,1,1,1);
    % %quadratic=gluNewQuadric();
    % %gluSphere(quadratic,fixationRadius,fixationSlices,fixationStacks);  
    % glutSolidSphere(fixationRadius,fixationSlices,fixationStacks)
    % glEndList();

    const.fixation = glGenLists(1);
    glNewList(const.fixation, GL.COMPILE);
    glColor4f(1,1,1,1);
    quadratic=gluNewQuadric();
    gluSphere(quadratic,0.025,64,32);  % hope's values
    glEndList();

    
%% Draw lines here (can delete later - RE for debugging)
    const.linesR = glGenLists(1);
    glNewList(const.linesR, GL.COMPILE);
    glLineWidth(15.0);
    glBegin(GL.LINES);

    % Right eye line
    glColor3f(0.0, 0.0, 0.0); % black color
    glVertex3f(3.86, 0.5, -2); % Start from origin
    glVertex3f(-2.86, 0.5, -2); % End at (1, 0, -5)
    glEnd();
    glEndList();
    
    const.linesL = glGenLists(1);
    glNewList(const.linesL, GL.COMPILE);
    glLineWidth(15.0)
    glBegin(GL.LINES);
    
     % Left eye line
    glColor3f(0.0, 0.0, 0.0); % Blue color
    glVertex3f(-3.86, 0.7, -2); % Start from origin
    glVertex3f(2.86, 0.7, -2); % End at (-1, 0, -5)
    glEnd();
    glEndList();

    %% Let's also draw a blue square (can also delete this - RE)
    const.bsquare = glGenLists(1);
    glNewList(const.bsquare, GL.COMPILE);
    glColor3f(0.0, 0.0, 1.0); % Blue color
    glBegin(GL.QUADS);
    glVertex3f(-3.86, -3.86, -2); % Bottom-left corner
    glVertex3f(3.86, -3.86, -2); % Bottom-right corner
    glVertex3f(3.86, 3.86, -2); % Top-right corner
    glVertex3f(-3.86, 3.86, -2); % Top-left corner
    glEnd();
    glEndList();

    Screen('EndOpenGL',const.window);
end


%% Stimulus Properties             

disp('~~~~~ CONST ~~~~~~')

const.stimContrast = 0.5;

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

%% Define width of the cosine ramp (and check that smaller than stimulus/surround)

% starting value (set this and the code below will decrease if too large)
const.stimCosEdge_deg = 0.3;
const.stimCosEdge_pix = vaDeg2pix(const.stimCosEdge_deg, scr);

% calculate the amount of area of surround exclusing target
% const.nonTargetRadiuspix = const.surroundRadiuspix - const.stimRadiuspix;
% const.surround2GapRadiusPix = const.nonTargetRadiuspix*(const.gapRatio); % outer boundary of the gap
% const.gap_pxfromBoundary = const.surroundRadiuspix*(const.gapRatio);
% const.gapWidth = (const.surroundRadiuspix-const.stimRadiuspix)*const.gapRatio;
% const.surroundWidth = const.surroundRadiuspix - const.gapWidth - const.stimRadiuspix;

% cosine ramp is applied at the edge of the center stimulus
% and is applied at the two edges of the surround stimulus
% so need to make sure that rampSize > center, and 2*rampSize > surroundwith

if const.stimCosEdge_pix > const.stimRadiuspix
    disp('The soft edges (cosine ramp) exceeds the stimulus radius..')
    disp('Decreasing the width of the ramp to 1/4 stimRadius..')
    const.stimCosEdge_pix = const.stimRadiuspix/4; % just make ramp 1/4 of the target radius
    const.stimCosEdge_deg = pix2vaDeg(const.stimCosEdge_pix, scr);
end
% if 2*const.stimCosEdge_pix > const.surroundWidth
%     disp('The soft edges (cosine ramp*2) exceeds the surround radius..')
%     disp('Decreasing the width of the ramp to 1/(4*2) surround radius..')
%     const.stimCosEdge_pix = const.surroundWidth/(4*2); % just make ramp 1/4 of the target radius
%     const.stimCosEdge_deg = pix2vaDeg(const.stimCosEdge_pix, scr);
% end

%% CENTER GRATING W/ RAMP

% Initialize displaying of grating (to save time for initial build):

% STIMULUS
const.grating_halfw= const.stimRadiuspix;
const.visiblesize=2*floor(const.grating_halfw)+1;

backgroundColor = [.5 .5 .5 1]; %0]; % was 0 for non-VR

% center stimulus 
if strcmp(expDes.stimulus, 'perlinNoise')
    const.squarewavetex = CreateProceduralScaledNoise(const.window, const.visiblesize, const.visiblesize, 'ClassicPerlin', backgroundColor, const.visiblesize/2);
elseif strcmp(expDes.stimulus, 'grating')
    const.squarewavetex = CreateProceduralSineGrating(const.window, const.visiblesize, const.visiblesize, backgroundColor, const.visiblesize/2, 1);
end

if const.VRdisplay==1 
    Screen('BeginOpenGL', const.window)
    %glBindTexture(GL.TEXTURE_2D, const.squarewavetex);
    % glBegin(GL.QUADS)
    % glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -3.0);
    % glTexCoord2f(.25, 0.0); glVertex3f(1.0, -1.0, -3.0);
    % glTexCoord2f(.25, .33); glVertex3f(1.0, 1.0, -3.0);
    % glTexCoord2f(0.0, .33); glVertex3f(-1.0, 1.0, -3.0);
    % glEnd();

    %const.squarewavetex = repmat([0 1 0 1 0 1 0 1], 800, 100); %rand(500,500)*255;
    const.sphereStim = glGenLists(1);
    glNewList(const.sphereStim, GL.COMPILE);

    %glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, size(const.squarewavetex, 2), size(const.squarewavetex, 1), 0, GL.RGB, GL.UNSIGNED_BYTE, uint8(const.squarewavetex));
    % Specify texture parameters
    %glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR); %_MIPMAP_LINEAR);
    %glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR); %_MIPMAP_LINEAR);
    %glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
    %glTexParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);

    %glBindTexture(GL.TEXTURE_2D, const.sphereStim);

    glColor4f(1,1,1,1);
    quadratic=gluNewQuadric();
    gluSphere(quadratic,0.025,64,32);  % hope's values
    glEndList();
    
    %glBindTexture(GL.TEXTURE_2D, 0);
    Screen('EndOpenGL', const.window)
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
     directionids = 0:45:315; ptbdirection = {225, 180, 135, 90, 45, 0, 315, 270};
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

end