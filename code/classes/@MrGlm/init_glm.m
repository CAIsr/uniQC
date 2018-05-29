function [this]  = init_glm(this)
% This method initializes MrGlm, i.e. checks for consistency and saves
% neccessary files
%
%   Y = MrGlm()
%   Y.specify_Glm(inputs)
%
% This is a method of class MrGlm.
%
% IN
%
% OUT
%
% EXAMPLE
%   init_glm
%
%   See also MrGlm
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2014-11-07
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

% save regressor file
R = struct2array(this.regressors);
if ~isempty(R)
    fileNameRegressors = fullfile(this.parameters.save.path, 'Regressors');
    save(fileNameRegressors, 'R');
else disp('No regressors specified. Are you sure?');
end

% save conditions file
fileNameConditions = fullfile(this.parameters.save.path, 'Conditions');

if ~isempty(this.conditions.names)
    names = this.conditions.names;
    onsets = this.conditions.onsets;
    durations = this.conditions.durations;
else disp('No conditions specified. Are you sure?');
    % make dummy conditions file
    names = {};
    onsets = {};
    durations = {};
end

save(fileNameConditions, 'names', 'onsets', 'durations');


% make SPM directory
spmDirectory = fullfile(this.parameters.save.path, this.parameters.save.spmDirectory);
if ~exist(spmDirectory)
    mkdir(spmDirectory);
end
