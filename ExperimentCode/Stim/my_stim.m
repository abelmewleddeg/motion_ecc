function [expDes, const, frameCounter, vbl] = my_stim(my_key, scr, const, expDes, frameCounter, trialID, vbl)

disp('my_stim')
movieDurationSecs=expDes.stimDur_s;   % Abort after 0.5 seconds.
currPhase = const.phaseLine(1,trialID);

if const.staircasemode > 0
    % which staircase + what iteration
    staircaseIndx = expDes.trialMat(trialID,6);
    currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);

    % correcting the trialMat of predefined c / cc values for when
    % staircase iteration goes the other way
    if const.staircasemode == 1
        if ~(expDes.trialMat(trialID, 5)* expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold > 0)
            expDes.trialMat(trialID, 5) = expDes.trialMat(trialID, 5)*-1;
        end
        
    elseif const.staircasemode == 2
        
        tiltAmount = qpQuery(expDes.stairs{staircaseIndx});
        
        if tiltAmount==0
            expDes.trialMat(trialID, 5) = 0;
        else
            clockSign = tiltAmount/abs(tiltAmount);
            expDes.trialMat(trialID, 5) = clockSign;  
        end
        
    end
end
    
disp('End of my_stim loop1:')
expDes.trialMat(trialID, 5)

tiltSign = expDes.trialMat(trialID, 5); % -1 or 1 ()

testDirection = expDes.trialMat(trialID,4); % e.g. 90, 180 drift direction

% eccentricity
const.stimEccpix = vaDeg2pix(expDes.trialMat(trialID,3),scr);
xDist = sqrt((const.stimEccpix^2)/2); yDist = sqrt((const.stimEccpix^2)/2);

% visible size
dstRect = create_dstRect(const.visiblesize, xDist, yDist, scr, expDes.trialMat(trialID,2), const); 

waitframes = 1;
vblendtime = vbl + movieDurationSecs;

const.responded=0;
movieframe_n = 1;
phasenow = 90;

%% STAIRCASE FOR TILT ANGLE

if const.staircasemode > 0
    % this should be a matrix of nans initialized in const. (col per staircase- each with the counter?)
    if expDes.stair_counter(1, staircaseIndx) == 1
        disp('first iteration of staircase')
    end
    
    if const.staircasemode == 1
        expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold
        tiltAmount = expDes.stairs{staircaseIndx}(currStaircaseIteration).threshold;
    end

    disp('Sign to start staircase:')
    disp(tiltSign)
    disp('Tilt value:')
    disp(tiltAmount)
    disp('staircaseIndx:')
    disp(staircaseIndx)
else
    tiltAmount = 20*tiltSign; % constant value for now
end

%%

% Animationloop:
while ~(const.expStop) && (vbl < vblendtime)

    if ~const.expStop  

        phasenow = phasenow + const.speedPixel; %  10
        
        if strcmp(expDes.stimulus, 'perlinNoise')
             auxParams = [const.stimContrast, currPhase, const.scalar4noiseTarget, phasenow];
        elseif strcmp(expDes.stimulus, 'grating')
            auxParams = [currPhase+(phasenow), const.stimSF_cpp, const.stimContrast, 0];
        end
        
        % Set the right blend function for drawing the gabors
        Screen('BlendFunction', const.window, 'GL_ONE', 'GL_ZERO');
        
        %if phasenow - should i just present counterphase this way?
        % Draw grating texture, rotated by "angle":
        Screen('DrawTexture', const.window,  const.squarewavetex, [], dstRect, const.mapdirection(testDirection)+tiltAmount, ...
            [], [], [], [],[], auxParams);
        
        % add grey gradient masks
        Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        Screen('DrawTexture', const.window, const.centermask, [], dstRect, [], [], [], [], [], []);


        % Draw stimuli here, better at the start of the drawing loop
        my_fixation(scr,const,const.black)

        Screen('DrawingFinished',const.window); % small ptb optimisation

        vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);

        if const.makemovie && mod(frameCounter,15) == 0
            M = Screen('GetImage', const.window,[],[],0,3);
            imwrite(M,fullfile(const.moviefolder, [num2str(movieframe_n),'.png']));
            movieframe_n = movieframe_n + 1;
        end
        
        % FlushEvents('KeyDown');
        frameCounter=frameCounter+1;
    else
        break
    end
     
end


expDes.tiltangle(trialID) = tiltAmount;
%expDes.tiltmagnitude(trialID) = tiltMagnitude;

%%

function dstRect = create_dstRect(visiblesize, xDist, yDist, scr, paLoc, const)

    if paLoc == 45
        yDist = -yDist;
    elseif paLoc == 135
        xDist = -xDist;
        yDist = -yDist;
    elseif paLoc == 225
        xDist = -xDist;
    elseif paLoc == 315
        xDist = xDist;
    else
        const.expStop =1;
        error('PA location not set up in my_stim and my_resp. Please configure.') 
    end

    xDist = scr.windCenter_px(1)+xDist-(visiblesize/2); % center + (+- distance added in pixels)
    yDist = scr.windCenter_px(2)+yDist-(visiblesize/2);  % check with -(vis part.. 
    dstRect=[xDist yDist visiblesize+xDist visiblesize+yDist];
    % const.distance = [xDist,yDist];
    % const.visiblesize = visiblesize/2
end

disp('End of my_stim:')
expDes.trialMat(trialID, 5)

end
