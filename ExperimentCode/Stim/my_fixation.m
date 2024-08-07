 function my_fixation(scr,const,color)
% ----------------------------------------------------------------------
% my_fixationCross(scr,const,color)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw a fixation cross in the center of the screen
% ----------------------------------------------------------------------
% Input(s) :
% scr = scr variable with contains Window Pointer   ex : scr
% color = color of the circle in RBG or RGBA        ex : color = [0 0 0]
% const = structure containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% ----------------------------------------------------------------------
% Draw the fixation point

%if const.VRdisplay==0 % not in VR
    % Screen('DrawDots', const.window, scr.windCenter_px, ...
    % 3.214*6, color, const.newcenter, 2); % const.fixationRadius_px

     Screen('DrawDots', const.window, const.VRcenter, ...
    const.fixationRadius_px, color, [], 2); % const.fixationRadius_px
%end


end