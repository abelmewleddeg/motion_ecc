function [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl, color)

disp('my_blank')

if nargin < 6
    error('At least 6 arguments required')
elseif nargin < 7
    color = const.black;
end

%try
    waitframes = 1;
    %vbl = Screen('Flip',const.window);
    vblendtime = vbl + expDes.itiDur_s*100;

    % Blank period
    while vbl <= vblendtime  
        
        if ~const.expStop

            % draw stimuli here, better at the start of the drawing loop
            my_fixation(scr,const,color)
            %Screen('DrawingFinished',const.window); % small ptb optimisation
            vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);

            % check for keyboard input
            [keyIsDown, ~, keyCode] = KbCheck(my_key.keyboardID);
            if keyIsDown && keyCode(my_key.escape)
                ShowCursor; 
                const.forceQuit=1;
                const.expStop=1;
            elseif keyIsDown && ~keyCode(my_key.escape)
                expDes.task(frameCounter,2) = 1;   
            end

            FlushEvents('KeyDown');
            frameCounter=frameCounter+1;
            
        else
            break
        end
    end
    
% catch
%     return
% end

end