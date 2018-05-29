function this = save(this, varargin)
% Saves data to file(s), depending on which loop-dimensions have been
% selected
%
%   Y = MrDataNd()
%   Y.save('fileName', fileName, 'splitDims', 'unset')
%
% This is a method of class MrDataNd.
%
% IN
%
% OUT
%
% EXAMPLE
%   save
%
%   See also MrDataNd MrDataNd.split
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2016-09-25
% Copyright (C) 2016 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: save.m 493 2018-05-22 22:38:32Z lkasper $

defaults.fileName = this.get_filename();
defaults.splitDims = 'unset'; % changed below!

args = propval(varargin, defaults);
args.doSave = true; % we do want to save here!

this.split(args);
            