function this = MrAffineGeometry_constructor(this, testVariants)
% Unit test for MrAffineGeometry Constructor
%
%   Y = MrUnitTest()
%   run(Y, 'MrAffineGeometry_constructor')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrAffineGeometry_constructor
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2017-10-19
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
% Unit test for MrAffineGeometry Constructor

switch testVariants
    case 'propVal' % test prop/val syntax
        
        % actual solution
        actSolution = this.make_affineGeometry_reference(0);
        
        % expected solution
        % get classes path
        classesPath = get_path('classes');
        % make full filename
        solutionFileName = fullfile(classesPath, '@MrUnitTest' , 'affineGeom.mat');
        expSolution = load(solutionFileName);
        expSolution = expSolution.affineGeom;
        
        % verify equality of expected and actual solution
        % import matlab.unittests to apply tolerances for objects
        import matlab.unittest.TestCase
        import matlab.unittest.constraints.IsEqualTo
        import matlab.unittest.constraints.AbsoluteTolerance
        import matlab.unittest.constraints.PublicPropertyComparator
        
        this.verifyThat(actSolution, IsEqualTo(expSolution,...
            'Within', AbsoluteTolerance(10e-7),...
            'Using', PublicPropertyComparator.supportingAllValues));
        
    case 'matrix' % test affine geometry as input        
        % expected solution
        expSolution = this.make_affineGeometry_reference(0);
        expSolution = expSolution.affineMatrix;
        % actual solution
        % make actual solution from affine matrix of expected solution
        actSolution = MrAffineGeometry(expSolution);
        actSolution = actSolution.affineMatrix;
        
        % verify equality of expected and actual solution
        this.verifyEqual(actSolution, expSolution, 'absTol', 10e-7);
end
end