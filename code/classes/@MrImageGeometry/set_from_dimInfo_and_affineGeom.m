function this = set_from_dimInfo_and_affineGeom(this, dimInfo, affineGeometry)
% Creats MrImageGeometry from MrDimInfo and MrAffineGeometry
%
%   Y = MrImageGeometry()
%   Y.set_from_dimInfo_and_affineGeom(dimInfo, affineGeometry)
%
% This is a method of class MrImageGeometry.
%
% IN
%
% OUT
%
% EXAMPLE
%   dimInfo = MrDimInfo(fileName);
%   affineGeometry = MrAffineGeometry(fileName);
%   ImageGeometry = MrImageGeometry(dimInfo, affineGeometry);
%
%   See also MrImageGeometry
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-10-30
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

% check input
isValidInput = (isa(dimInfo, 'MrDimInfo')) && (isa(affineGeometry, 'MrAffineGeometry'));

if isValidInput
    % just copy/paste from dimInfo and affineGeometry
    
    % properties from MrAfffineGeometry
    this.rotation_deg = affineGeometry.rotation_deg;
    this.shear_mm = affineGeometry.shear_mm;
    this.resolution_mm = affineGeometry.resolution_mm;
    
    % properties from MrDimInfo
    % check first whether these actually exist!
    % x
    if ~isempty(dimInfo.nSamples('x'))
        this.nVoxels(1) = dimInfo.nSamples('x');
    else
        this.nVoxels(1) = 1;
        fprintf('nSamples for ''x'' not specified. Check dimInfo.');
    end
    % y
    if ~isempty(dimInfo.nSamples('y'))
        this.nVoxels(2) = dimInfo.nSamples('y');
    else
        this.nVoxels(2) = 1;
        fprintf('nSamples for ''x'' not specified. Check dimInfo.');
    end
    % z
    if ~isempty(dimInfo.nSamples('z'))
        this.nVoxels(3) = dimInfo.nSamples('z');
    else
        this.nVoxels(3) = 1;
        fprintf('nSamples for ''z'' not specified. Check dimInfo.');
    end
    
    % search for timing info
    trCharacters = {'t', 'time', 'TR'};
    trFound = ismember(trCharacters, dimInfo.dimLabels);
    if any(trFound)
        % check whether timing information is given in (milli)seconds
        if strcmpi('s', dimInfo.units(trCharacters{trFound}))
            this.TR_s = dimInfo.resolutions(trCharacters{trFound});
            this.nVoxels(4) = dimInfo.nSamples(trCharacters{trFound});
        elseif strcmpi('ms', dimInfo.units(trCharacters{trFound}))
            this.TR_s = dimInfo.resolutions(trCharacters{trFound})./1000;
            this.nVoxels(4) = dimInfo.nSamples(trCharacters{trFound});
        else
            this.nVoxels(4) = dimInfo.nSamples(trCharacters{trFound});
        end
    end
    
    % compute FOV directly
    this.FOV_mm = this.nVoxels(1:3).*this.resolution_mm;
    
    % sliceOrientation
    this.sliceOrientation = affineGeometry.sliceOrientation;
    
    % displayOffcentre
    if strcmp(affineGeometry.displayOffset, 'nifti')
        % nothing to for nifti, just copy
        this.offcenter_mm = affineGeometry.offcenter_mm;
        % set coordinate system
        this. coordinateSystem = CoordinateSystems.nifti;
    elseif strcmp(affineGeometry.displayOffset, 'scanner')
        % compute new offcentre for scanner
        voxel_coord = [dimInfo.nSamples({'x', 'y', 'z'})./2, 1]';
        world_coord = affineGeometry.affineMatrix * voxel_coord;
        this.offcenter_mm = world_coord(1:3)';
        % set coordinate system
        this.coordinateSystem = CoordinateSystems.scanner;
    end
else
    fprintf('Geometry could not be created: Invalid Input (MrDimInfo and MrAffineGeometry expected');
end