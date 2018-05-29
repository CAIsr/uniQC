function this = MrAffineGeometry_transformation(this)
% Unit test for MrAffineGeometry applying transformations
%
%   Y = MrUnitTest()
%   run(Y, 'MrAffineGeometry_transformation')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrAffineGeometry_transformation
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2018-01-16
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

% construct MrAffineGeometry object from sampling points
affineGeometry = this.make_affineGeometry_reference(0);

% define expected solution
expSolution = affineGeometry.copyobj;

% create transformation matrix
transformationMatrix = [-0.2769 0.6948 0.4387 18.69; ...
    0.0462 -0.3171 0.3816 4.898; ...
    0.0971 0.9502 -0.7655 4.456; ...
    -0.8235 0.0344 0.7952 0.6463];
% apply transformation matrix
affineGeometry.apply_transformation(transformationMatrix);
% apply inverse transformation matrix
affineGeometry.apply_inverse_transformation(transformationMatrix);

% define actual solution
actSolution = affineGeometry;

% verify equality of expected and actual solution
% import matlab.unittests to apply tolerances for objects 
import matlab.unittest.TestCase
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.AbsoluteTolerance
import matlab.unittest.constraints.PublicPropertyComparator

this.verifyThat(actSolution, IsEqualTo(expSolution,...
    'Within', AbsoluteTolerance(10e-7),...
    'Using', PublicPropertyComparator.supportingAllValues));
