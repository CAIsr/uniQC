function pathOut = get_path(folder)
% Returns absolute paths for given folder
%
%   pathOut = get_path(folder)
%
% IN
%   folder      default: 'code'; returns full path of given folder within
%               fmri_svn
%               options:
%               'code'
%               'utils'
%               'examples'
%               'classes'
%               TODO: automatic search for subfolders...
%   
% OUT
%
% EXAMPLE
%   pathCode = get_path('code');
%   pathUtils = get_path('utils');
%
%   See also
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2014-11-18
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
% $Id: get_path.m 162 2015-02-12 10:18:38Z lkasper $

if nargin < 1
    folder = 'code';
end

pathUtils = fullfile(fileparts(mfilename('fullpath')));

switch folder
    case 'utils'
        pathOut = pathUtils;
    case 'code'
        pathOut = fullfile(pathUtils, '..\');
    case 'classes'
        pathOut = fullfile(pathUtils, '..\classes');
    case {'example', 'examples', 'data'}
        pathOut = fullfile(pathUtils, '..\..\data');
    case {'tests', 'test'}
        pathOut = fullfile(pathUtils, '..\..\test');
    case {'demo', 'demos'}
        pathOut = fullfile(pathUtils, '..\..\demo');     
end

pathOut = simplify_path(pathOut);