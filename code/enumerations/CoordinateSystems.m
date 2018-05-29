classdef CoordinateSystems < int32
% Labels for commonly used image coordinate system conventions
%
% The image coordinate systems usually defines:
% 1) x,y,z axis orientation relative to patient RL-AP-FH
% 2) origin of coordinate system: e.g. voxel [1,1,1] (Nifti) or
% midcenter-midslice (Philips)
%
% EXAMPLE
%   CoordinateSystems.nifti
%
%   See also MrImageGeometry MrImageGeometry.convert
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-12-09
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
% $Id: CoordinateSystems.m 224 2015-12-09 10:46:40Z lkasper $

enumeration
 % Different Names are specified for the same coordinate system convention:
 
 % Convention 1: Origin is center of volume, i.e. mid-slice, mid-center
 scanner (1)
 siemens (1)
 philips (1)
 originCenterVolume (1)
 
 % Convention 2: Voxel with index [1,1,1] is
 nifti   (2)
 originCornerVoxel (2)
end % enumeration

%
% properties
%  % not needed yet...maybe put reference coordinate system here...
% end % properties
%  
 
 
% methods
% 
% % Constructor of class, only needed, if properties initialized
% function this = CoordinateSystems()
% end
% 
% % NOTE: Useful methods are: char, eq (==) and ne (~=).
% 
% end % methods
 
end
