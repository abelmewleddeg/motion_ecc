function [expDes, const, frameCounter, vbl] = my_blank(my_key, scr, const, expDes, frameCounter, vbl, color)

disp('my_blank')

if nargin < 6
    error('At least 6 arguments required')
elseif nargin < 7
    color = const.black;
end

if const.VRdisplay==1
    global GL;
    InitializeMatlabOpenGL(1);
end

%try
    waitframes = 1;
    %vbl = Screen('Flip',const.window);
    vblendtime = vbl + expDes.itiDur_s;

    % Blank period
    while vbl <= vblendtime  
        
        if ~const.expStop

            if const.VRdisplay==0
                disp('my_blank_nonVR')
                 const.newcenter = [0 0];
                % draw stimuli here, better at the start of the drawing loop
                my_fixation(scr,const,color)

            elseif const.VRdisplay==1
                disp('my_blank_VR')

            
                % just doing for 1 eye b/c that's how Hope did it
                scr.oc.renderPass = 1;
                eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
                pa.floorHeight = -1; % m
                pa.fixationdist = 3;
                pa.gazeangle = atan(-pa.floorHeight/pa.fixationdist);
                R = [1 0 0; 0 cos(pa.gazeangle) -sin(pa.gazeangle); 0 sin(pa.gazeangle) cos(pa.gazeangle)];
                eye.modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1];
                eye.modelView(1:3,1:3) = eye.modelView(1:3,1:3)*R;
                originaleye = eye;
                theta = pa.gazeangle;
            
                for renderPass = 0:1 %:1 % loop over eyes
                    scr.oc.renderPass = renderPass;
            
                    eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);
            
                    if scr.oc.renderPass % drawing right eye
                        scr.oc.modelViewDataRight = [scr.oc.modelViewDataRight; eye.modelView];
                        const.newcenter = [-const.vrshift/2 0];
            
                    else % drawing left eye
                        scr.oc.modelViewDataLeft = [scr.oc.modelViewDataLeft; eye.modelView];
                        const.newcenter = [const.vrshift/2 0];
                    end 
            
                    eye.eyeIndex = scr.oc.renderPass;
            
                    Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass); % openGL must be closed
                    modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %eye.modelView;
                    %modelView = eye.modelView;
            
                    Screen('BeginOpenGL',const.window);
                    
                    glClearColor(0, 1, 0, 3); % red background
            
                    glClear(); % clear the buffers - must be done for every frame
                    %glColor3f(1,1,1);
                    %glColor4f(1,1, 1, 1);
            
                   
                    % % Clear the screen
                    %glClear(GL.COLOR_BUFFER_BIT);
            
                    % Setup camera position and orientation for this eyes view:
                    glMatrixMode(GL.PROJECTION)
                    glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});
            
                    glMatrixMode(GL.MODELVIEW);
                    glLoadMatrixd(modelView);  
            
                    glPushMatrix;
                    glTranslatef(0,0,-1);

                    glEnable(GL.COLOR_MATERIAL); % Enable color tracking
                    glShadeModel(GL.SMOOTH); % Use smooth shading for color interpolation
                    glColor4f(1,1, 1, 1);
                    
                    glCallList(const.fixation)
                    %glCallList(const.bsquare)
                     % if scr.oc.renderPass % drawing right eye
                     %     glCallList(const.linesR)
                     % else
                     %     glCallList(const.linesL)
                     % end
                    glPopMatrix;
                    Screen('EndOpenGL', const.window);
                    %disp('OPENGL STATUS')
                    %errorCode = glGetError()
                    % my_fixation(scr,const,const.black)
                end
            end


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