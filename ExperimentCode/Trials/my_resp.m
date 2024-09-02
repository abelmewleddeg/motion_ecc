function [expDes, const, frameCounter, vbl] = my_resp(my_key, scr, const, expDes, frameCounter, trialID, vbl)
waitframes = 1;
responseDir = nan;

%disp('my_resp')
if const.VRdisplay==1 % determine arrow dimensions for VR vs non-VR conditons
    global GL;
    InitializeMatlabOpenGL(1);
    lined = 1.5;
    arrowd = 4;
else
    lined = 4;
    arrowd = 10;
end 
% simulatedPsiParams = [0, 10, 0];
%
% % Function handle that will take stimulus parameters x and simulate
% % a trial according to the parameters above.
% simulatedObserverFun = @(x) qpSimulatedObserver(x,@qpPFNormal,simulatedPsiParams);
%
% % Freeze random number generator so output is repeatable
% rng('default'); rng(2004,'twister');
% rng(6);
% arrow dimensions
if expDes.trialMat(trialID,4) == 45
    x2 = scr.windCenter_px(1) - const.visiblesizeResp/lined;
    y2 = scr.windCenter_px(2) + const.visiblesizeResp/lined;
    x3 = scr.windCenter_px(1) + const.visiblesizeResp/lined;
    y3 = scr.windCenter_px(2) - const.visiblesizeResp/lined;
    x4 = x3 - const.visiblesizeResp/arrowd;
    y4 = y3 + const.visiblesizeResp/arrowd;
elseif expDes.trialMat(trialID,4) == 225
    x2 = scr.windCenter_px(1) + const.visiblesizeResp/lined;
    y2 = scr.windCenter_px(2) - const.visiblesizeResp/lined;
    x3 = scr.windCenter_px(1) - const.visiblesizeResp/lined;
    y3 = scr.windCenter_px(2) + const.visiblesizeResp/lined;
    x4 = x3 + const.visiblesizeResp/arrowd;
    y4 = y3 - const.visiblesizeResp/arrowd;
elseif expDes.trialMat(trialID,4) == 135
    x2 = scr.windCenter_px(1) + const.visiblesizeResp/lined;
    y2 = scr.windCenter_px(2) + const.visiblesizeResp/lined;
    x3 = scr.windCenter_px(1) - const.visiblesizeResp/lined;
    y3 = scr.windCenter_px(2) - const.visiblesizeResp/lined;
    x4 = x3 + const.visiblesizeResp/arrowd;
    y4 = y3 + const.visiblesizeResp/arrowd;
elseif expDes.trialMat(trialID,4) == 315
    x2 = scr.windCenter_px(1) - const.visiblesizeResp/lined;
    y2 = scr.windCenter_px(2) - const.visiblesizeResp/lined;
    x3 = scr.windCenter_px(1) + const.visiblesizeResp/lined;
    y3 = scr.windCenter_px(2) + const.visiblesizeResp/lined;
    x4 = x3 - const.visiblesizeResp/arrowd;
    y4 = y3 - const.visiblesizeResp/arrowd;
