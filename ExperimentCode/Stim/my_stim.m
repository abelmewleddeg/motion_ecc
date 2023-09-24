function [expDes, const, frameCounter, vbl] = my_stim(my_key, scr, const, expDes, frameCounter, trialID, vbl)

movieDurationSecs=expDes.stimDur_s;   % Abort after 0.5 seconds.
iL = const.phaseLine(1,trialID);
iR = const.phaseLine(2,trialID);

testContrast = expDes.trialMat(trialID,2); % contrast value
adjustedContrast = expDes.startingContrasts(1,trialID); % these can either be random or some starting value
responseDir = expDes.responseDirection(1,trialID);
%eccentricity
% for Utrials = 1:length(trialIDs(1,:))
if expDes.trialMat(trialID,3) == 2
    const.stimEccpix = vaDeg2pix(expDes.trialMat(trialID,3),scr)
elseif expDes.trialMat(trialID,3) == 4
    const.stimEccpix = vaDeg2pix(expDes.trialMat(trialID,3),scr)
elseif expDes.trialMat(trialID,3) == 6
    const.stimEccpix = vaDeg2pix(expDes.trialMat(trialID,3),scr)
end
% end
XYDist = sqrt(const.stimEccpix/2)
if expDes.trialMat(trialID,2) == 45
    xDist = const.stimEccpix; yDist = const.stimEccpix
elseif expDes.trialMat(trialID,2) == 135
   xDist = -(const.stimEccpix); yDist = const.stimEccpix
elseif expDes.trialMat(trialID,2) == 225
   xDist = -(const.stimEccpix); yDist = -(const.stimEccpix)
elseif expDes.trialMat(trialID,2) == 315
   xDist = const.stimEccpix; yDist = -(const.stimEccpix)
end
% eccentricity
%xDist = const.stimEccpix; yDist = const.stimEccpix;

%dstRect_R = create_dstRect(const.visiblesize, xDist, yDist, scr, 1); % right side
dstRect_L = create_dstRect(const.visiblesize, xDist, yDist, scr, 0); % left side

waitframes = 1;
vblendtime = vbl + movieDurationSecs;

flicker_time = movieDurationSecs/(movieDurationSecs*const.flicker_hz); 
increment = flicker_time;
flipphase = -1; phasenow = 90; %1;
const.responded=0;
movieframe_n = 1;

% Animationloop:
%while (vbl < vblendtime)
while ~(const.expStop) && ~(const.responded)

    if ~const.expStop  
         
        % if (movieDurationSecs-(vblendtime-vbl)) > flicker_time
        % 
        %     flicker_time = flicker_time+increment;
        % end

        phasenow = phasenow + const.speedPixel; %  10

        contrast_R = testContrast; contrast_L = testContrast;
        
        if strcmp(expDes.stimulus, 'perlinNoise')
             auxParamsR = [contrast_R, iR, const.scalar4noiseTarget, phasenow];
             auxParamsL = [contrast_L, iL, const.scalar4noiseTarget, phasenow];
        elseif strcmp(expDes.stimulus, 'grating')
            auxParamsR = [iR+(phasenow), const.stimSF_cpp, contrast_R, 0];
            auxParamsL = [iL+(phasenow), const.stimSF_cpp, contrast_L, 0];
        end
        
        % Set the right blend function for drawing the gabors
        Screen('BlendFunction', const.window, 'GL_ONE', 'GL_ZERO');
        
        %if phasenow - should i just present counterphase this way?
        % Draw grating texture, rotated by "angle":
        % Screen('DrawTexture', const.window, const.squarewavetex, [], dstRect_R, const.maporientation(const.stimOri), ...
            % [], [], [], [], [], auxParamsR);
        
        Screen('DrawTexture', const.window,  const.squarewavetex, [], dstRect_L, const.maporientation(const.stimOri), ...
            [], [], [], [],[], auxParamsL);
        
        % add grey gradient masks
        Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        Screen('DrawTexture', const.window, const.centermask, [], dstRect_L, [], [], [], [], [], []);

        % Screen('DrawTexture', const.window, const.centermask, [], dstRect_R, [], [], [], [], [], []);


        % Draw stimuli here, better at the start of the drawing loop
        my_fixation(scr,const,const.black)

        Screen('DrawingFinished',const.window); % small ptb optimisation

        vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);

        % check for keyboard input
        [keyIsDown, ~, keyCode] = KbCheck(my_key.keyboardID);
        % if ~keyIsDown % if finger is lifted off key do not set a time contraint
        %     reset = 1;
        if keyIsDown && keyCode(my_key.escape)
            ShowCursor; 
            const.forceQuit=1;
            const.expStop=1;
        elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.rightArrow) 
            const.responded=1; 
            responseDir = 1;
        elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.leftArrow) 
            const.responded=1; 
            responseDir = 0;
            
        % elseif (keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.rightArrow)) && reset
        %     adjustedContrast = adjustedContrast+0.01;
        %     reset = 1
        %     % if adjustedContrast>1
        %     %     adjustedContrast=1;
        %     % end
        % elseif (keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.leftArrow)) && reset
        %     adjustedContrast = adjustedContrast-0.01;
        %     reset = 1;
        %     if adjustedContrast<0
        %         adjustedContrast=0;
        %     end
        end

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

% save submitted contrast:
expDes.response(trialID, 1) = responseDir %adjustedContrast;

%%

function dstRect = create_dstRect(visiblesize, xDist, yDist, scr, rightside)
    if ~rightside
        xDist = -xDist;
    end
    xDist = scr.windCenter_px(1)+xDist-(visiblesize/2); % center + (+- distance added in pixels)
    yDist = scr.windCenter_px(2)+yDist-(visiblesize/2);  % check with -(vis part.. 
    dstRect=[xDist yDist visiblesize+xDist visiblesize+yDist];
end

end
