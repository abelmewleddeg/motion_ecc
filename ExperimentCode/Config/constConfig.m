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

    const.fixation = glGenLists(1);
    glNewList(const.fixation, GL.COMPILE);
    glColor4f(1,1,1,1);
    quadratic=gluNewQuadric();
    gluSphere(quadratic,0.02,64,32);  % hope's values
    glEndList();

    Screen('EndOpenGL',const.window);
end

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


%% Saving procedure :

const.expStart = 1;

% .mat file
save(const.const_fileMat,'const');

end