end
newy2 = y2 - const.vrVershift;
newy3 = y3 - const.vrVershift;
newy4 = y4 - const.vrVershift;
% draw arrow head
% if expDes.fillArrow
%     head = [x3 y3];
%     width = 10;
%     points = [x3,y3;x4,y3;x3,y4];
%     Screen('FillPoly', const.window, [255 255 255], points);
% else
%     Screen('DrawLine',const.window, [255 255 255],x3,y3,x4,y3,3);
%     Screen('DrawLine',const.window, [255 255 255],x3,y3,x3,y4,3);
% end
%% loop through boith eyes fior arrow presentation
keyIsDown = 0;
while ~keyIsDown
    % check for keyboard input
    [keyIsDown, ~, keyCode] = KbCheck(-1); %KbCheck(my_key.keyboardID);
    if const.VRdisplay==1
                % just doing for 1 eye b/c that's how Hope did it
                scr.oc.renderPass = 1;
                eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
                pa.floorHeight = -1; % m
                pa.fixationdist = 0.01; %40; %3;
                pa.gazeangle = atan(-pa.floorHeight/pa.fixationdist);
                R = [1 0 0; 0 cos(pa.gazeangle) -sin(pa.gazeangle); 0 sin(pa.gazeangle) cos(pa.gazeangle)];
                eye.modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1];
                eye.modelView(1:3,1:3) = eye.modelView(1:3,1:3)*R;
                originaleye = eye;
                theta = pa.gazeangle;
    
                for renderPass = 0:1 %:10 % 
                    % loop over eyes\
                    
                    %disp(sprintf('eye %i', renderPass))
                    scr.oc.renderPass = renderPass;
    
                    eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
    
                    if scr.oc.renderPass % drawing right eye
                        scr.oc.modelViewDataRight = [scr.oc.modelViewDataRight; eye.modelView];  
                        const.newcenter = [-const.vrshift -const.vrVershift];
                        const.VRcenter = scr.windCenter_px + const.newcenter;
                        newx2 = x2 - const.vrshift;
                        newx3 = x3 - const.vrshift;
                        newx4 = x4 - const.vrshift;
                    else % drawing left eye
                        scr.oc.modelViewDataLeft = [scr.oc.modelViewDataLeft; eye.modelView];
                        const.newcenter = [const.vrshift -const.vrVershift];
                        const.VRcenter = scr.windCenter_px + const.newcenter;
                        newx2 = x2 + const.vrshift;
                        newx3 = x3 + const.vrshift;
                        newx4 = x4 + const.vrshift;
                    end 
    
                    eye.eyeIndex = scr.oc.renderPass;
    
                    Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass); % openGL must be closed
                    modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %eye.modelView;
    
                    Screen('BeginOpenGL',const.window);
    
                    glClearColor(0.5, 0.5, 0.5, 3); % yellow background
    
                    glClear(); % clear the buffers - must be done for every frame
    
    
                    % glColor3f(0,0,1);
                    glClear(GL.COLOR_BUFFER_BIT);
                    %Setup camera position and orientation for this eyes view:
                    glMatrixMode(GL.PROJECTION)
                    glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});
    
                    glMatrixMode(GL.MODELVIEW);
                    glLoadMatrixd(modelView); 
                    glPushMatrix;
                    % glTranslatef(0,0.35,-2);
                    %glCallList(const.fixation);
                    % glCallList(const.bsquare);
                    % glTranslatef(0,-0.35,-6);
                    % glCallList(const.csquare);

                   

                    glPopMatrix;
    
                    Screen('EndOpenGL', const.window);
                    % main response line orientation
                    Screen('BlendFunction', const.window, 'GL_ONE', 'GL_ZERO');
                    my_fixation(scr,const,const.black)
                    if expDes.fillArrow
                        % head = [x3 y3];
                        % width = 10;
                        points = [newx3,newy3;newx4,newy3;newx3,newy4];
                        Screen('FillPoly', const.window, [255 255 255], points);
                    else  
                        Screen('DrawLine',const.window, [255 255 255],newx3+15,y3-15,newx4-15,y3-15,3);
                        Screen('DrawLine',const.window, [255 255 255],newx3+15,y3-15,newx3+15,y4+15,3);
                    end
                    Screen('DrawLine',const.window, [],newx2,newy2,newx3,newy3,3); % scr.windCenter_px(1),scr.windCenter_px(2),x1,y1) %scr.windCenter_px(1) +  xDist, scr.windCenter_px(2) +  yDist,1)
                    % % % [255 255 255]
                    %Screen('DrawingFinished',const.window); % small ptb optimisation
                    % % 
                    %vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);
                    %vbl = Screen('Flip',const.window);
    
                    %Screen('BlendFunction', const.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                   
    
                     % Screen('DrawTexture', const.window, const.squarewavetex, [], newdstRect, const.mapdirection(testDirection)+tiltAmount, ...
                     %    [], [], [], [],[], auxParams); % tex4testing
    
                   
                end
    else
        % draw arrow head
        if expDes.fillArrow
            % head = [x3 y3];
            % width = 10;
            points = [x3,y3;x4,y3;x3,y4];
            Screen('FillPoly', const.window, [255 255 255], points);
        else
            Screen('DrawLine',const.window, [255 255 255],x3,y3,x4,y3,3);
            Screen('DrawLine',const.window, [255 255 255],x3,y3,x3,y4,3);
        end
        const.newcenter = [0 0];
        const.VRcenter = scr.windCenter_px + const.newcenter;
        Screen('DrawLine',const.window, [255 255 255],x2,y2,x3,y3,3); % scr.windCenter_px(1),scr.windCenter_px(2),x1,y1) %scr.windCenter_px(1) +  xDist, scr.windCenter_px(2) +  yDist,1)
        my_fixation(scr,const,[0 0 0]) %const.black
        Screen('DrawingFinished',const.window); % small ptb optimisation
        % vbl = Screen('Flip',const.window);
    end
