function dataType = get_data_type_from_n_voxels(nVoxels)
% Specifies memory-efficient data type for saving from number of voxels
% TODO: incorporate dynamic range of data to be saved as well!
%
% dataType = get_data_type_from_n_voxels(nVoxels)
%
% IN
%   nVoxels    [1,4] voxels per dimension to be saved
%               see also MrImageGeometry
% OUT
%
% EXAMPLE
%   get_data_type_from_n_voxels
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-12-06
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
% $Id: get_data_type_from_n_voxels.m 325 2017-03-29 08:03:37Z lkasper $

% use [64 1] double 64 or [16 1] float 32 for single images, but [8 1]
% signed int (32 bit/voxel) or [4 1] signed short (16 bit/voxel)
% for raw data (more than 30 images)

% BUG: smoothing and SNR-calculation create problems if you use this
% file format (it is much too discrete!)

% only convert to int, if file bigger than 2 GB otherwise

is3D = numel(nVoxels) <= 3 || nVoxels(4) == 1;
isStructural = prod(nVoxels(1:3)) >= 220*220*120;
floatExceeds2GB = prod(nVoxels) > 2*1024*1024*1024*8/64;

if is3D && isStructural % highest bit resolution for structural images
    dataType   = 'float64';
    
elseif floatExceeds2GB % int32 for large raw data
    dataType = 'int32';
else
    dataType   = 'float32'; %float32 for everything in between
end