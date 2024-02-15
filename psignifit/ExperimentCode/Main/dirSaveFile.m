function [const] = dirSaveFile(const)
% ----------------------------------------------------------------------
% [const]=dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------

disp('~~~~~ DIRSAVEFILE ~~~~~~')

% Subject name:
if const.DEBUG ~= 1
    prompt = sprintf('\n\tSubject ID (digits only): ');
    [const.subjID_numeric, const.subjID] = getNumericInput(prompt);
else
    const.subjID = '00';
end

% Subject Directory
MainDirectory = sursuppRootPath;
datadir = fullfile(MainDirectory, 'Data');
const.subjDir = fullfile(datadir,sprintf('StaircaseMode%i', const.staircasemode),const.subjID);
const.subjStaircaseDir = fullfile(datadir, sprintf('StaircaseMode%i', const.staircasemode),const.subjID);
const.blockLog = fullfile(const.subjStaircaseDir, 'blocklog.txt');

% this saves path, the values are loaded in later (in scrConfig)
const.gammaTablePath = fullfile(MainDirectory, 'ExperimentCode', 'Config', 'gamma.mat');

if ~isfile(const.blockLog)
    mkdir(const.subjStaircaseDir);
    const.block = 1;
else
    fid = fopen(const.blockLog, 'r');
    blocks = fscanf(fid, '%s');
    blockarray = split(blocks, 'Block');
    const.block = str2num(blockarray{end})+1;
end

% check if practice was already logged
if const.staircasemode > 0 % if not in practice block
    practiceLog = strrep(const.blockLog, sprintf('StaircaseMode%i', const.staircasemode), 'StaircaseMode0');
    fid = fopen(practiceLog, 'r');
    if fid ~= -1 % if file exists
        practiceblocks = fscanf(fid, '%s');
        practiceblockarray = split(practiceblocks, 'Block');
        corr_practiceblock = str2num(practiceblockarray{end});
        if corr_practiceblock ~= const.block
            proceed = input(sprintf('\n\tPractice block is not recent/found. Proceed? y/n '), 's');
        else
            proceed = 'y';
        end
    else
        proceed = input(sprintf('\n\tNo practice log file found. Proceed? y/n '), 's');
    end
    if ~strcmp(proceed, 'y')
        error('Please run practice block first.')
    end
end

% make run directory
const.blockDir = fullfile(const.subjStaircaseDir, sprintf('Block%i', const.block));
mkdir(const.blockDir);

% Defines saving file names
const.scr_fileDat =     fullfile(const.blockDir, sprintf('S%s_scr_file_Block%i.dat',const.subjID, const.block));
const.scr_fileMat =     fullfile(const.blockDir, sprintf('S%s_scr_file_Block%i.mat',const.subjID, const.block));
const.const_fileDat =   fullfile(const.blockDir, sprintf('S%s_const_file_Block%i.dat',const.subjID, const.block));
const.const_fileMat =   fullfile(const.blockDir, sprintf('S%s_const_file_Block%i.mat',const.subjID, const.block));
const.expRes_fileCsv =  fullfile(const.blockDir, sprintf('S%s_expRes_Block%i.csv',const.subjID, const.block));
const.design_fileMat =  fullfile(const.blockDir, sprintf('S%s_design_Block%i.mat',const.subjID, const.block));
const.responses_fileMat =  fullfile(const.blockDir, sprintf('S%s_responses_Block%i.mat',const.subjID, const.block));

if const.makemovie
    const.moviefolder = fullfile(const.blockDir, 'trialmovie');
    if ~isfolder(const.moviefolder)
        mkdir(const.moviefolder);
    end
end

end

%%

function [userInput, userInput_s] = getNumericInput(prompt)

    while true
        userInput_s = input(prompt, 's');
        
        if length(userInput_s) < 2
            userInput_s = ['0', userInput_s];
        end
        
        if isempty(userInput_s) || ~all(isstrprop(userInput_s, 'digit'))
            disp('Invalid input. Please enter only digits.');
        else
            userInput = str2double(userInput_s);
            
            if ~isnan(userInput)
                break;
            else
                disp('Invalid input. Please enter only digits.');
            end
        end
    end
end