 This README file contains a description of folders and important MATLAB scripts inside ExperimentCode .

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




