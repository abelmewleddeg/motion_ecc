function dstRect = create_dstRect(visiblesize, xDist, yDist, scr, paLoc, const)
   
    if ~const.VRdisplay
        xEccScale = xDist;
    elseif const.VRdisplay
        xhat = (cos((xDist/1080)*deg2rad(90)))*100;
        xEccScale = xDist; %xhat; %xDist - xhat
    end


    if paLoc == 45
        yDist = -yDist;
        xDist = xEccScale; % + xEccScale
    elseif paLoc == 135
        xDist = -xEccScale; % - xEccScale;
        yDist = -yDist;
    elseif paLoc == 225
        xDist = -xEccScale; % - xEccScale;
    elseif paLoc == 315
        xDist = xEccScale; % + xEccScale;
    else
        const.expStop =1;
        error('PA location not set up in my_stim and my_resp. Please configure.') 
    end
    
    % xDist = scr.windCenter_px(1)+xDist-(visiblesize/2); % center + (+- distance added in pixels)
    % yDist = scr.windCenter_px(2)+yDist-(visiblesize/2);  % check with -(vis part.. 
    xDist = const.VRcenter(1)+xDist-(visiblesize/2); % center + (+- distance added in pixels)
    yDist = const.VRcenter(2)+yDist-(visiblesize/2);  % check with -(vis part.. 
    dstRect=[xDist yDist visiblesize+xDist visiblesize+yDist];

    
    % const.distance = [xDist,yDist];
    % const.visiblesize = visiblesize/2
end