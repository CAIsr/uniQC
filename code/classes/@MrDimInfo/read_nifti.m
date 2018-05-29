function [dimLabels, resolutions, nSamples, units, firstSamplingPoint] = ...
    read_nifti(~, fileName)
% Reads nifti files and extracts properties for dimInfo
%
%   Y = MrDimInfo()
%   [dimLabels, resolutions, nSamples, units] = Y.read_nifti(fileName)
%   used in Y.load(fileName)
%
% This is a method of class MrDimInfo.
%
% IN
%
% OUT
%
% EXAMPLE
%   read_nifti
%
%   See also MrDimInfo
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-11-02
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
% $Id: new_method2.m 354 2013-12-02 22:21:41Z kasperla $


%% read header info
V = spm_vol(fileName);

%% nSamples
nSamples = V(1).private.dat.dim;
tempDimInfo = MrDimInfo('nSamples', nSamples);
nDims = numel(nSamples);

%% dimLabels
dimLabels = tempDimInfo.dimLabels;

%% units
units = tempDimInfo.units;

%% resolutions
P = round(uniqc_spm_imatrix(V(1).mat),7);
resolution_mm  = P(7:9);
% some nifti formats supply timing information (for files with more than 3
% dimension)
if isfield(V(1), 'private') && nDims > 3
    if isstruct(V(1).private.timing)
        TR_s = V(1).private.timing.tspace;
        tStart = 0;
    else
        TR_s = 1;
        units{4} = 'samples';
        tStart = 1;
    end
end
% need nifti to reference first sampling point as offcenter
resolutions = ones(1, nDims);
resolutions(1, 1:3) = resolution_mm;
if nDims > 3
    resolutions(1,4) = TR_s;
end

%% firstSamplingPoint
% voxel position by voxel center, time starts at 0 seconds/1 sample
firstSamplingPoint = ones(1, nDims);
firstSamplingPoint(1:3) = resolutions(1:3)/2;
if nDims > 3
    firstSamplingPoint(4) = tStart;
end