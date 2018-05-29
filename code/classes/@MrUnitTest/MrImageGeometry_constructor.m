function this = MrImageGeometry_constructor(this, testVariants)
% Unit test for MrImageGeometry Constructor with different inputs
%
%   Y = MrUnitTest()
%   run(Y, 'MrImageGeometry_constructor')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrImageGeometry_constructor
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2018-01-18
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

% reference objects
dimInfo = this.make_dimInfo_reference;
affineGeom = this.make_affineGeometry_reference;
imageGeom = this.make_MrImageGeometry_reference;

switch testVariants
    case 'makeReference' % test whether reference is valid
        % actual solution
        actSolution = imageGeom;
        
        % expected solution
        % get classes path
        classesPath = get_path('classes');
        % make full filename
        solutionFileName = fullfile(classesPath, '@MrUnitTest' , 'imageGeom.mat');
        expSolution = load(solutionFileName);
        expSolution = expSolution.imageGeom;
        
    case 'matrix' % test affine geometry as input
        % expected solution
        expSolution = affineGeom;
        expSolution = expSolution.affineMatrix;
        
        % actual solution
        % make actual solution from affine matrix of expected solution
        actSolution = MrAffineGeometry(expSolution);
        actSolution = actSolution.affineMatrix;
        
    case 'dimInfo'
        % expected solution
        expSolution.nVoxels = imageGeom.nVoxels;
        expSolution.TR_s = imageGeom.TR_s;
        
        % actual Solution
        imageGeomObj = MrImageGeometry(dimInfo);
        actSolution.nVoxels = imageGeomObj.nVoxels;
        actSolution.TR_s = imageGeomObj.TR_s;
        
    case 'affineGeometry'
        % expected solution
        expSolution.resolution_mm = imageGeom.resolution_mm;
        expSolution.offcenter_mm = imageGeom.offcenter_mm;
        expSolution.rotation_deg = imageGeom.rotation_deg;
        expSolution.shear_mm = imageGeom.shear_mm;
        expSolution.sliceOrientation = imageGeom.sliceOrientation;
        expSolution.coordinateSystem = imageGeom.coordinateSystem;
        
        % actual Solution
        imageGeomObj = MrImageGeometry(affineGeom, ...
            MrDimInfo('nSamples', imageGeom.nVoxels));
        actSolution.resolution_mm = imageGeomObj.resolution_mm;
        actSolution.offcenter_mm = imageGeomObj.offcenter_mm;
        actSolution.rotation_deg = imageGeomObj.rotation_deg;
        actSolution.shear_mm = imageGeomObj.shear_mm;
        actSolution.sliceOrientation = imageGeomObj.sliceOrientation;
        actSolution.coordinateSystem = imageGeomObj.coordinateSystem;
        
        
    case 'dimInfoAndAffineGeometry'
        % expected solution
        expSolution = imageGeom;
        
        % acutal solution
        actSolution = MrImageGeometry(affineGeom, dimInfo);
        
    case 'FOV_resolutions'
        
        % FOV
        resolution_mm = affineGeom.resolution_mm;
        nVoxels = dimInfo.nSamples({'x', 'y', 'z'});
        FOV_mm = resolution_mm .* nVoxels(1:3);
        % expected solution
        expSolution = [nVoxels 1];
        % actual solution
        imageGeomObj =  MrImageGeometry([], ...
            'resolution_mm', resolution_mm, ...
            'FOV_mm', FOV_mm);
        actSolution = imageGeomObj.nVoxels;
        
    case 'FOV_nVoxels'
        
        % FOV
        resolution_mm = affineGeom.resolution_mm;
        nVoxels = dimInfo.nSamples({'x', 'y', 'z'});
        FOV_mm = resolution_mm .* nVoxels;
        
        % expected solution
        expSolution = resolution_mm;
        
        % actual solution
        imageGeomObj =  MrImageGeometry([], ...
            'nVoxels', nVoxels, ...
            'FOV_mm', FOV_mm);
        actSolution = imageGeomObj.resolution_mm;
        
        
    case 'resolutions_nVoxels'
        
        % FOV
        resolution_mm = affineGeom.resolution_mm;
        nVoxels = dimInfo.nSamples({'x', 'y', 'z', 't'});
        FOV_mm = resolution_mm .* nVoxels(1:3);
        
        % expected solution
        expSolution = FOV_mm;
        
        % actual solution
        imageGeomObj =  MrImageGeometry([], ...
            'nVoxels', nVoxels, ...
            'resolution_mm', resolution_mm);
        actSolution = imageGeomObj.FOV_mm;
        
    case 'FOV_resolutions_nVoxels'
        % FOV
        resolution_mm = affineGeom.resolution_mm;
        nVoxels = dimInfo.nSamples({'x', 'y', 'z', 't'});
        FOV_mm = resolution_mm .* nVoxels(1:3);
        
        % expected Solution
        expSolution.nVoxels = nVoxels;
        expSolution.resolution_mm = resolution_mm;
        expSolution.FOV_mm = FOV_mm;
        
        % actual solution
        imageGeomObj =  MrImageGeometry([], ...
            'nVoxels', nVoxels, ...
            'resolution_mm', resolution_mm, ...
            'FOV_mm', FOV_mm);
        actSolution.nVoxels = imageGeomObj.nVoxels;
        actSolution.resolution_mm = imageGeomObj.resolution_mm;
        actSolution.FOV_mm = imageGeomObj.FOV_mm;
        
    case 'timing_info'
        % expected solution
        expSolution.s       = 0.65;
        expSolution.ms      = 0.65;
        expSolution.samples = 0;
        
        % TR is given in seconds
        geom = MrImageGeometry(dimInfo);
        actSolution.(dimInfo.t.units{1}) = geom.TR_s;
        
        % TR is given in ms
        dimInfo.set_dims('t', 'units', 'ms', 'resolutions', ...
            dimInfo.t.resolutions * 1000)
        geom = MrImageGeometry(dimInfo);
        actSolution.(dimInfo.t.units{1}) = geom.TR_s;
        
        % TR is given in samples
        dimInfo.set_dims('t', 'units', 'samples', 'resolutions', 1);
        geom = MrImageGeometry(dimInfo);
        actSolution.(dimInfo.t.units{1}) = geom.TR_s;
        
        
end
% verify equality of expected and actual solution

switch testVariants
    case 'makeReference'
        % verify equality of expected and actual solution
        % import matlab.unittests to apply tolerances for objects
        import matlab.unittest.TestCase
        import matlab.unittest.constraints.IsEqualTo
        import matlab.unittest.constraints.AbsoluteTolerance
        import matlab.unittest.constraints.PublicPropertyComparator
        
        this.verifyThat(actSolution, IsEqualTo(expSolution,...
            'Within', AbsoluteTolerance(10e-7),...
            'Using', PublicPropertyComparator.supportingAllValues));
        
    otherwise
        % verify equality of expected and actual solution
        this.verifyEqual(actSolution, ...
            expSolution, 'absTol', 10e-7);
        
end


end
