function predictedProportions = qpPFStandardWeibull(stimParams,psiParams)
%qpPFStandardWeibull  Weibull cdf psychometric function 
%
% Usage:
%     predictedProportions = qpPFStandardWeibull(stimParams,psiParams)
%
% Description:
%     Compute the proportions of each outcome for the Weibull psychometric
%     function.
%
%     See docuent qpPF_GuessLapseParameterization.pdf for a discussion of
%     various ways to parameterize the lapse rate and how to convert
%     between them.  In particular, that document describes the
%     parameterization used in this function.
%
%     Note: This version of the PF function doesn't require the stimulus,
%     nor the threshold, to be expressed in dB or log10 units.
%
% Input:
%     stimParams     Matrix, with each row being a vector of stimulus parameters.
%                    Here the row vector is just a single number giving
%                    the linear stimulus contrast level, or other stimulus parameter
%                    in linear units rather than dB or log10 units.
%
%     psiParams      Row vector or matrix of parameters
%                      threshold  Threshold in linear units of stimulus
%                      slope      Slope
%                      guess      Guess rate
%                      lapse      Lapse rate
%                    Parameterization matches the Mathematica code from the
%                    Watson QUEST+ paper. If this is passed as a matrix,
%                    must have same number of rows as stimParams and the
%                    parameters are used from corresponding rows. If it is
%                    passed as a row vector, that vector is taken as the
%                    parameters for each stimulus row.
%
% Output:
%     predictedProportions  Matrix, where each row is a vector of predicted proportions
%                           for each outcome.
%                             First entry of each row is for no/incorrect (outcome == 1)
%                             Second entry of each row is for yes/correct (outcome == 2)
%
% Optional key/value pairs
%     None
%
% See also: qpStandardWeibullInv, qpPFWeibull, qpPFWeibullInv,
%           qpPFWeibullLog, qpPFWeibullLogInv.

% 4/1/19  aer  Wrote it.

%% Parse input
%
% This routine gets called many many times and should be as fast as
% possible.  The input parser is slow.  So we forego arg checking and
% optional key/value pairs.  The code below shows how they would look.
%
% p = inputParser;
% p.addRequired('stimParams',@isnumeric);
% p.addRequired('psiParams',@isnumeric);
% p.parse(stimParams,psiParams,varargin{:}); 

%% Here is the Matlab version
if (size(psiParams,2) ~= 4)
    error('Parameters vector has wrong length for qpPFStandardWeibull');
end
if (size(stimParams,2) ~= 1)
    error('Each row of stimParams should have only one entry');
end
threshold = psiParams(:,1);
slope = psiParams(:,2);
guess = psiParams(:,3);
lapse = psiParams(:,4);
nStim = size(stimParams,1);
predictedProportions = zeros(nStim,2);

%% Compute, handling the two calling cases.
if (length(threshold) > 1)
    if (length(threshold) ~= nStim )
        error('Number of parameter vectors passed is not one and does not match number of stimuli passed');
    end
    
    for ii = 1:nStim 
        p_success = guess(ii) + (1 - guess(ii) - lapse(ii))*(1-exp(-(stimParams(ii) / threshold(ii))^slope(ii)));
        predictedProportions(ii,:) = [1-p_success p_success];
    end 
else
    for ii = 1:nStim
        p_success = guess + (1 - guess - lapse)*(1-exp(-(stimParams(ii) / threshold)^slope));
        predictedProportions(ii,:) = [1-p_success p_success];
    end 
end
