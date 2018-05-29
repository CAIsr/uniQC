function outputImage = imfill(this, locations)
% Fills image slice-wise; mimicks imfill in matlab functionality
%
%   Y = MrImage()
%   filledY = Y.imfill(locations)
%
% This is a method of class MrImage.
%
% IN
%   locations
%           array of 2D coordinates or string 'holes' to fill all holes
% OUT
%   outputImage    
%           MrImage where data matrix is inflated
%
% EXAMPLE
%   Y = MrImage();
%   filledY = Y.imfill()
%   filledY = Y.imfill('holes')
%
%
%   See also MrImage imfill MrImage.imerode perform_unary_operation
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
% $Id: imfill.m 289 2016-04-14 09:33:13Z lkasper $

% update geometry-header with flipping left-right
if nargin < 2
    locations = 'holes';
end

if isreal(this)
    outputImage = this.perform_unary_operation(...
        @(x) imfill(x, locations), '2d');
else
    outputImage = this.abs.perform_unary_operation(...
        @(x) imfill(x, locations), '2d');
end