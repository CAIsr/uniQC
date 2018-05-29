function this = set_from_geometry4D(this, geometry)
% Updates affine geometry from read-in MrImageGeometry
%
%   Y = MrAffineGeometry()
%   Y.set_from_geometry4D(geometry)
%
% This is a method of class MrAffineGeometry.
%
% IN
%   geometry        MrImageGeometry
% OUT
%
% EXAMPLE
%   set_from_geometry4D
%
%   See also MrAffineGeometry
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-10-12
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
% $Id: set_from_geometry4D.m 371 2017-11-02 10:29:29Z lkasper $

% MrAffineMatrix is always in nifti coordinate system
geometryNifti = geometry.copyobj.convert(CoordinateSystems.nifti);

this.shear_mm = geometryNifti.shear_mm;
this.rotation_deg = geometryNifti.rotation_deg;
this.resolution_mm = geometryNifti.resolution_mm;
this.offcenter_mm = geometryNifti.offcenter_mm;

