function [expDes, const, frameCounter, vbl] = my_VRstim(my_key, scr, const, expDes, frameCounter, trialID, vbl)

%disp('my_VRstim')
%Initialize openGL
if const.VRdisplay==1
    global GL;
    InitializeMatlabOpenGL(1);
end

movieDurationSecs=expDes.stimDur_s;   % Abort after 0.5 seconds.
currPhase = const.phaseLine(1,trialID);
%% Stimulus Properties             

const.stimContrast = .5; % stimulus contrast value

% grating and noise can be rotated, but this is only very meaningful for
% grating
%const.stimOri = 90;                                     % 90 deg (vertical orientation)

if strcmp(expDes.stimulus, 'grating')
    % stimulus spatial frequency
    const.stimSF_cpd =2;  % cycle per degree
    const.stimSF_cpdCM = ( const.stimSF_cpd*(17.3/expDes.trialMat(trialID,3)+0.75))/((17.3/expDes.EccensCM(1)+0.75)); % spatial frequency cortically magnified
    const.stimSF_cpp = const.stimSF_cpdCM/vaDeg2pix(1, scr);  % cycle per pixel
    const.stimSF_radians = const.stimSF_cpp*(2*pi);         % in radians
    const.stimSF_ppc = ceil(1/const.stimSF_cpp);            % pixel per cycle
    const.speedDeg = 8*const.stimSF_cpdCM % speed in cycles per second
    const.speedDeg = const.speedDeg*(expDes.trialMat(trialID,3)/expDes.EccensCM(1))
    const.speedPixel = (const.speedDeg*360)*scr.ifi;  %vaDeg2pix(const.speedDeg,scr)*scr.ifi;
elseif strcmp(expDes.stimulus, 'perlinNoise')
    % stimulus scalar for noise
    const.scalar4noiseTarget = 0.05; % unitless
    const.scalar4noiseTarget = ( const.scalar4noiseTarget*(17.3/expDes.trialMat(trialID,3)+0.75))/((17.3/expDes.EccensCM(1)+0.75)); % stimulus scalar for noise stim after cortical magnification.
    const.speedDeg = 8;
    const.speedDeg = const.speedDeg*(expDes.trialMat(trialID,3)/expDes.EccensCM(1)); % speed in degrees per second
    const.speedPixel = vaDeg2pix(const.speedDeg,scr)*scr.ifi;
end
% const.speedDeg = const.speedDeg*(expDes.trialMat(trialID,3)/expDes.EccensCM(1)); % speed in degrees per second
% const.speedPixel = vaDeg2pix(const.speedDeg,scr)*scr.ifi; % speed in pixels per frame
%% Define width of the cosine ramp (and check that smaller than stimulus/surround)

% starting value (set this and the code below will decrease if too large)
const.stimCosEdge_deg = 0.3;
const.stimCosEdge_pix = vaDeg2pix(const.stimCosEdge_deg, scr);
const.stimRadius_deg = 1.5; 
const.stimRadius_degCM = (const.stimRadius_deg*(17.3/expDes.EccensCM(1)+0.75))/((17.3/expDes.trialMat(trialID,3)+0.75)); % stim size after cortical magnification
const.stimRadiuspix = vaDeg2pix(const.stimRadius_degCM, scr);


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
% for drawing arrow
const.RespSize  = vaDeg2pix(const.stimRadius_deg, scr);
const.visiblesizeResp=2*floor(const.RespSize)+1;

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
    Screen('BeginOpenGL', const.window) % bind stimulus to 
    %glBindTexture(GL.TEXTURE_2D, const.squarewavetex);
    % glBegin(GL.QUADS)
    % glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -3.0);
    % glTexCoord2f(.25, 0.0); glVertex3f(1.0, -1.0, -3.0);
    % glTexCoord2f(.25, .33); glVertex3f(1.0, 1.0, -3.0);
    % glTexCoord2f(0.0, .33); glVertex3f(-1.0, 1.0, -3.0);    % glEnd();

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
    Screen('EndOpenGL', const.window);
end

% center ramp
distance_fromRadius = 0;
x = meshgrid(-const.grating_halfw:const.grating_halfw, 1); % + const.stimSF_ppc, 1);
mask = ones(length(x),length(x)).*0.5;
[mask(:,:,2), filterparam] = create_cosRamp(mask, distance_fromRadius, const.stimCosEdge_pix, 1, [], []); % 1 for initialize mask
const.centermask=Screen('MakeTexture', const.window, mask);
%% 
tiltSign = expDes.trialMat(trialID, 5); % -1 or 1 ()
testDirection = expDes.trialMat(trialID,4); 

