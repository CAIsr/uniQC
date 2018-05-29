function [dimLabels, resolutions, nSamples, units, firstSamplingPoint] = ...
    read_par(~, filename)
% Reads dimInfo for Philips par/rec format.
% TODO: extend to ND-data (so far, only 4D time series supported)
%
%   Y = MrDimInfo()
%   Y.load_par(filename)
%
% This is a method of class MrDimInfo.
%
% NOTE: The output labels refer to dimensions in MNI space, *not* the
%       Philips scanner axis notation
%
% IN
%
% OUT
%
% EXAMPLE
%   load_par
%
%   See also MrDimInfo
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-10-25
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
% $Id: load_par.m 364 2017-10-25 21:35:40Z lkasper $

%% read header information
header = read_par_header(filename);

%% dimLabels
dimLabels = {'x', 'y', 'z', 't'}; % MNI space XYZ, NOT Philips XYZ

%% units
units = {'mm', 'mm', 'mm', 's'};

%% nSamples
nSamples = [header.xDim, header.yDim, header.zDim, header.tDim];

%% resolutions
resolutions     = [header.xres, header.yres, header.zres header.TR_s];

% rotated data matrix depending on slice acquisition orientation
% (transverse, sagittal, coronal)
ori             = header.sliceOrientation;

switch ori
    case 1 % transversal, dim1 = ap, dim2 = fh, dim3 = rl (ap fh rl)
        ind = [3 1 2];    % ap,fh,rl to rl,ap,fh
        ind_res = [1 2 3]; % OR [2 1 3];    % x,y,z to rl,ap,fh
    case 2 % sagittal, dim1 = ap, dim2 = fh, dim3 = lr
        ind = [3 1 2];
        ind_res = [3 1 2];  % OR [3 2 1]
    case 3 % coronal, dim1 = lr, dim2 = fh, dim3 = ap
        ind = [3 1 2];
        ind_res = [1 3 2]; % OR [2 3 1]; % x,y,z to rl,ap,fh
end
% perform matrix transformation from (ap, fh, rl) to (x,y,z);
% (x,y,z) is (rl,ap,fh)

resolutions(1:3)    = resolutions(ind_res);
nSamples(1:3)       = nSamples(ind);

%% firstSamplingPoint
% voxel position by voxel center, time starts at 0 seconds
nDims = numel(nSamples);
firstSamplingPoint = ones(1, nDims);
tStart = 0;
firstSamplingPoint(1:4) = [resolutions(1:3)/2 tStart];
end