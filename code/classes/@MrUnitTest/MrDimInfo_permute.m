function this = MrDimInfo_permute(this)
% Unit test for MrDimInfo permute
%
%   Y = MrUnitTest()
%   run(Y, 'MrDimInfo_permute')
%
% This is a method of class MrUnitTest.
%
% IN
%
% OUT
%
% EXAMPLE
%   MrDimInfo_permute
%
%   See also MrUnitTest
%
% Author:   Saskia Bollmann
% Created:  2018-01-15
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

% construct MrDimInfo object from sampling points
dimInfo = this.make_dimInfo_reference(0);

% define expected solution
expSolution = dimInfo.copyobj;

% permute
dimInfo.permute([3 1 4 2 5]);
% permute again
dimInfo.permute([5 2 1 4 3]);
% permute again to original order
dimInfo.permute([2 4 3 5 1]);

% define actual solution
actSolution = dimInfo;

% verify whether expected and actual solution are identical
% Note: convert to struct, since the PublicPropertyComparator (to allow
% nans to be treated as equal) does not compare properties of objects that
% overload subsref

warning('off', 'MATLAB:structOnObject');
this.verifyEqual(struct(actSolution), struct(expSolution), 'absTol', 10e-7);
warning('on', 'MATLAB:structOnObject');

end
