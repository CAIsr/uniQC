function this = save(this, varargin)
% Saves 4D file in single file.
%
%   Y = MrImageSpm4D()
%   Y.save('fileName', fileName)
%
% This is a method of class MrImageSpm4D.
%
% IN
%   fileName    string: default via get_filename
% OUT
%
% EXAMPLE
%   save
%
%   See also MrImageSpm4D MrDataNd.save MrDataNd.get_filename
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
% $Id: save.m 495 2018-05-23 22:33:46Z lkasper $

defaults.fileName = this.get_filename();
args = propval(varargin, defaults);

strip_fields(args);

% defaults splitDims are adapted depending on file extension to have
% e.g. default 4D nifti files.
[fp, fn, ext] = fileparts(fileName);

% save dimInfo for later recovery of absolute indices (e.g.
% which coil or echo time)
warning('off', 'MATLAB:structOnObject');
dimInfo = struct(this.dimInfo);
warning('on', 'MATLAB:structOnObject');

if ~exist(fp, 'dir')
    mkdir(fp);
end
save(fullfile(fp, [fn '_dimInfo.mat']), 'dimInfo');

this.write_single_file(fileName);