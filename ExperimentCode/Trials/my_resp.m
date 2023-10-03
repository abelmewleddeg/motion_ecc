function [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, trialID, vbl)

    waitframes = 1;

    while ~(const.expStop) && ~(const.responded)
    
        if ~const.expStop  scr.windCenter_px(1)

           
          
            % THIS IS WHERE YOUR CODE GOES
           if expDes.trialMat(trialID,2) == 45
                x1 =  scr.windCenter_px(1) + const.stimEccpix;
                y1 = scr.windCenter_px(2) - const.stimEccpix;
           elseif  expDes.trialMat(trialID,2) == 135
                x1 = scr.windCenter_px(1) - const.stimEccpix;
                y1 = scr.windCenter_px(2) - const.stimEccpix;
           elseif  expDes.trialMat(trialID,2) == 225
                x1 = scr.windCenter_px(1) - const.stimEccpix;
                y1 = scr.windCenter_px(2) + const.stimEccpix;
           elseif  expDes.trialMat(trialID,2) == 315
                x1 = scr.windCenter_px(1) + const.stimEccpix;
                y1 = scr.windCenter_px(2) + const.stimEccpix;
           end

           if expDes.trialMat(trialID,4) == 45 || expDes.trialMat(trialID,4) == 225
               x2 = scr.windCenter_px(1) - const.visiblesize/4;
               y2 = scr.windCenter_px(2) + const.visiblesize/4;
               x3 = scr.windCenter_px(1) + const.visiblesize/4;
               y3 = scr.windCenter_px(2) - const.visiblesize/4;
           elseif expDes.trialMat(trialID,4) == 135 || expDes.trialMat(trialID,4) == 315
               x2 = scr.windCenter_px(1) + const.visiblesize/4;
               y2 = scr.windCenter_px(2) + const.visiblesize/4;
               x3 = scr.windCenter_px(1) - const.visiblesize/4;
               y3 = scr.windCenter_px(2) - const.visiblesize/4;
           end
             % ...
            Screen('DrawLine',const.window, [255 255 255],x2,y2,x3,y3,3) % scr.windCenter_px(1),scr.windCenter_px(2),x1,y1) %scr.windCenter_px(1) +  xDist, scr.windCenter_px(2) +  yDist,1)
            my_fixation(scr,const,[0 0 1]) %const.black
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
            end

        end
    
    end


% save submitted contrast:
expDes.response(trialID, 1) = responseDir;
    
%% STAIRCASE

staircaseIndx = expDes.trialMat(trialID,6);
currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);

% if the tiltangle is the same SIGN as the responseDir (e.g., -4.5 and -1 OR 4.5 and 1):
%if expDes.trialMat(trialID, 5) == responseDir
if expDes.tiltangle(trialID, 1)*responseDir > 0 
    expDes.correctness{staircaseIndx}(currStaircaseIteration) = 1; % correct
    expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
else
    expDes.correctness{staircaseIndx}(currStaircaseIteration) = 0; % incorrect
    expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
end

% if the correctness from previous trial is not NAN and is not the the
% last trial-1 - run the staircase to obtain new threshold for this
% trial
% corrNow flips correct/incorrect for the backwards staircase. This
% variable is ONLY used here
if ~isnan(expDes.correctness{staircaseIndx}(currStaircaseIteration)) && trialID<expDes.nb_trials-1 % if correct has valid value
    % b/c staircase algorithm makes things "harder" by decreasing the
    % thresh - consider correct/incorrect FLIPPED for counterclockwise
    %if expDes.tiltangle(trialID, 1)<0
    if expDes.trialMat(trialID, 5) == -1 % should this depend on the staircase OR the tilt angle?
        corrNow = expDes.correctness{staircaseIndx}(currStaircaseIteration);
        if corrNow == 1
            corrNow = 0;
        elseif corrNow == 0
            corrNow = 1;
        end
    else
        corrNow = expDes.correctness{staircaseIndx}(currStaircaseIteration);
    end
    expDes.stairs{staircaseIndx}(currStaircaseIteration+1) = upDownStaircase(expDes.stairs{staircaseIndx}(currStaircaseIteration), corrNow);
end
% iterate over that particular staircase
expDes.stair_counter(1, staircaseIndx) = expDes.stair_counter(1, staircaseIndx)+1;

%%

end