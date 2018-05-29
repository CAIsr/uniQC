function this = update_geometry_dim_info(this, varargin)
% Updates Image geometry and keeps corresponding dimInfo in sync
%
%   Y = MrImage()
%   Y.update_geometry_dim_info(varargin)
%
% This is a method of class MrImage.
%
% IN
%   dependent   'geometry' or 'dimInfo';
%               specifies which of the two image properties is the
%               dependent one and will be updated according to the other
%               one
%               default: 'dimInfo'
%   removeDims  default:false
%               if true, singleton dimensions (zero or one element) in
%               dimInfo will be removed
% OUT
%
% EXAMPLE
%   update_geometry_dim_info
%
%   See also MrImage MrDimInfo.get_geometry4D
%
% Author:   Lars Kasper
% Created:  2016-01-31
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
% $Id: update_geometry_dim_info.m 287 2016-04-05 20:35:09Z lkasper $

% Create dim-Info, if not existing
defaults.dependent = 'dimInfo'; % 'dimInfo' or 'geometry'
defaults.dimLabels = [];
defaults.removeDims = false;

[argsUpdate, argsGeomDimInfo] = propval(varargin, defaults);

dimLabelsGeom = {'x', 'y', 'z', 't'};
dimUnitsGeom = {'mm', 'mm', 'mm', 's'};

argsGeometry = filter_propval(argsGeomDimInfo, MrImageGeometry());
argsDimInfo = filter_propval(argsGeomDimInfo, MrDimInfo());


% Create dimInfo with right dimLabels/units, if it does not exist

nDimsImage = ndims(this); % from non-1 voxel dimensions of geometry
if isempty(this.dimInfo) || this.dimInfo.nDims < nDimsImage
    this.dimInfo = MrDimInfo('dimLabels', dimLabelsGeom(1:nDimsImage), ...
        'units', dimUnitsGeom(1:nDimsImage));
end

if isempty(argsUpdate.dimLabels)
    argsUpdate.dimLabels = this.dimInfo.dimLabels;
else % update names of dimensions
    this.dimInfo.set_dims(num2cell(1:numel(argsUpdate.dimLabels)), ...
        'dimLabels', argsUpdate.dimLabels);
end


% now we have to decide which changes are altered based on dependencies and
% which are updated based on the different input parameters...

switch lower(argsUpdate.dependent)
    case 'diminfo' % dimInfo updated from geometry-change
        
        % convert geometry for correct offcenter-calculation from 1st voxel corner!
        geometryNifti = this.geometry.copyobj.convert(...
            CoordinateSystems.nifti);
        
        this.geometry.update(argsGeometry{:});
        
        % combined 4D resolution, TR is spacing in t, i.e. temporal
        % resolution
        resolutions = [this.geometry.resolution_mm, this.geometry.TR_s];
        
        % Set all relevant dimensions, identified by typical labels
        this.dimInfo.set_dims(dimLabelsGeom, ...
            'units', dimUnitsGeom, ...
            'nSamples', this.geometry.nVoxels, ...
            'resolutions', resolutions, ...
            'firstSamplingPoint', [geometryNifti.offcenter_mm 0]);
        
        
    case 'geometry' % geometry updated from dimInfo
        
        this.dimInfo.set_dims(argsUpdate.dimLabels, argsDimInfo{:});

        % Create dummy geometry
        geometry4D = this.dimInfo.get_geometry4D(dimLabelsGeom);
        
        this.geometry.update(...
            'nVoxels', geometry4D.nVoxels, ...
            'resolution_mm', geometry4D.resolution_mm, ...
            'offcenter_mm', geometry4D.offcenter_mm, ...
            'TR_s', geometry4D.TR_s);    
end

% update dimensionality info smaller size of image
if argsUpdate.removeDims
    this.dimInfo.remove_dims();
end
