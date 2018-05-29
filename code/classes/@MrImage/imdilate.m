function outputImage = imdilate(this, structureElement)
% Dilates image clusters slice-wise; mimicks imdilate in matlab functionality
%
%   Y = MrImage()
%   dilatedY = Y.imdilate()
%
% This is a method of class MrImage.
%
% IN
%   structureElement
%           morphological structuring element for dilation, e.g.
%           strel('disk', 2) for a disk of radius 2
%           default: strel('disk', 2) 
% OUT
%   outputImage    
%           MrImage where data matrix is inflated
%
% EXAMPLE
%   Y = MrImage();
%   dilatedY = Y.imdilate()
%   dilatedY = Y.imdilate(strel('disk', 5))
%
%
%   See also MrImage imdilate MrImage.imerode perform_unary_operation
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-08-04
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
% $Id: imdilate.m 281 2016-03-14 14:49:36Z lkasper $

% update geometry-header with flipping left-right
if nargin < 2
    structureElement = strel('disk', 2);
end

if isreal(this)
    outputImage = this.perform_unary_operation(...
        @(x) imdilate(x, structureElement), '2d');
else
    outputImage = this.abs.perform_unary_operation(...
        @(x) imdilate(x, structureElement), '2d');
end