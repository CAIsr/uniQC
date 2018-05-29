function this = smooth(this, fwhmMillimeter)
% smoothes ND MrImage using Gaussian kernel and via SPM functionality
%
%   Y = MrImage()
%   Y = Y.smooth(fwhmMillimeter)
%
% This is a method of class MrImage.
%
% IN
%
% OUT
%
% EXAMPLE
%   smooth
%
%   See also MrImage MrImageSpm4D.smooth
%
% Author:   Saskia Bollmann & Lars Kasper
% Created:  2018-04-26
% Copyright (C) 2018 Institute for Biomedical Engineering
%                    University of Zurich and ETH Zurich
%
% This file is part of the Zurich fMRI Methods Evaluation Repository, which is released
% under the terms of the GNU General Public License (GPL), version 3. 
% You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version).
% For further details, see the file COPYING or
%  <http://www.gnu.org/licenses/>.
%
% $Id: smooth.m 509 2018-05-25 23:09:41Z lkasper $

%% Decide upon which type of ND image this is
if nargin < 2
    fwhmMillimeter = 8;
end

isComplexImage = ~isreal(this);

if isComplexImage
    outputImage = this.split_complex('mp');
else
    outputImage = this;
end

outputImage.apply_spm_method_per_4d_split(@smooth, ...
    'methodParameters', {fwhmMillimeter});

%% reassemble complex smoothed images into one again
if isComplexImage
  outputImage = outputImage.combine_complex();
  this.update_properties_from(outputImage);
end