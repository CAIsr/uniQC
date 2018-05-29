function filename = get_filename(this, prefix, isSuffix, isMixedCase)
% returns the full filename as given in this.parameters.save, an additional
% prefix can be given
%
%   Y = MrImage()
%   Y.get_filename()
%
% This is a method of class MrImage.
%
% IN
%
% OUT
%
% EXAMPLE
%   filename = Y.get_filename;
%
%   See also MrImage
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2014-11-12
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
% $Id: new_method2.m 354 2013-12-02 22:21:41Z kasperla $

% settings for prefix
if nargin == 1 % just the filename
    prefix = '';
    isSuffix = 0;
    isMixedCase = 0;
elseif nargin == 2 % add prefix with standard settings
    isSuffix = 0;
    isMixedCase = 1;
elseif nargin == 3 % set also isSuffix
    isMixedCase = 1;
else % all parameters set
end

% create new sub-directory for raw data to store it there temporarily
switch prefix
    case 'dimInfo'
        [~,fn,~] = fileparts(this.parameters.save.fileName);
        filename = fullfile(this.parameters.save.path, [fn '_dimInfo.mat']);
    case 'dimInfoRaw'
        [~,fn,~] = fileparts(this.parameters.save.fileName);
        filename = fullfile(this.parameters.save.path, 'raw', [fn '_dimInfo.mat']);
    case 'raw'
        filename = fullfile(this.parameters.save.path, ...
            prefix, this.parameters.save.fileName);
    otherwise
        % create filename
        filename = fullfile(this.parameters.save.path, ...
            this.parameters.save.fileName);
        % prefix filename
        filename = prefix_files(filename, prefix, isSuffix, isMixedCase);
end