% end
%vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi)
    vbl = Screen('Flip',const.window);

% keyIsDown = 0;
% while ~keyIsDown
%     % check for keyboard input
%     [keyIsDown, ~, keyCode] = KbCheck(-1); %KbCheck(my_key.keyboardID);
end

%while ~(const.responded) % ~(const.expStop) &&

%if ~const.expStop

% check for keyboard input
%[keyIsDown, ~, keyCode] = KbCheck(-1); %KbCheck(my_key.keyboardID);

% max(keyIsDown)
% if ~keyIsDown % if finger is lifted off key do not set a time contraint
%     reset = 1;
%if keyIsDown
if keyCode(my_key.escape) % end experiment
    ShowCursor;
    const.forceQuit=1;
    const.responded =1;
    responseDir = nan;
    const.expStop=1;
elseif keyCode(my_key.rightArrow) % clockwise
    const.responded=1;
    responseDir = 1;
elseif keyCode(my_key.leftArrow) % counterclockwise
    const.responded=1;
    responseDir = -1;
elseif find(keyCode) == 175
    disp('clockwise')
    %key = KbName(find(keyCode))
    const.responded=1;
    responseDir = 1;
elseif find(keyCode) == 174
    disp('counterclockwise')
    const.responded=1;
    responseDir = -1;
else % to check for button press
    find(keyCode)
end

% responseDir = -1;

% FAKE RESPONSES (TAKE OUT LATER)
% const.responded=1;
% simResp = rand;
% if simResp > 0.5
%     responseDir = -1;
% else
%     responseDir = 1;
% end
% %  simulatedPsiParams = [-1, 10, 0];

% Function handle that will take stimulus parameters x and simulate
% a trial according to the parameters above.
%const.responded = 1;
% logAns = const.simulatedObserverFun(expDes.tiltangle(trialID));
% if logAns == 1
%     responseDir = -1;
% elseif logAns == 2
%     responseDir = 1;
%  end
% end
%end


% try fixing the blinking of fixation after response cue
% Screen('DrawDots', const.window, scr.windCenter_px, ...
%     const.fixationRadius_px, [0 0 0], [], 2);
% 
% vbl = Screen('Flip',const.window, vbl + (waitframes - 0.5) * scr.ifi);


% save submitted contrast:
expDes.response(trialID,1) = responseDir;

