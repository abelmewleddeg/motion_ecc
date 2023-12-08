function [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, trialID, vbl)

    waitframes = 1;
    responseDir = nan;

    while ~(const.expStop) && ~(const.responded)
    
        if ~const.expStop

           
          
            % THIS IS WHERE YOUR CODE GOES
           % if expDes.trialMat(trialID,2) == 45
           %      x1 =  scr.windCenter_px(1) + const.stimEccpix;
           %      y1 = scr.windCenter_px(2) - const.stimEccpix;
           % elseif  expDes.trialMat(trialID,2) == 135
           %      x1 = scr.windCenter_px(1) - const.stimEccpix;
           %      y1 = scr.windCenter_px(2) - const.stimEccpix;
           % elseif  expDes.trialMat(trialID,2) == 225
           %      x1 = scr.windCenter_px(1) - const.stimEccpix;
           %      y1 = scr.windCenter_px(2) + const.stimEccpix;
           % elseif  expDes.trialMat(trialID,2) == 315
           %      x1 = scr.windCenter_px(1) + const.stimEccpix;
           %      y1 = scr.windCenter_px(2) + const.stimEccpix;
           % end

           if expDes.trialMat(trialID,4) == 45
               x2 = scr.windCenter_px(1) - const.visiblesize/4;
               y2 = scr.windCenter_px(2) + const.visiblesize/4;
               x3 = scr.windCenter_px(1) + const.visiblesize/4;
               y3 = scr.windCenter_px(2) - const.visiblesize/4;
               x4 = x3 - const.visiblesize/10;
               y4 = y3 + const.visiblesize/10;
           elseif expDes.trialMat(trialID,4) == 225
               x2 = scr.windCenter_px(1) + const.visiblesize/4;
               y2 = scr.windCenter_px(2) - const.visiblesize/4;
               x3 = scr.windCenter_px(1) - const.visiblesize/4;
               y3 = scr.windCenter_px(2) + const.visiblesize/4;
               x4 = x3 + const.visiblesize/10;
               y4 = y3 - const.visiblesize/10;
           elseif expDes.trialMat(trialID,4) == 135 
               x2 = scr.windCenter_px(1) + const.visiblesize/4;
               y2 = scr.windCenter_px(2) + const.visiblesize/4;
               x3 = scr.windCenter_px(1) - const.visiblesize/4;
               y3 = scr.windCenter_px(2) - const.visiblesize/4;
               x4 = x3 + const.visiblesize/10;
               y4 = y3 + const.visiblesize/10;
           elseif expDes.trialMat(trialID,4) == 315
               x2 = scr.windCenter_px(1) - const.visiblesize/4;
               y2 = scr.windCenter_px(2) - const.visiblesize/4;
               x3 = scr.windCenter_px(1) + const.visiblesize/4;
               y3 = scr.windCenter_px(2) + const.visiblesize/4;
               x4 = x3 - const.visiblesize/10;
               y4 = y3 - const.visiblesize/10;
           end

           % draw arrow head
           if expDes.fillArrow
               head = [x3 y3];
               width = 10;
               points = [x3,y3;x4,y3;x3,y4];
               Screen('FillPoly', const.window, [255 255 255], points);
           else
                Screen('DrawLine',const.window, [255 255 255],x3,y3,x4,y3,3);
                Screen('DrawLine',const.window, [255 255 255],x3,y3,x3,y4,3);
           end

            % main response line orientation
            Screen('DrawLine',const.window, [255 255 255],x2,y2,x3,y3,3); % scr.windCenter_px(1),scr.windCenter_px(2),x1,y1) %scr.windCenter_px(1) +  xDist, scr.windCenter_px(2) +  yDist,1)

            my_fixation(scr,const,[0 0 0]) %const.black
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
            elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.rightArrow) % clockwise
                const.responded=1; 
                responseDir = 1;
            elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.leftArrow) % counterclockwise
                const.responded=1; 
                responseDir = -1;
            elseif keyIsDown && find(keyCode) == 175
                disp('clockwise')
                %key = KbName(find(keyCode))
                const.responded=1; 
                responseDir = 1;
            elseif keyIsDown && find(keyCode) == 174
                disp('counterclockwise')
                const.responded=1; 
                responseDir = -1;
            elseif keyIsDown % to check for button press
                find(keyCode)
            end
            

            % % FAKE RESPONSES (TAKE OUT LATER)
            % const.responded=1; 
            % simResp = rand; 
            % if simResp > 0.5
            %     responseDir = -1;
            % else
            %     responseDir = 1;
            % end 

        end
    end
    vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);


% save submitted contrast:
expDes.response(trialID,1) = responseDir;
    
%% STAIRCASE

staircaseIndx = expDes.trialMat(trialID,6);
currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);

% if the tiltangle is the same SIGN as the responseDir (e.g., -4.5 and -1 OR 4.5 and 1):
%if expDes.trialMat(trialID, 5) == responseDir
if ~isnan(responseDir)
    
    disp('~~~~~~~')
    staircaseIndx
    currStaircaseIteration
    size(expDes.correctness)
    size(expDes.correctness{staircaseIndx})
    disp('~~~~~~~')
    
    if expDes.tiltangle(trialID, 1)*responseDir > 0 
        expDes.correctness{staircaseIndx}(currStaircaseIteration) = 1; % correct
        expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
    elseif expDes.tiltangle(trialID, 1)*responseDir < 0
        expDes.correctness{staircaseIndx}(currStaircaseIteration) = 0; % incorrect
        expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
    end
    save(const.design_fileMat,'expDes');

    
    % if the correctness from previous trial is not NAN and is not the the
    % last trial-1 - run the staircase to obtain new threshold for this
    % trial
    % corrNow flips correct/incorrect for the backwards staircase. This
    % variable is ONLY used here
    if ~isnan(expDes.correctness{staircaseIndx}(currStaircaseIteration)) && trialID<expDes.nb_trials-1 % if correct has valid value
        % b/c staircase algorithm makes things "harder" by decreasing the
        % thresh - consider correct/incorrect FLIPPED for counterclockwise
        %if expDes.tiltangle(trialID, 1)<0
        if expDes.trialMat(trialID, 5) == -1 % this (-1 == cc) is upated based on threshold from staircase (in my_stim)
            corrNow = expDes.correctness{staircaseIndx}(currStaircaseIteration);
            % flipping correct and incorrect for the counterclockwise
            % (reverse) staircase. 
            if corrNow == 1
                corrNow = 0;
            elseif corrNow == 0
                corrNow = 1;
            end
        elseif expDes.trialMat(trialID, 5) == 1 % (1 = c)
            corrNow = expDes.correctness{staircaseIndx}(currStaircaseIteration);
        end
        expDes.stairs{staircaseIndx}(currStaircaseIteration+1) = upDownStaircase(expDes.stairs{staircaseIndx}(currStaircaseIteration), corrNow);

        %add if statement to prevent tilt value to equal 0
        if expDes.stairs{staircaseIndx}(currStaircaseIteration+1).threshold == 0
           expDes.stairs{staircaseIndx}(currStaircaseIteration+1).threshold = 0.1%expDes.trialMat(currStaircaseIteration+1, 5);
         end

    end
    % iterate over that particular staircase
    expDes.stair_counter(1, staircaseIndx) = expDes.stair_counter(1, staircaseIndx)+1;

end
%%

end