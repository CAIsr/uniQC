classdef MrImageGeometry < MrCopyData
    % Geometry properties of MrImage, in particular for operations on niftis
    % Provides full voxel to world mapping, i.e. affine transformation
    % Including rotation/translation/voxel scaling
    %
    %
    % EXAMPLE
    %   MrImageGeometry
    %
    %   See also MrImage uniqc_spm_matrix uniqc_spm_imatrix
    %
    % Author:   Saskia Klein & Lars Kasper
    % Created:  2014-07-15
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
    % $Id: MrImageGeometry.m 458 2018-05-01 01:43:22Z sklein $
    
    properties (SetObservable = true)
        
        % [1,3] vector of Field of View (in mm)
        FOV_mm          = [0 0 0];
        
        % [1,4] vector of number of voxels per image dimension
        % (x, y, z and time (number of volumes)
        nVoxels         = [1 1 1 1];
        
        % [1,3] vector of image resolution (voxel size in mm) in x,y,z
        % direction
        resolution_mm   = [0 0 0];
        
        % Repetition time in seconds
        % between subsequent scans/volumes (4th dim samples)
        TR_s            = 0;
        
        % [1,3] vector of translational offcenter (in mm) in x,y,z of
        % image volume with respect to isocenter
        offcenter_mm    = [0 0 0];
        
        % [1,3] vector of rotation (in degrees)
        % around x,y,z-axis (i.e. pitch, roll and yaw), i.e. isocenter (0,0,0)
        rotation_deg    = [0 0 0];
        
        % [1,3] vector of x-y, x-z and y-z shear (in mm)
        %
        % equivalent to off-diagonal elements of affine transformation matrix:
        % S   = [1      P(10)   P(11)   0;
        %        0      1       P(12)   0;
        %        0      0       1       0;
        %        0      0       0       1];
        shear_mm         = [0 0 0]
        
        % @Laetitia: What is 1,2,3 <=> sagittal/coronal/transversal?
        sliceOrientation = 1;
        
        % coordinate system that defines
        % 1) x,y,z axis orientation relative to patient RL-AP-FH
        % 2) origin of coordinate system: e.g. voxel [1,1,1] (Nifti) or
        % midcenter-midslice (Philips)
        % See also CoordinateSystems
        coordinateSystem = CoordinateSystems.nifti;
    end % properties
    
    methods
        
        function this = MrImageGeometry(varargin)
            % Constructor of class, allows input of affine transformation matrix or
            % nifti/analyze file parsing its header information
            %
            %   MrImageGeometry(fileName, 'PropertyName', PropertyValue, ...)
            %   MrImageGeometry([], 'PropertyName', PropertyValue, ...)
            %   MrImageGeometry(dimInfo, affineGeometry)
            %
            hasInputFile = nargin && ~isempty(varargin{1}) ...
                && ischar(varargin{1});
            hasOneValidInput = nargin && ~isempty(varargin{1});
            hasTwoValidInputs = nargin > 1 && ~isempty(varargin{2});
            
            % check whether dimInfo is first input
            isDimInfoFirstInput = hasOneValidInput && isa(varargin{1}, 'MrDimInfo');
            isAffineGeometrySecondInput = hasTwoValidInputs && isa(varargin{2}, 'MrAffineGeometry');
            isAffineGeometryFirstInput = hasOneValidInput && isa(varargin{1}, 'MrAffineGeometry');
            isDimInfoSecondInput = hasTwoValidInputs && isa(varargin{2}, 'MrDimInfo');
            
            hasInputObjects = (isDimInfoFirstInput  && isAffineGeometrySecondInput) ...
                || (isAffineGeometryFirstInput && isDimInfoSecondInput);
            
            if hasInputFile % file is provided
                fileName = varargin{1};
                tempDimInfo = MrDimInfo(fileName);
                % check whether individual file or whole folder is provided
                if isdir(fileName)
                    % if whole folder, read first file
                    tempDir = dir(fileName);
                    tempAffineGeometry = MrAffineGeometry(...
                        fullfile(fileName, tempDir(3).name));
                else
                    tempAffineGeometry = MrAffineGeometry(fileName);
                end
                this.set_from_dimInfo_and_affineGeom(tempDimInfo, tempAffineGeometry);
                hasInputObjects = 0;
            elseif hasInputObjects % dimInfo and affineGeometry are provided
                if isDimInfoFirstInput
                    this.set_from_dimInfo_and_affineGeom(varargin{1}, varargin{2});
                elseif isAffineGeometryFirstInput
                    this.set_from_dimInfo_and_affineGeom(varargin{2}, varargin{1});
                end
            elseif isDimInfoFirstInput && ~isAffineGeometrySecondInput
                affineGeometry = MrAffineGeometry(varargin{1});
                this.set_from_dimInfo_and_affineGeom(varargin{1}, affineGeometry);
            elseif isAffineGeometryFirstInput && ~isDimInfoSecondInput
                dimInfo = MrDimInfo(varargin{1}); % TODO!
                this.set_from_dimInfo_and_affineGeom(dimInfo, varargin{1});
            end
            % update explicit geometry parameters
            % input file and additional parameters are given
            if hasInputFile && (nargin > 1)
                this.update(varargin{2:end});
                % input objects and additional parameters are given
            elseif hasInputObjects && (nargin > 2)
                this.update(varargin{3:end});
                % only additional parameters are given
            elseif ~hasInputFile && ~hasInputObjects && (nargin > 2)
                this.update(varargin{2:end});
            end
        end
        
        % NOTE: Most of the methods are saved in separate function.m-files in this folder;
        %       except: constructor, delete, set/get methods for properties.
    end % methods
    
end
