# Motion Eccentricity Project
Steps before running this experiment:

(1) Ensure Psychtoolbox (PTB) is on the MATLAB path. 

(Optional) To permanently add PTB to MATLAB path, run:

addpath /path/to/psychtoolbox/
savepath

(2) Navigate to motion_ecc directory:

cd /path/to/motion_ecc/

(3) Run expLauncher.m

Data will be saved in a folder named Data in the main directory. The data is organized into three subfolders: StaircaseMode0, StaircaseMode1, StaircaseMode2, and StaircaseMode3 based on the type of staircase used. 
staircaseMode0 --> no staircase used (practice block)
staircaseMode1 --> upDown staircase
staircaseMode2 --> QUEST+ Staircase
staircaseMode3 --> method of constants


Inside these subfolders are separate folders named after the subject ID assigned to the participant at the beginning of the experiment. Each subject folder contains subfolders for each block session. inside every session folder, we have three .mat files, each containing a struct that has important information about the experiment.

- const: struct containing all of the constant data
	- const.DEBUG: boolean that indicates if the experiment was ran in debug mode
	- const.miniwindow: Boolean that indicates if the experiment used the whole or part of the screen to open the experiment window (0 -> full screen).
	const.makemovie: Boolean indicating if the experiment was screen recorded
	const.staircasemode: indicates which staircase was used
		- staicaseMode = 2 (	QUEST+),
		- StaircaseMode = 1 (upDOwn)
		- staircaseMode = 0 (no staircase/practice)
	- VRdisplay - indicates whether the experiment was ran in VR
	- SubjID - participant's unique ID as a string
	- SubjID_numeric - participant's unique ID as a number
	- MainDirectory - the experiment's main directory
	- subjDir - subject's data directory
	- subjDir - subject's data directory (duplicate)
	- blockLog - path to blocklog text file containing the number of blocks (sessions) ran.
	- gammaTablePath: path to gamma table?
	- block- -block/session number
	- blockDir - path to block folder
	- scr_fileDat: path to scr_file.dat for within a given session
	- scr_fileMat: path to scr_file.Mat for within a given session
	- const_fileDat: path to const_file.dat within a given session
	- const_fileMat: path to const_file.Mat within a given session
	- design_fileMat: path to expDes.mat file for within a given session 
	- expRes_fileCsv
	- responses_fileMat
	- text_size
	- text_font
	- white - RGB values for white
	- gray - RGB values for gray
	- black - RGB values for black
	- lightgray - RGB values for lightgray 
	- stimtype - type of stimulus used (grating or noise)
	- vrshift - the amount of horizontal shift (in pixels) required in each VR screen to render a clear non-diplopic image
	- vrVerShift - the amount of vertical shift (in pixels) required to adjust for the disparity between OpenGL center and psychtoolbox center
	- keyboard
	- fixationRadius_px - fixation dot radius in pixels
	- fixationRadius_Deg - fixation dot radius in degrees
	 - window - window handle
	- windowRect - dimensions of the window, when full screen windowRect = screen resolution
	- gammaVals: contains the gamma lookup table for adjusting the luminance of the display
	- calibSucess: Boolean indicating whether or not the custom gamma table was successfully loaded correctly 
	- ImageTexture: ptb texture made from the instruction image
	- ImageRect- not used
	- imageRectnonVR:instruction image dimensions in non-VR
	- imagePlaneID: opoenGL texture generated from the instruction image. used only in VR conditions
	- fixation: (not used): a fication sphere deawn using open GL
	- LinesR: (not used)
	- LinesL: not used
	- phaseLine: helps determine the initial phase shift of the stimulus for each trial
	- maporientation: adjust for the disparity between MATLAB and PTB orientations
	- mapDirection:adjust for the disparity between MATLAB and PTB directions
	- mapDirection

	- expStart: Boolean that determines whether ListenChar(2) is enabled, which suppresses command window output during response. 
	- instrct: Boolean that determines whether the instruction (1) or block breaks(2) are displayed. the type of instruction 
	- expStop: Boolean indicating whether or not the experiment was stopped
	- forceQuit: Boolean indicating whether or not we forcequit the experiment using the esc key
 
	- newCenter: x and y axis adjustments to obtain VR center  
	- VRcenter: VR center
	- stimContrast: stimulus contrast
	- speedDeg:stimulus speed in degrees per second
	- speedPixel: stimulus speed in pixels per frame
	- Scalar4noiseTarget: noise stimulus spatial frequency?

	- stimCosEdge_deg: cosine edge
	- const.stimCosEdge_pix:(in pixels)
	- stimRadius_deg: stimulus radius in degrees
	- stimRadius_degCM:stimulus radius in degrees after cortical magnificaiton
 
	- stimRadiuspix: stimulus radius 
 (in pixels) after CM
	- RespSize: response arrow lenght
	- visiblesizeResp:(entire response arrow size visible in width, rounding for pixel misalignment - in pixels)
	- grating_halfw: half grating width in pixels
	- visiblesize: entire stimulus size visible in width, rounding for pixel misalignment - in pixels)
	- squarewavetex: grating texture pointer for ptb
	- sphereStim: (not used)
	- centermask:
	- stimEccpix: stimulus eccentricity in pixels
	- responded: indicates whether or not a response was recorded


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














TO DO:

(0) Fix eccentricity pixels so that x,y are the hypotenuse of set ecc in deg

(1) Add cortical magnification for the eccentricities

(2) Code for 2 sessions; choose 2 polar angles randomly for a given subject, then test the other 2 in second session

(3) Add neutral cue to prepare subject for target presentation

(4) Ensure response cue is added

(5) Add response time to saved response matrix

(6) Plot output of staircases + some measure of performance. What happens when output of staircase is negative? Set params to -20 to 20. Probably c/cc cannot be defined beforehand.

(7) Instructions? Practice?

(8) Figure out if vignetting is an issue

~~~~~~~~~~~~~~~~~~

Steps before running this experiment:

(1) Install any dependencies (see below).

(2) Set the experimental parameters:
Change values as needed in the parameters.tsv file in the main directory (motion_ecc).
The parameters.json file is a dictionary will all of the variables defined for the tsv.

(3) Add the gamma.mat table from the calibration procedure to the Config folder inside the main directory for accurate contrast settings (otherwise code will not run if debug is off).

~~~~~~~~~~~~~~~~~~

To run experiment:

Run expLauncher.m

~~~~~~~~~~~~~~~~~~
Data will be saved in:

Folder named Data in the main directory.

~~~~~~~~~~~~~~~~~~

PlotPsy.m will automatically run at the end of every session. 
PlotPsy produces psychometric plots with sensitivity and bias measures for each staircase. If the up-down staircase is being sued (of const.staircasemode ==1). it will also produce staircase convergence plots.

~~~~~~~~~~~~~~~~~~

Dependencies:

MATLAB (tested with R2019a, R2020a, R2023a)
Psychtoolbox (tested with v3)

~~~~~~~~~~~~~~~~~~

Tested and works on operating systems:
 
MacOS Montery, MacOS Mojave
