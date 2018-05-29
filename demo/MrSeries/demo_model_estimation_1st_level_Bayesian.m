% Script demo_bayes
% 1st level model specification and estimation using a Bayesian estimation
%
%  demo_bayes
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

% uses the output of demo_model_estimation_1st_level
S = MrSeries('C:\Users\uqsboll2\Desktop\test_uniQC\model_estimation\MrSeries_180528_095854');
% change directory to get a separate it from the preprocessing
S.parameters.save.path = strrep(S.parameters.save.path, 'model_estimation', 'model_estimation_bayes');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (2) Specify Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% swith to bayes
S.glm.estimationMethod = 'Bayesian';
% contrasts need to be specified already here
S.glm.gcon(1).name = 'simple';
S.glm.gcon(1).convec = 1;
S.glm.gcon(2).name = 'complex';
S.glm.gcon(2).convec = [0 0 0 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (3) Estimate Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute stat images
S.compute_stat_images;
% estimate
S.specify_and_estimate_1st_level;