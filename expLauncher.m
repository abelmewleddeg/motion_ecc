%% General experimenter launcher %%
%  =============================  %
   
% Clean up: 

sca; Screen('CloseAll');  
clear functions; clear mex;
close all; clear all; clc; 
rng('default'); 

Screen('Preference', 'TextRenderer', 0);
KbName('UnifyKeyNames')

%PsychDebugWindowConfiguration;
 

% Initialization
warning('off');        % do not print warnings
const.DEBUG = 0;       % skips subject det+ails / data saving
const.miniWindow = 0;  % for debugging purposes on   ly
const.makemovie =0;   % capture movie of trial (slows down   performance)

% staircasemode = [0=no staircase/practice; 1=updown; 2=bayesian] 
const.staircasemode = 0;
const.VRdisplay = 1; % display binocular stimulus either on screen or headset
%const.VRconnect =1; % here headset is working and connected
 
Screen('Preference', 'SkipSyncTests', 1);

% to initialize open GL if needed:
if const.VRdisplay
    global GL; % GL data structure needed for all OpenGL programs
    InitializeMatlabOpenGL(1);
end

% Verify that path is correct
if isempty(which('instructions'))
    % Ensure all folders are on path
    addpath(genpath(fullfile(sursuppRootPath, 'ExperimentCode'))); % add folders with experimental code
end
        
% Main experimental code
main(const);
clear expDes

