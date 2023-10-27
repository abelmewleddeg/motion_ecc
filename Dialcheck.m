%clear all;
%InitializePsychSound()
%PsychPortAudio('GetDevices')
LoadPsychHID
KbName('UnifyKeyNames')
devices3 = PsychHID('Devices');

my_key.escape       = KbName('ESCAPE');
my_key.space        = KbName('Space');
my_key.rightArrow   = KbName('RightArrow');
my_key.leftArrow    = KbName('LeftArrow');
my_key.DIAL_C       = KbName('f17');
%%
counter = 1;

while counter<5
    %[keyIsDown, ~, keyCode] = KbCheck(1);
    [keyIsDown, ~, keyCode] = PsychHID('KbCheck'); %,1);

    if keyIsDown %&& keyCode(my_key.DIAL_C)
        disp('clockwise')
        key = KbName(find(keyCode))
    % else %if keyIsDown && keyCode(my_key.DIAL_D)
    %     disp('counterclockwise')
    %     key = KbName(find(keyCode))
    end
    pause(1)
    counter = counter+1;
end
