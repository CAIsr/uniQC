function this = set_from_dim_info(this, dimInfo)
% Sets resolution/offcenter from dimInfo (via 1st sampling point), rotation
% and shear is 0.
%
%   Y = MrAffineGeometry()
%   Y.set_from_dim_info(dimInfo)
%
% This is a method of class MrAffineGeometry.
%
% IN
%
% OUT
%
% EXAMPLE
%   set_from_dim_info
%
%   See also MrAffineGeometry
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2017-11-07
% Copyright (C) 2017 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3.
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: set_from_dim_info.m 391 2018-01-12 12:22:16Z lkasper $

this.shear_mm       = [0 0 0];
this.rotation_deg   = [0 0 0];

if ~isempty(dimInfo)
    if isequal(dimInfo.units({'x','y','z'}), {'mm', 'mm', 'mm'})
        this.resolution_mm  = dimInfo.resolutions({'x','y','z'});
        samplingPoints = dimInfo.samplingPoints({'x','y','z'}); % TODO: nicer get!
        this.offcenter_mm  = [samplingPoints{1}(1), samplingPoints{2}(1), samplingPoints{3}(1)];
    elseif ~isempty(dimInfo.units)
        warning('unknown units in dimInfo...cannot convert to mm')
    end
end
