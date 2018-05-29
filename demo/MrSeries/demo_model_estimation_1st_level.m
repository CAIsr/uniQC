% Script demo_model_estimation_1st_level
% 1st level model specification and estimation
%
%  demo_model_estimation_1st_level
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-05-04
% Copyright (C) 2018 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: new_script2.m 354 2013-12-02 22:21:41Z kasperla $
%
clear;
close all;
clc;
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (1) Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uses the output of demo_preprocessing
S = MrSeries('C:\Users\uqsboll2\Desktop\test_uniQC\preprocessing\MrSeries_180528_095854');
% change directory to get a separate it from the preprocessing
S.parameters.save.path = strrep(S.parameters.save.path, 'preprocessing', 'model_estimation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (2) Make brain mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add white and grey matter TPMs
S.additionalImages{end+1} = S.tissueProbabilityMaps{1} + S.tissueProbabilityMaps{2};
S.additionalImages{4}.name = 'brain_tpm';
S.additionalImages{4}.parameters.save.fileName = 'brain_tpm.nii';
S.additionalImages{4}.plot;
% set parameters for mask
S.parameters.compute_masks.nameInputImages = 'brain_tpm';
S.parameters.compute_masks.nameTargetGeometry = 'mean';
S.compute_masks;
% check mask
S.mean.plot('overlayImages', S.masks{2});
% close mask
S.masks{3} = S.masks{2}.imclose(strel('disk', 5));
% check again
S.mean.plot('overlayImages', S.masks{3});
% perfect - save new mask
S.masks{3}.save;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (3) Specify Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% timing in seconds
S.glm.timingUnits = 'secs';
% repetition time - check!
disp(['The specified TR is ', num2str(S.data.geometry.TR_s), 's.']);
S.glm.repetitionTime = S.data.geometry.TR_s;
% model derivatives
S.glm.hrfDerivatives = [1 1];
% noise model FAST
S.glm.serialCorrelations = 'FAST';

% add conditions
% specify block length first
block_length = 18;
% specify first condition
first_condition = [1 5 7 11 13 17];
first_condition_onsets = first_condition*block_length;
% remove 5 first TRs
first_condition_onsets = first_condition_onsets - 5 * S.data.geometry.TR_s;
% specify second condition
second_condition = [2 4 8 10 14 16];
second_condition_onsets = second_condition*block_length;
second_condition_onsets = second_condition_onsets - 5 * S.data.geometry.TR_s;

% add to glm
S.glm.conditions.names = {'simple', 'complex'};
S.glm.conditions.onsets = {second_condition_onsets, first_condition_onsets};
% add durations
S.glm.conditions.durations = {block_length, block_length};
% add an explicit mask
S.glm.explicitMasking = S.masks{3}.get_filename;
% turn of inplicit masking threshold;
S.glm.maskingThreshold = -Inf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (4) Estimate Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute stat images
S.compute_stat_images;
% estimate
S.specify_and_estimate_1st_level;
% look at design matrix
S.glm.plot_design_matrix;