%% STAIRCASE
if const.staircasemode > 0  %&& const.staircasemode < 3
    staircaseIndx = expDes.trialMat(trialID,6);
    currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);

    % if the tiltangle is the same SIGN as the responseDir (e.g., -4.5 and -1 OR 4.5 and 1):
    %if expDes.trialMat(trialID, 5) == responseDir
    if ~isnan(responseDir)

        % coded for bayesian case but can be generalized (this is b/c
        % staircase starts at 0
        if expDes.tiltangle(trialID, 1)*responseDir == 0
            coinflip = rand(1);
        end

        if expDes.tiltangle(trialID, 1)*responseDir > 0 || (exist('coinflip', 'var') && coinflip>0.5)
            expDes.correctness{staircaseIndx}(currStaircaseIteration) = 1; % correct
            expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
            % feedbackRGB = [0 0 255]; %[0 0 1]; % remove later
        elseif expDes.tiltangle(trialID, 1)*responseDir < 0 || (exist('coinflip', 'var') && coinflip<=0.5)
            expDes.correctness{staircaseIndx}(currStaircaseIteration) = 0; % incorrect
            expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
            % feedbackRGB = [255 0 0]; %[1 0 0];
        else
            feedbackRGB = [0 255 0]; % [0 255 0]
        end
        % [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl, feedbackRGB);

        % if the correctness from previous trial is not NAN and is not the the
        % last trial-1 - run the staircase to obtain new threshold for this
        % trial
        % corrNow flips correct/incorrect for the backwards staircase. This
        % variable is ONLY used here
        if ~isnan(expDes.correctness{staircaseIndx}(currStaircaseIteration)) %&& trialID<expDes.nb_trials-1 % if correct has valid value
            if const.staircasemode == 1 && trialID<expDes.nb_trials-1% updown
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
                    expDes.stairs{staircaseIndx}(currStaircaseIteration+1).threshold = 0.1; %expDes.trialMat(currStaircaseIteration+1, 5);
                end
                save(const.design_fileMat,'expDes'); % save responses/design

            elseif const.staircasemode == 2 % bayesian

                % trying a fix for staircase 2
                if responseDir == -1
                    logAns = 1;
                elseif responseDir == 1
                    logAns = 2;
                end
                % % Parameters of the simulated Normal
                %logAns = responseDir;
                % if correct == 2 and incorrect = 1
                corrNow = expDes.correctness{staircaseIndx}(currStaircaseIteration)+1; % add 1 for the 1,2 vs 0,1 discrepancey
                %expDes.stairs{staircaseIndx}(currStaircaseIteration+1) = qpUpdate(expDes.stairs{staircaseIndx}(currStaircaseIteration), expDes.tiltangle(trialID), corrNow);
                expDes.stairs{staircaseIndx} = qpUpdate(expDes.stairs{staircaseIndx}, expDes.tiltangle(trialID),logAns); %corrNow);

                tempsaveExpDes = expDes;
                for i=1:length(tempsaveExpDes.stairs)
                    tempsaveExpDes.stairs{i} = rmfield(tempsaveExpDes.stairs{i}, 'precomputedOutcomeProportions');
                end
                save(const.design_fileMat,'tempsaveExpDes'); % note, not saving entire struct because it causes a delay
            elseif const.staircasemode == 3 
                if expDes.tiltangle(trialID, 1)*responseDir > 0
                    expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
                    % feedbackRGB = [0 0 255]; %[0 0 1];
                elseif expDes.tiltangle(trialID, 1)*responseDir < 0
                    expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
                    % feedbackRGB = [255 0 0]; %[1 0 0];
                end
            end
        end
        % iterate over that particular staircase (not really used for
        % bayesian, just printing the #)
        expDes.stair_counter(1, staircaseIndx) = expDes.stair_counter(1, staircaseIndx)+1;

    end
% elseif const.staircasemode == 3
%     staircaseIndx = expDes.trialMat(trialID,6);
%     currStaircaseIteration = expDes.stair_counter(1, staircaseIndx);
%     if expDes.tiltangle(trialID, 1)*responseDir > 0
%         expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
%         % feedbackRGB = [0 0 255]; %[0 0 1];
%     elseif expDes.tiltangle(trialID, 1)*responseDir < 0
%         expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
%         % feedbackRGB = [255 0 0]; %[1 0 0];
%     end
%     expDes.stair_counter(1, staircaseIndx) = expDes.stair_counter(1, staircaseIndx)+1;
else
    if expDes.tiltangle(trialID, 1)*responseDir > 0
        expDes.response(trialID, 2) = 1; % "correct" for overall response matrix
        feedbackRGB = [0 0 255]; %[0 0 1];
    elseif expDes.tiltangle(trialID, 1)*responseDir < 0
        expDes.response(trialID, 2) = 0; % "correct" for overall response matrix
        feedbackRGB = [255 0 0]; %[1 0 0];
    else % nan (to prevent error when quitting)
        feedbackRGB = [0 255 0]; % [0 255 0]
    end
    
    % feedbackRGB = [0 0 0];
    save(const.design_fileMat,'expDes');
    [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl, feedbackRGB);

end

end