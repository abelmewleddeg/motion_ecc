# Motion Eccentricity Project

TO DO:

(1) Add cortical magnification for the eccentricities

(2) Code for 2 sessions; choose 2 polar angles randomly for a given subject, then test the other 2 in second session

(3) Add neutral cue to prepare subject for target presentation

(4) Ensure response cue is added

(5) Add response time to saved response matrix

(6) Plot output of staircases + some measure of performance

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

Dependencies:

MATLAB (tested with R2019a, R2020a, R2023a)
Psychtoolbox (tested with v3)

~~~~~~~~~~~~~~~~~~

Tested and works on operating systems:
 
MacOS Montery, MacOS Mojave
