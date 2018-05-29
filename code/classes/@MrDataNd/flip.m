function outputImage = flip(this, iDim)
% Flips all elements of a given dimension and updates dimInfo.samplingPoints
%
%   Y = MrDataNd()
%   Y.flip(inputs)
%
% This is a method of class MrDataNd.
%
% IN
%   iDim    index of dimension to be flipped; default: 1
%
% OUT
%
% EXAMPLE
%   flip
%
%   See also MrDataNd perform_unary_operation MrDataNd.fliplr
%   See also MrDataNd.flipud
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
% $Id: flip.m 310 2016-06-24 20:16:03Z lkasper $

if nargin < 2
    iDim = 1;
end

if exist('flip', 'builtin')
    outputImage = this.perform_unary_operation(@(x) flip(x, iDim));
else
    outputImage = this.perform_unary_operation(@(x) flipdim(x, iDim));
end
outputImage.dimInfo.samplingPoints{iDim} = flipud(outputImage.dimInfo.samplingPoints{iDim});
