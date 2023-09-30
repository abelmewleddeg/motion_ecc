function [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, trialID, vbl)

    waitframes = 1;

    while ~(const.expStop) && ~(const.responded)
    
        if ~const.expStop  

            my_fixation(scr,const,[0 0 1]) %const.black

            % THIS IS WHERE YOUR CODE GOES

            % ...

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

% if the tiltsign is the same as the response sign:
if expDes.trialMat(trialID, 5) == responseDir
    expDes.correctness{staircaseIndx}(currStaircaseIteration) = 1; % correct
    expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
else
    expDes.correctness{staircaseIndx}(currStaircaseIteration) = 0; % incorrect
    expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
end

% if the correctness from previous trial is not NAN and is not the the
% last trial-1 - run the staircase to obtain new threshold for this
% trial
if ~isnan(expDes.correctness{staircaseIndx}(currStaircaseIteration)) && trialID<expDes.nb_trials-1 % if correct has valid value
    expDes.stairs{staircaseIndx}(currStaircaseIteration+1) = upDownStaircase(expDes.stairs{staircaseIndx}(currStaircaseIteration), expDes.correctness{staircaseIndx}(currStaircaseIteration));
end

% iterate over that particular staircase
expDes.stair_counter(1, staircaseIndx) = expDes.stair_counter(1, staircaseIndx)+1;

%%

end