function this = convert(this, newCoordinateSystem)
% Converts current geometry to new coordinate system
%
%   Y = MrImageGeometry()
%   Y.convert(newCoordinateSystem)
%
% This is a method of class MrImageGeometry.
%
% IN
%
% OUT
%
% EXAMPLE
%   Y.convert(CoordinateSystems.nifti) => overwrite current geometry values
%                                       (e.g. offcenter, rotation
%   Y.copyobj.convert(CoordinateSystems.nifti)
%   Y.convert(CoordinateSystems.scanner)
%
%   See also MrImageGeometry CoordinateSystems
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-12-09
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
% $Id: convert.m 405 2018-01-18 07:27:50Z sklein $

switch this.coordinateSystem
    case CoordinateSystems.scanner
        switch newCoordinateSystem
            case CoordinateSystems.nifti
                % compute world coordinates of voxel -nVoxels/2
                voxel_coord = [-this.nVoxels(1:3)./2, 1]';
                world_coord = this.affineMatrix * voxel_coord;
                this.offcenter_mm = world_coord(1:3)';
        end
    case CoordinateSystems.nifti
        switch newCoordinateSystem
            case CoordinateSystems.scanner
                % compute world coordinates of voxel +nVoxels/2
                voxel_coord = [this.nVoxels(1:3)./2, 1]';
                world_coord = this.affineMatrix * voxel_coord;
                this.offcenter_mm = world_coord(1:3)';
        end
end
this.coordinateSystem = newCoordinateSystem;