function [textExp] = instructionConfig
% ----------------------------------------------------------------------
% [textExp] = instructionConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Write text of calibration and general instruction for the experiment.
% ----------------------------------------------------------------------
% Input(s) :
% (none)
% ----------------------------------------------------------------------
% Output(s):
% textExp : struct containing all text of general instructions.
% ----------------------------------------------------------------------

disp('~~~~~ INSTRUCTION ~~~~~~')

%% Main instruction :

 instruction = '-----------------  Ready to start? [space]  -----------------';
% imagefile = fullfile("C:\Users\rokers lab 2\Downloads\exapleInstructions_Abel.jpeg")
% image = imread(imagefile);
% instruction = imshow(image);

textExp.instruction= {instruction};

end