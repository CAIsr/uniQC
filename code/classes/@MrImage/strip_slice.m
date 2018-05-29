function this = strip_slice(this, slice_number)
% removes one slice and updates geometry parameters
%
%   Y = MrImage()
%   Y.strip_slice(inputs)
%
% This is a method of class MrImage.
%
% IN    slice_number
%
% OUT
%
% EXAMPLE
%   strip_slice(1)
%
%   See also MrImage
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-02-27
% Copyright (C) 2015 Institute for Biomedical Engineering
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

this.data(:,:,slice_number,:) = [];
if numel(size(this.data)) < 4 % 3D data set
    this.geometry.nVoxels = [size(this.data), 1];
else
    this.geometry.nVoxels = size(this.data);
end
this.geometry.FOV_mm = ...
    this.geometry.resolution_mm.*...
    this.geometry.nVoxels(1:3);
end
