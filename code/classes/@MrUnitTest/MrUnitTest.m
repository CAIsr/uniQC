classdef MrUnitTest < matlab.unittest.TestCase
    % Implements unit testing for MrClasses
    %
    % EXAMPLE
    %   MrUnitTest
    %
    %   See also
    %
    % Author:   Saskia Bollmann
    % Created:  2017-07-07
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
    % $Id: new_class2.m 354 2013-12-02 22:21:41Z kasperla $
    
    properties (TestParameter)
        % MrDimInfo
        testVariantsDimInfo = {'1', '2', '3', '4', '5', '6', '7', '8', '9', ...
            '10', '11'};
        testFile = {'3DNifti', '4DNifti', 'Folder', 'ParRec'};
        testVariantsDimInfoSplit = {'singleDim', 'twoDims', 'nonExistingDim', ...
            'charSplitDim', 'differentIndex'};
        testVariantsDimInfoSelect = {'singleDim', 'multipleDimsWithSelection',...
            'type', 'invert', 'removeDims', 'unusedVarargin'};
        % MrAffineGeometry
        testVariantsAffineGeom = {'propVal', 'matrix'};
        testFileAffineGeom = {'3DNifti', '4DNifti', 'ParRec'};
        testVariantsImageGeom = {'makeReference', 'matrix', 'dimInfo', ...
            'affineGeometry', 'dimInfoAndAffineGeometry', 'FOV_resolutions', ...
            'FOV_nVoxels', 'resolutions_nVoxels', 'FOV_resolutions_nVoxels', 'timing_info'};
        % MrDataNd
        testVariantsDataNd = {'matrix', 'matrixWithDimInfo', 'matrixWithPropVal'};
        testArithmeticOperation = {'minus', 'plus', 'power', 'rdivide', 'times'};
        testDimensionOperation = {'circshift', 'flip', 'fliplr', 'flipud', ...
            'resize', 'rot90', 'select', 'split'};
        MrDataNd_value_operation = {'cumsum', 'diff', 'fft', 'hist', 'ifft', ...
            'isreal', 'max', 'maxip', 'mean', 'power', 'prctile', 'real', ...
            'rms', 'rmse', 'unwrap'};
    end
    
    %% MrDimInfo
    methods (Test, TestTags = {'Constructor', 'MrDimInfo'})
        this = MrDimInfo_constructor(this, testVariantsDimInfo)
        this = MrDimInfo_load_from_file(this, testFile)
    end
    
    methods (Test, TestTags = {'Methods', 'MrDimInfo'})
        this = MrDimInfo_get_add_remove(this)
        this = MrDimInfo_index2sample(this)
        this = MrDimInfo_permute(this)
        this = MrDimInfo_split(this, testVariantsDimInfoSplit)
        this = MrDimInfo_select(this, testVariantsDimInfoSelect)
    end
    
    %% MrAffineGeometry
    methods (Test, TestTags = {'Constructor', 'MrAffineGeometry'})
        this = MrAffineGeometry_constructor(this, testVariantsAffineGeom)
        this = MrAffineGeometry_load_from_file(this, testFileAffineGeom)
    end
    
    methods (Test, TestTags = {'Methods', 'MrAffineGeometry'})
        this = MrAffineGeometry_transformation(this)
        this = MrAffineGeometry_affineMatrix(this)
    end
    %% MrImageGeometry
    methods (Test, TestTags = {'Constructor', 'MrImageGeometry'})
        this = MrImageGeometry_constructor(this, testVariantsImageGeom)
        this = MrImageGeometry_load_from_file(this, testFile)
    end
    
    methods (Test, TestTags = {'Methods', 'MrImageGeometry'})
        this = MrImageGeometry_create_empty_image(this)
    end
    %% MrDataNd
    methods (Test, TestTags = {'Constructor', 'MrDataNd'})
        this = MrDataNd_constructor(this, testVariantsDataNd)
        % loading of nifti data will be tested in MrImage (since there,
        % also the affineGeometry is created)
    end
    
    methods (Test, TestTags = {'Methods', 'MrDataNd'})
        this = MrDataNd_arithmetic_operation(this, testArithmeticOperation)
        % this = MrDataNd_dimension_operation(this, testDimensionOperation);
        % this = MrDataNd_value_operation(this, testValueOperation);
    end
    
end