if const.staircasemode > 0
    % which staircase + what iteration
    staircaseIndx = expDes.trialMat(trialID,6);
    currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);

    % correcting the trialMat of predefined c / cc values for when
    % staircase iteration goes the other way
    if const.staircasemode == 1
        if ~(expDes.trialMat(trialID, 5)* expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold > 0)
            expDes.trialMat(trialID, 5) = expDes.trialMat(trialID, 5)*-1; % correcting for cases where the cw staircase shoiws ccw stimuli and vice versa
        end
        tiltAmount = expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold;
    elseif const.staircasemode == 2       
        tiltAmount = qpQuery(expDes.stairs{staircaseIndx});
        if tiltAmount==0
            expDes.trialMat(trialID, 5) = 0;
        else
            clockSign = tiltAmount/abs(tiltAmount);
            expDes.trialMat(trialID, 5) = clockSign;  
        end
    elseif const.staircasemode == 3
        tiltAmount = expDes.stairs{staircaseIndx}.trialAngles(currStaircaseIteration)
        clockSign = tiltAmount/abs(tiltAmount);
        expDes.trialMat(trialID, 5) = clockSign; 
    end
elseif const.staircasemode == 0
     tiltAmount = 20*tiltSign;
end
    
%disp('End of my_stim loop1:')
%expDes.trialMat(trialID, 5);

% e.g. 90, 180 drift direction

% eccentricity
const.stimEccpix = vaDeg2pix(expDes.trialMat(trialID,3),scr);
xDist = sqrt((const.stimEccpix^2)/2); yDist = sqrt((const.stimEccpix^2)/2);
waitframes = 1;
vblendtime = vbl + movieDurationSecs;

const.responded=0;
movieframe_n = 1;
phasenow = 90;

%% STAIRCASE FOR TILT ANGLE

% if const.staircasemode > 0
%     % this should be a matrix of nans initialized in const. (col per staircase- each with the counter?)
%     % if expDes.stair_counter(1, staircaseIndx) == 1
%     %     % disp('first iteration of staircase')
%     % end
% 
%     if const.staircasemode == 1
%         % expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold
%         tiltAmount = expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold;
%     end
% 
%     % disp('Sign to start staircase:')
%     % disp(tiltSign)
%     % disp('Tilt value:')
%     % disp(tiltAmount)
%     % disp('staircaseIndx:')
%     % disp(staircaseIndx)
% else
%     tiltAmount = 20*tiltSign; % constant value for now AM change back to 20*tiltSign later
% end

% textureSize = 100;
% whiteSquare = ones(textureSize,textureSize,4)*255;
% tex4testing = Screen('MakeTexture', const.window, whiteSquare);
% %tex4testing = CreateProceduralSineGrating(const.window, textureSize, textureSize, [.5 .5 .5 1], textureSize/2, 1);
% tex4testing = CreateProceduralScaledNoise(const.window, textureSize, textureSize, 'ClassicPerlin', [.5 .5 .5 1], textureSize/2);
% tempDstRect = CenterRect([0 0 textureSize textureSize], Screen('Rect',const.window));

%%

%%

