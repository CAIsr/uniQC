function maxValue = max(this, varargin)
% Returns max value of data matrix of MrImage, accepts selection parameters
%
%   Y = MrImage()
%   maxValue = ...
%       Y.max('ParameterName1', 'ParameterValue1', ...)
%
% This is a method of class MrImage.
%
% IN
%   varargin    parameterName/Value pairs for selection of volumes/slices
%
% OUT
%
% EXAMPLE
%   Y.max(50, 'z', 1, 't', 3:100, ...,
%           'x', 55:75)
%
% EXAMPLE
%   max(Y)
%
%   See also MrImage MrImage.maxip
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2014-11-25
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
% $Id: max.m 306 2016-05-26 16:13:53Z lkasper $

if nargin < 2
    imgSelect = this;
else
    imgSelect = this.select(varargin{:});
end

maxValue = max(imgSelect.data(:));