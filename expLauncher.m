%% General experimenter launcher %%
%  =============================  %

% Clean up:

sca; Screen('CloseAll');  
clear functions; clear mex;
close all; clear all; clc; 
rng('default'); 

Screen('Preference', 'TextRenderer', 0);
KbName('UnifyKeyNames')

% Initialization
warning('off');        % do not print warnings
const.DEBUG = 0;       % skips subject det+ails / data saving
const.miniWindow = 0;  % for debugging purposes only
const.makemovie =0;   % capture movie of trial (slows down performance)

% staircasemode = [0=no staircase/practice; 1=updown; 2=bayesian]
const.staircasemode = 0    ;

Screen('Preference', 'SkipSyncTests', 1);

% Verify that path is correct
if isempty(which('instructions'))
    % Ensure all folders are on path
    addpath(genpath(fullfile(sursuppRootPath, 'ExperimentCode'))); % add folders with experimental code
end
        
% Main experimental code
main(const);
clear expDes

