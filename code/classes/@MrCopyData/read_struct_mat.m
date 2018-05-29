function this = read_mat(this, fileName)
% loads dimInfo from struct that was created when saving dimInfo as .mat
%
%   Y = MrDimInfo()
%   Y.read_mat(fileName)
%
% This is a method of class MrDimInfo.
%
% IN
%
% OUT
%
% EXAMPLE
%   read_mat
%
%   See also MrDimInfo
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-05-23
% Copyright (C) 2018 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the TAPAS UniQC Toolbox, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: read_struct_mat.m 496 2018-05-24 08:06:39Z lkasper $
structDimInfo = load(fileName, 'dimInfo');

this.update_properties_from(structDimInfo.dimInfo);