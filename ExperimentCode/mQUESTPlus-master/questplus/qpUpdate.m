function questData = qpUpdate(questData,stim,outcome,varargin)
% qpUpdate  Update the questData structure for the trial stimulus and outcome
%
% Usage: 
%     questData = qpUpdate(questData,stim,outcome)
%
% Description:
%     Update the questData strucgure given the stimulus and outcome of
%     a trial.  Computes the new likelihood of the whole data stream given
%     the stimulus/outcomes so far, updates the posterior, entropy, etc.
%
%     If qpInitialize was called with 'noentropy' set to true, then entropy
%     calculations are skipped.  See help on qpParams for a note as to why
%     you might want to do this.
%
% Input:
%     questData       questData structure before the trial.
%
%     stim            Stimulus parameters on trial (row vector).  Must be contained in
%                     questData.stimParamsDomain, otherwise an error is thrown.
%
%                     If this is passed as [], the updating by trials is
%                     skipped, but the final entropy calculation is done,
%                     even when the noentropy field is true. By controlling
%                     this carefully along with noentropy, you can update a
%                     bunch of stimuli in a batch faster than doing all the
%                     calculations for each stimulus update.  Useful
%                     particularly for simulations where it may be
%                     efficient to compute responses for many trials of the
%                     same stimulus in a batch.
%
%     outcome         What happened on the trial.
%
% Output:
%     questData       Updated questData structure.  This adds and/or keeps up to date the following
%                     fields of the questData structure.
%                       trialData - Trial data array, a struct array containing stimulus and outcome for each trial.
%                         Initialized on the first call and updated thereafter. This has subfields for both stimulus
%                         and outcome.
%                       stimIndices - Index into stimulus domain for stimulus used on each trial.  This can be useful
%                         for looking at how much and which parts of the stimulus domain were used in a run.
%                       logLikelihood - Updated for trial outcome.
%                       posterior - Update for trial outcome.
%                       entropyAfterTrial - The entropy of the posterior after the trail. Initialized on the first
%                         call and updated thereafter.
%                       expectedNextEntropiesByStim - Updated for trial outcome.
%
% Optional key/value pairs
%     None.   
%
% See also: qpParams, qpInitialize, qpQuery, qpRun.

% 07/01/17  dhb  Started writing.
% 12/21/17  dhb  Make sure to put in stimIndex on first trial.
% 01/14/18  dhb  Added check on range of outcome, at suggestion of Denis
%                Pelli.
% 04/18/23  dhb  Added option to pass stim as empty, to avoid updating but
%                still do entropy calculation.

%% Update for stimulus if not passed as empty
if (~isempty(stim))
    % Get stimulus index from stimulus
    stimIndex = qpStimToStimIndex(stim,questData.stimParamsDomain);
    if (stimIndex == 0)
        error('Trying to update with a stimulus outside the domain');
    end

    % Check for legal outcome
    if (round(outcome) ~= outcome | outcome < 1 | outcome > questData.nOutcomes)
        error('Illegal value provided for outcome, given initialization');
    end

    % Add trial data to list
    %
    % Create first element of the array if necessary.
    if (isfield(questData,'trialData'))
        nTrials = length(questData.trialData);
        questData.trialData(nTrials+1,1).stim = stim;
        questData.trialData(nTrials+1,1).outcome = outcome;
        questData.stimIndices(nTrials+1,1) = stimIndex;
    else
        nTrials = 0;
        questData.trialData.stim = stim;
        questData.trialData.outcome = outcome;
        questData.stimIndices = stimIndex;
    end

    % Update posterior
    %
    % We have the predicted proportions precomputed for every combintation of
    % stimulus parmameters, psi parameters and outcome. So given stimulus index
    % and outcome, we just look up the likelihood of the outcome for every set of
    % psychometric parameters, multiply by the previous posterior (which we
    % take as our prior here, and then normalize to get new posterior.)
    questData.posterior = qpUnitizeArray(questData.posterior .* squeeze(questData.precomputedOutcomeProportions(stimIndex,:,outcome))');
else
    % Set nTrials in case of no stim update.  We subtract 1 so that when
    % 1 gets added back in below it matches current nTrials.
    nTrials = length(questData.trialData) - 1;
end

%% Update table of expected entropies
if (~questData.noentropy || isempty(stim))
    if (~isempty(questData.marginalize))
        questData.marginalPosterior = qpMarginalizePosterior(questData.posterior,questData.psiParamsDomain,questData.marginalize);
        questData.entropyAfterTrial(nTrials+1,1) = qpArrayEntropy(questData.marginalPosterior);
        questData.expectedNextEntropiesByStim  = qpUpdateExpectedNextEntropiesByStim(questData);
    else
        questData.entropyAfterTrial(nTrials+1,1) = qpArrayEntropy(questData.posterior);
        questData.expectedNextEntropiesByStim  = qpUpdateExpectedNextEntropiesByStim(questData);
    end
end

end
