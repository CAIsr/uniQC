function update_from_affine_matrix(this, ...
    affineMatrix)
% Updates properties of MrImageGeometry from affine 4x4 transformation
% matrix
%
%   Y = MrImageGeometry()
%   Y.update_from_affine_matrix(affineMatrix)
%
% This is a method of class MrImageGeometry.
%
% IN
%
% OUT
%
% EXAMPLE
%   update_from_affine_matrix
%
%   See also MrImageGeometry uniqc_spm_matrix, uniqc_spm_imatrix
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-27
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
% $Id: update_from_affine_matrix.m 458 2018-05-01 01:43:22Z sklein $
P = round(uniqc_spm_imatrix(affineMatrix),7); % round 7 decimals, to avoid small numbers < single precision

% only valid for nifti coordinate system, compute from there
originalCoordinateSystem = this.coordinateSystem;

this.coordinateSystem   = CoordinateSystems.nifti;
this.offcenter_mm       = P(1:3);
this.rotation_deg       = P(4:6)/pi*180;
this.resolution_mm      = P(7:9);
this.shear_mm           = P(10:12);
this.FOV_mm             = this.resolution_mm.*...
    this.nVoxels(1:3);

this.convert(originalCoordinateSystem);