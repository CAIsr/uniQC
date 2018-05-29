% Script demo_realign_coregister_series
% Shows different ways to realign (intra-modality, same contrast) and
% co-register (inter-modality, between different contrasts) images
%
%  demo_realign_coregister_series
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-05-11
% Copyright (C) 2015 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: demo_realign_coregister.m 514 2018-05-28 01:51:44Z sklein $
%
clear;
close all;
clc;
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Define Input Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathExamples        = get_path('examples');
pathData            = fullfile(pathExamples, 'nifti', 'rest');

fileFunctional      = fullfile(pathData, 'fmri_short.nii');
fileStructural      = fullfile(pathData, 'struct.nii');

dirResults          = ['results' filesep];


fileArray = ...
    {
    fileFunctional
    fileFunctional
    };

nFiles = numel(fileArray);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Load Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = MrSeries(fileArray{1});

% for n = 2:nFiles
%     S.data.append(fileArray{n})
% end

S.data.plot('sliceDimension', 't', 'z', 15);

% look at prominent shift in AP between volume 10 and 11, visible as edge
% in difference image
S.data.diff.plot('sliceDimension', 't', 'z', 15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Realign: Rigid body registration of all 3D volumes in S.data
%  minimizes pixelwise sum of squares error via translation/rotation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S.realign();


% realignment worked, edge is gone
S.data.diff.plot('sliceDimension', 't', 'z', 15);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Co-Registration: coregisters one image to another via mutual information 
%   maximization (works also for different modalities, e.g. T1/T2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S.anatomy.load(fileStructural, 'updateProperties', 'none');

S.parameters.coregister.nameStationaryImage = 'data';
S.parameters.coregister.nameTransformedImage = 'anatomy';

% coregister images 
S.coregister();

spm_check_registration(char({fileStructural; S.anatomy.get_filename}));