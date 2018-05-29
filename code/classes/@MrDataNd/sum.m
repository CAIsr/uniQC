function outputImage = sum(this, applicationDimension)
% Computes sum along specified dimension, uses Matlab sum function
%
%
%   Y = MrImage()
%   Y.sum(applicationDimension)
%
% This is a method of class MrImage.
%
% IN
%   applicationDimension    image dimension along which operation is
%                           performed (e.g. 4 = time, 3 = slices)
%                           default: The last dimension with more than one
%                           value is chosen 
%                           (i.e. 3 for 3D image, 4 for 4D image)
%
% OUT
%   outputImage             Sum of all images along application dimension
%
% EXAMPLE
%   sum
%
%   See also MrImage MrImage.perform_unary_operation
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-11-02
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
% $Id: sum.m 513 2018-05-27 08:41:04Z sklein $
if nargin < 2
    applicationDimension = this.dimInfo.nDims;
end

outputImage = this.perform_unary_operation(@(x) sum(x), applicationDimension);