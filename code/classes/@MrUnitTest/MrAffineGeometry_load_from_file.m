function this = MrAffineGeometry_load_from_file(this, testFile)
% Unit test for MrAffineGeometry Constructor from file
%
%   Y = MrUnitTest()
%   run(Y, 'MrAffineGeometry_load_from_file')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrAffineGeometry_load_from_file
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2017-11-30
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

% Unit test for MrDimInfo Constructor loading from different example files

switch testFile
    case '3DNifti'
        % 3D Nifti
        % actual solution
        dataPath = get_path('data');
        niftiFile3D = fullfile(dataPath, 'nifti', 'rest', 'meanfmri.nii');
        actSolution = MrAffineGeometry(niftiFile3D);
        % expected solution
        % get classes path
        classesPath = get_path('classes');
        expSolution = load(fullfile(classesPath, '@MrUnitTest' , ...
            'affineGeom-meanfmri.mat'));
        expSolution = expSolution.affineGeom;
    case '4DNifti'
        % 4D Nifti
        % actual solution
        dataPath = get_path('data');
        niftiFile4D = fullfile(dataPath, 'nifti', 'rest', 'fmri_short.nii');
        actSolution = MrAffineGeometry(niftiFile4D);
        % expected solution
        % get classes path
        classesPath = get_path('classes');
        expSolution = load(fullfile(classesPath, '@MrUnitTest' , ...
            'affineGeom-fmri_short.mat'));
        expSolution = expSolution.affineGeom;
    case 'ParRec'
        % par/rec data
        % actual solution
        dataPath = get_path('data');
        % par/rec
        parRecFile = fullfile(dataPath, 'parrec', 'rest_feedback_7T', 'fmri1.par');
        actSolution = MrAffineGeometry(parRecFile);
        % expected solution
        % get classes path
        classesPath = get_path('classes');
        expSolution = load(fullfile(classesPath, '@MrUnitTest' , ...
            'affineGeom-fmri.mat'));
        expSolution = expSolution.affineGeom;
end

% verify equality of expected and actual solution
% import matlab.unittests to apply tolerances for objects 
import matlab.unittest.TestCase
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.AbsoluteTolerance
import matlab.unittest.constraints.PublicPropertyComparator

this.verifyThat(actSolution, IsEqualTo(expSolution,...
    'Within', AbsoluteTolerance(10e-7),...
    'Using', PublicPropertyComparator.supportingAllValues));
end
