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
            elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.rightArrow) 
                const.responded=1; 
                responseDir = 1;
            elseif keyIsDown && ~keyCode(my_key.escape) && keyCode(my_key.leftArrow) 
                const.responded=1; 
                responseDir = 0;
            end

        end
    
    end


% save submitted contrast:
expDes.response(trialID, 1) = responseDir;

end