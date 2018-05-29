function this = redo(this)
% restores next processing step status of MrSeries, after previous undo (or
% restore)
%
%   Y = MrSeries()
%   Y.redo()
%
% This is a method of class MrSeries.
%
% IN
%   doDeleteLastStep    false - last step is kept for possible restore
%                       true  - last step is removed from history,
%                               including files
% OUT
%
% EXAMPLE
%   Y = MrSeries();
%   Y.realign();
%   Y.coregister();
%   Y.undo();  % restore Y-status before co-registration, keep coreg for restore
%   Y.redo();  % restore Y-status after co-registration
%   Y.undo(1); % restore Y-status before co-registration, delete
%                co-registration
%
%   See also MrSeries MrSeries.restore();
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-12-07
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
% $Id: redo.m 223 2015-12-07 15:36:38Z lkasper $

this.restore(this.nProcessingSteps+1, 1, 0);