function [this, argsUnused] = update(this, varargin)
% updates Geometry directly or computes given new FOV/resolution/nVoxels or whole affineGeometry
%
%   Y = MrImageGeometry()
%   Y.update('FOV_mm', FOV_mm, 'resolution_mm', resolution_mm, ...
%            'nVoxels', nVoxels, 'affineMatrix', affineMatrix, ...
%            <other geom propertyName/Value pairs>)
%
% This is a method of class MrImageGeometry.
%
% Two of the three values FOV/resolution/nVoxels have to be given to define
% the third. Alternatively, the 4x4 affine Matrix can be given to update
% the geometry.
% Other geom parameters are just re-written directly (offcenter,
% rotation...)
%
% IN
%
% OUT
%   this        updated MrImageGeometry
%   argsUnused  other ParamName/Value pairs that do not correspond to image
%               geometry
%
% EXAMPLE
%   update
%
%   See also MrImageGeometry
%
% Author:   Lars Kasper
% Created:  2016-01-30
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: update.m 352 2017-10-12 11:20:02Z lkasper $

% ignore cases without input to update...
if nargin > 1
    
    defaults.affineMatrix =  [];
    defaults.resolution_mm = this.resolution_mm;
    defaults.offcenter_mm = [];
    defaults.rotation_deg = [];
    defaults.coordinateSystem = [];
    defaults.shear_mm = this.shear_mm;

    
    [argsGeom, argsUnused] = propval(varargin, defaults);
    strip_fields(argsGeom);
    
    updateAffine = ~isempty(affineMatrix);  
    
    % here, computations are necessary
    if updateAffine
        this.update_from_affine_transformation_matrix(affineMatrix);
    else
        this.resolution_mm      = resolution_mm;
        this.offcenter_mm       = offcenter_mm;
        this.rotation_deg       = rotation_deg;
        this.coordinateSystem   = coordinateSystem;
        this.shear_mm           = shear_mm;
    end  
end
end