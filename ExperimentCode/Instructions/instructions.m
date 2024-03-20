function keyCode = instructions(scr,const,my_key,text)
% ----------------------------------------------------------------------
% instructions(scr,const,my_key,text,button)
% ----------------------------------------------------------------------
% Goal of the function :
% Display instructions write in a specified matrix.
% ----------------------------------------------------------------------
% Input(s) :
% scr : main window pointer.
% const : struct containing all the constant configurations.
% text : library of the type {}.
% ----------------------------------------------------------------------
% Output(s):
% (none)
% ----------------------------------------------------------------------

x_mid = scr.windCenter_px(1);
y_mid = scr.windCenter_px(2);

%while KbCheck(-1); end
while KbCheck(my_key.keyboardID); end
KbName('UnifyKeyNames');

push_button = 0;
while ~push_button

    if const.VRdisplay==1 % if in VR
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

        for renderPass = 0:1 % loop over eyes
            scr.oc.renderPass = renderPass;

            eye = PsychVRHMD('GetEyePose', scr.hmd, scr.oc.renderPass, scr.oc.globalHeadPose);

            if scr.oc.renderPass % drawing right eye
                scr.oc.modelViewDataRight = [scr.oc.modelViewDataRight; eye.modelView];
                 textshift = -const.vrshift/2;
            else % drawing left eye
                scr.oc.modelViewDataLeft = [scr.oc.modelViewDataLeft; eye.modelView];
                textshift = const.vrshift/2;
            end 

            eye.eyeIndex = scr.oc.renderPass;

            Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass);
            modelView = [1 0 0 0; 0 1 0 0; 0 0 1 -scr.oc.viewingDistance; 0 0 0 1]; %eye.modelView;

            Screen('BeginOpenGL',const.window);
            %Screen('SwapInterval', const.window, 1); % added this to prevent error
            
            glClearColor(1, 0, 0, 3); % red background

            glClear(); % clear the buffers - must be done for every frame
            % 
            % % Clear the screen
            glClear(GL.COLOR_BUFFER_BIT);

            % Setup camera position and orientation for this eyes view:
            glMatrixMode(GL.PROJECTION)
            glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});

            glMatrixMode(GL.MODELVIEW);
            glLoadMatrixd(modelView);  
            Screen('EndOpenGL', const.window);
            
            if const.instrct == 0
                 Screen('BeginOpenGL',const.window);
                % call the texture
                glRotatef(270.0, 0.0, 0.0, 1.0)
                %glRotatef(270.0, 1.0, 0.0, 0.0)
                glPushMatrix;
                glCallList(const.imagePlaneID)
                glPopMatrix;
                %Screen('DrawTexture',const.window,const.imageTexture,[],[],[],[],[],[],[],kPsychUseTextureMatrixForRotation, modelView); %transMatrix);
                Screen('EndOpenGL', const.window);

            else
                %Screen('DrawTexture',const.window,const.imageTexture,[],const.imageRect);
                %sprintf('Coordinates for %i', renderPass)
                %scr.oc.xycenter
                %input1 = (scr.oc.xycenter(1)-200*scr.oc.renderPass)-100
                %input2 = scr.oc.xycenter(2)
                %Screen('DrawText',const.window,text{1,:},input1,input2, const.white);
                 Screen('Preference', 'TextAntiAliasing',1);
                Screen('TextSize',const.window, const.text_size);
                Screen ('TextFont', const.window, const.text_font);
                % Screen('FillRect', const.window, const.gray);
            
                sizeT = size(text);
                lines = sizeT(1)+2;
                bound = Screen('TextBounds',const.window,text{1,:});
                espace = ((const.text_size)*1.50);
                first_line = y_mid - ((round(lines/2))*espace);
            
                addi = 0;
                for t_lines = 1:sizeT(1)
                    Screen('DrawText',const.window,text{t_lines,:},(x_mid-bound(3)/2)+textshift,first_line+addi*espace, const.white);
                    addi = addi+1;
                end
                addi = addi+2;
                    % % create text offset per eye
                    % if renderPass == 0
                    %     offset = scr.oc.x_offset;
                    % elseif renderPass == 1
                    %     offset = -scr.oc.x_offset;
                    % end
    
                    % Screen('DrawText',const.window,text{1,:},instCenter(1), instCenter(2), const.black);
        
                end
            
        end

    else % if not in VR
         if const.instrct == 0
            %my_fixation(scr,const,const.black)
            Screen('DrawTexture',const.window,const.imageTexture,[],const.imageRect_nonVR);
         else
            Screen('Preference', 'TextAntiAliasing',1);
            Screen('TextSize',const.window, const.text_size);
            Screen ('TextFont', const.window, const.text_font);
            Screen('FillRect', const.window, const.gray);
        
            sizeT = size(text);
            lines = sizeT(1)+2;
            bound = Screen('TextBounds',const.window,text{1,:});
            espace = ((const.text_size)*1.50);
            first_line = y_mid - ((round(lines/2))*espace);
        
            addi = 0;
            for t_lines = 1:sizeT(1)
                Screen('DrawText',const.window,text{t_lines,:},x_mid-bound(3)/2,first_line+addi*espace, const.white);
                addi = addi+1;
            end
            addi = addi+2;

         end 

    end


    Screen('Flip',const.window);
    
    % wait for trigger with keyboard
    [ keyIsDown, ~, keyCode ] = KbCheck(my_key.keyboardID); % KbCheck(-1);
    if keyIsDown
        if keyCode(my_key.space)
            disp('STARTED EXPERIMENT ...')
            push_button=1;
        elseif keyCode(my_key.escape) && ~const.expStart
            return
        end
    end

end

end
