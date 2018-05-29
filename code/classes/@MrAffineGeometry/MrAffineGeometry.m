classdef MrAffineGeometry < MrCopyData
    % Stores affine transformation (nifti convention!) for an image. Is
    % disregarded during display
    %
    % Assumes that matrix always refers to dimensions in order
    % {'x', 'y', 'z'} => if dims are in different order in dimInfo, they
    % are resorted before applying a transformation
    %
    % NOTE: If you want to see rotations/offcenter etc. in a different
    % coordinate system, look at MrImageGeometry
    %
    % EXAMPLE
    %   MrAffineGeometry
    %
    %   See also
    %
    % Author:   Saskia Bollmann & Lars Kasper
    % Created:  2016-06-15
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
    % $Id: MrAffineGeometry.m 458 2018-05-01 01:43:22Z sklein $
    
    properties
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
        shear_mm         = [0 0 0];
        
        % voxel size in mm
        resolution_mm = [1 1 1];
        
        % see also uniqc_spm_matrix.m for more details
        
        % for par/rec files indicating slice orientation
        sliceOrientation = 1;
        
        % for MrImageGeometry which offset should be displayed
        displayOffset = 'nifti';
        
    end % properties
    
    properties (Dependent)
        % Affine transformation matrix, computed from SPM
        affineMatrix;
    end
    
    methods
        
        function this = MrAffineGeometry(varargin)
            % Constructor of class
            %   MrAffineGeometry(affineMatrix)
            %       OR
            %   MrAffineGeometry(fileName)
            %       OR
            %   MrAffineGeometry('PropertyName', PropertyValue, ...)
            
            hasInputFile = nargin == 1 && ischar(varargin{1}) && exist(varargin{1}, 'file');
            hasInputAffineMatrix = nargin == 1 && isnumeric(varargin{1});
            hasInputDimInfo = nargin == 1 && isa(varargin{1}, 'MrDimInfo');
            
           if nargin == 1
                if hasInputFile
                    % load from file
                    this.load(varargin{1});
                elseif hasInputAffineMatrix
                    % affineMatrix
                    this.update_from_affine_matrix(varargin{1});
                elseif hasInputDimInfo
                    this.set_from_dim_info(varargin{1});
                end
            else
                for cnt = 1:nargin/2 % save 'PropertyName', PropertyValue  ... to object properties
                    this.(varargin{2*cnt-1}) = varargin{2*cnt};
                end
            end
        end
        
        % NOTE: Most of the methods are saved in separate function.m-files in this folder;
        %       except: constructor, delete, set/get methods for properties.
        
        function affineMatrix = get.affineMatrix(this)
            affineMatrix = this.get_affine_matrix();
        end
        
    end % methods
    
end
