function this = MrDataNd_arithmetic_operation(this, testArithmeticOperation)
% Unit test for MrDataNd for arithmetic operations (perform binary
% operation)
%
%   Y = MrUnitTest()
%   run(Y, 'MrDataNd_arithmetic_operation')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrDataNd_arithmetic_operation
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2018-02-08
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

% create two MrDataNd objects
% seed random number generator
rng(1);
nSamples = [24, 24, 6, 5, 4, 3];
dataMatrixX = randn(nSamples);
dataMatrixY = randn(nSamples(1:2));
% 6D image
x = MrDataNd(dataMatrixX);
% 2D image
y = MrDataNd(dataMatrixY);

switch testArithmeticOperation
    case 'minus'
        % define actual solution
        actSolution = x - y;
        % define expected solution
        expSolution = dataMatrixX - dataMatrixY;
    case 'plus'
        % define actual solution
        actSolution = x + y;
        % define expected solution
        expSolution = dataMatrixX + dataMatrixY;
    case 'power'
        % define actual solution
        actSolution = x.^y;
        % define expected solution
        expSolution = dataMatrixX.^dataMatrixY;
    case 'rdivide'
        % define actual solution
        actSolution = x./y;
        % define expected solution
        expSolution = dataMatrixX./dataMatrixY;
    case 'times'
        % define actual solution
        actSolution = x.*y;
        % define expected solution
        expSolution = dataMatrixX.*dataMatrixY;
end

% verify equality of expected and actual solution
% import matlab.unittests to apply tolerances for objects
this.verifyEqual(actSolution.data, expSolution, 'absTol', 10e-7);


end