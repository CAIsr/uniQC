% Script demo_save
% Shows how to save (image) data to one or multiple files (split!)
%
%  demo_save
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2016-09-22
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: demo_save.m 514 2018-05-28 01:51:44Z sklein $
%
clear;
close all;
clc;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Load 4D Time series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
dirSave             = 'results_demo_save';
pathExamples        = get_path('examples');
pathData            = fullfile(pathExamples, 'nifti', 'rest');
pathData2           = fullfile(pathExamples, 'nifti', '5D');
fileFunctional      = fullfile(pathData, 'fmri_short.nii');

% 4D example
Y = MrImage(fileFunctional);

% 5D example
dimInfo2 = MrDimInfo('dimLabels', {'x','y','z', 't', 'dr'}, ...
    'units', {'mm','mm','mm','t','mm'});
fileDeformationField = fullfile(pathData2, ...
    'y_5d_deformation_field.nii');
Y2 = MrImage(fileDeformationField, 'dimInfo', dimInfo2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Save 3D, one file per volume
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

splitDims = {'t'}; % or: 4
fileName = fullfile(dirSave , 'fmri3D.nii');

[dimInfoSplit, sfxSplit, selectionSplit] = Y.dimInfo.split(splitDims);

% saves to results_demo_save/fmri3D_t0001...fmri3D_t0015.nii
Y.save('fileName', fileName, 'splitDims', splitDims);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Save 2D, one file per deformation field direction and slice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

splitDims = {'dr', 'z'};
fileName = fullfile(dirSave , 'deformed2D.nii');

% saves to results_demo_save/fmri3D_t0001...fmri3D_t0015.nii
Y2.save('fileName', fileName, 'splitDims', splitDims);

