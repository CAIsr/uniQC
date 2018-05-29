function this = write_nifti_analyze(this, filename, dataType)
% saves MrImage to nifti/analyze file depending on file extension
% (.nii/.img)
%
%   MrImage = write_nifti_analyze(MrImage)
%
% This is a method of class MrImage.
%
% IN
%   fileName    string of file identifier to save to; if not specified
%               MrImage.parameters.save.path/name is used
%   dataType    number format for saving voxel values; see also spm_type
%               specified as one of the following string identifiers
%                'uint8','int16','int32','float32','float64','int8','uint16','uint32';
%               default (3D): float64
%               default (4D or size > 30 MB): int32
%
% OUT
%
% EXAMPLE
%   write_nifti_analyze
%
%   See also MrImage
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-02
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
% $Id: write_nifti_analyze.m 354 2017-10-18 03:57:21Z sklein $

if nargin < 3
    dataType = get_data_type_from_n_voxels(this.geometry.nVoxels);
end


if ischar(dataType)
    dataType = [spm_type(dataType), 1];
end


if isa(this, 'MrImage') % explicit geometry information/affine matrix
    geometryNifti = this.geometry.copyobj.convert(CoordinateSystems.nifti);
else
    % no affine information for standard MrDataNd, i.e. no rotation and shear
    geometryNifti = this.dimInfo.get_geometry4D();
end

nVoxels3D = geometryNifti.nVoxels(1:3);
affineMatrix = geometryNifti.get_affine_matrix();
TR_s = geometryNifti.TR_s;
nVols = geometryNifti.nVoxels(4);

verbose = true;

% captures coordinate flip matlab/analyze between 1st and 2nd dimension
iVolArray = 1:nVols;

% create different img-files for each volume, if analyze-format
[fileNameVolArray, nifti_flag] = get_vol_filenames(filename, iVolArray);

%% delete existing image files & header (.nii/.mat or .img/.hdr)
if exist(filename, 'file')
    if nifti_flag
        delete_with_hdr(filename);
    else % delete img/hdr-files with same file name trunk one by one
        existingFileArray = get_vol_filenames(filename);
        delete_with_hdr(existingFileArray);
    end
end

if verbose, fprintf(1, 'writing %s, volume %04d', filename, 0); end;
for v = 1:nVols
    if verbose
        fprintf(1, '\b\b\b\b%04d', v);
    end
    if nifti_flag
        % remove ", iVol" to make it readable for spm_write_vol
        V.fname = regexprep(fileNameVolArray{v}, ',.*', '');
        V.n = [v, 1];
    else
        V.fname     = fileNameVolArray{v};
    end
    V.mat       = affineMatrix;
    V.pinfo     = [1;0;0];
    
    V.dt        = dataType;
    Y           = this.data(:,:,:,v);
    V.dim       = nVoxels3D;
    
    % this adds the TR to the nifti file but requires to uncomment line 86
    % 'try, N.timing = V.private.timing; end' in the spm code in function
    % spm_create_vol, which is implemented in spm_create_vol_with_tr.m
    V.private.timing.tspace = TR_s;
    pathSave = fileparts(fileNameVolArray{v});
    [~, ~] = mkdir(pathSave);
    
    spm_create_vol_with_tr(V);
    spm_write_vol_with_tr(V, Y);
end
if verbose, fprintf(1, '\n');end;
