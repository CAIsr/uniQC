function imageGeom = make_MrImageGeometry_reference(this, varargin)
% create a MrImageGeometry reference object for unit testing
%
%   Y = MrUnitTest()
%   Y.make_MrImageGeometry_reference(do_save, fileName)
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   make_MrImageGeometry_reference
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2018-01-17
% Copyright (C) 2018 Institute for Biomedical Engineering
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

% check if created object should be saved for unit testing
if nargin > 1
    do_save = varargin{1};
else
    do_save = 0;
end

if nargin > 2
    fileName = varargin{2};
    makeFromFile = 1;
else
    makeFromFile = 0;
end

if makeFromFile
    imageGeom = MrImageGeometry(fileName);
    [~,name] = fileparts(fileName);
    % get classes path
    classesPath = get_path('classes');
    % make full filename using date
    filename = fullfile(classesPath, '@MrUnitTest' , ...
        ['imageGeom-' name '.mat']);
else
    % get reference MrDimInfo object
    dimInfo = this.make_dimInfo_reference;
    % get reference MrAffineGeometry object
    affineGeometry = this.make_affineGeometry_reference;
    
    % make MrImageGeometry object
    % displayOffcentre
    if strcmp(affineGeometry.displayOffset, 'nifti')
        % nothing to for nifti, just copy
        offcenter_mm = affineGeometry.offcenter_mm;
    elseif strcmp(affineGeometry.displayOffset, 'scanner')
        % compute new offcentre for scanner
        voxel_coord = [dimInfo.nSamples({'x', 'y', 'z'})./2, 1]';
        world_coord = affineGeometry.affineMatrix * voxel_coord;
        offcenter_mm = world_coord(1:3)';
    end
    
    % set imageGeom properties
    imageGeom = MrImageGeometry([], ...
        'resolution_mm', affineGeometry.resolution_mm, ...
        'nVoxels', dimInfo.nSamples({'x', 'y', 'z', 't'}), ...
        'TR_s', dimInfo.t.resolutions, ...
        'offcenter_mm', offcenter_mm, ...
        'rotation_deg', affineGeometry.rotation_deg, ...
        'shear_mm', affineGeometry.shear_mm, ...
        'sliceOrientation', affineGeometry.sliceOrientation, ...
        'coordinateSystem', affineGeometry.displayOffset);
    
    % get classes path
    classesPath = get_path('classes');
    % make full filename using date
    filename = fullfile(classesPath, '@MrUnitTest' , 'imageGeom.mat');
end
if do_save
    if exist(filename, 'file')
        prompt = 'Overwrite current MrImageGeometry constructor reference object? Y/N [N]:';
        answer = input(prompt, 's');
        if strcmpi(answer, 'N')
            do_save = 0;
        end
    end
end
if do_save
    save(filename, 'imageGeom');
end
