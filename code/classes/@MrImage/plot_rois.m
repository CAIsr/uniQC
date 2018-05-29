function fhArray = plot_rois(this, varargin)
%Plots Rois (different types, e.g. boxplot, time series) for all rois
%
%   output = plot_rois(input)
%
% IN
%   selectedRois    [1,nRois] index vector of cell in MrImage.rois,
%                   or all (Inf) 
%                   default: Inf
%
%   varargin for MrRoi.plot (see in that description)
%
% OUT
%   fhArray         array of Figure handles
%
% EXAMPLE
%   plot_rois
%
%   See also MrRoi.plot
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2015-06-24
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
% $Id: new_function2.m 354 2013-12-02 22:21:41Z kasperla $

defaults.selectedRois = Inf;

[args, argsPlotRois] = propval(varargin, defaults);
strip_fields(args);

if isinf(selectedRois)
    selectedRois = 1:numel(this.rois);
end

fhArray = [];
for indRoi = selectedRois
   fh = this.rois{indRoi}.plot(argsPlotRois{:});
   fhArray = [fhArray; fh(:)];
end
