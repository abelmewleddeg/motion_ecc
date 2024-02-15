function keyCode = instructions(scr,const,my_key,text,textExp)
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
MainDirectory = sursuppRootPath;
imagefile = fullfile(MainDirectory,'ExperimentCode','Instructions','InstructionsFigure.jpeg');
push_button = 0;
while ~push_button
    
    Screen('Preference', 'TextAntiAliasing',1);
    Screen('TextSize',const.window, const.text_size);
    Screen ('TextFont', const.window, const.text_font);
    Screen('FillRect', const.window, const.gray);

    sizeT = size(text);
    lines = sizeT(1)+2;
    bound = Screen('TextBounds',const.window,text{1,:});
    espace = ((const.text_size)*1.50);
    first_line = y_mid - ((round(lines/2))*espace);

    % addi = 0;
    % for t_lines = 1:sizeT(1)
    %     Screen('DrawText',const.window,text{t_lines,:},x_mid-bound(3)/2,first_line+addi*espace, const.white);
    %     addi = addi+1;
    % end
    % addi = addi+2;

    % if the instructions image needs to be loaded
    if const.instrct == 0
        image = imread(imagefile);
        imageTexture = Screen('MakeTexture',const.window,image);
        imageSize = size(image);
        imageRect = CenterRectOnPoint([0, 0, imageSize(2), imageSize(1)], const.windowRect(3)/2, const.windowRect(4)/2);
    end

    if const.VRdisplay==1 
        InitializeMatlabOpenGL(1);

        for renderPass = 0:1 % loop over eyes
            scr.oc.renderPass = renderPass;
            Screen('SelectStereoDrawBuffer',const.window,scr.oc.renderPass);
            Screen('BeginOpenGL',const.window);
                                
            % Setup camera position and orientation for this eyes view:
            glMatrixMode(GL.PROJECTION)
            glLoadMatrixd(scr.oc.projMatrix{renderPass + 1});
            
            modelView = scr.oc.initialState.modelView{scr.oc.renderPass + 1}; % Use per-eye modelView matrices
            glLoadMatrixd(modelView);
    
            glClearColor(.5,.5,.5,1); % gray background
            
            glClear(); % clear the buffers - must be done for every frame
            glColor3f(1,1,1);

            % % create horizontal offset
            if renderPass==0 % left
                imageRect(1) = imageRect(1)+scr.oc.x_offset;
                imageRect(3) = imageRect(3)+scr.oc.x_offset;
                offset = scr.oc.x_offset;
                colornow = const.black;
            elseif renderPass==1 % right
                imageRect(1) = imageRect(1)-scr.oc.x_offset;
                imageRect(3) = imageRect(3)-scr.oc.x_offset;
                offset = -scr.oc.x_offset;
                colornow = const.white;
            end

            %my_fixation(scr,const,const.black)
    
            Screen('EndOpenGL', const.window);
            Screen('DrawTexture',const.window,imageTexture,[],imageRect);
            %sprintf('Coordinates for %i', renderPass)
            %scr.oc.xycenter
            %input1 = (scr.oc.xycenter(1)-200*scr.oc.renderPass)-100
            %input2 = scr.oc.xycenter(2)
            %Screen('DrawText',const.window,text{1,:},input1,input2, const.white);
            
            % works
            %Screen('DrawText',const.window,text{1,:},scr.oc.xycenter(1)+offset, scr.oc.xycenter(2), colornow);
    
        end

    else

        my_fixation(scr,const,const.black)
        Screen('DrawTexture',const.window,imageTexture,[],imageRect);

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
