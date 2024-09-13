# Motion Eccentricity Project

1. Steps before running this experiment:

1. Install any dependencies

- Dependencies for Experimental Code
	- MATLAB (tested using version 2023b)
	- Psychtoolbox v3
- Dependencies for analysis
	- Psignifit: computes the psychometric plots, and computes sensitivity and bias estimates
- VR dependencies:??

2. If using VR, you need a gaming PC (most of the data was collected using the Predator Helios 300 computer, an oculus rift VR headset a rotating response dial, and a USB-USBc adapter. 
Also check if the Oculus Rift CV1 headset and the two sensors are plugged in. Go to the Meta Quest Link App → devices and check whether they are connected. 

To run  the experiment

(1) Ensure Psychtoolbox (PTB) is on the MATLAB path. 

(Optional) To permanently add PTB to MATLAB path, run:

addpath /path/to/psychtoolbox/
savepath

(2) Navigate to motion_ecc directory:

cd /path/to/motion_ecc/

(3) Run expLauncher.m

Before running the experiment, make sure that the following variables inside expLauncher.m are set to the appropriate values. 
1. const.staircasemode 
  const.staircaseMode == 0 --> no staircase used (practice block)
  const.staircaseMode == 1 --> upDown staircase
  const.staircaseMode == 2 --> QUEST+ Staircase (currently under use)
  const.staircaseMode == 3 --> method of constants
2. const.VRdisplay
  const.VRdisplay == 0 no VR
  const.VRdisplay == 1 VR
  
~~~~~~~~~~~~~~~~~~

Description of folders and important MATLAB scripts inside ExperimentCode.

Config: contains a series of MATLAB scripts that compute and save all the data configurations necessary for the experiment
	- designConfig: computes and saves trial sequence data (PA, Ecc, Dir, Timing, etc.}
	- constConfig: contains all of the constant data of the experiment (stimulus contrast,size, fixation dot properties.	
	KeyConfig: Unifies key names and returns a structure containing each key name.
	scrConfong: gives all the information about the screen.
	Dialcheck: checks if the response dial is working 

conversion: contains various conversion functions
GLShaders: contains programs necessary for creating and displaying a perlin Scaled noise.
Instruction: contains the function used to display the instruction and breaks between blocks.
	- Instructions.m: function that displays instruction figure and block breaks
: contains scripts to initialize experiment, save important variables and tend the experiment.
Main: main part of the experiment. calls the important configuration and trial functions
	- main.m: the main code of the experiment.
	- dirSaveFile: makes directory for important files and saves them under the struct 	const. Const is a struct containing a lot of constant configurations. 
	- Overdone: Close screen, listen keyboard and save duration of the experiment
mQUESTPlus-master: folder contains functions and Demos for QUEST+, an adaptive staircase used in our experiment.

stim: contains functions used to create and draw stimulus
	- my_blank: presents fixation dots by calling my_fixation
	- my_VRstim: set stimulus properties and draw the stimulus
trials: 
	 -runTrials: Main trial function, display the trial function and save the experi-
% -mental data in different files.
	- upDownStaircase: Function called by runTrials in case we decide to run the updownstaircase (const.staircasemode == 1)
	- my_resp: Draws response cue arrow after stimulus is presented and record the response. it also provides color feedbacks for practice trials (const.staircasemode == 0)




Data will be saved in:

Folder named Data in the main directory.

The data is organized into three subfolders: StaircaseMode0, StaircaseMode1, StaircaseMode2, and StaircaseMode3 based on the type of staircase used. 

Inside these subfolders are separate folders named after the subject ID assigned to the participant at the beginning of the experiment. Each subject folder contains subfolders for each block session. inside every session folder, we have three .mat files, each containing a struct that has important information about the experiment.


FILE: S00_const_file_BlockX.mat
- const: struct containing all of the constant data
	- const.DEBUG: boolean that indicates if the experiment was ran in debug mode
	- const.miniwindow: Boolean that indicates if the experiment used the whole or part of the screen to open the experiment window (0 -> full screen).
	const.makemovie: Boolean indicating if the experiment was screen recorded
	const.staircasemode: indicates which staircase was used
		- staicaseMode = 2 (	QUEST+),
		- StaircaseMode = 1 (upDOwn)
		- staircaseMode = 0 (no staircase/practice)
	- const.VRdisplay - indicates whether the experiment was ran in VR
	- const.SubjID - participant's unique ID as a string
	- const.SubjID_numeric - participant's unique ID as a number
	- const.MainDirectory - the experiment's main directory
	- const.subjDir - subject's data directory
	- const.subjDir - subject's data directory (duplicate)
	- const.blockLog - path to blocklog text file containing the number of blocks (sessions) ran.
	- const.gammaTablePath: path to gamma table?
	- const.block- -block/session number
	- const.blockDir - path to block folder
	- const.scr_fileDat: path to scr_file.dat for within a given session
	- const.scr_fileMat: path to scr_file.Mat for within a given session
	- const.const_fileDat: path to const_file.dat within a given session
	- const.const_fileMat: path to const_file.Mat within a given session
	- const.design_fileMat: path to expDes.mat file for within a given session 
	- const.expRes_fileCsv
	- const.responses_fileMat
	- const.text_size
	- const.text_font
	- const.white - RGB values for white
	- const.gray - RGB values for gray
	- const.black - RGB values for black
	- const.lightgray - RGB values for lightgray 
	- const.stimtype - type of stimulus used (grating or noise)
	- const.vrshift - the amount of horizontal shift (in pixels) required in each VR screen to render a clear non-diplopic image
	- const.vrVerShift - the amount of vertical shift (in pixels) required to adjust for the disparity between OpenGL center and psychtoolbox center
	- keyboard
	- const.fixationRadius_px - fixation dot radius in pixels
	- const.fixationRadius_Deg - fixation dot radius in degrees
	 - const.window - window handle
	- const.windowRect - dimensions of the window, when full screen windowRect = screen resolution
	- const.gammaVals: contains the gamma lookup table for adjusting the luminance of the display
	- const.calibSucess: Boolean indicating whether or not the custom gamma table was successfully loaded correctly 
	- const.ImageTexture: ptb texture made from the instruction image
	- const.ImageRect- not used
	- const.imageRectnonVR:instruction image dimensions in non-VR
	- const.imagePlaneID: opoenGL texture generated from the instruction image. used only in VR conditions
	- const.fixation: (not used): a fication sphere deawn using open GL
	- const.LinesR: (not used)
	- const.LinesL: not used
	-const. phaseLine: helps determine the initial phase shift of the stimulus for each trial
	- const.maporientation: adjust for the disparity between MATLAB and PTB orientations
	- const.mapDirection:adjust for the disparity between MATLAB and PTB directions
	
	- const.expStart: Boolean that determines whether ListenChar(2) is enabled, which suppresses command window output during response. 
	- const.instrct: Boolean that determines whether the instruction (1) or block breaks(2) are displayed. the type of instruction 
	- const.expStop: Boolean indicating whether or not the experiment was stopped
	- const.forceQuit: Boolean indicating whether or not we forcequit the experiment using the esc key
 
	- const.newCenter: x and y axis adjustments to obtain VR center  
	- const.VRcenter: VR center
	- const.stimContrast: stimulus contrast
	- const.speedDeg:stimulus speed in degrees per second
	- const.speedPixel: stimulus speed in pixels per frame
	- const.Scalar4noiseTarget: noise stimulus spatial frequency?

	- const.stimCosEdge_deg: cosine edge
	- const.stimCosEdge_pix:(in pixels)
	- const.stimRadius_deg: stimulus radius in degrees
	- const.stimRadius_degCM:stimulus radius in degrees after cortical magnificaiton
 
	- const.stimRadiuspix: stimulus radius 
 (in pixels) after CM
	- const.RespSize: response arrow lenght
	- const.visiblesizeResp:(entire response arrow size visible in width, rounding for pixel misalignment - in pixels)
	- const.grating_halfw: half grating width in pixels
	- const.visiblesize: entire stimulus size visible in width, rounding for pixel misalignment - in pixels)
	- const.squarewavetex: grating texture pointer for ptb
	- const.sphereStim: (not used)
	- const.centermask:
	- const.stimEccpix: stimulus eccentricity in pixels
	- const.responded: indicates whether or not a response was recorded

FILE: S00_design_BlockX.mat
- contains experiment parameters such as polar angles, eccentricity, direction, tiltangles and responses (cw/ccw, correctness,etc)

	- expDes.polarAngles = polar angles tested
	- expDes.fillArrow: arrow is drawn when expDes.fillArrow == 1 
	- expDes.rng (random seed used for the run)
	- expDes.nb_repeat (# of stimulus repeats - counts 0 and 180 as 2x)
	- expDes.stimulus (string with stimulus descriptor: ‘perlinNoise’ or ‘grating’)
	- expDes.contrasts (contrast levels of the embedded stimulus)
	- expDes.mainStimTypes (table of all unique stimuli in the session)
	- expDes.nb_trials (# of trials in the experiment)
	- expDes.trialMat (matrix of trial parameters, row=trial; column=[trial#, polar angle, eccentricity, standard direction, tilt direction (cw or ccw), staircase number (if applicable) ])
	- expDes.itiDur_s (inter trial interval)
	- expDes.trial_onsets (time that has elapsed from the start of the experiment in seconds)
	- expDes.stimulus_onsets (time that has elapsed from the start of the experiment in seconds)
	- expDes.response (col1: contrast response - the contrast that is submitted for the perceptual judgement; col2: response time - time that elapsed since stimulus onset)
	- expDes.numStaircases: number of staircases
	-  response: clockwise or counterclockwise dial response (1 or -1)
	- expDes.stimDur_s: stimulus duration
	- expDes.NumBlocks: number of block within a session (there is a break after each block)
	- express.total_s: total experiment duration excluding response (stimulus + inter stimulus interval)
	- expDes.ApprxTrialperBlock: approximate number of trials per block
	- expDes.stimDur_nFrames:  stimulus duration in frames
	- itiDur_nFrames: inter trial interval in frames
	- : expDes.totalframes: total experiment duration excluding response (stimulus + inter stimulus interval)in frames
	- expDes.TrialsStart_frame: frame number at the start of the experiment
	- expDes.TrialsEnd_frame: frame number at the end of the experiment
	- expDes.stair_counter: counter for each staircase
	- expDes.stairs: contains staircase data 
	- expDes.correctness: correctness of responses for every trial (0s and 1s)
	- tiltangle: angular offset from standard direction ( ccw tilts are negative)

	- expDes.trial_onsets: trial onset time in second
	- expDes.stimulus_onsets: stimulus onset time in seconds
	- expDes.respCue_onsets: response cue onset time in seconds
	- expDes.rt_onset: response onset time in seconds.


FILE: S00_scr_file_BlockX.mat
- scr --> saves screen and window parameters in centimeter and pixels. 
	- scr.scr_num (screen pointer for PTB)
	- scrX_cm (screen width in cm)
	- scrY_cm (screen height in cm)
	- scrViewingDist_cm (screen distance from eye in cm)
	- experimenter (string with initials of experimenter, if 	- set up in code. ‘Unknown’ if not specified). unused. we use a 2-digit subject ID. see const.subjID
	- scrX_px (# of pixels for screen width)
	- scrY_px (# of pixels for screen height)
	- scrPixelDepth_bpp (# of bits per pixel)
	- windX_px (# of pixels for window width - actual display)
	- windY_px (# of pixels for window height - actual display)
	- windCenter_px (central pixel position X,Y)
	- vbl (time tracker - only used during experiment)
ifi (inter frame interval - inverse of refresh rate)- scr.scr_num:
	- oc: VR screen properties
	- hmd: a struct containing various fields related to the VR setup

~~~~~~~~~~~~~~~~~~


~~~~~~~~~~~~~~~~~~
Data will be saved in:

Folder named Data in the main directory.


This experiment was tested and works on operating systems:
 
Windows 11
~~~~~~~~~~~~~~~~~~
2. Data Analysis
 For analysis check the README under motionEcc_project/Analysis  





