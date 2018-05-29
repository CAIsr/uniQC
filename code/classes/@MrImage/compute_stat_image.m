function statMrImage = compute_stat_image(this, statImageType, varargin)
% wrapper for computing different statistical images (taken over time series)
% while retaining image geometry information
%
%   Y = MrImage()
%   statMrImage = Y.compute_stat_image(statImageType, ...
%                                       'PropertyName', PropertyValue, ...)
%
% This is a method of class MrImage.
%
% IN
%   statImageType   'snr'       (default), ignoring voxels with sd < 1e-6
%                   'sd'        standard deviation,
%                   'mean'
%                   'coeffVar'  (coefficient of variance) = 1/snr;
%                               ignoring voxels with mean < 1e-6
%
%   'PropertyName'
%               'applicationDimension'  dimension along which statistical
%                                       calculation is performed
% OUT
%   statMrImage     output statistical image. See also MrImage
%
% EXAMPLE
%   Y = MrImage()
%   snr = Y.compute_stat_image('snr', 't');
%
%   See also MrImage
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-06
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
% $Id: compute_stat_image.m 487 2018-05-22 08:14:12Z sklein $

defaults.applicationDimension = 't';

% fills in default arguments not given as input
args = propval(varargin, defaults);

% strips input fields from args-structure,
% i.e. args.selectedVolumes => selectedVolumes
strip_fields(args);

% get application index
applicationIndex = this.dimInfo.get_dim_index(applicationDimension);
% if applicationDimension is not found
if isempty(applicationIndex)
    if strcmp(applicationDimension, 't') % default has been used, alternative is last dim
        applicationIndex = this.ndims;
        applicationDimension = this.dimInfo.dimLabels(applicationIndex);
        applicationDimension = applicationDimension{1};
    else
        error(sprintf('The specified application dimension %s does not exist.', ...
            applicationDimension));
    end
end

switch lower(statImageType)
    case 'mean'
        statMrImage = this.mean(applicationIndex);
    case 'sd'
        statMrImage = this.std(applicationIndex);
    case 'snr'
        tmpSd = apply_threshold(this.std(applicationIndex), 1e-6); % to avoid divisions by zero
        statMrImage = this.mean(applicationIndex)./tmpSd;
        
    case {'coeffvar', 'coeff_var'}
        tmpMean = apply_threshold(this.mean(applicationIndex), 1e-6);% to avoid divisions by zero
        statMrImage = this.std(applicationIndex)./tmpMean;
        
    case {'difflastfirst', 'diff_last_first'}
        statMrImage = this.select(applicationDimension, 1) - ...
            this.select(applicationDimension, ...
            this.dimInfo.(applicationDimension).nSamples(end));
end

statMrImage.name = sprintf('%s (%s)', statImageType, this.name);

end
