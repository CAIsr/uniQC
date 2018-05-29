% function output = test_add_overlay(input)
% Test image overlay creation and plotting of 3D-RGB-image via montage
%
%   output = test_add_overlay(input)
%
% IN
%
% OUT
%
% EXAMPLE
%   test_add_overlay
%
%   See also add_overlay
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2014-11-25
% Copyright (C) 2014 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public Licence (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: demo_add_overlay.m 514 2018-05-28 01:51:44Z sklein $

clear;
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load example data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


pathExamples    = get_path('examples');
fileTest        = fullfile(pathExamples, 'nifti', 'rest', 'meanfmri.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create Example overlay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X               = MrImage(fileTest);
edgeX           = edge(X);

imageMatrix     = X.data;
overlayMatrix   = edgeX.data;

rgbMatrix       = add_overlay(imageMatrix, overlayMatrix, 'jet');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot resulting overlay via montage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X.plot('overlayImages', edgeX)

stringTitle = 'imageMatrix';
figure('Name', stringTitle);
montage(permute(imageMatrix, [1 2 4 3]), 'DisplayRange', []);
title(str2label(stringTitle));


stringTitle = 'overlayMatrix';
figure('Name', stringTitle);
montage(permute(overlayMatrix, [1 2 4 3]), 'DisplayRange', []);
title(str2label(stringTitle));
colormap hot;

stringTitle = 'test_add_overlay Montage Image';
figure('Name', stringTitle);
montage(rgbMatrix, 'DisplayRange', []);
title(str2label(stringTitle));