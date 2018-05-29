function outputImage = diff(this, varargin)
% Performs diff operation along specified dimension
%
%   Y = MrImage()
%   Y.diff(applicationDimension)
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
%   outputImage             new difference image along specified dimension
% EXAMPLE
%   diff
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
% $Id: new_method2.m 354 2013-12-02 22:21:41Z kasperla $
if nargin < 2
    applicationDimension = this.dimInfo.nDims;
else
    applicationDimension = varargin{1};
end

outputImage = this.perform_unary_operation(@(x) diff(x,1,applicationDimension));

end