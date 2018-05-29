function [affineCoregistrationGeometry] = coregister_to(this, stationaryImage, ...
    applyTransformation, affine)
% Coregister this MrImage to another given MrImage
% NOTE: Also does reslicing of image
%
%   Y = MrImage()
%   affineCoregistrationMatrix = Y.coregister_to(this, otherImage, ...
%               applyTransformation);
%
% This is a method of class MrImage.
%
% IN
%       stationaryImage  MrImage that serves as "stationary" or reference image
%                        to which this image is coregistered to
%       applyTransformation
%                   'geometry'      MrImageGeometry is updated,
%                                   MrImage.data remains untouched
%                   'data'          MrImage.data is resliced to new
%                                   geometry
%                                   NOTE: An existing
%                                   transformation in MrImageGeometry will
%                                   also be applied to MrImage, combined
%                                   with the calculated one for
%                                   coregistration
%
%                   'none'          transformation matrix is
%                                   computed, but not applied to geometry of data of this
%                                   image
%       affine      'true' or 'false' (default)
%                                   whether an affine or a rigid body
%                                   transformation is computed
% OUT
%       affineCoregistrationGeometry  MrImageGeometry holding mapping from
%                                     stationary to transformed image
%
%
% EXAMPLE
%   Y = MrImage();
%   otherImage = MrImage();
%
%   co-registers Y to otherImage, i.e. changes geometry of Y
%   Y.coregister_to(otherImage);
%
%   See also MrImage spm_coreg
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-24
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
% $Id: coregister_to.m 463 2018-05-02 10:41:56Z lkasper $

if nargin < 3
    applyTransformation = 'data';
end
if nargin < 4
    affine = 0;
end
%% save raw and stationary image data as nifti
% set filenames
fileStationaryImage = fullfile(this.parameters.save.path, 'rawStationary.nii');

% save raw files
this.save('fileName', this.get_filename('raw'));
stationaryImage.copyobj.save('fileName', fileStationaryImage);

%% matlabbatch
% get matlabbatch
matlabbatch = this.get_matlabbatch('coregister_to', ...
    [fileStationaryImage, ',1']);
% save matlabbatch
save(fullfile(this.parameters.save.path, 'matlabbatch.mat'), ...
    'matlabbatch');

% NOTE: This job is not actually run to enable a clean separation of
% coregistration and re-writing of the object
% spm_jobman('run', matlabbatch);
% NOTE: The following lines are copied and modified from spm_run_coreg to
% enable a separation between computation and application of coregistration
% parameters

job = matlabbatch{1}.spm.spatial.coreg.estimate;

% Enable affine instead of rigid body registration by setting scaling of
% zoom-parameters to 1,1,1

if affine
    job.eoptions.params = [0 0 0 0 0 0 1 1 1 0 0 0];
end

%% Coregistration
% Compute coregistration transformation
x  = spm_coreg(char(job.ref), char(job.source), job.eoptions);

% Apply coregistration, if specified, but leave raw image untouched!

% header of stationary image:
% MatF voxel -> world
% header of transformed image:
% MatV voxel -> world
%
% transformation in spm_coreg:
% worldF -> worldF

%  mapping from voxels in G to voxels in F is attained by:
%           i.e. from reference to source:
%               G = reference
%               F = source
%
%         VF.mat\spm_matrix(x(:)')*VG.mat
% =       inv(VF.mat) * spm_matrix(x) * VG.mat
% A\B = inv(A) * B

% get affine coregistration matrix
affineCoregistrationMatrix = uniqc_spm_matrix(x);
affineCoregistrationGeometry = MrAffineGeometry(affineCoregistrationMatrix);

%% update geometry/data if necessary
doUpdateAffineGeometry = ismember(applyTransformation, {'data', 'geometry'});
% update geometry
if doUpdateAffineGeometry
    this.affineGeometry.apply_inverse_transformation(affineCoregistrationGeometry);
end

% reslice image
doResliceImage = strcmpi(applyTransformation, 'data');
if doResliceImage
    % keep save parameters for later
    parametersSave = this.parameters.save;
    this.parameters.save.keepCreatedFiles = 1;
   
    % reslice image to given geometry
    this.reslice(stationaryImage.geometry);
    
    this.parameters.save = parametersSave;
end

%% save processed image
this.save();
%% clean up: move/delete processed spm files, load new data into matrix
fnOutputSpm = {};
this.finish_processing_step('coregister_to', fileStationaryImage, ...
    fnOutputSpm);