% Animationloop:
while ~(const.expStop) && (vbl < vblendtime)

    if ~const.expStop  

        phasenow = phasenow + const.speedPixel; %  10
        
        if strcmp(expDes.stimulus, 'perlinNoise')
             auxParams = [const.stimContrast, currPhase, const.scalar4noiseTarget, phasenow];
        elseif strcmp(expDes.stimulus, 'grating')
            auxParams = [currPhase+(phasenow), const.stimSF_cpp, const.stimContrast, 0];
            % auxParams = [const.stimContrast, currPhase, const.stimSF_cpp, phasenow];
        end
        
        
        
        %if phasenow - should i just present counterphase this way?
        % Draw grating texture, rotated by "angle":
        if const.VRdisplay==1
            textCoords = [0, 0; 1, 0; 1, 1; 0, 1];
            vertices = [-0.5, -0.5; 0.5, -0.5; 0.5, 0.5; -0.5, 0.5];

            % just doing for 1 eye b/c that's how Hope did it
            scr.oc.renderPass = 1;
            eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
            pa.floorHeight = -1; % m
            pa.fixationdist = 0.01; %40; %3;
            pa.gazeangle = atan(-pa.floorHeight/pa.fixationdist);
            R = [1 0 0; 0 cos(pa.gazeangle) -sin(pa.gazeangle); 0 sin(pa.gazeangle) cos(pa.gazeangle)];
            eye.modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1];
            eye.modelView(1:3,1:3) = eye.modelView(1:3,1:3)*R;
            originaleye = eye;
            theta = pa.gazeangle;

            for renderPass = 0:1 %:10 % 
                % loop over eyes\
                
                %disp(sprintf('eye %i', renderPass))
                scr.oc.renderPass = renderPass;

                eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
                    
                if scr.oc.renderPass % drawing right eye
                    scr.oc.modelViewDataRight = [scr.oc.modelViewDataRight; eye.modelView];
                    % newdstRect = dstRect - [const.vrshift/2 const.vrVershift const.vrshift/2 const.vrVershift]; % + [-1*const.vrshift 0 -1*const.vrshift 0]; %cm2pix(286,scr)
                    % const.newcenter = [-const.vrshift/2 -const.vrVershift];
                    const.newcenter = [-const.vrshift -const.vrVershift];
                    const.VRcenter = scr.windCenter_px + const.newcenter; %setting the VR fixatin center here.
                else % drawing left eye
                    scr.oc.modelViewDataLeft = [scr.oc.modelViewDataLeft; eye.modelView];
                    % newdstRect = dstRect + [const.vrshift/2 -const.vrVershift const.vrshift/2 -const.vrVershift]; %cm2pix(286,scr)
                    % const.newcenter = [const.vrshift/2 -const.vrVershift];
                     const.newcenter = [const.vrshift -const.vrVershift];
                     const.VRcenter = scr.windCenter_px + const.newcenter; %setting the VR fixatin center here.
                end 
                dstRect = create_dstRect(const.visiblesize, xDist, yDist, scr, expDes.trialMat(trialID,2), const);
                eye.eyeIndex = scr.oc.renderPass;
                Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass); % openGL must be closed
                modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %eye.modelView;
                my_fixation(scr,const,const.black)
                Screen('BeginOpenGL',const.window);

                glClearColor(0.5, 0.5, 0.5, 3); % green background

                glClear(); % clear the buffers - must be done for every frame

                glColor3f(0,0,1);

                % Clear the screen
                glClear(GL.COLOR_BUFFER_BIT);

                %Setup camera position and orientation for this eyes view:
                glMatrixMode(GL.PROJECTION)
                glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});

                glMatrixMode(GL.MODELVIEW);
                glLoadMatrixd(modelView);  

                glPushMatrix;
                glTranslatef(0,0,-2);

                % glCallList(const.fixation)
                glPopMatrix;
                Screen('EndOpenGL', const.window);

                Screen('BlendFunction', const.window, 'GL_ONE', 'GL_ZERO');
                %Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
               

                Screen('DrawTexture', const.window, const.squarewavetex, [], dstRect, const.mapdirection(testDirection)+tiltAmount, ...
                    [], [], [], [],[], auxParams); % tex4testing

                my_fixation(scr,const,const.black);           

                % FlushEvents('KeyDown');
                %my_targetsphere(scr,const,const.black)
            end
        else
             const.newcenter = [0 0];
             const.VRcenter = scr.windCenter_px + const.newcenter;
             dstRect = create_dstRect(const.visiblesize, xDist, yDist, scr, expDes.trialMat(trialID,2), const);
             my_fixation(scr,const,const.black)
            % Set the right blend function for drawing the gabors
             Screen('BlendFunction', const.window, 'GL_ONE', 'GL_ZERO');

             Screen('DrawTexture', const.window,  const.squarewavetex, [], dstRect, const.mapdirection(testDirection)+tiltAmount, ...
                [], [], [], [],[], auxParams);
            
             % add grey gradient masks
            Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
            Screen('DrawTexture', const.window, const.centermask, [], dstRect, [], [], [], [], [], []);        

            % Draw stimuli here, better at the start of the drawing loop
                
            Screen('DrawingFinished',const.window); % small ptb optimisation
    
            % vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);
    
            if const.makemovie && mod(frameCounter,15) == 0
                M = Screen('GetImage', const.window,[],[],0,3);
                imwrite(M,fullfile(const.moviefolder, [num2str(movieframe_n),'.png']));
                movieframe_n = movieframe_n + 1;
            end            
            % FlushEvents('KeyDown');

        end
        
        %disp('ABOUT TO FLIP')
        vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);
        %disp('DONE WITH FLIP')
        frameCounter=frameCounter+1; % count one frame for both eyes
    else
        break
    end
     
end

%%

expDes.tiltangle(trialID) = tiltAmount;
%expDes.tiltmagnitude(trialID) = tiltMagnitude;

%disp('End of my_stim:')
% expDes.trialMat(trialID, 5)
end