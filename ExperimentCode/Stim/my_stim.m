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

% eccentricity
xDist = const.stimEccpix; yDist = const.stimEccpix;

dstRect_L = create_dstRect(const.visiblesize, xDist, yDist, scr, expDes.trialMat(trialID,2)); 

waitframes = 1;
vblendtime = vbl + movieDurationSecs;

flicker_time = movieDurationSecs/(movieDurationSecs*const.flicker_hz); 
increment = flicker_time;
flipphase = -1; phasenow = 90; %1;
const.responded=0;
movieframe_n = 1;
testDirection = expDes.trialMat(trialID,4);

%% STAIRCASE FOR TILT ANGLE

stair1_counter = 1; stair2_counter = 1;
thresh_counted1 = []; thresh_counted2 = [];
% for staircase one
if mod(trialID,2) 
    jj = 1;
    disp('Current threshold for staircase 1:')
    thresh_counted1 = [thresh_counted1, expDes.stairs1(stair1_counter).threshold];
    stair1_counter = stair1_counter+1;
    
    % simulate response
    if expDes.stairs1(stair1_counter-1).threshold+randn > 1
        expDes.correctness{jj}(stair1_counter-1) = 1;
    else
        expDes.correctness{jj}(stair1_counter-1) = 0;
    end
    
    if ~isnan(expDes.correctness{jj}(stair1_counter-1)) && trialID<expDes.nb_trials-1 % if correct has valid value
        expDes.stairs1(stair1_counter) = upDownStaircase(expDes.stairs1(stair1_counter-1), expDes.correctness{jj}(stair1_counter-1));
    end
    
else
    jj = 2;
    disp('Current threshold 2:')
    thresh_counted2 = [thresh_counted2, expDes.stairs2(stair2_counter).threshold];
    stair2_counter = stair2_counter+1;
    
    % simulate response
    if expDes.stairs2(stair2_counter-1).threshold+randn > 1
        expDes.correctness{jj}(stair2_counter-1) = 1;
    else
        expDes.correctness{jj}(stair2_counter-1) = 0;
    end
    
    if ~isnan(expDes.correctness{jj}(stair2_counter-1)) && trialID<expDes.nb_trials-1 % if correct has valid value
        expDes.stairs2(stair2_counter) = upDownStaircase(expDes.stairs2(stair2_counter-1), expDes.correctness{jj}(stair2_counter-1));
    end
end

tiltAmount = 5;
%%

% Animationloop:
while ~(const.expStop) && (vbl < vblendtime)

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
        
        Screen('DrawTexture', const.window,  const.squarewavetex, [], dstRect_L, const.mapdirection(testDirection)+tiltAmount, ...
            [], [], [], [],[], auxParamsL); %const.mapdirection(testDirection)
        
        % add grey gradient masks
        Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        Screen('DrawTexture', const.window, const.centermask, [], dstRect_L, [], [], [], [], [], []);

        % Screen('DrawTexture', const.window, const.centermask, [], dstRect_R, [], [], [], [], [], []);


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

%%

function dstRect = create_dstRect(visiblesize, xDist, yDist, scr, paLoc)

    if paLoc == 45
        yDist = -yDist;
    elseif paLoc == 135
        xDist = -xDist;
        yDist = -yDist;
    elseif paLoc == 225
        xDist = -xDist;
%     elseif paLoc == 315
%         continue
    end

    xDist = scr.windCenter_px(1)+xDist-(visiblesize/2); % center + (+- distance added in pixels)
    yDist = scr.windCenter_px(2)+yDist-(visiblesize/2);  % check with -(vis part.. 
    dstRect=[xDist yDist visiblesize+xDist visiblesize+yDist];
end

end
