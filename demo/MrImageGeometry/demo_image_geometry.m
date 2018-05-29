% Script demo_image_geometry
% Exemplifies creation and usage of MrImageGeometry
%
%  demo_image_geometry
%
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-10-30
% Copyright (C) 2017 Institute for Biomedical Engineering
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
%% Create from nifti
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataPath = get_path('data');
niftiFile4D = fullfile(dataPath, 'nifti', 'rest', 'fmri_short.nii');
geom = MrImageGeometry(niftiFile4D);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create from dimInfo and AffineGeometry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dimInfo = MrDimInfo(niftiFile4D);
affineGeometry = MrAffineGeometry(niftiFile4D);
geom2 = MrImageGeometry(dimInfo, affineGeometry);
% test different input combinations
geom3 = MrImageGeometry(affineGeometry, dimInfo);
geom4 = MrImageGeometry(dimInfo);
geom5 = MrImageGeometry(affineGeometry);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create from Par/Rec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parRecFile = fullfile(dataPath, 'parrec/rest_feedback_7T', 'fmri1.par');
geomPar = MrImageGeometry(parRecFile);
disp(geomPar);


