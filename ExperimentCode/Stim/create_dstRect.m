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