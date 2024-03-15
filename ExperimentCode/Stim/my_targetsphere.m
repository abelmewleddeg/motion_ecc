function my_targetsphere(scr,const,color)
% ----------------------------------------------------------------------
disp('my_sphere')
% Draw the fixation point

if const.VRdisplay==0 % not in VR
    Screen('DrawDots', const.window, scr.windCenter_px, ...
    const.fixationRadius_px, color, [], 2);
elseif const.VRdisplay==1
    global GL;
    InitializeMatlabOpenGL(1);

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
        else % drawing left eye
            scr.oc.modelViewDataLeft = [scr.oc.modelViewDataLeft; eye.modelView];
        end 

        eye.eyeIndex = scr.oc.renderPass;

        Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass); % openGL must be closed
        modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %eye.modelView;
        %modelView = eye.modelView;

        Screen('BeginOpenGL',const.window);
        
        glClearColor(1, 0, 0, 3); % red background

        glClear(); % clear the buffers - must be done for every frame
        glColor3f(0,0,1);
        % 
        % % Clear the screen
        %glClear(GL.COLOR_BUFFER_BIT);

        % Setup camera position and orientation for this eyes view:
        glMatrixMode(GL.PROJECTION)
        glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});

        glMatrixMode(GL.MODELVIEW);
        glLoadMatrixd(modelView);  

        glPushMatrix;
        glTranslatef(0.0,0.0,-1);
        %glCallList(const.sphereStim)
        glCallList(const.fixation)
        glPopMatrix;
        Screen('EndOpenGL', const.window);
        %disp('OPENGL STATUS')
        %errorCode = glGetError()

    end
end


end