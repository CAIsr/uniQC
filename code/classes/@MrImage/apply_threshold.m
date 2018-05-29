function this = apply_threshold(this, threshold, caseEqual)
% sets all voxel values < (=) threshold(1) to zero, and, optionally ceils
% all voxel values above threshold(2) to threshold(2);
%
% NOTE: Nans are set to zero, Infs are kept, if at/above threshold
%
%   Y = MrImage()
%   Y.apply_threshold(threshold, caseEqual)
%
% This is a method of class MrImage.
%
% IN
%       threshold   [minThreshold, maxThreshold] thresholding value for image
%                   all pixels < (=) minThreshold will be set to zero
%                   all pixels > (=) maxThreshold will be set to
%                                    maxThreshold (default: Inf)
%                    
%
%       caseEqual   'exclude' or 'include'
%                   'include' pixels with exact threshold value will be kept
%                             (default)
%                   'exclude' pixels with exact threshold value will be
%                             set to 0
% OUT
%       this        thresholded, binary image
%
% EXAMPLE
%   Y = MrImage('mean.nii')
%   Y.apply_threshold(0, 'exclude'); % set all values <= 0 to 0
%                                      % i.e. keeps all positive values in
%                                      % image
%   Y.apply_threshold(0, 'include'); % set all values < 0 to 0
%                                      % i.e. keeps all non-negative values
%                                      in image
%   Y.apply_threshold(-20, 'include'); % set all values < -20 to 0
%
%   See also MrImage
%
% Author:   Saskia Klein & Lars Kasper
% Created:  2014-07-18
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
% $Id: apply_threshold.m 105 2014-11-25 08:52:45Z lkasper $
if nargin < 2
    threshold = 0;
end

if numel(threshold) < 2
    threshold(2) = Inf;
end

if nargin < 3
    caseEqual = 'include';
end

switch lower(caseEqual)
    case 'include'
        this.data(this.data < threshold(1)) = 0;
        this.data(this.data > threshold(2)) = threshold(2);
    case 'exclude'
        this.data(this.data <= threshold(1)) = 0;
        this.data(this.data >= threshold(2)) = threshold(2);
 end

% set NaNs to zero as well
this.data(isnan(this.data)) = 0;