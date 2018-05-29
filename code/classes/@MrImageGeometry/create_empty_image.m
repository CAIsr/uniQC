function emptyImage = create_empty_image(this, varargin)
% Creates all-zeroes image with
%
%   Y = MrImageGeometry()
%   Y.create_empty_image(varargin)
%
% This is a method of class MrImageGeometry.
%
% IN
%
%   varargin    'ParameterName', 'ParameterValue'-pairs for the following
%               properties:
%
%               Parameters for data extraction:
%
%               'signalPart'        for complex data, defines which signal
%                                   part shall be extracted for plotting
%                                       'all'       - do not change data (default)
%                                       'abs'       - absolute value
%                                       'phase'     - phase of signal
%                                       'real'      - real part of signal
%                                       'imag'      - imaginary part of
%                                                     signal
%               'plotMode',         transformation of data before plotting
%                                   'linear' (default), 'log'
%               'selectedX'         [1, nPixelX] vector of selected
%                                   pixel indices in 1st image dimension
%               'selectedY'         [1, nPixelY] vector of selected
%                                   pixel indices in 2nd image dimension
%               'selectedVolumes'   [1,nVols] vector of selected volumes to
%                                             be displayed
%               'selectedSlices'    [1,nSlices] vector of selected slices to
%                                               be displayed
%                                   choose Inf to display all volumes
%               'sliceDimension'    (default: 3) determines which dimension
%                                   shall be plotted as a slice
%               'exclude'           false (default) or true
%                                   if true, selection will be inverted, i.e.
%                                   selectedX/Y/Slices/Volumes will NOT be
%                                   extracted, but all others in dataset
%               'rotate90'          default: 0; 0,1,2,3; rotates image
%                                   by multiple of 90 degrees AFTER
%                                   flipping slice dimensions
% OUT
%
% EXAMPLE
%   % create 3D version of empty image from current geometry
%   Y.create_empty_image('selectedVolumes', 1);
%
%   See also MrImageGeometry
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-12-10
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
% $Id: create_empty_image.m 405 2018-01-18 07:27:50Z sklein $
emptyImage = MrImage();
% add AffineGeometry
% check which coordinate System of MrImageGeometry
switch this.coordinateSystem
    case CoordinateSystems.scanner
        voxel_coord = [-this.nVoxels(1:3)./2, 1]';
        world_coord = this.get_affine_matrix * voxel_coord;
        offcenter_mm = world_coord(1:3)';
    otherwise
        offcenter_mm = this.offcenter_mm;
end
emptyImage.affineGeometry = MrAffineGeometry(...
    'offcenter_mm', offcenter_mm, ...
    'rotation_deg', this.rotation_deg, ...
    'shear_mm', this.shear_mm, ...
    'resolution_mm', this.resolution_mm, ...
    'sliceOrientation', this.sliceOrientation, ...
    'displayOffset', char(this.coordinateSystem));
% add DimInfo
emptyImage.dimInfo = MrDimInfo(...
    'dimLabels', {'x', 'y', 'z', 't'}, ...
    'units', {'mm', 'mm', 'mm', 's'}, ...
    'nSamples', this.nVoxels, ...
    'resolutions', [this.resolution_mm, this.TR_s], ...
    'firstSamplingPoint', [this.resolution_mm, this.TR_s]);
emptyImage.data = zeros(emptyImage.geometry.nVoxels);
emptyImage.parameters.save.fileName = 'emptyImageTargetGeometry.nii';
if nargin
    emptyImage.select(varargin{:});
end
